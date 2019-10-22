close all; clearvars;

HI = imread("lena.bmp"); % host image
[dimx,dimy] = size(HI);
HI = double(HI);

load("W");

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
imwrite(uint8(IDWT),'WI.bmp');

subplot(3,3,1)
imagesc(LL1)
colormap gray
title('Approximation')
subplot(3,3,2)
imagesc(HL1)
colormap gray
title('Horizontal')
subplot(3,3,3)
imagesc(LH1)
colormap gray
title('Vertical')
subplot(3,3,4)
imagesc(HH1)
colormap gray
title('Diagonal')
subplot(3,3,5)
imagesc(DLL1)
colormap gray
title('DLL1')
subplot(3,3,6)
imagesc(IDWT)
colormap gray
title('IDWT')
subplot(3,3,7)
imagesc(W)
colormap gray
title('W')
subplot(3,3,8)
imagesc(HI)
colormap gray
title('Original')

wpsnr = WPSNR(uint8(HI), uint8(IDWT));
fprintf('WPSNR = +%5.2f dB\n',wpsnr);
