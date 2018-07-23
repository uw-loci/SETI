function [ pattern_pixel_width, num_sub_img, aperture_percent, ...
    pattern ] = seti_folder_name_parser( dname )
%% SETI Folder Name Parser
%   By: Niklas Gahm
%   2018/07/23
%
%   This code programatically parses the sub-folder names to be used in 
%   conjunction with loading in images
%
%   2018/07/23 - Started
%   2018/07/23 - Finished 



%% Get Pattern Pixel Width
start_point = 0;
for i = 1:(numel(dname))
    if strcmp(dname(i), ' ')
        start_point = i;
        break;
    end
end
pattern_pixel_width = str2double(dname(1:(start_point-4)));
dname = dname((start_point+1):end);


%% Get Sub Image Count
start_point = 0;
for i = 1:(numel(dname))
    if strcmp(dname(i), ' ')
        start_point = i;
        break;
    end
end
num_sub_img = str2double(dname(1:(start_point-3)));
dname = dname((start_point+1):end);


%% Get Aperture Percentage
start_point = 0;
for i = 1:(numel(dname))
    if strcmp(dname(i), ' ')
        start_point = i;
        break;
    end
end
aperture_percent = str2double(dname(1:(start_point-3)));


%% Get Pattern
pattern = dname((start_point+1):end);


end

