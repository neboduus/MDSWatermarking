

I    = imread(img_fname);
[dimx,dimy] = size(I);
Id   = double(I);

% generate and save watermark
rand('state', 123); % seed random
w = round(rand(1,1000));
save('watermark','w');

% SS embedding param
alpha = 0.75;
save('alpha','alpha');

J = dct2(Id);
J_prime = reshape(J, 1, dimx*dimy);

% store the sign to restore image and sort in order to exclude DC
J_sign = sign(J_prime);
J_mod = abs(J_prime);
[J_sorted, indexes_sorted] = sort(J_mod, 'descend');

% add watermark
sizes = size(J_sorted);
k = uint32(sizes(2)/10);
%k = 2;
save('k','k');

for j=1:1000
    index_to_watermark = indexes_sorted(k);
    % multiplicative
    J_mod(index_to_watermark) = J_mod(index_to_watermark) * (1+alpha*w(j));
    % additive 
    % J_mod(index_to_watermark) = J_mod(index_to_watermark) * (1+alpha);
    k = k+1;
end

% restore original format
a = J_mod .* J_sign;
J_restored = reshape(a, dimx, dimy);
I_wat = idct2(J_restored);

imwrite(uint8(I_wat),'SSwat.bmp'); 

subplot(1,2,1); 
imshow(I);
title('Original');

subplot(1,2,2); 
imshow(uint8(I_wat));
title('Watermarked');

q2 = WPSNR(uint8(I), uint8(I_wat));
fprintf('WPSNR = +%5.2f dB\n',q2);
 
