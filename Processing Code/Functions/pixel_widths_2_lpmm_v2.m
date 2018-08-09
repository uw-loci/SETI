function [ img_sets ] = pixel_widths_2_lpmm_v2( ...
    img_sets,  f_number, obj_mag, pixel_lpmm_conv )
%% Pixel Widths to lp/mm Converter 
%   By: Niklas Gahm
%   2017/11/28
%
%   This code converts a pattern pixel width into a real lp/mm 
% 
%   2017/11/24 - Started 
%   2017/11/30 - Finished
%   2018/07/27 - Updated for the GUI framework



%% Calculate Useful Variables
field_of_view = f_number / obj_mag;


%% Convert Pattern Pixel Widths
for i = 1:numel(img_sets)
    if ~strcmp(img_sets(i).name, 'Bright Field')
        img_sets(i).lpmm = (field_of_view / pixel_lpmm_conv) * ...
            img_sets(i).pattern_pixel_width;
    else
        img_sets(i).lpmm = 0;
    end
end

end