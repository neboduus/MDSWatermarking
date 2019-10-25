close all; clearvars;
% computes the treshold

% load watermark
W = load('W');
W = reshape(W, 1, Wx*Wy);

SIMs = zeros(1,1000);

rand('state', 123);
for i=1:999
    randW = randi([0, 1], 32, 32);
    randW = reshape(randW, 1, Wx*Wy);
    SIMs(i+1) = W * randW' / sqrt(randW * randW');
end

SIMs = abs(SIMs);
SIMs = sort(SIMs, 'descend');
t = SIMs(2);
T = t + 0.1*t;