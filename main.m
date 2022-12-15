close all; clear; clc;

%% read image
filename1 = '../data/image.jpg';
I = imread(filename1);
figure('name', 'source image');
imshow(I);

%% call functions
% output = function(input1, input2, ...);

% RGB to YUV function
I2 = rgb2yuv(I);

% flip function
I3 = my_flip(I,2);

% rotation function
I4 = rotation(I, pi/6);

% shear transformation
I5 = shear(I, -0.8, 0.2);

% resize function
I6 = resize(I, 0.6);
%forward warping(rotate by method of forward warping)
I7 = ForwardWarpingRotate(I,pi/6) ;
% my resize(with bilinear interpolation )
I8 = resize2(I, 0.6);

%% show image
% Need to convert U and V back to RGB before showing them.
[I_Y_rgb, I_U_rgb, I_V_rgb] = show_yuv(I2);

figure('name', 'flipped image'),
imshow(I3);

figure('name', 'rotated image'),
imshow(I4);

figure('name', 'shear image'),
imshow(I5);

figure('name', 'resized image'),
imshow(I6);

figure('name', 'Forward warping rotate image'),
imshow(I7);

figure('name', 'resized2 image'),
imshow(I8);

%% write image
% save image for your report

filename2_Y = '../results/Y_image.jpg';
imwrite(I_Y_rgb, filename2_Y);
filename2_U = '../results/U_image.jpg';
imwrite(I_U_rgb, filename2_U);
filename2_V = '../results/V_image.jpg';
imwrite(I_V_rgb, filename2_V);

filename3 = '../results/flip_image.jpg';
imwrite(I3, filename3);

filename4 = '../results/rotated_image.jpg';
imwrite(I4, filename4);

filename5 = '../results/shear_image.jpg';
imwrite(I5, filename5);

filename6 = '../results/resized_image.jpg';
imwrite(I6, filename6);

filename7 = '../results/ForwardWarpingRotate_image.jpg';
imwrite(I7, filename7);

filename8 = '../results/resize2_image.jpg';
imwrite(I8, filename8);