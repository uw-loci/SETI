function [ img_cube ] = SETI_position_file_img_tiling( ...
    img_sets, xyz_map, um_pixel_conversion)
%% SETI Image Tiler - Position File
%   By: Niklas Gahm
%   2018/11/26
%
%   This script tiles the ssfc images to generate an image cube. 
%   Input Dimensions are 'XYZ'
%   Output Dimensions are XYZ
% 
%   Specifically this script calculates some global variables then switches
%   the tiling algorithm used based on the order of the input dimensions.
%
%
%   2018/12/05 - Started
%   2020/10/20 - Updated for TXYZ
%   2021/09/02 - Adapted to SETI from the SSFC Project




%% Variables
num_pos = numel(xyz_map);


%% Calculate Number of Unique X Y Z Positions
unique_x = [];
unique_y = [];
unique_z = [];
for i = 1:num_pos
    unique_x_flag = 1;
    for j = 1:numel(unique_x)
        if xyz_map(i).x_pos == unique_x(j)
            unique_x_flag = 0;
        end
    end
    if unique_x_flag == 1
        unique_x = [unique_x, xyz_map(i).x_pos]; %#ok<*AGROW>
    end
    
    unique_y_flag = 1;
    for j = 1:numel(unique_y)
        if xyz_map(i).y_pos == unique_y(j)
            unique_y_flag = 0;
        end
    end
    if unique_y_flag == 1
        unique_y = [unique_y, xyz_map(i).y_pos]; %#ok<*AGROW>
    end
    
    unique_z_flag = 1;
    for j = 1:numel(unique_z)
        if xyz_map(i).z_pos == unique_z(j)
            unique_z_flag = 0;
        end
    end
    if unique_z_flag == 1
        unique_z = [unique_z, xyz_map(i).z_pos]; %#ok<*AGROW>
    end
end
num_x = numel(unique_x);
num_y = numel(unique_y);
num_z = numel(unique_z);

% Determine Direction and Sort Unique Positions
x_direction = '+X';
if sum(unique_x(2:end) - unique_x(1:(end-1))) < 0
    x_direction = '-X';
end
y_direction = '+Y';
if sum(unique_y(2:end) - unique_y(1:(end-1))) < 0
    y_direction = '-Y';
end
    
unique_x_sorted = sort(unique_x);
unique_y_sorted = sort(unique_y);
unique_z_sorted = sort(unique_z);



%% Tiling 
% This is structured this way to enable future work for different
% dimensional arrangements that will require seperate sub-functions, easily
% enabled with a switch tree here.
img_cube = SSFC_img_tiling_XYZ( img_sets, ...
            num_x, num_y, num_z, unique_x_sorted, ...
            unique_y_sorted, unique_z_sorted, x_direction, y_direction, ...
            um_pixel_conversion );
end