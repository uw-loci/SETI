function [ img_sets ] = axial_framework_pre_processing_v2( img_sets, ...
    max_int, bit_depth, rec_mode, fpath, img_save_type, ...
    save_intermediaries_flag, flat_field_flag, flat_field_path)
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
%   2018/11/05 - Updated to include stable flat field correction



%% Setup Navigation
hpath = pwd;


%% Flat Field Correcction
if flat_field_flag == 1
    % Use Bioformats to Load in Image
    temp = bfopen(flat_field_path);
    flat_field_reference = double(temp{1,1}{1,1});
else
    flat_field_reference = 1;
end
for i = 1:numel(img_sets)
    for j = 1:numel(img_sets(i).images)
        img_sets(i).images(j).flat = img_sets(i).images(j).image ./ ...
            flat_field_reference;
    end
end


%% Determine Normalization Method and Navigate to Images
switch rec_mode
    case 'Rejection Profile'
        % Special Handling is Needed to Handle the Local Normalization and
        % the Global Normalization
        [ img_sets ] = img_normalizer_2D_rej_profile_v2(img_sets, max_int);
        
    otherwise
        % Normalize Images Individually
        for i = 1:numel(img_sets)
            for j = 1:numel(img_sets(i).images)
                img_sets(i).images(j).image_processed = ...
                    img_normalizer_2D( ...
                    img_sets(i).images(j).flat, max_int );
            end
        end
end


%% Save Pre-Processed Images
if save_intermediaries_flag == 1
    fprintf('\nSaving Pre-Processed Images\n');
    for i = 1:numel(img_sets)
        spath = [fpath '\' img_sets(i).name '\Pre-processed Images'];
        mkdir(spath);
        wait_element = waitbar((1/numel(img_sets(i).images)), ...
            sprintf('Saving Pre-Processed Sub-Images From %s', ...
            img_sets(i).name));
        for j = 1:numel(img_sets(i).images)
            waitbar((j/numel(img_sets(i).images)), wait_element);
            bfsave( img_bit_depth_converter( ...
                img_sets(i).images(j).image_processed, bit_depth ), ...
                [spath '\' img_sets(i).images(j).name '_pre-processed' ...
                img_save_type]);
        end
        close(wait_element);
    end
end


%% Clean Memory Usage
for i = 1:numel(img_sets)
    fields = {'image','flat'};
    img_sets(i).images = rmfield(img_sets(i).images, fields);
end


%% Clean Navigation
cd(hpath);
end

