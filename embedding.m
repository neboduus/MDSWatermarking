close all; clearvars;
addpath('detection');

group_name = 'unemployed';
img_name = 'cameraman';

originalFN = strcat('img/nowatermark/', img_name, '.bmp');
watermarkedFN = strcat('img/', img_name, '_', group_name, '.bmp');
attackedFN = 'img/WI_A.bmp';

fprintf('\n Embedding\n');
fprintf(strcat('Original Image: \t', originalFN, '\n'));
fprintf(strcat('Watermarked Image: \t', originalFN, '\n\n'));
HI = imread(originalFN); % host image
[dimx,dimy] = size(HI);
HI = double(HI);

% load watermark from file
load('W.mat');
W = w;

% Compute Wavelet Transform
[LL1,HL1,LH1,HH1] = dwt2(HI,'sym4','mode','per');

% Apply 8x8 block DCT on LL1 level of Wavelet Transform

% create function handler 
dct2Handle = @(block_struct) dct2(block_struct.data);

% apply function of each block
DLL1 = blockproc(LL1, [8 8], dct2Handle);

% compute CDLL1
blockSizeR = 8;
blockSizeC = 8;

% separate each 8x8 block from 
% DLL1 which is 256x256 and store it
% in CDDL1 which will become a 32x32 matrix 
% s.t. CDDL(i,j) contains the block
[rows,columns] = size(DLL1);
wholeBlockRows = floor(rows / blockSizeR);  
blockVectorR = blockSizeR * ones(1, wholeBlockRows);
wholeBlockCols = floor(columns / blockSizeC);
blockVectorC = blockSizeC * ones(1, wholeBlockCols);

% create cell array
CDLL1 = mat2cell(DLL1, blockVectorR, blockVectorC);
WCDLL1 = CDLL1;

% codify the watermark in the (6,6) bit of each block
bits = [6 6];
for i=1:32
    for j=1:32
        cell = CDLL1{i, j};
        
        % codification
        if (W(i, j) == 0)
            cell(bits(1), bits(2)) = cell(bits(1), bits(2))+10;
            WCDLL1{i, j} = cell;
        elseif (W(i, j) == 1)
            cell(bits(1), bits(2)) = cell(bits(1), bits(2))-5;
            WCDLL1{i, j} = cell;
        end
    end
end

% transform back to a matrix (256x256)
% Watermarked DLL1
WDLL1 = cell2mat(WCDLL1);

% inverse dct on each block to obtain LL1 of Wavelet
idct2Handle = @(block_struct) idct2(block_struct.data);
WLL1 = blockproc(WDLL1, [8 8], idct2Handle);

IDWT = idwt2(WLL1,HL1,LH1,HH1,'sym4','mode','per');
imwrite(uint8(IDWT),watermarkedFN);

WI = IDWT;

fprintf('WPSNR(Original, Watermarked) = +%5.2f dB\n', WPSNR(uint8(HI), uint8(WI)));

fprintf('\n Detecting...\n');

% WI = Watermarked Image
WI_A = WI; 
WI_A = test_jpeg(uint8(WI_A), 95);
WI_A = test_blur(WI_A, 7.175000e-01);
WI_A = test_jpeg(uint8(WI_A), 95);
imwrite(uint8(WI_A), attackedFN);

[detected, wpsnr_att] = detection_unemployed(originalFN, watermarkedFN, attackedFN);

%Decision
if detected == 1
    fprintf('Mark has been found. \n');
else
    fprintf('Mark has been lost. \n');
end

fprintf('WPSNR(Watermarked, Attacked) = +%5.2f dB\n', wpsnr_att);

subplot(2,3,1);
imagesc(HI);
colormap gray;
title('Original Image');
subplot(2,3,2);
imagesc(WI);
colormap gray;
title('Watermarked Image');
subplot(2,3,3);
imagesc(double(WI_A));
colormap gray;
title('Attacked Image');
subplot(2,3,4);
imagesc(W);
colormap gray;
title('Watermark');
