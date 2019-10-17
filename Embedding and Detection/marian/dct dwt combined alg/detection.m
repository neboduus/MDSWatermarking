close all; clearvars;

start_time = cputime;

HI    = imread('lena.bmp');
WI   = imread('WI.bmp');
load('W');

% some attacks
imwrite(WI, 'SSatt.jpg', 'Quality', 70);
WI = imread('SSatt.jpg');
WI = test_sharpening(WI, 2, 3);
WI = test_resize(WI, 2);

HI = double(HI);
WI = double(WI);

[dimx,dimy] = size(WI);

[HLL1,HHL1,HLH1,HHH1] = dwt2(HI,'sym4','mode','per');
[WLL1,WHL1,WLH1,WHH1] = dwt2(WI,'sym4','mode','per');

blockSizeR = 8;
blockSizeC = 8;
[rows,columns] = size(HLL1);

wholeBlockRows = floor(rows / blockSizeR);
blockVectorR = blockSizeR * ones(1, wholeBlockRows);

wholeBlockCols = floor(columns / blockSizeC);
blockVectorC = blockSizeC * ones(1, wholeBlockCols);

CWLL1 = mat2cell(WLL1, blockVectorR, blockVectorC);
CHLL1 = mat2cell(HLL1, blockVectorR, blockVectorC);

M1 = ones(wholeBlockRows,wholeBlockCols);
M2 = ones(wholeBlockRows,wholeBlockCols);

for i=1:wholeBlockRows
    for j=1:wholeBlockCols
        WDCT = dct2(CWLL1{i,j});
        HDCT = dct2(CHLL1{i,j});

        M1(i,j) = WDCT(8,8);
        M2(i,j) = HDCT(8,8);
    end
end

ExW = ones(32,32);
M3 = M1 - M2;
for i=1:wholeBlockRows
    for j=1:wholeBlockCols
        if (M3(i,j)>=0)
            ExW(i,j) = 0;
        else
            ExW(i,j) = 1;
        end
    end
end

ExW = double(ExW);
[Wx,Wy] = size(ExW);
ExW = reshape(ExW, 1, Wx*Wy);
W = reshape(W, 1, Wx*Wy);

SIMs = zeros(1,1000);
SIM = W * ExW' / sqrt(ExW * ExW');
SIMs(1) = SIM;

for i=1:999
    randW = randi([0, 1], 32, 32);
    randW = reshape(randW, 1, Wx*Wy);
    SIMs(i+1) = W * randW' / sqrt(randW * randW');
end

SIMs = abs(SIMs);
SIMs = sort(SIMs, 'descend');
t = SIMs(2);
T = t + 0.1*t;
fprintf('T= +%5.2f dB\n',T);
% stem(SIMs);

%Decision
if SIM > T
    fprintf('Mark has been found. \nSIM = %f\n', SIM);
else
    fprintf('Mark has been lost. \nSIM = %f\n', SIM);
end

stop_time = cputime;
fprintf('Execution time = %0.5f sec\n',abs( start_time - stop_time));














