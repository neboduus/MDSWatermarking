%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Course :  Multimedia Data Security
% Project:  Spread Spectrum
%           Watermark Embedding
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clear all;

%% Read original image and convert it to double
I    = imread('lena.bmp');
[dimx,dimy] = size(I);
Id   = double(I);

%% Generate random watermark
rand('state',123);
w = round(rand(1,1000)); %1000 scale
save('watermark','w');

%% Define watermark strenght
alpha = 0.1;

%% Compute DCT
% HERE SOME CODE IS MISSING
It = dct2(Id);

%% Reshape the DCT into a vector
% HERE SOME CODE IS MISSING
It_re = reshape(It, 1, dimx*dimy);

%% Coefficient selection (hint: use sing, abs and sort functions)
% HERE SOME CODE IS MISSING
It_sgn = sign(It_re);
It_mod = abs(It_re); %modify
[It_sort,Ix] = sort(It_mod,'descend')
%[sorted_coef,pos] = sort(It_mod)
%watermark is 1000
%% Embedding
% HERE SOME CODE IS MISSING
Itw_mod = It_mod; 

k = 2;
for j = 1:1000
    m=Ix(k);
    %Itw_mod(m) = It_mod(m) + (alpha*w(j));
    Itw_mod(m) = It_mod(m) * (1+alpha*w(j));
    k=k+1;
end

%% Restore the sign and go back to matrix representation using reshape
% HERE SOME CODE IS MISSING

%% Inverse DCT
% HERE SOME CODE IS MISSING

%% Show the watermarked image
imshow(I_wat,[]);
 
%% Save the watermarked image
imwrite(uint8(I_wat),'SSwat.bmp'); 

%% Calculate PSNR and WPSNR
q1 = PSNR(uint8(I), uint8(I_wat));
fprintf('PSNR = +%5.2f dB\n',q1);

q2 = WPSNR(uint8(I), uint8(I_wat));
fprintf('WPSNR = +%5.2f dB\n',q2);
 