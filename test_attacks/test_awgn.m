
function Iatt = test_awgn(Iw, noisePower)

Iatt = imnoise(Iw,'gaussian',0,noisePower);

