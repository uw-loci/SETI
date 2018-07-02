function [] = Launch_Microscope_Configuration_File_Generator( )
%% Microscope Configuration File Generator Launcher
%   By: Niklas Gahm
%   2018/06/29
%
%   This launches microscope configuration file generator GUI
%
%   2018/06/29 - Started
%   2018/06/29 - Finished


%% Get Navigation Hook
hpath = pwd;


%% Add Required Path
addpath('./Functions');
addpath('./Functions/Microscope Configurations');


%% Launch GUI Function
Microscope_Configuration_File_Generator_GUI;


%% Return to Starting Point
cd(hpath);

end

