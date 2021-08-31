function [ ] = Launch_Axial_Sectioning_v11( )
%% Axial Sectioning Launcher
%   This launches the axial sectioning and reconstruction GUI
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
%   2018/07/04 - Started
%   2018/07/04 - Finished


%% Get Navigation Hook
hpath = pwd;


%% Add Required Path
addpath('./Functions');


%% Launch GUI Function
Axial_Sectioning_Framework_App; 


%% Return to Starting Point
cd(hpath);

end

