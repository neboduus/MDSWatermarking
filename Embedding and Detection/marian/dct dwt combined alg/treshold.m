close all; clearvars;

% generate and save watermark, only before competition
rand('state', 123); % seed random
W = randi([0, 1], 32, 32);
[Wx, Wy] = size(W);
save('W','W');
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