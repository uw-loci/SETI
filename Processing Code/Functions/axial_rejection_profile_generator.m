function [ img_sets ] = axial_rejection_profile_generator( img_sets, ...
    fpath, rejection_step_size, rejection_step_size_units, ...
    save_intermediaries_flag )
%% Axial Rejection Profile Generator
%   By: Niklas Gahm
%   2018/08/03
%
%   This script calculates the rejection profiles of the image sets. 
%
%
%   2018/08/03 - Started
%   2018/08/03 - Finished



%% Setup Navigation
hpath = pwd;


%% Generate the Absolute and Normalized Intensities
for i = 1:numel(img_sets)
    % Generate Step Array
    img_sets(i).rejection_profile.steps = rejection_step_size * ...
        [0:1:(size(img_sets(i).images_tiled.original, 3)-1)];
    
    % Get the Absolute and Normalized Intensities
    img_sets(i).rejection_profile.int_abs = ...
        zeros(1,size(img_sets(i).images_tiled.original, 3));
    for j = 1:size(img_sets(i).images_tiled.original, 3)
        img_sets(i).rejection_profile.int_abs(j) = ...
            sum(sum(img_sets(i).images_tiled.original(:,:,j)));
    end
    img_sets(i).rejection_profile.int_norm = ...
        img_sets(i).rejection_profile.int_abs ./ ...
        max(img_sets(i).rejection_profile.int_abs);
end


%% Display and Save Individual Rejection Profiles
if save_intermediaries_flag == 1
    for i = 1:numel(img_sets)
        spath = [fpath '\' img_sets(i).name '\Rejection Profile'];
        mkdir(spath);
        
        % Absolute Intensity Plot
        temp = figure; clf;
        plot(img_sets(i).rejection_profile.steps, ...
            img_sets(i).rejection_profile.int_abs, '-ok');
        title({'Absolute Intensity Rejection Profile of', ...
            img_sets(i).name, ''});
        xlabel(['Position from Focus [' rejection_step_size_units ']']);
        ylabel('Absolute Pixel Intensity [Counts]');
        print(temp, [spath '\' img_sets(i).name ...
            '_Absolute_Intensity_Rejection_Profile'], '-djpeg');
        
        % Normalized Intensity Plot
        temp2 = figure; clf;
        plot(img_sets(i).rejection_profile.steps, ...
            img_sets(i).rejection_profile.int_norm, '-ok');
        title({'Normalized Intensity Rejection Profile of', ...
            img_sets(i).name, ''});
        xlabel(['Position from Focus [' rejection_step_size_units ']']);
        ylabel('Normalized Pixel Intensity');
        print(temp2, [spath '\' img_sets(i).name ...
            '_Normalized_Intensity_Rejection_Profile'], '-djpeg');
    end
end


%% Clean Navigation
cd(hpath);

end
