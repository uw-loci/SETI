function [ img_sets ] = axial_framework_img_loader( file_path )
%% Axial Framework Image Loader
%   By: Niklas Gahm
%   2018/07/23
%
%   This code programatically loads in images and generates the apropriate
%   structs needed for the remainder of the processing code
%
%   2018/07/23 - Started
%   2018/07/23 - Finished 



%% Setup Navigation
hpath = pwd;
% addpath('.\Functions\bfmatlab');
cd(file_path);


%% Get Directory List 
dir_list = dir;
dir_list = dir_list(3:end);


%% Setup Img Set Structs
img_sets = struct;
valid_folder_counter = 0;
for i = 1:numel(dir_list)
    if isdir(dir_list(i).name)
        valid_folder_counter = valid_folder_counter + 1;
        img_sets(valid_folder_counter).name = dir_list(i).name;
        img_sets(valid_folder_counter).images = struct;
        if ~strcmpi(dir_list(i).name, 'Bright Field') && ...
                ~strcmpi(dir_list(i).name, 'BF')
            [img_sets(valid_folder_counter).pattern_pixel_width, ...
                img_sets(valid_folder_counter).num_sub_img, ...
                img_sets(valid_folder_counter).aperture_percent, ...
                img_sets(valid_folder_counter).pattern ] = ...
                seti_folder_name_parser( dir_list(i).name );
            img_sets(valid_folder_counter).images_reconstructed = {};
        else
            img_sets(valid_folder_counter).pattern_pixel_width = 0;
            img_sets(valid_folder_counter).num_sub_img = 0;
            img_sets(valid_folder_counter).aperture_percent = ...
                str2double(dir_list(i).name(14:(end-2)));
        end
    end
end


%% Fill in img_sets.images
for i = 1:valid_folder_counter
    cd(img_sets(i).name);
    img_list = dir;
    img_list = img_list(3:end);
    for j = 1:numel(img_list)
        [ img_sets(i).images(j).x_pos, img_sets(i).images(j).y_pos, ...
            img_sets(i).images(j).z_pos, ...
            img_sets(i).images(j).sub_img_id, ...
            img_sets(i).images(j).name, ...
            img_sets(i).images(j).ftype ] = ...
            seti_file_name_parser( img_list(j).name );
        
        % Use Bioformats to Load in Image
         temp = bfopen(img_list(j).name);
         img_sets(i).images(j).image = double(temp{1,1}{1,1});
        
    end
    cd(file_path);
end


%% Clean Navigation
cd(hpath);
end
