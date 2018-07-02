function [ ] = perfect_bar_pattern_generator_v2( ...
    pattern_width, pattern_height, pixels_wide, n_rec, ...
    naming_convention, img_file_type, save_path)
%% Perfect Bar Pattern Generator
%   By: Niklas Gahm
%   2017/08/22 
%
%   This is a piece of code that generates perfect bar patterns for a given
%   output image size. 
%
%   Variables:
%       pattern_width - The output image width 
%       pattern_height - The output image height 
%       pixels_wide - The width of a single bar
%       n_rec - the number of reconstruction images to output
%       naming_convention - This is the given naming convention for saving
%           the output images with
%       img_file_type - This is the output image file type
% 
%   Usage:
%           When you run this code make sure the pixels_wide is divisible 
%           by n_rec and by n_rec-1 otherwise perfect bar patterns cannot
%           be generated. 
% 
%   Supported Filetypes:
%       .bmp
% 
%   Supported Reconstruction Types
%       3_Sub_Image - Basic SIM reconstruction with 3 images {i,j,k}
%       4_Sub_Image - Basic SIM reconstruction with 3 images {i,j,k,u}
%       5_Sub_Image - Basic SIM reconstruction with 3 images {i,j,k,u,w}
% 
%   2017/08/22 - Started 
%   2017/08/24 - Finished Perfect Bar Patterns
%   2018/07/02 - Updated to work in the GUI framework



%% Setup Navigation
hpath = pwd;
cd(save_path);


%% Check for Conditions
if mod(pixels_wide, n_rec) ~= 0
    cd(hpath);
    rmdir(save_path); % Deletes the path that can't be used.
    error(['For perfect bar patterns the pixels_wide must be ' ...
        'divisible by the n_rec (number of reconstruction images).']);
end


%% Generate Arch Pattern
pattern = zeros(1, 2*pixels_wide);
pattern(1:pixels_wide) = 1;
pattern = repmat(pattern, pattern_height, ...
    (1+ceil(pattern_width/(pixels_wide*2))));


%% Generate and Save Individual Patterns
for i = 1:n_rec
    pat_img = circshift(pattern, (-1*(i-1)*(((2*pixels_wide)/n_rec))), 2);
    pat_img = pat_img(1:pattern_height, 1:pattern_width);
    imwrite(pat_img, [naming_convention{i} num2str(pixels_wide) ...
        img_file_type], img_file_type(2:end));
end


%% Clean Navigation
cd(hpath);
end

