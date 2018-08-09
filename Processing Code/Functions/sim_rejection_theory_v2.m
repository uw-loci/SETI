function [ rejection_theory ] = sim_rejection_theory_v2( img_sets, ...
    rejection_step_size_units, cut_depth, sim_points, ...
    refractive_index_medium, obj_na, wavelength, fpath, ...
    save_intermediaries_flag)
%% SIM Rejection Theory 
%   By: Niklas Gahm
%   2017/07/18
%
%   This code generates theoretical rejection profile curves based on the
%   input and the theory presented in:
%       Neil, Mark AA, Rimas Juškaitis, and Tony Wilson. 
%           "Method of obtaining optical sectioning by using structured 
%           light in a conventional microscope." Optics letters 22.24 
%           (1997): 1905-1907.
%   and
%       Wilson, T. "Optical sectioning in fluorescence microscopy." 
%           Journal of microscopy 242.2 (2011): 111-116.
% 
%   Supported Units:
%       mm
%       \mum
%       nm
% 
%   2017/07/18 - Started 
%   2017/11/30 - Finished
%   2018/08/03 - Updated to work with GUI Axial Framework



%% Generate Useful Internal Vectors 
% All units used internally are matched to nm, graphs are in \mum
switch rejection_step_size_units
    case 'mm'
        convert = 1000000;
    case 'um'
        convert = 1000;
    case 'nm'
        convert = 1;
    otherwise
        error('Unsupported Units');
end

% Builds the Defocus Span 
steps = linspace(0, (cut_depth * ...
    numel(img_sets(1).images_reconstructed)), sim_points);

% Generate the Defocus Vector
half_angle = asin(obj_na / refractive_index_medium);
u = 8 * pi * (steps .* convert) * refractive_index_medium * ...
    ((sin(half_angle/2))^2) / wavelength;

% Generate the Spatial Frequency Vector
res = 0.61 * wavelength / obj_na;   % Passable resolution
lpmm_max_pass = res/2;  % Max lp/mm the system can pass/resolve 


%% Determine All Unique Line Pairs/mm
rejection_theory = struct;
lpmm_starter_flag = 0;
for i = 1:numel(img_sets)
    if ~strcmp(img_sets(i).name, 'Bright Field')
        if lpmm_starter_flag ~= 0
            unique_flag = 1;
            for j = 1:numel(rejection_theory)
                if rejection_theory(j).lpmm == img_sets(i).lpmm
                    unique_flag = 0;
                    break;
                end
            end
            if unique_flag == 1
                ind = numel(rejection_theory) + 1;
                rejection_theory(ind).lpmm = img_sets(i).lpmm;
                rejection_theory(ind).steps = steps;
                rejection_theory(ind).name = ...
                    [num2str(rejection_theory(ind).lpmm) ' lp/mm Theory'];
                rejection_theory(ind).rejection_step_size_units = ...
                    rejection_step_size_units;
                rejection_theory(ind).rejection_step_size = ...
                    cut_depth;
            end
        else
            lpmm_starter_flag = 1;
            rejection_theory.steps = steps;
            rejection_theory.lpmm = img_sets(i).lpmm;
            rejection_theory.name = [num2str(rejection_theory.lpmm) ...
                ' lp/mm Theory'];
            rejection_theory.rejection_step_size_units = ...
                rejection_step_size_units;
            rejection_theory.rejection_step_size = cut_depth;
        end
    end
end


%% Generate v Vector
temp = struct2cell(rejection_theory);
v = cell2mat(squeeze(temp(2,:,:))) / lpmm_max_pass;


%% Generate Intensities
Tau = @(d) 1 - (0.69.*d) + (0.0076 .* (d.^2)) + (0.043 .* (d .^ 3));
for i = 1:numel(rejection_theory)
    if v(i) ~=0
    rejection_theory(i).int_theory_abs = (Tau(v(i)) .* (2 .* ...
        (besselj(1, ((u .* v(i) .* ...
        (1 - (v(i) ./ 2))))) ./ (u .* v(i) .* (1 - (v(i) ./ 2)))))).^2; 
    else
        rejection_theory(i).int_theory_abs = ones(1, sim_points);
    end
    rejection_theory(i).int_theory_norm = ...
        rejection_theory(i).int_theory_abs ./ ...
        max(rejection_theory(i).int_theory_abs);
    rejection_theory(i).half_width_defocus = ...
        max(u(rejection_theory(i).int_theory_norm > 0.5));
    rejection_theory(i).full_width_half_max_steps = (2 * ...
        rejection_theory(i).half_width_defocus/(((8*pi)/wavelength) ...
        * (sin(half_angle/2)^2))) / convert;
end


%% Generate and Save the Rejection Profile Figures
if save_intermediaries_flag == 1
    spath = [fpath '\Rejection Theory'];
    mkdir(spath);
    
    % Absolute Intensity Plot
    temp = figure; clf;
    hold on;
    for i = 1:numel(rejection_theory)
        plot(steps, rejection_theory(i).int_theory_abs, '--');
    end
    hold off;
    title('Absolute Intensity Rejection Profile Theory');
    xlabel(['Position from Focus [' rejection_step_size_units ']']);
    ylabel('Absolute Pixel Intensity [Counts]');
    legend_names = struct2cell(rejection_theory);
    legend_names = squeeze(legend_names(3,:,:));
    legend(legend_names, 'Location', 'best');
    print(temp, ...
        [spath '\Theoretical_Absolute_Intensity_Rejection_Profile'], ...
        '-djpeg');
    
    % Normalized Intensity Plot
    temp = figure; clf;
    hold on;
    temp2 = struct2cell(rejection_theory);
    temp2 = cell2mat(squeeze(temp2(6,:,:)));
    abs_max = max(max(temp2));
    abs_min = min(min(temp2));
    
    for i = 1:numel(rejection_theory)
        plot(steps, ((rejection_theory(i).int_theory_abs - abs_min) / ...
            (abs_max - abs_min)), '--');
    end
    hold off;
    title('Normalized Intensity Rejection Profile Theory');
    xlabel(['Position from Focus [' rejection_step_size_units ']']);
    ylabel('Normalized Pixel Intensity');
    legend(legend_names, 'Location', 'best');
    print(temp, ...
        [spath '\Theoretical_Normalized_Intensity_Rejection_Profile'], ...
        '-djpeg');
end
end
