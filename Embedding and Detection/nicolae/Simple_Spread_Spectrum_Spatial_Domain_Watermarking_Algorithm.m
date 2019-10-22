close all; clear all; clc;

%-----------------------------------------
%-------WATERMARKING ALGORITHM------------
%-------AUTHOR Piotr Lenarczyk------------
%-------ver. 1.13 24.09.2015y.------------
%-------originally 2009y.-----------------
%-----------------------------------------

% Atention! It is a (simple and nonrobust) Spread Spectrum 
% Watermarking Algorithm in a Spatial Domain and it is  mostly 
% designed on the bases of Tomasz Zielinsky
% great book "Digital Signal Processing".

%% 
% Parameters---------------------------------------------------------------
 
K = 32;         %size of single watermarked block of host image, it  
                %must create a size of host image in a multiple way 
gain = 2;       %Watermark Gain coefficient, 
                %Please note, that if it is set to higher values the 
                %watermark's artefacts are becoming visible

%% 
% Read of host image A, image must have the same X and Y pixel size--------

% %Reading host image from file
% 1. Exact file read
% A = imread('lena512.bmp');
A = imread('lena.bmp');

% 2. Choosing file
% image_format=input...
% ('Choose host image format [j] for *.jpg [b] for *.bmp [j] [b]: ','s')
% if image_format=='j'
%     buffer=pwd;
%     [plik, path] = uigetfile('*.jpg','Read file');
%     cd(path);
%     A=imread(plik);
%     cd(path);
% 
% elseif image_format=='b'
%     buffer=pwd;
%     [plik, path] = uigetfile('*.bmp','Read file');
%     cd(path);
%     A=imread(plik);
%     cd(path);
% end

if length(size(A)) > 2
    A = rgb2ycbcr(A); %if A is color image, not in a greyscale
    B = double(A(:,:,1));
else
    B = double(A);
end

%% 
%-------------------------------------------------
%-----------------ENCODING------------------------
%-------------------------------------------------
% Embedding Watermark into host image A as a product watermarked
% image B is created.-------------------------------------------

[M,N] = size(B);
fprintf('%i\n', N);

%random additional information creation (blank watermark, with the respect
%of algorithm spatial domain)
Mb = (M/K); 
Nb = (N/K);
plusminus1 = sign(randn(1,Mb*Nb))
Watermark = zeros(size(B));
 for i = 1:Mb
    for j = 1:Nb
        Watermark((i-1)*K+1:i*K,(j-1)*K+1:j*K) = plusminus1(i*j);
    end
 end      
 
%watermark is a random information modulated with noise
Noise = round(randn(size(B))); %please take into consideration that
% information about noise Noise is necessary for watermark decoding
WatermarkNoise = gain*Noise.*Watermark;

% adding watermark to host image
B=uint8(B+WatermarkNoise);

if length(size(A)) > 2
    C = uint8(zeros(M,N,3));
    C(:,:,1) = B;
    C(:,:,2) = A(:,:,2);
    C(:,:,3) = A(:,:,3);
    C = ycbcr2rgb(C);
    A = ycbcr2rgb(A);
else
    C = B;
end

%% WPSNR
fprintf('WPSNR = +%5.2f dB\n',WPSNR(uint8(A), uint8(C)));

%% 
% Graphs of A and B image comparison---------------------------------------
figure(1),subplot(1,2,1),...
       imshow(Watermark,[]);    title('Additional Information')
       subplot(1,2,2),imshow(WatermarkNoise,[]); 
                                title('Watermark (after noise modulation)')
figure(2),subplot(1,2,1),imshow((A),[]);           
                                title('Host Image')
       subplot(1,2,2),imshow(C,[]);              
                                title('Watermarked image')

imwrite(C, 'watermarked.bmp', 'bmp');                                
       
%%        
%-------------------------------------------------
%-----------------DECODING------------------------
%-------------------------------------------------
% Additional Information extraction------------------------------
B = double(B);

% High Pass filter
L = 10;
L2 = 2*L+1;
w = hamming(L2);
w = w*w';
f0 = 0.5; 
wc = pi*f0; 
[m,n] = meshgrid(-L:L,-L:L);
lp = wc*besselj(1,wc*sqrt(m.^2+n.^2))./(2*pi*sqrt(m.^2+n.^2));
lp(L+1,L+1) = wc^2/(4*pi);
hp = -lp; hp(L+1,L+1)=1-lp(L+1,L+1);
h = hp.*w;
B = imfilter(B,h,'same');

%% 
% Decision of each bit value of additional information (blank watermark)---
Noise_Demod = B.*Noise;
Sign_Detection = zeros(size(B));
    for i = 1:Mb
        for j = 1:Nb
        Sign_Detection((i-1)*K+1:i*K, (j-1)*K+1:j*K) = ...
            sign(sum(sum(Noise_Demod((i-1)*K+1:i*K, (j-1)*K+1:j*K))));
        end
    end

%{    
%% Detection
    SIM = dot(w, w_extracted)/norm(w_extracted, 2);
    
%% Compute threshold
    randWatermarks = round(rand(999,size(C,2)));
    x = zeros(1,1000);

    x(1) = SIM;  
    for i = 1:999
        w_rand = randWatermarks(i,:);
        x(i+1) = dot(w_rand, C)/norm(C, 2);
    end

    x = abs(x);
    x = sort(x, 'descend');
    t = x(2);
    T = t + 0.1*t;
    fprintf('T = %f\n', T);

    %Decision
    if SIM > T
        fprintf('Mark has been found. \nSIM = %f\n', SIM);
    else
        fprintf('Mark has been lost. \nSIM = %f\n', SIM);
    end    
%%
    
%}    
% Additional Information decoding efficiency-------------------------------
Detection_Errors = sum(sum(abs(Watermark-Sign_Detection)))

%% 
% Graphs-------------------------------------------------------------------
figure(3),subplot(1,2,1);imshow(Noise_Demod,[]);       
                            title('Noise Demodulation')
       subplot(1,2,2);imshow(Sign_Detection,[]);       
                            title('Extracted Additional Information')
        