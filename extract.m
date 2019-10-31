function [W] = extract(originalI, watermarkedI)

    start_time = cputime;

    HI = imread(originalI);
    WI = imread(watermarkedI);

    HI = double(HI);
    WI = double(WI);

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

    bits = [6 6];
    for i=1:wholeBlockRows
        for j=1:wholeBlockCols
            WDCT = dct2(CWLL1{i,j});
            HDCT = dct2(CHLL1{i,j});

            M1(i,j) = WDCT(bits(1),bits(2));
            M2(i,j) = HDCT(bits(1),bits(2));
        end
    end

    W = ones(32,32); % the original W
    ExW = ones(32,32); % the extracted W

    M3 = M1 - M2;
    for i=1:wholeBlockRows
        for j=1:wholeBlockCols
            if (M3(i,j)>=0)
                W(i,j) = 0;
            else
                W(i,j) = 1;
            end
        end
    end
    

    stop_time = cputime;
    % fprintf('Detection Execution time = %0.5f sec\n',abs( start_time - stop_time));














