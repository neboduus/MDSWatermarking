   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Course :  Multimedia Data Security
% Project:  Spread Spectrum
%           Watermark Detection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;clc;
start_time = cputime;

%% Read original and watermarked images
I    = imread('lena.bmp');
I_wat   = imread('SSwat.bmp');

%% Attacks

% resize
Iw_resized = test_resize(I_wat, 2);

% jpeg compression
imwrite(Iw_resized, 'SSatt.jpg', 'Quality', 10);
Iw_jpeg = imread('SSatt.jpg');

% blur
%Iw_blur = test_blur(Iw_jpeg, 0.1);
Iw_blur = test_blur(I_wat, 2);

% awgn
Iw_awgn = test_awgn(Iw_jpeg, 0.1, 123);

subplot(2,3,1); imshow(I); title('Original');
subplot(2,3,2); imshow(I_wat); title('Watermarked');
subplot(2,3,3); imshow(Iw_resized); title('Resized');
subplot(2,3,4); imshow(Iw_jpeg); title('Resized -> Jpeg');
subplot(2,3,5); imshow(Iw_blur); title('Jpeg -> Blur');
subplot(2,3,6); imshow(Iw_awgn); title('Jpeg -> Awgn');

%I_wat = Iw_blur;%%%%%%%%%%%%

fprintf('attacked WPSNR = +%5.2f dB\n',WPSNR(uint8(I), uint8(I_wat)));
delete('SSatt.jpg');

%% Convert them to double
[dimx,dimy] = size(I_wat);
I_wat = double(I_wat);
I  = double(I);

%% Load the original watermark
load('watermark.mat');

%% Define watermark strength
alpha = 0.5;

%% Compute DCTs
I_dct = dct2(I);
I_wat_dct = dct2(I_wat);

%% Reshape the DCTs into vectors
I_wat_dct_flat = reshape(I_wat_dct, 1, dimx*dimy);
I_dct_flat = reshape(I_dct, 1, dimx*dimy);

%% Coefficient selection for watermarked image
[I_wat_dct_flat_sorted, index_I_wat_dct_flat_sorted] = sort(abs(I_wat_dct_flat), 'descend'); 
% ??????????????????

%% Coefficient selection for original image
[I_dct_flat_sorted, index_I_dct_flat_sorted] = sort(abs(I_dct_flat), 'descend');
% ??????

%% Watermark extraction
w_extracted = zeros(1, 1000);
%k =2;
%k=4000;
%k = uint32((dimx*dimy)/2);
%k = 131072;
k = 10000;
for i = 1:1000
    %m = index_I_wat_dct_flat_sorted(k);
    m = index_I_dct_flat_sorted(k);
    % embed v_i' = v_i * (i + alpha * x_i)
    % Itw_mod(m) = It_mod(m)*(1+alpha*w(j))

    % detec x_i' = (v_i' - v_i) / alpha * v_i
    % WORNG 
    %w_extracted(i) = (I_wat_dct_flat_sorted(k) - I_dct_flat_sorted(k)) / (alpha * I_dct_flat_sorted(k));
    w_extracted(i) = (I_wat_dct_flat(m) - I_dct_flat(m)) / (alpha * I_dct_flat(m));
    k = k + 1; 
end

%% Detection
% prof -> 
%SIM = w * w_extracted' / sqrt( w_extracted * w_extracted' );
% SIM = dot(w, w_extracted)/sqrt(dot(w_extracted,w_extracted))
SIM = dot(w, w_extracted)/norm(w_extracted, 2);

%% Compute threshold
randWatermarks = round(rand(999,size(w,2)));
x = zeros(1,1000);

x(1) = SIM;  
for i = 1:999
    w_rand = randWatermarks(i,:);
    x(i+1) = dot(w_rand, w)/norm(w, 2);
end

stem(x);

x = abs(x);
x = sort(x, 'descend');
t = x(2);
T = t + 0.1*t;
fprintf('T = %f\n', T);

%Decision
if SIM > T
    fprintf('Mark has been found. \nSIM = %f\n', SIM);
else
    fprintf('Mark has been lost. \nSIM = %f\n', SIM);
end

stop_time = cputime;
fprintf('Execution time = %0.5f sec\n',abs( start_time - stop_time));
