function [ pixel_lpmm_conversion, obj_na, obj_mag, f_number, ...
    wavelength, refractive_index_medium, working_distance, ...
    um_pixel_conversion, SETI_version ] = ...
    Microscope_Configuration_Loader( microscope_configuration )
%%  Microscope Configuration Loader
%   By: Niklas Gahm
%   2018/07/10 
% 
%   This script loads in the variables from the microscope configuration
%   file selected in the GUI. 
% 
%   Started: 2018/07/09
%   Finished: 2018/07/09


%% Setup Navigation
hpath = pwd;
cd('./Functions/Microscope Configurations');


%% Load the Configuration File
load(microscope_configuration);


%% Reset Navigation
cd(hpath);
end

