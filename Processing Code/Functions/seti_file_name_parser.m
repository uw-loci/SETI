function [ x_pos, y_pos, z_pos, sub_img_id, ftype] = ...
    seti_file_name_parser( fname )
%% SETI File Name Parser
%   By: Niklas Gahm
%   2018/07/23
%
%   This code programatically parses the file names to be used in 
%   conjunction with loading in images
%
%   2018/07/23 - Started
%   2018/07/23 - Finished 



%% Get File Type
[~, fname, ftype] = fileparts(fname);


%% Get Sub-Image ID
start_point = 0;
for i = 1:(numel(fname))
    if strcmp(fname(i), '_')
        start_point = i;
        break;
    end
end
sub_img_id = fname((end-(start_point-1)):end);
fname = fname(1:(start_point+2));


%% Get Z-Position
start_point = 0;
for i = 1:(numel(fname))
    if strcmp(fname(i), '_')
        start_point = i;
        break;
    end
end
z_pos = fname((end-(start_point-1)):end);
fname = fname(1:(start_point+2));


%% Get Y-Position
start_point = 0;
for i = 1:(numel(fname))
    if strcmp(fname(i), '_')
        start_point = i;
        break;
    end
end
y_pos = fname((end-(start_point-1)):end);
fname = fname(1:(start_point+2));


%% Get X-Position
start_point = 0;
for i = 1:(numel(fname))
    if strcmp(fname(i), '_')
        start_point = i;
        break;
    end
end
x_pos = fname((end-(start_point-1)):end);


end

