function [I_wat, q1, q2] = embedding_nicolae(I_path, alpha, k)
    %Embedding function

    %% Read original image and convert it to double
    I    = imread(I_path);
    [dimx,dimy] = size(I);
    Id   = double(I);

    %% Generate random watermark
    rand('state',123);
    w = round(rand(1,1000));
    save('watermark','w');

    %% Define watermark strenght
    %alpha = 0.5;

    %% Compute DCT
    It = dct2(Id);

    %% Reshape the DCT into a vector
    It_re = reshape(It,1,dimx*dimy);
    % 1 262144

    %% Coefficient selection (hint: use sign, abs and sort functions)
    It_sgn = sign(It_re);
    It_mod = abs(It_re);
    [~,Ix] = sort(It_mod,'descend');

    %% Embedding
    Itw_mod = It_mod; 
    for j = 1:1000
        m = Ix(k);
        Itw_mod(m) = It_mod(m)*(1+alpha*w(j)); % v_i' = v_i * (i + alpha * x_i)
        k = k+1;
    end

    %% Restore the sign and go back to matrix representation using reshape
    It_new = Itw_mod.*It_sgn;
    It_newi=reshape(It_new,dimx,dimy);
    
    %% Inverse DCT
    I_wat = idct2(It_newi);

    %% Show the watermarked image
    imshow(I_wat,[]);

    %% Save the watermarked image
    I_wat = uint8(I_wat);
    imwrite(I_wat, strcp('img/nowatermark/nicolae_', I_path, '.bmp')); 

    %% Calculate PSNR and WPSNR
    q1 = PSNR(uint8(I), uint8(I_wat));
    fprintf('PSNR = +%5.2f dB\n',q1);

    q2 = WPSNR(uint8(I), uint8(I_wat));
    fprintf('WPSNR = +%5.2f dB\n',q2);
end

