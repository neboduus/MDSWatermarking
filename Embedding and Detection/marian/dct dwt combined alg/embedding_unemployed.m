function [originalI, watermarkedI, wpsnr] = embedding_unemployed(iName, W)

    HI = imread(iName); % host image
    HI = double(HI);
    originalI = HI;

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

    for i=1:3
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
    watermarkedI = IDWT;
    imwrite(IDWT, "WI.bmp");

    wpsnr = WPSNR(uint8(HI), uint8(IDWT));
    
