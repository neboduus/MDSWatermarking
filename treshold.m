close all; clearvars;

img_name = 'lena.bmp';
originalFN = strcat('img/nowatermark/', img_name);
watermarkedFN = strcat('img/unemployed_', img_name);
attackedFN = 'img/WI_A.bmp';

fprintf('\n Embedding...\n');
HI = imread(originalFN); % host image
[dimx,dimy] = size(HI);
HI = double(HI);

% load watermark from file
load('W.mat');
W = w;

% Compute Wavelet Transform
[LL1,HL1,LH1,HH1] = dwt2(HI,'sym4','mode','per');

% Apply 8x8 block DCT on LL1 level of Wavelet Transform

% create function handler to apply on 8x8 blocks
dct2Handle = @(block_struct) dct2(block_struct.data);

% apply 
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

bits = [6 6];
for i=1:32
    for j=1:32
        cell = CDLL1{i, j};
        if (W(i, j) == 0)            
            cell(bits(1), bits(2)) = cell(bits(1), bits(2))+10;
            WCDLL1{i, j} = cell;
        elseif (W(i, j) == 1)
            cell(bits(1), bits(2)) = cell(bits(1), bits(2))-5;
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

fprintf('WPSNR(Original, Watermarked) = +%5.2f dB\n', WPSNR(uint8(HI), uint8(WI)));

fprintf('\n Extracting...\n');

[extractedW] = extract(originalFN, watermarkedFN);
[Wx, Wy] = size(W);
W = reshape(W, 1, Wx*Wy);
extractedW = reshape(extractedW, 1, Wx*Wy);
s = W * extractedW' / sqrt(extractedW * extractedW');
SIMs = zeros(1,1000);
SIMs(1) = s;

rand('state', 123);
for i=1:999
    randW = randi([0, 1], 32, 32);
    randW = reshape(randW, 1, Wx*Wy);
    SIMs(i+1) = W * randW' / sqrt(randW * randW');
end

SIMs = abs(SIMs);
SIMs = sort(SIMs, 'descend');
t = SIMs(2);
T = t + 0.1*t;

W = reshape(W, Wx, Wy);
extractedW = reshape(extractedW, Wx, Wy);

%Decision
if s >= T
    fprintf('Mark has been found. \n');
else
    fprintf('Mark has been lost. \n');
end
fprintf('T = +%5.2f\n', T);

%fprintf('WPSNR(WI, WI_A) = +%5.2f dB\n', wpsnr_att);
 
subplot(2,2,1)
imagesc(HI)
colormap gray
title('HI')
subplot(2,2,2)
imagesc(WI)
colormap gray
title('WI')
subplot(2,2,3)
imagesc(W)
colormap gray
title('W')
subplot(2,2,4)
imagesc(extractedW)
colormap gray
title('extractedW')


