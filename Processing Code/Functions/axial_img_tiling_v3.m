function [ img_sets ] = axial_img_tiling_v3( img_sets, num_x, num_y, ...
    num_z, overlap_percent, threshold_percent)
%% Axial Sectioning Image Tiler
%   By: Niklas Gahm
%   2018/07/27
%
%   This script performs tiling and 3D stacking using methods from:
%   https://www.mathworks.com/help/images/ref/imregconfig.html
%   https://www.mathworks.com/help/images/ref/imregtform.html
%   https://www.mathworks.com/help/images/ref/imwarp.html
% 
% 
%   2018/07/27 - Started
%   2018/07/27 - Placeholder Finished
%   2018/08/03 - Updated to Handle a Pure Z-Stack Case
%   2018/11/28 - Finished



% Initialize Optimizer
[optimizer, metric] = imregconfig('monomodal');
optimizer.MaximumIterations = 600;


%% X Tiling
for i = 1:numel(img_sets)
    n_rows = numel(img_sets(i).images_reconstructed) / num_x;
    img_sets(i).images_tiled.x_combined = cell(1,n_rows);
    
    for j = 1:n_rows
        % Initialize the X-row being built
        start_img = 1 + (num_x * (j-1));
        mosaic = img_sets(i).images_reconstructed(start_img).image;
        
        % Calculate mosaic bound range
        mosaic_bound_range = round(size(mosaic, 2) * overlap_percent);
        
        for k = 1:(num_x-1)
            % Tile to be added
            growth_tile = ...
                img_sets(i).images_reconstructed(start_img + k).image;
            
            % Mosaic search bounds
            bounds_mosaic = [ (size(mosaic, 2) - mosaic_bound_range), ...
                size(mosaic, 2)];
            
            % Tile to be added search bounds
            bounds_growth_tile = [1, round(size(growth_tile, 2)/2)];
            
            % Generated reduced temp images for cross-correlation
            mosaic_reduced = mosaic( :, bounds_mosaic(1):bounds_mosaic(2));
            mosaic_reduced = mosaic_reduced - mean(mean(mosaic_reduced));
            tile_reduced = growth_tile(:, ...
                bounds_growth_tile(1):bounds_growth_tile(2));
            tile_reduced = tile_reduced - mean(mean(tile_reduced));
            
            % Threshold reduced images
            mosaic_mask = imbinarize(mosaic_reduced, ...
                (max(max(mosaic_reduced)) * (1 - threshold_percent)));
            tile_mask = imbinarize(tile_reduced, ...
                (max(max(tile_reduced)) * (1 - threshold_percent)));
            
            mosaic_reduced = mosaic_mask .* mosaic_reduced; 
            mosaic_reduced = mosaic_reduced - mean(mean(mosaic_reduced));
            tile_reduced = tile_mask .* tile_reduced;
            tile_reduced = tile_reduced - mean(mean(tile_reduced));
            
            % Register Reduced and Masked Images 
            tform = imregtform(tile_reduced, mosaic_reduced, ...
                'translation', optimizer, metric);
            
            % Update transform with the bounds
            tform.T(3,1) = tform.T(3,1) + bounds_mosaic(1);
            
            % Initialize Identity Transform
            itform = projective2d(eye(3));
            
            % Generate new Mosaic Reference Object
            y_shift = tform.T(3,2);
            x_shift = tform.T(3,1);
            
            mosaic_ref_size = size(mosaic);
            if y_shift < 0
                mosaic_ref_size(1) = mosaic_ref_size(1) + ...
                    round(abs(y_shift));
                itform.T(3,2) = abs(tform.T(3,2));
                tform.T(3,2) = 0;
            elseif (round(y_shift) + size(growth_tile,1)) > size(mosaic, 1) 
                mosaic_ref_size(1) = floor(y_shift) + size(growth_tile,1); 
            end
            mosaic_ref_size(2) = size(growth_tile, 2) + round(x_shift);
            
            ref_obj_mosaic = imref2d(mosaic_ref_size);
            
            % Generate Transformed Tile
            tile_tform = imwarp(growth_tile, tform, 'OutputView', ...
                ref_obj_mosaic);
            
            % Fill a new mosaic of correct dimensions
            mosaic_itform = imwarp(mosaic, itform, 'OutputView', ...
                ref_obj_mosaic);
            
            % Feather overlaping reagions
            feather_region = [(round(x_shift)+1), size(mosaic, 2)];
            feather_gradient = repmat(linspace(0, 1, ...
                (1 + feather_region(2) - feather_region(1))), ...
                mosaic_ref_size(1), 1);
            
            tile_tform(:, feather_region(1):feather_region(2)) = ...
                tile_tform(:, feather_region(1):feather_region(2)) .* ...
                feather_gradient;
            mosaic_itform(:, feather_region(1):feather_region(2)) = ...
                mosaic_itform(:, feather_region(1):feather_region(2)) ...
                .* (1 - feather_gradient);
            
            % Generate updated mosaic
            mosaic = tile_tform + mosaic_itform;
        end
        
        % Save Completed X-Row
        img_sets(i).images_tiled.x_combined{j} = mosaic;
    end
