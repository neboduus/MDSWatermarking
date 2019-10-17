%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Course :  Multimedia Data Security
% Project:  Spread Spectrum
%           Watermark Detection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;clc;
start_time = cputime;

%original image
I    = imread('lena.bmp','bmp');
%watermarked image
Iw   = imread('SSwat.bmp','bmp');

[dimx,dimy] = size(Iw);
Iw = double(Iw);
I  = double(I);

% load original watermark
load('watermark.mat');

%define watermark strength
alpha = 0.1;

%DCT transform
%% HERE SOME CODE IS MISSING
I_dct = dct2(I);
Iw_dct = dct2(Iw);

sizes = size(I_dct);
vectorI = reshape(I_dct,1,[]);
vectorIw = reshape(Iw_dct,1,[]);

%Coefficient selection for watermarked image
%% HERE SOME CODE IS MISSING
vectorIAbs = abs(vectorI);
vectorIwAbs = abs(vectorIw);
[vectorIsrt,indexesI] = sort(vectorIAbs,'descend');
[vectorIwsrt,indexesIw] = sort(vectorIwAbs,'descend');
wex = zeros(1,1000);

%Coefficient selection for original image
%% HERE SOME CODE IS MISSING
for R = 2:(1001)
    index = indexesI(1,R);
    wex(R-1) = (vectorIw(index)-vectorI(index))/(alpha*vectorI(index));
end
%
%%similarity
SIM = (wex*w')/sqrt(wex*wex');

%detection
%% HERE SOME CODE IS MISSING

%Compute threshold
SIMs = zeros(1,999);
rand('state',123);
for R =1:1000
    tmp = round(rand(1,1000));
    SIMs(R) = (tmp*w')/sqrt(tmp*tmp');
end
res = sort(SIMs,'descend');
T = res(2)+(res(2)*0.1);
%Decision
if SIM > T
    fprintf('Mark has been found. \nSIM = %f\n', SIM);
else
    fprintf('Mark has been lost. \nSIM = %f\n', SIM);
end

stop_time = cputime;
fprintf('Execution time = %0.5f sec\n',abs( start_time - stop_time));
