function [ img_sets ] = axial_framework_pre_processing( img_sets, ...
    max_int, rec_mode, fpath, img_save_type, save_intermediaries_flag)
%% Axial Framework Pre-Processing 
%   By: Niklas Gahm
%   2018/07/23
%
%   This script performs image pre-processing. This is primarily an
%   interface and can be expanded with more pre-processing techniques in
%   future releases.
% 
%   Pre-Processing Performed:
%       - Image Normalization 
%
%   2018/07/23 - Started
%   2018/07/23 - Finished



%% Setup Navigation
hpath = pwd;


%% Determine Normalization Method and Navigate to Images
switch rec_mode
    case 'Rejection Profile'
        % Special Handling is Needed to Handle the Local Normalization and
        % the Global Normalization
        [ img_sets ] = img_normalizer_2D_rej_profile( img_sets, max_int );
        
    otherwise
        % Normalize Images Individually
        for i = 1:numel(img_sets)
            for j = 1:numel(img_sets(i).images)
                img_sets(i).images(j).image_processed = ...
                    img_normalizer_2D( ...
                    img_sets(i).images(j).image, max_int );
            end
        end
end


%% Save Pre-Processed Images
if save_intermediaries_flag == 1
    fprintf('\nSaving Pre-Processed Images\n');
    for i = 1:numel(img_sets)
        spath = [fpath '\' img_sets(i).name '\Pre-processed Images'];
        mkdir(spath);
        for j = 1:numel(img_sets(i).images)
            bfsave(uint8(img_sets(i).images(j).image_processed), ...
                [spath '\' img_sets(i).images(j).name '_pre-processed' ...
                img_save_type]);
        end
    end
end


%% Clean Navigation
cd(hpath);
end

