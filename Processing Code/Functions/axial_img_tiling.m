function [ img_sets ] = axial_img_tiling( img_sets )
%% SIM Image Sorter Based on lp/mm and Reconstruction Type  
%   By: Niklas Gahm
%   2018/07/27
%
%   This script interfaces with Adib's code to generate the tiled images
%   from the reconstructed images. 
% 
% 
%   2018/07/27 - Started
%   2018/07/27 - Placeholder finished



%%%%%%% PLACEHOLDER TH1AT SETS THE FORM UNTIL ADIB'S TILING CODE IS ADDED.
for i = 1:numel(img_sets)
    img_sets(i).images_tiled = img_sets(i).images_reconstructed(1).image;
end


end