end


%% Y Tiling
for i = 1:numel(img_sets)
    n_col = numel(img_sets(i).images_tiled.x_combined) / num_y;
    img_sets(i).images_tiled.xy_combined = cell(1,n_col);
    
    for j = 1:n_col
        % Initialize the Y-column being built
        start_img = 1 + (num_y * (j-1));
        mosaic = img_sets(i).images_tiled.x_combined{start_img};
        
        % Calculate mosaic bound range
        mosaic_bound_range = round(size(mosaic, 1) * overlap_percent);
        
        for k = 1:(num_y-1)
            % Tile to be added
            growth_tile = ...
                img_sets(i).images_tiled.x_combined{start_img + k};
            
            % Mosaic search bounds
            bounds_mosaic = [ (size(mosaic, 1) - mosaic_bound_range), ...
                size(mosaic, 1)];
            
            % Tile to be added search bounds
            bounds_growth_tile = [1, round(size(growth_tile, 1)/2)];
            
            % Generated reduced temp images for cross-correlation
            mosaic_reduced = mosaic( bounds_mosaic(1):bounds_mosaic(2), :);
            mosaic_reduced = mosaic_reduced - mean(mean(mosaic_reduced));
            tile_reduced = growth_tile(...
                bounds_growth_tile(1):bounds_growth_tile(2), :);
            tile_reduced = tile_reduced - mean(mean(tile_reduced));
            
            % Threshold reduced images
            mosaic_mask = imbinarize(mosaic_reduced, ...
                (max(max(mosaic_reduced)) * (1 - threshold_percent)));
            tile_mask = imbinarize(tile_reduced, ...
                (max(max(tile_reduced)) * (1 - threshold_percent)));
            
            mosaic_reduced = mosaic_mask .* mosaic_reduced; 
            mosaic_reduced = mosaic_reduced - mean(mean(mosaic_reduced));
            tile_reduced = tile_mask .* tile_reduced;
            tile_reduced = tile_reduced - mean(mean(tile_reduced));
            
            % Register Reduced and Masked Images 
            tform = imregtform(tile_reduced, mosaic_reduced, ...
                'translation', optimizer, metric);
            
            % Update transform with the bounds
            tform.T(3,2) = tform.T(3,2) + bounds_mosaic(1);
            
            % Initialize Identity Transform
            itform = projective2d(eye(3));
            
            % Generate new Mosaic Reference Object
            y_shift = tform.T(3,2);
            x_shift = tform.T(3,1);
            
            mosaic_ref_size = size(mosaic);
            if x_shift < 0
                 mosaic_ref_size(2) = mosaic_ref_size(2) + ...
                    round(abs(x_shift));
                itform.T(3,1) = abs(tform.T(3,1));
                tform.T(3,1) = 0;
            elseif (round(x_shift) + size(growth_tile,2)) > size(mosaic, 2) 
                mosaic_ref_size(2) = floor(x_shift) + size(growth_tile,2); 
            end
            mosaic_ref_size(1) = size(growth_tile, 1) + round(y_shift);
            
            ref_obj_mosaic = imref2d(mosaic_ref_size);
            
            % Generate Transformed Tile
            tile_tform = imwarp(growth_tile, tform, 'OutputView', ...
                ref_obj_mosaic);
            
            % Fill a new mosaic of correct dimensions
            mosaic_itform = imwarp(mosaic, itform, 'OutputView', ...
                ref_obj_mosaic);
            
            % Feather overlaping reagions
            feather_region = [(round(y_shift)+1), size(mosaic, 1)];
            feather_gradient = repmat(linspace(0, 1, ...
                (1 + feather_region(2) - feather_region(1)))', 1, ...
                mosaic_ref_size(2));
            
            tile_tform(feather_region(1):feather_region(2), :) = ...
                tile_tform(feather_region(1):feather_region(2), :) .* ...
                feather_gradient;
            mosaic_itform(feather_region(1):feather_region(2), :) = ...
                mosaic_itform(feather_region(1):feather_region(2), :) ...
                .* (1 - feather_gradient);
            
            % Generate updated mosaic
            mosaic = tile_tform + mosaic_itform;
        end
        
        % Save Completed XY-Grid
        img_sets(i).images_tiled.xy_combined{j} = mosaic;
    end
