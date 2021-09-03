function [ img_sets ] = SETI_spatiotemporal_assignment( img_sets, xyz_map )
%% SETI Spatio Temporal Assignment
%   By: Niklas Gahm
%   2020/02/03
%
%   This script populates the img_sets struct with correct positional and
%   timepoint assignments
%
%
%   2020/02/03 - Started
%   2020/02/03 - Finished
%   2021/09/02 - Adapted to SETI from the SSFC Project



% Iterate through the Positions
for j = 1:numel(xyz_map)
    img_sets(j+offset).x_pos = xyz_map(j).x_pos;
    img_sets(j+offset).y_pos = xyz_map(j).y_pos;
    img_sets(j+offset).z_pos = xyz_map(j).z_pos;
end

end