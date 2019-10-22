close all; clearvars;

rand('state', 123); % seed random
W = randi([0, 1], 32, 32);

originalFN = 'lena.bmp';
watermarkedFN = 'WI.bmp';
attackedFN = 'WI_A.bmp';

fprintf('\n Embedding...\n');
[WI, HI, wpsnr_emb] = embedding_unemployed(originalFN, W);
imwrite(uint8(WI), watermarkedFN);

fprintf('WPSNR(Original, Watermarked) = +%5.2f dB\n', wpsnr_emb);

WI_A = WI;
fprintf('\n Attacking...\n');
% imwrite(WI_A, 'SSatt.jpg', 'Quality', 80);
% Iatt = imread('SSatt.jpg');
% delete('SSatt.jpg');
% WI_A = test_sharpening(WI_A, 2, 3);
% WI_A = test_resize(WI_A, 2);
imwrite(uint8(WI_A), attackedFN, 'bmp');

fprintf('\n Detecting...\n');
[detected, wpsnr_att] = detection_unemployed(originalFN, watermarkedFN, watermarkedFN);

%Decision
if detected == 1
    fprintf('Mark has been found. \n');
else
    fprintf('Mark has been lost. \n');
end

fprintf('WPSNR(WI, WI_A) = +%5.2f dB\n', wpsnr_att);
 
subplot(2,3,1)
imagesc(HI)
title('HI')
subplot(2,3,2)
imagesc(WI)
title('WI')
subplot(2,3,3)
imagesc(WI_A)
title('WI_A')
subplot(2,3,4)
imagesc(W)
title('W')


