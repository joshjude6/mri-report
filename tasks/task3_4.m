% task 3 and 4: removal of k-space and testing of fourier transform

% generating k-space
[Mn, params, M0, Kn, K0] = phantom_parallel(0, 2, 100, 0.1);

% percentage to remove for task 3a and 3b
percent = 45; % step size = 10

% task 3a/b: replacing a inner/outer circular patch with zeros
size = 256;
center = floor(size/2);
radius = round(percent/100 * size/2);
[x, y] = meshgrid(1:size, 1:size);
circle = sqrt((x-center).^2 + (y-center).^2) <= radius; % change <= to > for task 3a

% task 4a: removing upper half of k-space
zero_upper = zeros(size, size);
zero_upper(center+1:end, :) = 1;

% task 4b: removing every second column in x-direction
zero_col = ones(size, size);
zero_col(:, 2:2:end) = 0;

% task 4c: removing every second row in y-direction
zero_row = ones(size, size);
zero_row(2:2:end, :) = 0;

% k-spaces from both coils multiplied by type of patch
Kn_1 = Kn(:,:,1) .* circle;
Kn_2 = Kn(:,:,2) .* circle;

% using transform back into image space
im1 = k2x(Kn_1, 1);
im2 = k2x(Kn_2, 1);

% composite image
composite_image = sos(cat(3, im1, im2));

% figure;
% imagesc(abs(Kn_1)); 
% colormap default;
% title('K-space from coil 1, every second row of K-space removed');
% axis off;
% saveas(gcf, 'kspace-1-zero-row', 'png');
% 
% figure;
% imagesc(abs(Kn_2)); 
% colormap default;
% title('K-space from coil 2, every second row of K-space removed');
% axis off;
% saveas(gcf, 'kspace-2-zero-row', 'png');
% 
% figure;
% imagesc(abs(im1)); 
% colormap default;
% title('Coil 1 image, every second row of K-space removed');
% axis off;
% saveas(gcf, 'coil1-zero-row', 'png');
% 
% figure;
% imagesc(abs(im2)); 
% colormap default;
% title('Coil 2 image, every second row of K-space removed');
% axis off;
% saveas(gcf, 'coil2-zero-row', 'png');

figure;
imagesc(abs(composite_image)); 
colormap default;
title('Composite image, outer 45% percent of k-space removed');
axis off;
saveas(gcf, 'composite-zero-row', 'png');
