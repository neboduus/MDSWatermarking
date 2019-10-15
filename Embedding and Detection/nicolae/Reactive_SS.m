clear all;clc;
start_time = cputime;

%% Read original image and set all parameters
I = imread('lena.bmp');
alpha = 0.3;
k = 1000;

%% Embed Image
[I_wat, q1, q2] = embed(I, alpha, k);

%% Attacks
I_att = I_wat;
% resize
I_att = test_blur(I_wat, 1);

%% Detect Image
[SIM, T] = detect(I, I_wat, alpha, k);

%% Images Plot
subplot(2,2,1); imshow(I); title('Original');
subplot(2,2,2); imshow(I_wat); title('Watermarked');
subplot(2,2,3); imshow(I_att); title('Attacked');

fprintf('attacked WPSNR = +%5.2f dB\n',WPSNR(uint8(I), uint8(I_att)));

%% Time
stop_time = cputime;
fprintf('Execution time = %0.5f sec\n',abs( start_time - stop_time));