function [ img_norm ] = img_normalizer_2D( img, new_intensity_max )
% Grayscale Image Normalizer for a 2D Image
%   By: Niklas Gahm
%   2017/06/29
%
%   This is a chunk of code to take an image and scale it to intensity
%   values of 0 to new_intensity_max.
%
%   2017/06/29 - Started 
%   2017/06/29 - Finished



% Determines the extremes of the current range
pix_max = max(max(img));
pix_min = min(min(img));

% The actual normalization step to a 0-1
img_norm = (img - pix_min) / (pix_max - pix_min);

% Expands the range to the user's desired intensity max
img_norm = img_norm .* new_intensity_max;

end