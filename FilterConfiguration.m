classdef FilterConfiguration
properties
filter FilterEnum
noisepower %AWGN, BLURRING, EQUALIZATION, RESIZING, SHARPENING
seed %AWGN
qualityfactor %JPEG
na %MEDIAN
nb %MEDIAN
nradius %SHARPENING
end
methods
function obj = setFilter(obj, filter)
  obj.filter = filter;
end
function obj = setNoisepower(obj, noisepower)
  obj.noisepower = noisepower;
end
function obj = setSeed(obj, seed)
  obj.seed = seed;
end
function obj = setQualityfactor(obj, qualityfactor)
  obj.qualityfactor = qualityfactor;
end
function obj = setNa(obj, na)
  obj.na = na;
end
function obj = setNb(obj, nb)
  obj.nb = nb;
end
function obj = setNradius(obj, nradius)
  obj.nradius = nradius;
end
function p = parameters(obj)
  switch uint32(obj.filter.id)
  case uint32(FilterEnum.AWGN.id)
    p = sprintf('noisepower = %f, seed = %d', obj.noisepower, obj.seed);
  case uint32(FilterEnum.BLURRING.id)
    p = sprintf('noisepower = %d', obj.noisepower);
  case uint32(FilterEnum.EQUALIZATION.id)
    p = sprintf('noisepower = %d', obj.noisepower);
  case uint32(FilterEnum.JPEG.id)
    p = sprintf('qualityfactor = %d', obj.qualityfactor);
  case uint32(FilterEnum.MEDIAN.id)
    p = sprintf('na = %d, nb = %d', obj.na, obj.nb);
  case uint32(FilterEnum.RESIZING.id)
    p = sprintf('noisepower = %f', obj.noisepower);
  case uint32(FilterEnum.SHARPENING.id)
    p = sprintf('noisepower = %d, nradius = %d', obj.noisepower, obj.nradius);
  end
end
function [aI_name, aI] = run_filter(obj, aI_name)
  aI = imread(aI_name);
  switch uint32(obj.filter.id)
  case uint32(FilterEnum.AWGN.id)
    %noisepower = .000001; seed = 100;
    %rand('state',obj.seed); OLD
    rng(obj.seed, 'twister');
    aI = imnoise(aI,'gaussian',0,obj.noisepower);
    imwrite(aI, aI_name);
  case uint32(FilterEnum.BLURRING.id)
    %noisepower = 2;
    aI = imgaussfilt(aI,obj.noisepower);
    imwrite(aI, aI_name);
  case uint32(FilterEnum.EQUALIZATION.id)
    %noisepower = 20;
    aI = histeq(aI,obj.noisepower);
    imwrite(aI, aI_name);
  case uint32(FilterEnum.JPEG.id)
    %qualityfactor = 50;
    aI_name = strrep(aI_name,'.bmp','.jpg');
    imwrite(aI, aI_name, 'Quality', obj.qualityfactor);
  case uint32(FilterEnum.MEDIAN.id)
    %na = 20;
    %nb = 40;
    aI = medfilt2(aI,[obj.na obj.nb]);
    imwrite(aI, aI_name);
  case uint32(FilterEnum.RESIZING.id)
    %noisepower = 0.1;
    n = size(aI);
    aI = double(aI);
    aI = imresize(aI, obj.noisepower);
    aI = imresize(aI, 1/obj.noisepower);
    aI = uint8(aI(1:n(1), 1:n(2)));
    imwrite(aI, aI_name);
  case uint32(FilterEnum.SHARPENING.id)
    %nradius = 3;
    %noisepower = 1;
    aI = imsharpen(aI, 'Radius', obj.nradius, 'Amount', obj.noisepower);
    imwrite(aI, aI_name);
  end
end
end
end
