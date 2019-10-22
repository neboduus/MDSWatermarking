%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Course :	Multimedia Data Security
% Project: 	Spread Spectrum
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
It = dct2(Id);

%% Reshape the DCT into a vector
It_re = reshape(It,1,dimx*dimy);
% 1 262144

%% Coefficient selection (hint: use sign, abs and sort functions)
It_sgn = sign(It_re);
It_mod = abs(It_re);
[It_sort,Ix] = sort(It_mod,'descend');

%% Embedding
Itw_mod = It_mod; 

%k = 2;
%k = uint32((dimx*dimy)/2);
%k = 131072;
k = 10000;
for j = 1:1000
    m = Ix(k);
    Itw_mod(m) = It_mod(m)*(1+alpha*w(j)); % v_i' = v_i * (i + alpha * x_i)
    k = k+1;
end

%% Restore the sign and go back to matrix representation using reshape
It_new = Itw_mod.*It_sgn;
%size(It_new)
It_newi=reshape(It_new,dimx,dimy);
%size(It_newi)


%% Inverse DCT
I_wat = idct2(It_newi);

%% Show the watermarked image
imshow(I_wat,[]);

%% Save the watermarked image
imwrite(uint8(I_wat),'SSwat.bmp'); 

%% Calculate PSNR and WPSNR
q1 = PSNR(uint8(I), uint8(I_wat));
fprintf('PSNR = +%5.2f dB\n',q1);

q2 = WPSNR(uint8(I), uint8(I_wat));
fprintf('WPSNR = +%5.2f dB\n',q2);
 
