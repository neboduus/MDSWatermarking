%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Course :  Multimedia Data Security
% Project:  Spread Spectrum
%           Watermark Detection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;clc;
start_time = cputime;

%% Read original and watermarked images and convert them to double
I    = imread('lena.bmp');
I_wat   = imread('SSwat.bmp');

[dimx,dimy] = size(I_wat);
I_wat = double(I_wat);
I  = double(I);

%% Load the original watermark
load('watermark.mat');

%% Define watermark strength
alpha = 0.1;

%% Compute DCTs
%% HERE SOME CODE IS MISSING

%% Reshape the DCTs into vectors
%% HERE SOME CODE IS MISSING

%% Coefficient selection for watermarked image
%% HERE SOME CODE IS MISSING

%% Coefficient selection for original image
%% HERE SOME CODE IS MISSING

%% Watermark extraction
%% HERE SOME CODE IS MISSING

%% Detection
SIM = w * w_rec' / sqrt( w_rec * w_rec' );

%% Compute threshold
randWatermarks = round(rand(999,size(w,2)));
x = zeros(1,1000);

x(1) = SIM;  
for i = 1:999
    w_rand = randWatermarks(i,:);
    x(i+1) = w_rand * w_rec' / sqrt( w_rec * w_rec' );
end

x = abs(x);
x = sort(x, 'descend');
t = x(2);
T = t + 0.1*t;

%Decision
if SIM > T
    fprintf('Mark has been found. \nSIM = %f\n', SIM);
else
    fprintf('Mark has been lost. \nSIM = %f\n', SIM);
end

stop_time = cputime;
fprintf('Execution time = %0.5f sec\n',abs( start_time - stop_time));
