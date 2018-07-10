function [ ] = DLP_Consistency_Evaluation( raw_data )
%% DLP Consistency Evaluation
%   This function generates two plots which show two characteristic aspects
%   of the digital light projector's intensity output.
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



%% User Variables
t_step = 21; % Units = msec


%% Generate the Time Axis 
t_axis = (1:1:numel(raw_data)) * t_step;


%% Convert Column Vector into Usable Format
intensity = zeros(1,numel(raw_data));
for i = 1:numel(raw_data)
    intensity(i) = str2double(raw_data{i}); 
end


%% Plot Intensity 
figure(1);clf;
plot(t_axis, intensity, '-k');
xlabel('Time [ms]');
ylabel('Intensity [counts]');
title('Digital Light Projector Intensity');


%% Generate Derivative
intensity_derivative = intensity(2:end)- intensity(1:(end-1));


%% Plot Derivative
figure(2); clf;
plot(t_axis(2:end), intensity_derivative, '-k');
xlabel('Time [ms]');
ylabel('Intensity Change [Counts]');
title('Digital Light Projecter Intensity Change');

end

