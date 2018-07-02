function [] = SIM_Pattern_Generator_v3_func( save_path, pixels_wide, ...
    pattern_width, pattern_height, reconstruction_type, pattern, file_type)
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


%% Generators
switch pattern
    case 'Perfect Bar'
        perfect_bar_pattern_generator_v2(pattern_width, pattern_height, ...
            pixels_wide, n_rec, naming_convention, file_type, save_path);
    case 'Imperfect Bar'
        imperfect_bar_pattern_generator_v2(pattern_width, ...
            pattern_height, pixels_wide, n_rec, naming_convention, ...
            file_type, save_path);
    case 'Imperfect Sine Wave'
        imperfect_sinewave_pattern_generator_v2(pattern_width, ...
            pattern_height, pixels_wide, n_rec, naming_convention, ...
            file_type, save_path);
    otherwise
        error('Unsupported Pattern');
end


end