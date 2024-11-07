% task 1: displaying k-space and reconstructed images

% generating k-space
[Mn, params, M0, Kn, K0] = phantom_parallel(0, 2, 100, 0.1);

% k-space, coil 1
figure;
imagesc(abs(Kn(:,:,1))); 
colormap default;
title('K-space, coil 1');
axis off;

% k-space, coil 2
figure;
imagesc(abs(Kn(:,:,2))); 
colormap default;
title('K-space, coil 2');
axis off;

% image from k-space, coil 1
im1 = k2x(Kn(:,:,1), 1);  
figure;
imagesc(abs(im1)); 
colormap default;
title('Image reconstruction, coil 1');
axis off;

% image from k-space, coil 2
im2 = k2x(Kn(:,:,2), 1);  
figure;
imagesc(abs(im2)); 
colormap default;
title('Image reconstruction, coil 2');
axis off;