close all; clearvars;
start_time = cputime;

% load original and watermarked images
I    = imread('cameraman.tif');
Iw   = imread('SSwat.bmp');

% attacks
Iw_to_attack = Iw;
% resize
% Iw_resized = test_resize(Iw, 2);

% jpeg compression
imwrite(Iw, 'SSatt.jpg', 'Quality', 90);
Iw_jpeg = imread('SSatt.jpg');

% sharpening
% Iw_sharp = test_sharpening(Iw_jpeg, 2, 3);

subplot(2,3,1); imshow(I);
title('Original');
% subplot(2,3,2); imshow(Iw);
% title('Watermarked');
% subplot(2,3,3); imshow(Iw_resized);
% title('Resized');
subplot(2,3,4); imshow(Iw_jpeg);
title('Resized -> Jpeg');
% subplot(2,3,5); imshow(Iw_sharp);
% title('Resized -> Jpeg -> Sharp');

fprintf('WPSNR(Iw_attacked, Iw) = +%5.2f dB\n',WPSNR(uint8(Iw_jpeg), uint8(Iw)));
% delete('SSatt.jpg');

[dimx,dimy] = size(Iw);
Iw = Iw_jpeg;
Iw = double(Iw);
I  = double(I);

% load embedding keys
load('watermark.mat');
load('alpha.mat');
load('k.mat');

% bring to transform domain
Iw_dct = dct2(Iw);
I_dct = dct2(I);

%Coefficient selection for original and watermarked image
Iw_dct_flat = reshape(Iw_dct, 1, dimx*dimy);
Iw_dct_flat_abs = abs(Iw_dct_flat);
[Iw_dct_sorted, Iw_indexes_sorted] = sort(Iw_dct_flat_abs, 'descend');

I_dct_flat = reshape(I_dct, 1, dimx*dimy);
I_dct_flat_abs = abs(I_dct_flat);
[I_dct_sorted, I_indexes_sorted] = sort(I_dct_flat_abs, 'descend');

%watermark extraction
w_prime = zeros(1, 1000);
for i=1:1000
    index = I_indexes_sorted(k);
    w_prime(i) = (Iw_dct_flat_abs(index)-I_dct_flat_abs(index)) / (alpha*I_dct_flat_abs(index));
    k = k + 1;
end

%detection
SIM = w * w_prime' / sqrt(w_prime * w_prime');

% Compute threshold
rand('state', 123); % seed random
randWs = round(rand(999, size(w, 2)));
SIMs = zeros(1, 999);
SIMs(1) = SIM;
for i = 1:999
    w_rand = randWs(i, :);
    SIMs(i+1) = w * w_rand' / sqrt( w_rand * w_rand' );
end

SIMs = abs(SIMs);
SIMs = sort(SIMs, 'descend');
t = SIMs(2);
T = t + 0.1*t;
fprintf('T= +%5.2f dB\n',T);
% stem(SIMs);

%Decision
if SIM > T
    fprintf('Mark has been found. \nSIM = %f\n', SIM);
else
    fprintf('Mark has been lost. \nSIM = %f\n', SIM);
end

stop_time = cputime;
fprintf('Execution time = %0.5f sec\n',abs( start_time - stop_time));


