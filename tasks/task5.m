% task 5: implement SENSE algorithm

% generating k-space
[Mn, params, M0, Kn, K0] = phantom_parallel(0, 2, 100, 0.1);

% defining relevant sizes
size = 256;
center = floor(size/2);

% generating coil sensitivity profiles
coil_profiles = sensitivity_map([size, size], 2);
coil_profile_1 = coil_profiles(:,:,1); % profile for coil 1
coil_profile_2 = coil_profiles(:,:,2); % profile for coil 2

% task 4c: removing every second row in y-direction
zero_row = ones(size, size);
zero_row(2:2:end, :) = 0;

% removing rows from k-spaces -> undersampled k-space
Kn_1 = Kn(:,:,1) .* zero_row;
Kn_2 = Kn(:,:,2) .* zero_row;

% reconstructing aliased images with inverse fourier
im1 = k2x(Kn_1, 1);
im2 = k2x(Kn_2, 1);

% initializing new image matrix
final_image = zeros(size, size);

for i = 1:size/2
    for j = 1:size
        C = [coil_profile_1(i, j), coil_profile_1(i + size/2, j); % adding size/2 to ensure entire image gets processed
             coil_profile_2(i, j), coil_profile_2(i + size/2, j)];
        F = [im1(i, j); im2(i, j)];
        A = inv(C) * F; % can't divide with a matrix so need to compute the inverse of C
        final_image(i, j) = A(1); % top half of image
        final_image(i + size/2, j) = A(2); % bottom half of image
    end
end

figure;
imagesc(abs(final_image));
colormap default;
title('SENSE Algorithm Reconstruction')
axis off;
