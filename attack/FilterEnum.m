classdef FilterEnum
properties
id
name
end

methods
function c = FilterEnum(id, name)
  c.id = id; c.name = name;
end
end

enumeration
AWGN (0, 'AWGN')
BLURRING (1, 'Blurring')
SHARPENING (2, 'Sharpening')
JPEG (3, 'JPEG')
EQUALIZATION (4, 'Equalization')
RESIZING (5, 'Resizing')
MEDIAN (6, 'Median')
end
end
