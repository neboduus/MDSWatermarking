clear all;clc;
start_time = cputime;

%% Read original image and set all parameters
I = imread('woman_darkhair.bmp');
%I = imread('cameraman.bmp');
alpha = 0.5;
k = 10000;

wpsnr = 0;
while( wpsnr <= 80 )
   fprintf('value of wpsnr and k: +%5.2f, %d\n', wpsnr, k);
   %embed
   [I_wat, q1, q2] = embed(I, alpha, k);
   %detect
   [~, ~] = detect(I, I_wat, alpha, k);
   %calculate wpsnr
   wpsnr = WPSNR(uint8(I), uint8(I_wat));
   k = k + 10000;
end

while(wpsnr > 67)
    fprintf('value of wpsnr and k: +%5.2f, %5.2f\n', wpsnr, alpha);
    %embed
    [I_wat, q1, q2] = embed(I, alpha, k);
    %detect
    [~, ~] = detect(I, I_wat, alpha, k);
    %calculate wpsnr
    wpsnr = WPSNR(uint8(I), uint8(I_wat));
    alpha = alpha + 0.5;
end

fprintf('final values of wpsnr and k and alpha: +%5.2f, %d, %5.2f\n', wpsnr, k, alpha);

%% Embed Image
%[I_wat, q1, q2] = embed(I, alpha, k);

%% Attacks
%I_att = test_resize(I_wat, 0.1);
%I_att = test_blur(I_att, 0.1);
WI_A = I_wat;

%m
%WI_A = test_jpeg(WI_A, 95);

%WI_A = test_sharpening(WI_A, 2, 1);
%WI_A = test_resize(WI_A, 5);


%% Detect Image
[~, ~] = detect(I, I_wat, alpha, k);
%[SIM, T] = detect(I, I_att, alpha, k);

%m
[SIM, T] = detect(I_wat, WI_A, alpha, k);

%% Images Plot
subplot(2,2,1); imshow(I); title('Original');
subplot(2,2,2); imshow(I_wat); title('Watermarked');
%subplot(2,2,3); imshow(I_att); title('Attacked');
%m
subplot(2,2,3); imshow(WI_A); title('Attacked');

fprintf('attacked WPSNR = +%5.2f dB\n',WPSNR(uint8(I_wat), uint8(WI_A)));

%% Time
stop_time = cputime;
fprintf('Execution time = %0.5f sec\n',abs( start_time - stop_time));