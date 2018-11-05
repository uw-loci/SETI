function [ img_sets ] = img_normalizer_2D_rej_profile_v2( img_sets, ...
    new_intensity_max )
%% Grayscale Image Normalizer for Images in Rejection Profile Mode
%   By: Niklas Gahm
%   2017/07/24
%
%   This is a chunk of code to take a stack of images in and scale them to 
%   intensity values of 0 to new_intensity_max on both a local and global
%   scale. This corrects the occasional dark image caused by DLP flashing
%   problems whilst preserving the relative image intensity across sets. 
%
%   2017/07/24 - Started 
%   2017/07/26 - Finished
%   2018/11/05 - Updated for Framework v11



%% Perform Local Normalization and Get Global Norms
pix_max = 0;
pix_min = 0;
for i = 1:numel(img_sets)
    % Local Normalization on non-brright field images
    if ~strcmp(img_sets(i).name(1:12), 'Bright Field')
        j = 1;
        num_si = img_sets(i).num_sub_img;
        while j <= numel(img_sets(i).images)
            % Get local max values
            local_max = 0;
            for k = 0:(num_si-1)
                if local_max < max(max(img_sets(i).images(j+k).flat))
                    local_max = max(max(img_sets(i).images(j+k).flat));
                end
            end
            
            % Local Normalization
            for k = 0:(num_si-1)
                img_sets(i).images(j+k).image_processed = ...
                ((img_sets(i).images(j+k).flat - ...
                min(min(img_sets(i).images(j+k).flat))) / ...
                (max(max(img_sets(i).images(j+k).flat)) - ...
                min(min(img_sets(i).images(j+k).flat)))) * local_max;
            end
            
            % Increment Counter
            j = j + num_si;
        end
    else
        % Handles the bright field image set
        for j = 1:numel(img_sets(i).images)
            img_sets(i).images(j).image_processed = ...
                img_sets(i).images(j).flat;
        end
    end
    
    % Find the Global Data Set Max and Min
    for j = 1:numel(img_sets(i).images)
        if pix_max < max(max(img_sets(i).images(j).image_processed))
            pix_max = max(max(img_sets(i).images(j).image_processed));
        end
        if pix_min > min(min(img_sets(i).images(j).image_processed))
            pix_min = min(min(img_sets(i).images(j).image_processed));
        elseif (i == 1) && (j ==1)
            % Handles the value initialization
            pix_min = min(min(img_sets(i).images(j).image_processed));
        end
    end
end


%% Perform Global Normalization
for i = 1:numel(img_sets)
    for j = 1:numel(img_sets(i).images)
        img_sets(i).images(j).image_processed = ...
            ((img_sets(i).images(j).image_processed - pix_min) / ...
            (pix_max - pix_min)) * new_intensity_max;
    end
end

end