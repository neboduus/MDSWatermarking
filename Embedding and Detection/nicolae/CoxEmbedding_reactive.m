close all; clear all;
start_time = cputime;
%% Read original image and convert it to double
I    = imread('woman_darkhair.bmp');
[dimx,dimy] = size(I);
Id   = double(I);

%% Generate random watermark
rand('state',123);
w = round(rand(1,1000));
save('watermark','w');

%% Define watermark strenght
alpha = 0.1;

%% Compute DCT
It = dct2(Id);

%% Reshape the DCT into a vector
It_re = reshape(It,1,dimx*dimy);

%% Coefficient selection (hint: use sign, abs and sort functions)
It_sgn = sign(It_re);
It_mod = abs(It_re);
[It_sort,Ix] = sort(It_mod,'descend');

%% Embedding
Itw_mod = It_mod; 

k=3000;
for j = 1:1000
    m = Ix(k);
    Itw_mod(m) = It_mod(m)*(1+alpha*w(j)); % v_i' = v_i * (i + alpha * x_i)
    k = k+1;
end

%% Coefficient selection for watermarked image
[I_dct_flat_sorted, index_I_dct_flat_sorted] = sort(abs(It_mod), 'descend'); 

%% Coefficient selection for original image
%[I_dct_flat_sorted, index_I_dct_flat_sorted] = sort(abs(I_dct_flat), 'descend');

%% Watermark extraction
w_extracted = zeros(1, 1000);
k=3000;
for i = 1:1000
    m = index_I_dct_flat_sorted(k);
    % embed v_i' = v_i * (i + alpha * x_i)
    % Itw_mod(m) = It_mod(m)*(1+alpha*w(j))

    % detec x_i' = (v_i' - v_i) / alpha * v_i
    % WRONG w_extracted(i) = (I_wat_dct_flat_sorted(k) - I_dct_flat_sorted(k)) / (alpha * I_dct_flat_sorted(k));
    w_extracted(i) = (Itw_mod(m) - It_mod(m)) / (alpha * It_mod(m));
    k = k + 1; 
end

%% Detection and Treshold
% prof -> 
%SIM = w * w_extracted' / sqrt( w_extracted * w_extracted' );
% SIM = dot(w, w_extracted)/sqrt(dot(w_extracted,w_extracted))
SIM = dot(w, w_extracted)/norm(w_extracted, 2);

% Compute threshold
randWatermarks = round(rand(999,size(w,2)));
x = zeros(1,1000);

x(1) = SIM;  
for i = 1:999
    w_rand = randWatermarks(i,:);
    x(i+1) = dot(w_rand, w)/norm(w, 2);
end

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

%% Restore the sign and go back to matrix representation using reshape
It_new = Itw_mod.*It_sgn;
It_newi=reshape(It_new,dimx,dimy);

%% Inverse DCT
I_wat = idct2(It_newi);

%% Save the watermarked image
imwrite(uint8(I_wat),'SSwat.bmp'); 

%% Calculate PSNR and WPSNR
q2 = WPSNR(uint8(I), uint8(I_wat));
fprintf('WPSNR = +%5.2f dB\n',q2);

%% Show the watermarked image
%imshow(I_wat,[]);

