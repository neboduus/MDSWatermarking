classdef FilterConfiguration
properties
filter
noisepower %AWGN, BLURRING, EQUALIZATION, RESIZING, SHARPENING
seed %AWGN
qualityfactor %JPEG
na %MEDIAN
nb %MEDIAN
nradius %SHARPENING
end
methods
function obj = FilterConfiguration(filter, noisepower, seed, qualityfactor, na, nb, nradius)
  obj.filter = filter;
  obj.noisepower = noisepower;
  obj.seed = seed;
  obj.qualityfactor = qualityfactor;
  obj.na = na;
  obj.nb = nb;
  obj.nradius = nradius;
end
function run_filter(obj, aI_name)
  I = imread(aI_name);
  switch uint32(obj.filter.id)
  case uint32(FilterEnum.AWGN.id)
    %noisepower = .000001; seed = 100;
    rand('state',obj.seed);
    aI = imnoise(I,'gaussian',0,obj.noisepower);
    imwrite(aI, aI_name);
  case uint32(FilterEnum.BLURRING.id)
    %noisepower = 2;
    aI = imgaussfilt(I,obj.noisepower);
    imwrite(aI, aI_name);
  case uint32(FilterEnum.EQUALIZATION.id)
    %noisepower = 20;
    aI = histeq(I,obj.noisepower);
    imwrite(aI, aI_name);
  case uint32(FilterEnum.JPEG.id)
    %qualityfactor = 50;
    imwrite(I, strrep(aI_name,'.bmp','.jpg'), 'Quality', obj.qualityfactor);
  case uint32(FilterEnum.MEDIAN.id)
    %na = 20;
    %nb = 40;
    aI = medfilt2(I,[obj.na obj.nb]);
    imwrite(aI, aI_name);
  case uint32(FilterEnum.RESIZING.id)
    %noisepower = 0.1;
    n = size(I);
    I = double(I);
    aI = imresize(I, obj.noisepower);
    aI = imresize(aI, 1/obj.noisepower);
    aI = uint8(aI(1:n(1), 1:n(2)));
    imwrite(aI, aI_name);
  case uint32(FilterEnum.SHARPENING.id)
    %nradius = 3;
    %noisepower = 1;
    aI = imsharpen(I, 'Radius', obj.nradius, 'Amount', obj.noisepower);
    imwrite(aI, aI_name);
  end
end
end
end
