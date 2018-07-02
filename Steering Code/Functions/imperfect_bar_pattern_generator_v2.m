function [ ] = imperfect_bar_pattern_generator_v2( ...
    pattern_width, pattern_height, pixels_wide, n_rec, ...
    naming_convention, img_file_type, save_path)
%% Imperfect Bar Pattern Generator
%   By: Niklas Gahm
%   2017/08/24 
%
%   This is a piece of code that generates imperfect bar patterns for a 
%   given output image size, meaning aliasing is possible, but any pixel
%   width is permissible. 
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
%           Merely satisfy the inputs and it should work fine, the
%           reconstruction will be worse than if you use the perfect bar
%           pattern, but this has no constraints. 
% 
%   Supported Filetypes:
%       .bmp
% 
%   Supported Reconstruction Types
%       3_Sub_Image - Basic SIM reconstruction with 3 images {i,j,k}
%       4_Sub_Image - Basic SIM reconstruction with 3 images {i,j,k,u}
%       5_Sub_Image - Basic SIM reconstruction with 3 images {i,j,k,u,w}
% 
%   2017/08/24 - Started 
%   2017/08/25 - Finished Imperfect Bar Patterns
%   2018/07/02 - Updated to work in the GUI framework



%% Setup Navigation
hpath = pwd;
cd(save_path);


%% Generate Arch Pattern
pattern = zeros(1, 2*pixels_wide);
pattern(1:pixels_wide) = 1;
pattern = repmat(pattern, pattern_height, ...
    (1+ceil(pattern_width/(pixels_wide*2))));
[pat_xx, pat_yy] = meshgrid(1:size(pattern,2), 1:size(pattern,1));


%% Generate and Save Individual Patterns
for i = 1:n_rec
    pat_shift = (i-1)*(((2*pixels_wide)/n_rec));
    pat_img = interp2(pat_xx, pat_yy, pattern, (pat_xx + pat_shift), ...
        pat_yy);
    pat_img = pat_img(1:pattern_height, 1:pattern_width);
    imwrite(pat_img, [naming_convention{i} num2str(pixels_wide) ...
        img_file_type], img_file_type(2:end));
end


%% Clean Navigation
cd(hpath);
end

