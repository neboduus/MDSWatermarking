close all; clearvars;
start_time = cputime;

img_name = 'bridge.bmp';
our_group_name = 'unemployed';
others_group_name = 'unemployed';

original_img_name = strcat('img/nowatermark/', img_name);
watermarked_img_name = strcat('img/', others_group_name, '_', img_name);
attacked_img_name = strcat('img/', our_group_name, '_', others_group_name, '_', img_name);

watermarked_img = imread(watermarked_img_name);
original_img = imread(original_img_name);
attacked_img = original_img;
detection_function = strcat('detection_', others_group_name);
attacks = [1 2 3 4 5 6];
attacks_permutations = perms(attacks);
jpeg_params = [50:5:100];
blur_params = [0.1:0.7:5];
awgn_params = [1:20:50];
equalization_params = flip([0:50:255]);
resize_params = [1:10:100];
a = [1:30:100];
b = [1:30:100];
[m,n] = ndgrid(a,b);
sharpening_params = [m(:),n(:)];
a = [1:5:20];
b = [1:5:20];
[m,n] = ndgrid(a,b);
median_params = [m(:),n(:)];
result = 0;

maxWPSNR = 0;

for i = 1 : length(jpeg_params)
    attacked_img = original_img;
    selected_jpeg_param = jpeg_params(i);
    
    for j = 1 : length(blur_params)
        selected_blur_param = blur_params(j);
        
        for k = 1 : length(awgn_params)
            selected_awgn_param = awgn_params(i);
            
            for l = 1 : length(equalization_params)
                selected_equalization_param = equalization_params(l);
                
                for m = 1 : length(resize_params)
                    selected_resize_param = resize_params(i);
                    
                    for n = 1 : length(sharpening_params)
                        selected_sharpening_param = sharpening_params(n, :);
                        
                        for o = 1 : length(median_params)
                            selected_median_param = median_params(o, :);

                            for p = 1 : length(attacks_permutations)
                                permutation = attacks_permutations(p, :);

                                for q = 1: length(permutation)
                                    attack_to_perform = permutation(q);

                                    if attack_to_perform==1
                                        % jpeg
                                        attacked_img = test_jpeg(original_img, selected_jpeg_param);

                                    elseif attack_to_perform==2
                                        %blur
                                        attacked_img = test_blur(original_img, selected_blur_param);

                                    elseif attack_to_perform==3
                                        %awgn
                                        attacked_img = test_awgn(original_img, 100, selected_awgn_param);

                                    elseif attack_to_perform==4
                                        %equalization
                                        attacked_img = test_equalization(original_img, selected_equalization_param);

                                    elseif attack_to_perform==5
                                        %resize
                                        attacked_img = test_resize(original_img, selected_resize_param);

                                    elseif attack_to_perform==6
                                        %sharpening
                                        attacked_img = test_sharpening(original_img, selected_sharpening_param(1), selected_sharpening_param(2));
                                    
                                    elseif attack_to_perform==7
                                        %median
                                        attacked_img = test_median(original_img, selected_median_param(1), selected_median_param(2));
                                    
                                    end

                                    imwrite(attacked_img, attacked_img_name);

                                    % calculate WPSNR and check if successfull attack 
                                    clear( detection_function )     
                                    [detected, wpsnr ] = feval(detection_function, original_img_name, watermarked_img_name, attacked_img_name);
                                    if (wpsnr > 35 && detected==0)
                                        fprintf('!!!Breaked Watermarking!!!, WPSR(WI,WI_A)=%d \n', uint8(wpsnr));
                                        fprintf('Permutation: \n');
                                        disp(permutation);
                                        fprintf('JPEG -> %d \n', selected_jpeg_param);
                                        fprintf('AWGN -> %d \n', selected_awgn_param);
                                        fprintf('BLUR -> %d \n', selected_blur_param);
                                        fprintf('SHARPENING -> %d, %d \n', selected_sharpening_param(1), selected_sharpening_param(2));
                                        fprintf('RESIZE -> %d \n', selected_resize_param);
                                        fprintf('EQUALIZATION -> %d \n', selected_equalization_param);
                                        result=1;
                                    end
                                    
                                    

                                end
                            end
                        end

                    end
                end
            end
        end
    end
end

if result==0
    fprintf('No attack worked!\n');
end

stop_time = cputime;
fprintf('Best Attack Detection Execution time = %0.5f sec\n',abs( start_time - stop_time));
    

