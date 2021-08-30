function [] = Launch_Microscope_Configuration_File_Generator( )
%% Microscope Configuration File Generator Launcher
%   This launches microscope configuration file generator GUI
% 
%     Copyright (C) 2018 Niklas Gahm
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
%
%   2018/06/29 - Started
%   2018/06/29 - Finished


%% Get Navigation Hook
hpath = pwd;


%% Add Required Path
addpath('./Functions');
addpath('./Functions/Microscope Configurations');


%% Launch GUI Function
Microscope_Configuration_File_Generator; 


%% Return to Starting Point
cd(hpath);

end

