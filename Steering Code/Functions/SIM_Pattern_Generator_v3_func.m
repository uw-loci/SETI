function [] = SIM_Pattern_Generator_v3_func( save_path, pixels_wide, ...
    pattern_width, pattern_height, reconstruction_type, pattern, ...
    file_type, aperture_percent, rotation)
%   By: Niklas Gahm
%   2017/08/21
%
%   This is a framework that generates the needed patterns for an axial 
%   sectioning microscope
%
%   Variables:
%       pattern_width - The output image width
%       pattern_height - The output image height
%       pixels_wide - The pattern width in pixels 
%       reconstruction_type - The type of reconstruction to be used. See 
%                   Supported Reconstruction Types. 
%       img_file_type - Desired file type for the output image. See
%                   Supported Filetypes
%       pattern - The pattern type to be generated. See Supported Patterns
% 
%   Usage:
%           When you run the framework please specify the relevant
%           variables down below.
% 
%   Supported Filetypes:
%       .bmp
% 
%   Supported Reconstruction Types
%       3_Sub_Image - Basic SIM reconstruction with 3 images {i,j,k}
%       4_Sub_Image - Basic SIM reconstruction with 3 images {i,j,k,u}
%       5_Sub_Image - Basic SIM reconstruction with 3 images {i,j,k,u,w}
% 
%   Supported Pattern Types
%       Perfect Bar
%       Imperfect Bar
%       Imperfect Sine Wave
% 
%   2017/08/22 - Started 
%   2017/08/24 - Finished Perfect Bar Patterns
%   2017/08/25 - Finished Imperfect Bar Patterns 
%   2017/08/25 - Finished Imperfect Sine Wave Patterns
%   2018/07/02 - Converted from a script into a function to work with GUI
%   2018/08/08 - Updated to enable rotating whole pattern sets



%% Variable Generator
switch reconstruction_type
    case '3 Sub Image'
        n_rec = 3;
        naming_convention = {'i', 'j', 'k'};
    case '4 Sub Image'
        n_rec = 4;
        naming_convention = {'i', 'j', 'k', 'u'};
    case '5 Sub Image'
        n_rec = 5;
        naming_convention = {'i', 'j', 'k', 'u', 'w'};
    otherwise
        error('Unsupported Reconstruction Type');
end


%% Generate Over-Sized Paramters
[over_width, over_height] = size(imrotate(zeros(pattern_width, ...
    pattern_height), 45));


%% Pattern Generators
switch pattern
    case 'Perfect Bar'
        img = perfect_bar_pattern_generator_v3(over_width, ...
            over_height, pixels_wide, n_rec, save_path);
    case 'Imperfect Bar'
        img = imperfect_bar_pattern_generator_v3(over_width, ...
            over_height, pixels_wide, n_rec);
    case 'Imperfect Sine Wave'
        img = imperfect_sinewave_pattern_generator_v3(over_width, ...
            over_height, pixels_wide, n_rec);
    otherwise
        error('Unsupported Pattern');
end


%% Rotate Pattern
for i = 1:n_rec
    img{i} = imrotate(img{i}, rotation, 'Nearest', 'Crop');
end


%% Cut Images to Central Region
for i = 1:n_rec
    img{i} = img{i}( floor(1+((over_width-pattern_width)/2)) : ...
        floor(over_width-((over_width-pattern_width)/2)) , ...
        floor(1+((over_height-pattern_height)/2)) : ...
        floor(over_height-((over_height-pattern_height)/2)));
end


%% Generate Aperture Overlay
if pattern_width > pattern_height
    long_axis = pattern_width/2;
    short_axis = pattern_height/2;
else
    long_axis = pattern_height/2;
    short_axis = pattern_width/2;
end

overlay_radius = ceil(short_axis/sin(atan(short_axis/long_axis)));
overlay = zeros((2*overlay_radius), (2*overlay_radius));

aperture_radius = overlay_radius * (1 - (aperture_percent/100));

for i = 1:(2*overlay_radius)
    for j = 1:(2*overlay_radius)
        if sqrt(((overlay_radius-i)^2)+((overlay_radius-j)^2)) ...
                < aperture_radius 
            overlay(i,j) = 1;
        end
    end
end


%% Combine Patterns with Aperture
img_overlay = overlay( ...
    floor(overlay_radius+1-(pattern_width/2)): ...
    floor(overlay_radius+(pattern_width/2)), ...
    floor(overlay_radius+1-(pattern_height/2)): ...
    floor(overlay_radius+(pattern_height/2)));
for i = 1:n_rec
    img{i} = img{i} .* img_overlay;
end


%% Save Patterns
hpath = pwd;
cd(save_path);
for i = 1:n_rec
    imwrite(img{i}, [naming_convention{i} num2str(pixels_wide) ...
        file_type], file_type(2:end));
end
cd(hpath);

end