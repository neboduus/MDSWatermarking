function [detected, wpsnr] = detection_unemployed(originalI, watermarkedI, attackedI)

    start_time = cputime;
    
    T = 14.0979;

    HI = imread(originalI);
    WI = imread(watermarkedI);
    WI_A = imread(attackedI);

    wpsnr = WPSNR(uint8(WI), uint8(WI_A));

    HI = double(HI);
    WI = double(WI);
    WI_A = double(WI_A);

    [HLL1,HHL1,HLH1,HHH1] = dwt2(HI,'sym4','mode','per');
    [WLL1,WHL1,WLH1,WHH1] = dwt2(WI,'sym4','mode','per');
    [WLL1_A,WHL1_A,WLH1_A,WHH1_A] = dwt2(WI_A,'sym4','mode','per');

    blockSizeR = 8;
    blockSizeC = 8;
    [rows,columns] = size(HLL1);

    wholeBlockRows = floor(rows / blockSizeR);
    blockVectorR = blockSizeR * ones(1, wholeBlockRows);

    wholeBlockCols = floor(columns / blockSizeC);
    blockVectorC = blockSizeC * ones(1, wholeBlockCols);

    CWLL1 = mat2cell(WLL1, blockVectorR, blockVectorC);
    CHLL1 = mat2cell(HLL1, blockVectorR, blockVectorC);
    CWLL1_A = mat2cell(WLL1_A, blockVectorR, blockVectorC);

    M0 = ones(wholeBlockRows,wholeBlockCols);
    M1 = ones(wholeBlockRows,wholeBlockCols);
    M2 = ones(wholeBlockRows,wholeBlockCols);

    for i=1:wholeBlockRows
        for j=1:wholeBlockCols
            WDCT = dct2(CWLL1{i,j});
            WDCT_A = dct2(CWLL1_A{i,j});
            HDCT = dct2(CHLL1{i,j});

            M0(i,j) = WDCT(8,8);
            M1(i,j) = WDCT_A(8,8);
            M2(i,j) = HDCT(8,8);
        end
    end

    W = ones(32,32); % the original W
    ExW = ones(32,32); % the extracted W

    M3 = M1 - M2;
    M4 = M0 - M2;
    for i=1:wholeBlockRows
        for j=1:wholeBlockCols
            if (M3(i,j)>=0)
                ExW(i,j) = 0;
            else
                ExW(i,j) = 1;
            end
            
            if (M4(i,j)>=0)
                W(i,j) = 0;
            else
                W(i,j) = 1;
            end
        end
    end

    ExW = double(ExW);
    W = double(W);
    
    [Wx,Wy] = size(W);
    ExW = reshape(ExW, 1, Wx*Wy);
    W = reshape(W, 1, Wx*Wy);

    SIM = W * ExW' / sqrt(ExW * ExW');

    fprintf('SIM(W,ExW) = %d \n', SIM);
    fprintf('T = %d \n', T);
    
    %Decision
    if SIM > T
        detected = 1;
    else
        detected = 0;
    end

    stop_time = cputime;
    %fprintf('Detection Execution time = %0.5f sec\n',abs( start_time - stop_time));














