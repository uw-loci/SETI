function [] = Launch_SIM_Pattern_Generator( )
%% SIM Pattern Generator Launcher
%   By: Niklas Gahm
%   2018/07/02
%
%   This launches the SIM pattern generator GUI
%
%   2018/07/02 - Started
%   2018/07/02 - Finished


%% Get Navigation Hook
hpath = pwd;


%% Add Required Path
addpath('./Functions');
addpath('./Patterns');


%% Launch GUI Function
SIM_Pattern_Generator_v3_GUI; 


%% Return to Starting Point
cd(hpath);

end