end


%% Z Tiling
for i = 1:numel(img_sets)
    % Initialize the Z-stack being built
    mosaic = img_sets(i).images_tiled.xy_combined{1};
    
    for j = 1:(num_z-1)
        % Tile to be added
        growth_tile = img_sets(i).images_tiled.xy_combined{1 + j};
        
        % Generated reduced temp images for cross-correlation
        mosaic_reduced = mosaic(:,:,end) - mean(mean(mosaic(:,:,end)));
        tile_reduced = growth_tile - mean(mean(growth_tile));
        
        % Threshold reduced images
        mosaic_mask = imbinarize(mosaic_reduced, ...
            (max(max(mosaic_reduced)) * (1 - threshold_percent)));
        tile_mask = imbinarize(tile_reduced, (max(max(tile_reduced)) * ...
            (1 - threshold_percent)));
        
        mosaic_reduced = mosaic_mask .* mosaic_reduced;
        mosaic_reduced = mosaic_reduced - mean(mean(mosaic_reduced));
        tile_reduced = tile_mask .* tile_reduced;
        tile_reduced = tile_reduced - mean(mean(tile_reduced));
        
        % Register Reduced and Masked Images
        tform = imregtform(tile_reduced, mosaic_reduced, 'translation', ...
            optimizer, metric);
        
        % Initialize Identity Transform
        itform = projective2d(eye(3));
        
        % Generate new Mosaic Reference Object
        y_shift = tform.T(3,2);
        x_shift = tform.T(3,1);
        
        mosaic_ref_size = size(mosaic);
        if j == 1
            mosaic_ref_size(3) = size(mosaic,3);
        end
        
        if x_shift < 0
            mosaic_ref_size(2) = mosaic_ref_size(2) + round(abs(x_shift));
            itform.T(3,1) = abs(tform.T(3,1));
            tform.T(3,1) = 0;
        elseif (round(x_shift) + size(growth_tile,2)) > size(mosaic, 2)
            mosaic_ref_size(2) = floor(x_shift) + size(growth_tile,2);
        end
        
        if y_shift < 0
            mosaic_ref_size(1) = mosaic_ref_size(1) + round(abs(y_shift));
            itform.T(3,2) = abs(tform.T(3,2));
            tform.T(3,2) = 0;
        elseif (round(y_shift) + size(growth_tile,1)) > size(mosaic, 1)
            mosaic_ref_size(1) = floor(y_shift) + size(growth_tile,1);
        end
        
        mosaic_ref_size(3) = mosaic_ref_size(3) + 1;
        
        ref_obj_mosaic = imref2d(mosaic_ref_size(1:2));
        
        % Fill temp mosaic with transformed images
        temp_mosaic = zeros(mosaic_ref_size);
        
        for k = 1:(mosaic_ref_size(3)-1)
            temp_mosaic(:,:,k) = imwarp(mosaic(:,:,k), itform, ...
                'OutputView', ref_obj_mosaic);
        end
        
        temp_mosaic(:,:,end) = imwarp(growth_tile, tform, 'OutputView', ...
            ref_obj_mosaic);
        
        % Replace old mosaic
        mosaic = temp_mosaic;
    end
    
    % Save Completed XYZ-Cube
    img_sets(i).images_tiled.original = mosaic;
end

end