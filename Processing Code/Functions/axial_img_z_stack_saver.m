function [ ] = axial_img_z_stack_saver( img_sets, fpath, img_save_type )
%% Axial Image Z-Stack Saver
%   By: Niklas Gahm
%   2018/08/03
%
%   This script Saves the Generated Z-Stacks of Tiled Images
%
%
%   2018/08/03 - Started
%   2018/08/03 - Finished



%% Setup Navigation
hpath = pwd;


%% Generate Medium and Small Sized Stack
for i = 1:numel(img_sets)
    if size(img_sets(i).images_tiled.original, 1) > ...
            size(img_sets(i).images_tiled.original, 2)
        resize_factor_medium = 512 / ...
            size(img_sets(i).images_tiled.original, 1);
        img_sets(i).images_tiled.medium = zeros( ...
            (size(img_sets(i).images_tiled.original, 1) * ...
            resize_factor_medium), floor(size( ...
            img_sets(i).images_tiled.original, 2) * ...
            resize_factor_medium), size( ...
            img_sets(i).images_tiled.original, 3));
        
        resize_factor_small = 256 / ...
            size(img_sets(i).images_tiled.original, 1);
        img_sets(i).images_tiled.small = zeros( ...
            (size(img_sets(i).images_tiled.original, 1) * ...
            resize_factor_small), floor(size( ...
            img_sets(i).images_tiled.original, 2) * ...
            resize_factor_small), size( ...
            img_sets(i).images_tiled.original, 3));
        
    else
        resize_factor_medium = 512 / ...
            size(img_sets(i).images_tiled.original, 2);
        img_sets(i).images_tiled.medium = zeros( ...
            floor(size(img_sets(i).images_tiled.original, 1) * ...
            resize_factor_medium), (size( ...
            img_sets(i).images_tiled.original, 2) * ...
            resize_factor_medium), size( ...
            img_sets(i).images_tiled.original, 3));
        
        resize_factor_small = 256 / ...
            size(img_sets(i).images_tiled.original, 2);
        img_sets(i).images_tiled.small = zeros( ...
            floor(size(img_sets(i).images_tiled.original, 1) * ...
            resize_factor_small), (size( ...
            img_sets(i).images_tiled.original, 2) * ...
            resize_factor_small), size( ...
            img_sets(i).images_tiled.original, 3));
    end
    
    for j = 1:size(img_sets(i).images_tiled.original, 3)
        img_sets(i).images_tiled.medium(:,:,j) = resizem( ...
            img_sets(i).images_tiled.original(:,:,j), ...
            resize_factor_medium, 'bilinear');
        img_sets(i).images_tiled.small(:,:,j) = resizem( ...
            img_sets(i).images_tiled.original(:,:,j), ...
            resize_factor_small, 'bilinear');
    end
end


%% Save Z-Stacks
for i = 1:numel(img_sets)
    spath = [fpath '\' img_sets(i).name '\Reconstructed Stack'];
    mkdir(spath);
    bfsave(uint8(img_sets(i).images_tiled.original), ...
        [spath '\' img_sets(i).name '_original' ...
        img_save_type]);
    bfsave(uint8(img_sets(i).images_tiled.medium), ...
        [spath '\' img_sets(i).name '_medium' ...
        img_save_type]);
    bfsave(uint8(img_sets(i).images_tiled.small), ...
        [spath '\' img_sets(i).name '_small' ...
        img_save_type]);
end


%% Clean Navigation
cd(hpath);

end
