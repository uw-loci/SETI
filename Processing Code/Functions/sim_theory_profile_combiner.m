function [ ] = sim_theory_profile_combiner(img_sets, rejection_theory, ...
    meas_scale, file_path, run_name)
%% Axial Image Set Sorter 
%   By: Niklas Gahm
%   2018/08/08
%
%   This code combines all the generated rejection profiles and the
%   rejection theory profiles 
% 
%   2018/08/08 - Started
%   2018/08/08 - Finished 



%% Generate Save Path
spath = [file_path '\Rejection Profiles and Theory Combined'];
mkdir(spath);


%% Absolute Intensity Plot 
% Get maximum absolute intensity from data 
max_int = 0;
for i = 1:numel(img_sets)
    if max_int < max(img_sets(i).rejection_profile.int_abs)
        max_int = max(img_sets(i).rejection_profile.int_abs);
    end
end

% Generate Legend Names
temp_img = struct2cell(img_sets);
temp_theory = struct2cell(rejection_theory);
legend_names = [squeeze(temp_img(1,:,:)); squeeze(temp_theory(3,:,:))];

% Absolute Intensity Plot
temp = figure; clf;
hold on;
for i = 1:numel(img_sets)
    plot(img_sets(i).rejection_profile.steps, ...
        img_sets(i).rejection_profile.int_abs, '-o')
end
for i = 1:numel(rejection_theory)
    plot(rejection_theory(i).steps, ...
        (max_int * rejection_theory(i).int_theory_abs), '--');
end
hold off;
title({'Absolute Intensity Rejection Profile of', ...
    strrep(run_name, '_', ' '), ''})
xlabel(['Position from Focus [' meas_scale ']']);
ylabel('Absolute Pixel Intensity [Counts]');
legend(legend_names);
print(temp, [spath '\' run_name ...
    '_Absolute_Intensity_Rejection_Profile'], '-djpeg');


%% Normalized Intensity Plot
temp = figure(); clf;
hold on;
for i = 1:numel(img_sets)
    plot(img_sets(i).rejection_profile.steps, ...
        (img_sets(i).rejection_profile.int_abs / max_int), '-o');
end
for i = 1:numel(rejection_theory)
    plot(rejection_theory(i).steps, ...
        rejection_theory(i).int_theory_abs, '--');
end
hold off;
title({'Normalized Intensity Rejection Profile of', ...
    strrep(run_name, '_', ' '), ''})
xlabel(['Position from Focus [' meas_scale ']']);
ylabel('Normalized Pixel Intensity');
legend(legend_names);
print(temp, [spath '\' run_name ...
    '_Normalized_Intensity_Rejection_Profile'], '-djpeg');

end
