function [ x_pos, y_pos, z_pos, sub_img_id, full_name, ftype] = ...
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
[~, full_name, ftype] = fileparts(fname);
fname = full_name;

%% Get Sub-Image ID
start_point = 0;
for i = 0:(numel(fname)-1)
    if strcmp(fname(end-i), '_')
        start_point = i;
        break;
    end
end
sub_img_id = fname((end-(start_point-1)):end);
fname = fname(1:(end-(start_point+2)));


%% Get Z-Position
start_point = 0;
for i = 0:(numel(fname)-1)
    if strcmp(fname(end-i), '_')
        start_point = i;
        break;
    end
end
z_pos = str2double(fname((end-(start_point-1)):end));
fname = fname(1:(end-(start_point+2)));


%% Get Y-Position
start_point = 0;
for i = 0:(numel(fname)-1)
    if strcmp(fname(end-i), '_')
        start_point = i;
        break;
    end
end
y_pos = str2double(fname((end-(start_point-1)):end));
fname = fname(1:(end-(start_point+2)));


%% Get X-Position
start_point = 0;
for i = 0:(numel(fname)-1)
    if strcmp(fname(end-i), '_')
        start_point = i;
        break;
    end
end
x_pos = str2double(fname((end-(start_point-1)):end));


end

