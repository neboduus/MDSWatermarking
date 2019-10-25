function [SIM, T] = detect(I, I_wat, alpha, k)
    %Detect function
    %% Convert them to double
    [dimx,dimy] = size(I_wat);
    I_wat = double(I_wat);
    I  = double(I);

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
    %{
    randWatermarks = round(rand(999,size(w,2)));
    x = zeros(1,1000);

    x(1) = SIM;  
    for i = 1:999
        w_rand = randWatermarks(i,:);
        x(i+1) = dot(w_rand, w)/norm(w, 2);
    end

    x = abs(x);
    x = sort(x, 'descend');
    t = x(2);
    T = t + 0.1*t;
    fprintf('T = %f\n', T);
    %}
    
    T = 14.0979;
    
    %Decision
    if SIM > T
        fprintf('Mark has been found. \nSIM = %f\n', SIM);
    else
        fprintf('Mark has been lost. \nSIM = %f\n', SIM);
    end
end

