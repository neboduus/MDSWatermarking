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
w = round(rand(1,1000));
save('watermark','w');

%% Define watermark strenght
alpha = 0.5;

%% Compute DCT
Idct = dct2(Id);

%% Reshape the DCT into a vector
sizes = size(Idct);
vector = reshape(Idct,1,[]);

%% Coefficient selection (hint: use sing, abs and sort functions)
vectorAbs = abs(vector);
[vectorSorted,indexes] = sort(vectorAbs,'descend');

%% Embedding
for R = 2:(size(w,2)+1)
    index = indexes(1,R);
    vector(index) = vector(index)*(1+alpha*w(R-1));
end

%% Restore the sign and go back to matrix representation using reshape
% HERE SOME CODE IS MISSING
backToMatrix = reshape(vector,sizes);
I_wat = idct2(backToMatrix);
%% Inverse DCT
% HERE SOME CODE IS MISSING

%% Show the watermarked image
imagesc(I_wat);

 
%% Save the watermarked image
imwrite(uint8(I_wat),'SSwat.bmp'); 

%% Calculate PSNR and WPSNR
q1 = PSNR(uint8(I), uint8(I_wat));
fprintf('PSNR = +%5.2f dB\n',q1);

q2 = WPSNR(uint8(I), uint8(I_wat));
fprintf('WPSNR = +%5.2f dB\n',q2);
 