function [ run_name, file_path, arch_path, cut_depth, meas_scale, ...
    num_x, num_y, num_z] = arch_path_generator( fpath )
%% Arch Path Generator   
%   By: Niklas Gahm
%   2018/07/10
%
%   This code generates all path references and structure needed for
%   starting a run.
%
%   2018/07/10 - Started
%   2018/07/10 - Finished


%% Setup Navigation
hpath = pwd;
cd(fpath);


%% Generate Run Name and Arch Path
[~, run_name, ~] = fileparts(fpath);
arch_path = fpath;


%% Get Cut Depths
run_name = run_name(1:end-5); % Remove _cuts tail on string
meas_scale = run_name((end-1):end);
run_name = run_name(1:(end-2));
start_point = 0;
for i = 0:(numel(run_name)-1)
    if strcmp(run_name(end-i), '_')
        start_point = i;
        break;
    end
end
cut_depth = str2double(run_name((end-(start_point-1)):end));


%% Get x, y, z Position Counts
run_name = run_name(1:(end-(start_point+2)));
for i = 0:(numel(run_name)-1)
    if strcmp(run_name(end-i), '_')
        start_point = i;
        break;
    end
end
num_z = str2double(run_name((end-(start_point-1)):end));
run_name = run_name(1:(end-(start_point+2)));
for i = 0:(numel(run_name)-1)
    if strcmp(run_name(end-i), '_')
        start_point = i;
        break;
    end
end
num_y = str2double(run_name((end-(start_point-1)):end));
run_name = run_name(1:(end-(start_point+2)));
for i = 0:(numel(run_name)-1)
    if strcmp(run_name(end-i), '_')
        start_point = i;
        break;
    end
end
num_x = str2double(run_name((end-(start_point-1)):end));
run_name = run_name(1:(end-(start_point+1)));


%% Check if Folder Already Sorted 
dir_list = dir;
if numel(dir_list) == 4
    proc_found = 0;
    unproc_found = 0;
    for i = 3:4
        if strcmp(dir_list(i).name, 'Processed Data')
            proc_found = 1;
        elseif strcmp(dir_list(i).name, 'Unprocessed Data')
            unproc_found = 1;
        end
    end
    
    % Folder Partially Sorted
    if unproc_found && ~proc_found
        copyfile('Unprocessed Data', 'Processed Data');
        file_path = [arch_path '\Processed Data'];
        % Clean Navigation
        cd(hpath);
        return;
    end
    
    % Folder Already Sorted
    if proc_found && unproc_found
        % Get Confirmation Before Overwriting Previously Processed Data
        confirmation_response = questdlg(['Are you sure you want to ' ...
            'overwrite previously processed data in this folder?'], ...
            'Overwrite Confirmation', 'Yes', 'No', 'No');
        switch confirmation_response
            case 'Yes'
                rmdir('Processed Data', 's');
                copyfile('Unprocessed Data', 'Processed Data');
                file_path = [arch_path '\Processed Data'];
                % Clean Navigation
                cd(hpath);
                return;
            case 'No'
                % Clean Navigation
                cd(hpath);
                error(['No overwrite permission given. Please select ' ...
                    'a different folder to process.']);
            otherwise
                % Clean Navigation
                cd(hpath);
                error('No overwrite confirmation given.');
        end
    end
end


%% Sort Folder Appropriately
movefile('*', 'Unprocessed Data');
copyfile('Unprocessed Data', 'Processed Data');
file_path = [arch_path '\Processed Data'];


%% Clean Navigation
cd(hpath);
end