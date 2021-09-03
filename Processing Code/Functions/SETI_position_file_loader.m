function [xyz_map] = SETI_position_file_loader(pos_file_path)
%% SETI Position File Loader 
%   By: Niklas Gahm
%   2019/01/15
%
%   This code programatically loads in the position file and generates a
%   mapping from the sequence index to a physical spatial distance as set
%   in the file
%
%   2019/01/15 - Started
%   2019/01/16 - Finished 
%   2021/09/02 - Adapted for SETI from the SSFC Project


%% Check if position file exists. 
if exist(pos_file_path, 'file') == 2
    % Open file to be read
    fid = fopen(pos_file_path);
    
    % First two lines do not contain information
    temp = fgetl(fid); %#ok<*NASGU>
    temp = fgetl(fid);
    
    % Initialize Struct
    xyz_map = struct;
    
    % Initialize Counters
    index_counter = 0;
    
    % Parse lines till end of useful lines or file
    while ~feof(fid)
        temp = fgetl(fid);
        if strcmp(temp, '</StageLocations>')
            % Found end of useful lines
            break;
        end
        
        % Incriment and register Index Counter
        index_counter = index_counter + 1;
        xyz_map(index_counter).ind = index_counter;
        
        % Parse Line
        % Get the first =" value which is the file's position index this
        % value is being replaced by our index counter to correct for the
        % difference between matlab indexing from 1 rather than 0. 
        for i = 1:(numel(temp)-1)
            if strcmp('="', temp(i:(i+1)))
                % Delete characters up to this point and break
                temp = temp(i+2:end);
                break
            end
        end
        
        
        % Get the second =" value which is the file's x position in um
        for i = 1:(numel(temp)-1)
            if strcmp('="', temp(i:(i+1)))
                % Delete characters up to this point and break
                temp = temp(i+2:end);
                break
            end
        end
        % Find the end of the number and convert it to a double
        for i = 1:numel(temp)
            if strcmp('"', temp(i))
                xyz_map(index_counter).x_pos = str2double(temp(1:i-1));
                break
            end
        end
        
        
        % Get the third =" value which is the file's y position in um
        for i = 1:(numel(temp)-1)
            if strcmp('="', temp(i:(i+1)))
                % Delete characters up to this point and break
                temp = temp(i+2:end);
                break
            end
        end
        % Find the end of the number and convert it to a double
        for i = 1:numel(temp)
            if strcmp('"', temp(i))
                xyz_map(index_counter).y_pos = str2double(temp(1:i-1));
                break
            end
        end
        
        
        % Get the fourth =" value which is the file's z position in um
        for i = 1:(numel(temp)-1)
            if strcmp('="', temp(i:(i+1)))
                % Delete characters up to this point and break
                temp = temp(i+2:end);
                break
            end
        end
        % Find the end of the number and convert it to a double
        for i = 1:numel(temp)
            if strcmp(',', temp(i)) || strcmp('"', temp(i))
                xyz_map(index_counter).z_pos = str2double(temp(1:i-1));
                break
            end
        end
        
    end
    
    % Close file 
    fclose(fid);
    
    
else
    %% Assume that this is a single position data set.
    xyz_map = struct;
    xyz_map.ind = 1;
    xyz_map.x_pos = 1;
    xyz_map.y_pos = 1;
    xyz_map.z_pos = 1;
end
end

