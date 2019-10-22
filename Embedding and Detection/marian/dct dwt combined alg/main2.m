close all; clearvars;

rand('state', 123); % seed random
W = randi([0, 1], 32, 32);

originalFN = 'baboon.bmp';
watermarkedFN = 'WI.bmp';
attackedFN = 'WI_A.bmp';

fprintf('\n Embedding...\n');
HI = imread(originalFN); % host image
[dimx,dimy] = size(HI);
HI = double(HI);

% generate and save watermark
rand('state', 123); % seed random
W = randi([0, 1], 32, 32);
save('W','W');

[LL1,HL1,LH1,HH1] = dwt2(HI,'sym4','mode','per');

dct2Handle = @(block_struct) dct2(block_struct.data);
DLL1 = blockproc(LL1, [8 8], dct2Handle);

% compute CDLL1
blockSizeR = 8;
blockSizeC = 8;

[rows,columns] = size(DLL1);

% Figure out the size of each block in rows and cols
% Most will be blockSizeR and blockSizeC but there 
% may be a remainder amount of less than that
wholeBlockRows = floor(rows / blockSizeR);
blockVectorR = blockSizeR * ones(1, wholeBlockRows);

wholeBlockCols = floor(columns / blockSizeC);
blockVectorC = blockSizeC * ones(1, wholeBlockCols);

% create cell array - CDLL1
CDLL1 = mat2cell(DLL1, blockVectorR, blockVectorC);
WCDLL1 = CDLL1;

for i=1:32
    for j=1:32
        cell = CDLL1{i, j};
        if (W(i, j) == 0)            
            cell(8, 8) = cell(8, 8)+10;
            WCDLL1{i, j} = cell;
        elseif (W(i, j) == 1)
            cell(8, 8) = cell(8, 8)-5;
            WCDLL1{i, j} = cell;
        end
    end
end

WDLL1 = cell2mat(WCDLL1);

idct2Handle = @(block_struct) idct2(block_struct.data);
WLL1 = blockproc(WDLL1, [8 8], idct2Handle);

IDWT = idwt2(WLL1,HL1,LH1,HH1,'sym4','mode','per');
imwrite(uint8(IDWT),watermarkedFN);

WI = IDWT;

fprintf('WPSNR(Original, Watermarked) = +%5.2f dB\n', WPSNR(uint8(HI), uint8(IDWT)));

WI_A = WI;
fprintf('\n Attacking...\n');
imwrite(WI_A, 'SSatt.jpg', 'Quality', 80);
Iatt = imread('SSatt.jpg');
delete('SSatt.jpg');
WI_A = test_sharpening(WI_A, 2, 3);
WI_A = test_resize(WI_A, 2);
imwrite(uint8(WI_A), attackedFN, 'bmp');

fprintf('\n Detecting...\n');
[detected, wpsnr_att] = detection_unemployed(originalFN, watermarkedFN, attackedFN);

%Decision
if detected == 1
    fprintf('Mark has been found. \n');
else
    fprintf('Mark has been lost. \n');
end

fprintf('WPSNR(WI, WI_A) = +%5.2f dB\n', wpsnr_att);
 
subplot(2,3,1)
imagesc(HI)
colormap gray
title('HI')
subplot(2,3,2)
imagesc(WI)
colormap gray
title('WI')
subplot(2,3,3)
imagesc(WI_A)
colormap gray
title('WI_A')
subplot(2,3,4)
imagesc(W)
colormap gray
title('W')


