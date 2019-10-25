function [detected, wpsnr] = detection_nicolae(originalI, watermarkedI, attackedI)
    
    %%Compute wpsnr
    I = imread(originalI);
    I_wat = imread(watermarkedI);
    I_wat_att = imread(attackedI);
    
    wpsnr = WPSNR(uint8(I_wat), uint8(I_wat_att));
    
    %Detect function
    %% Convert them to double
    [dimx,dimy] = size(I_wat);
    I_wat = double(I_wat);
    I  = double(I);

    alpha = 2.5;
    k = 3000;
    %% Load the original watermark
    load('W.mat', 'w');
    w = reshape(w,1,32*32);

    %% Compute DCTs
    I_dct = dct2(I);
    I_wat_dct = dct2(I_wat);

    %% Reshape the DCTs into vectors
    I_wat_dct_flat = reshape(I_wat_dct, 1, dimx*dimy);
    I_dct_flat = reshape(I_dct, 1, dimx*dimy);

    %% Coefficient selection for original image
    [~, index_I_dct_flat_sorted] = sort(abs(I_dct_flat), 'descend');

    %% Watermark extraction
    w_extracted = zeros(1, 32*32);
    for i = 1:32*32
        m = index_I_dct_flat_sorted(k);
        w_extracted(i) = (I_wat_dct_flat(m) - I_dct_flat(m)) / (alpha * I_dct_flat(m));
        k = k + 1; 
    end

    %% Detection
    
    SIM = dot(w, w_extracted)/norm(w_extracted, 2);

    %% Compute threshold
    T = 14.0979;

    %Decision
    if SIM > T
        detected = 1;
    else
        detected = 0;
    end
end

