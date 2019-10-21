function aI_name = run_filter(aI_name, filter)
  I = imread(aI_name);
  switch uint32(filter.id)
  case uint32(FilterEnum.AWGN.id)
    noisepower = .000001; seed = 100;
    rand('state',seed);
    aI = imnoise(I,'gaussian',0,noisepower);
    imwrite(aI, aI_name);
  case uint32(FilterEnum.BLURRING.id)
    noisepower = 2;
    aI = imgaussfilt(I,noisepower);
    imwrite(aI, aI_name);
  case uint32(FilterEnum.EQUALIZATION.id)
    noisepower = 20;
    aI = histeq(I,noisepower);
    imwrite(aI, aI_name);
  case uint32(FilterEnum.JPEG.id)
    qualityfactor = 50;
    imwrite(I, strrep(aI_name,'.bmp','.jpg'), 'Quality', qualityfactor);
  case uint32(FilterEnum.MEDIAN.id)
    na = 20;
    nb = 40;
    aI = medfilt2(I,[na nb]);
    imwrite(aI, aI_name);
  case uint32(FilterEnum.RESIZING.id)
    noisepower = 0.1;
    n = size(I);
    I = double(I);
    aI = imresize(I, noisepower);
    aI = imresize(aI, 1/noisepower);
    aI = uint8(aI(1:n(1), 1:n(2)));
    imwrite(aI, aI_name);
  case uint32(FilterEnum.SHARPENING.id)
    nradius = 3;
    noisepower = 1;
    aI = imsharpen(I, 'Radius', nradius, 'Amount', noisepower);
    imwrite(aI, aI_name);
  end
end
