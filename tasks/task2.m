% task 2: sum of squares method

% generating k-space
[Mn, params, M0, Kn, K0] = phantom_parallel(0, 2, 100, 0.1);

% image from k-space, coil 1
im1 = k2x(Kn(:,:,1), 1);  

% image from k-space, coil 2
im2 = k2x(Kn(:,:,2), 1);  

% convert into matrix
image_matrix = cat(3, im1, im2);

% using sum of squares
composite_image = sos(image_matrix);

imagesc(abs(composite_image)); 
colormap default;
title('Composite image (sum of squares)');
axis off;