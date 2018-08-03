function [ img_sets ] = axial_img_tiling( img_sets, num_x, num_y)
%% Axial Sectioning Image Tiler
%   By: Niklas Gahm
%   2018/07/27
%
%   This script interfaces with Adib's code to generate the tiled images
%   from the reconstructed images. 
% 
% 
%   2018/07/27 - Started
%   2018/07/27 - Placeholder Finished
%   2018/08/03 - Updated to Handle a Pure Z-Stack Case


%% Generate Z-Stack if Num_X == 1 and Num_Y == 1
if (num_x == 1) && (num_y == 1)
    for i = 1:numel(img_sets)
        img_sets(i).images_tiled.original = zeros( ...
            size(img_sets(i).images_reconstructed(1).image, 1), ...
            size(img_sets(i).images_reconstructed(1).image, 2), ...
            numel(img_sets(i).images_reconstructed));
        for j = 1:numel(img_sets(i).images_reconstructed)
            img_sets(i).images_tiled.original(:,:,j) = ...
                img_sets(i).images_reconstructed(j).image;
        end
    end
    return;
end


%% Otherwise Perform Tiling

%%%%%%% PLACEHOLDER TH1AT SETS THE FORM UNTIL ADIB'S TILING CODE IS ADDED.
for i = 1:numel(img_sets)
    img_sets(i).images_tiled.original = ...
        img_sets(i).images_reconstructed(1).image;
end


end

