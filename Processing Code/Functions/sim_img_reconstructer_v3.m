function [ img_sets ] = sim_img_reconstructer_v3( img_sets, file_path, ...
    img_save_type )
% SIM Image Reconstruction
%   By: Niklas Gahm
%   2017/06/29
%
%   This is a chunk of code to take a stack of SIM sub-images in and use
%   them to reconstruct a SIM Image.
% 
%   Reconstructions Supported:
%       3_Sub_Image
%       4_Sub_Image
%       5_Sub_Image
%
%   2017/06/29 - Started 
%   2017/06/29 - Finished 3 Sub-Image Reconstruction
%   2017/07/05 - Finished Adding 4 and 5 Sub-Image Reconstruction
%   2018/07/26 - Updated to work with the Axial Sectioning Framework GUI




%% Reconstruct Images
for i = 1:numel(img_sets)
    if ~strcmp(img_sets(i).name, 'Bright Field')
        j = 1;
        num_si = img_sets(i).num_sub_img;
        recon_counter = 1;
        while j <= numel(img_sets(i).images)
            switch num_si
                
                case 3
                    % Normal SIM reconstruction from 3 Sub-Images
                    img_sets(i).images_reconstructed(recon_counter)...
                        .image = sqrt(((...
                        img_sets(i).images(j).image_processed - ...
                        img_sets(i).images(j+1).image_processed).^2) + ...
                        ((img_sets(i).images(j+1).image_processed - ...
                        img_sets(i).images(j+2).image_processed).^2) + ...
                        ((img_sets(i).images(j).image_processed - ...
                        img_sets(i).images(j+2).image_processed).^2));
                    
                    % Transfer appropriate values
                    img_sets(i).images_reconstructed(recon_counter)...
                        .x_pos = img_sets(i).images(j).x_pos;
                    img_sets(i).images_reconstructed(recon_counter)...
                        .y_pos = img_sets(i).images(j).y_pos;
                    img_sets(i).images_reconstructed(recon_counter)...
                        .z_pos = img_sets(i).images(j).z_pos;
                    img_sets(i).images_reconstructed(recon_counter)...
                        .ftype = img_sets(i).images(j).ftype;
                    
                    % Get new reconstructed name
                    temp_name = img_sets(i).images(j).name;
                    start_point = 0;
                    for k = 0:(numel(temp_name)-1)
                        if strcmp(temp_name(end-k), '_')
                            start_point = k;
                            break;
                        end
                    end
                    img_sets(i).images_reconstructed(recon_counter)...
                        .name = temp_name(1:(end-(start_point+2)));
                    
                    
                case 4
                    % Normal SIM reconstruction from 4 Sub-Images
                    img_sets(i).images_reconstructed(recon_counter)...
                        .image = sqrt(((...
                        img_sets(i).images(j).image_processed - ...
                        img_sets(i).images(j+1).image_processed).^2) + ...
                        ((img_sets(i).images(j+1).image_processed - ...
                        img_sets(i).images(j+2).image_processed).^2) + ...
                        ((img_sets(i).images(j).image_processed - ...
                        img_sets(i).images(j+2).image_processed).^2) + ...
                        ((img_sets(i).images(j).image_processed - ...
                        img_sets(i).images(j+3).image_processed).^2) + ...
                        ((img_sets(i).images(j+1).image_processed - ...
                        img_sets(i).images(j+3).image_processed).^2) + ...
                        ((img_sets(i).images(j+2).image_processed - ...
                        img_sets(i).images(j+3).image_processed).^2));
                    
                    % Transfer appropriate values
                    img_sets(i).images_reconstructed(recon_counter)...
                        .x_pos = img_sets(i).images(j).x_pos;
                    img_sets(i).images_reconstructed(recon_counter)...
                        .y_pos = img_sets(i).images(j).y_pos;
                    img_sets(i).images_reconstructed(recon_counter)...
                        .z_pos = img_sets(i).images(j).z_pos;
                    img_sets(i).images_reconstructed(recon_counter)...
                        .ftype = img_sets(i).images(j).ftype;
                    
                    % Get new reconstructed name
                    temp_name = img_sets(i).images(j).name;
                    start_point = 0;
                    for k = 0:(numel(temp_name)-1)
                        if strcmp(temp_name(end-k), '_')
                            start_point = k;
                            break;
                        end
                    end
                    img_sets(i).images_reconstructed(recon_counter)...
                        .name = temp_name(1:(end-(start_point+2)));
                    
                    
                case 5
                    % Normal SIM reconstruction from 5 Sub-Images
                    img_sets(i).images_reconstructed(recon_counter)...
                        .image = sqrt(((...
                        img_sets(i).images(j).image_processed - ...
                        img_sets(i).images(j+1).image_processed).^2) + ...
                        ((img_sets(i).images(j+1).image_processed - ...
                        img_sets(i).images(j+2).image_processed).^2) + ...
                        ((img_sets(i).images(j).image_processed - ...
                        img_sets(i).images(j+2).image_processed).^2) + ...
                        ((img_sets(i).images(j).image_processed - ...
                        img_sets(i).images(j+3).image_processed).^2) + ...
                        ((img_sets(i).images(j+1).image_processed - ...
                        img_sets(i).images(j+3).image_processed).^2) + ...
                        ((img_sets(i).images(j+2).image_processed - ...
                        img_sets(i).images(j+3).image_processed).^2) + ...
                        ((img_sets(i).images(j).image_processed - ...
                        img_sets(i).images(j+4).image_processed).^2) + ...
                        ((img_sets(i).images(j+1).image_processed - ...
                        img_sets(i).images(j+4).image_processed).^2) + ...
                        ((img_sets(i).images(j+2).image_processed - ...
                        img_sets(i).images(j+4).image_processed).^2) + ...
                        ((img_sets(i).images(j+3).image_processed - ...
                        img_sets(i).images(j+4).image_processed).^2));
                    
                    % Transfer appropriate values
                    img_sets(i).images_reconstructed(recon_counter)...
                        .x_pos = img_sets(i).images(j).x_pos;
                    img_sets(i).images_reconstructed(recon_counter)...
                        .y_pos = img_sets(i).images(j).y_pos;
                    img_sets(i).images_reconstructed(recon_counter)...
                        .z_pos = img_sets(i).images(j).z_pos;
                    img_sets(i).images_reconstructed(recon_counter)...
                        .ftype = img_sets(i).images(j).ftype;
                    
                    % Get new reconstructed name
                    temp_name = img_sets(i).images(j).name;
                    start_point = 0;
                    for k = 0:(numel(temp_name)-1)
                        if strcmp(temp_name(end-k), '_')
                            start_point = k;
                            break;
                        end
                    end
                    img_sets(i).images_reconstructed(recon_counter)...
                        .name = temp_name(1:(end-(start_point+2)));
                    
                    
                otherwise
                    error('Unsupported Reconstruction Type');
            end
            
            % Increment Counters
            recon_counter = recon_counter + 1;
            j = j + num_si;
        end
    else
        % Handles the bright field image set
        for j = 1:numel(img_sets(i).images)
            img_sets(i).images_reconstructed(j).image = ...
                img_sets(i).images(j).image_processed;
            
            % Transfer appropriate values
            img_sets(i).images_reconstructed(j)...
                .x_pos = img_sets(i).images(j).x_pos;
            img_sets(i).images_reconstructed(j)...
                .y_pos = img_sets(i).images(j).y_pos;
            img_sets(i).images_reconstructed(j)...
                .z_pos = img_sets(i).images(j).z_pos;
            img_sets(i).images_reconstructed(j)...
                .ftype = img_sets(i).images(j).ftype;
            img_sets(i).images_reconstructed(j).name = ...
                img_sets(i).images(j).name;
        end
    end
end


%% Save Reconstructed Images
for i = 1:numel(img_sets)
    spath = [file_path '\' img_sets(i).name '\Reconstructed Images'];
    mkdir(spath);
    for j = 1:numel(img_sets(i).images_reconstructed)
        bfsave(uint8(img_sets(i).images_reconstructed(j).image), ...
            [spath '\' img_sets(i).images_reconstructed(j).name ...
            img_save_type]);
    end
end

end