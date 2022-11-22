function [ ] = raw_data_renamer_v2(fpath, run_name, num_x, ...
    num_y, num_z, rec_type_variables)
%% Raw Data Renamer
%   By: Niklas Gahm
%   2018/07/18
%
%   This code renames all data appropriately from it's raw state produced
%   by the steering code and imaging protocol
%
%   2018/07/18 - Started
%   2018/07/19 - Finished 
%   2022/11/08 - Reworked for SETI 1.5



%% Setup Navigation
hpath = pwd;
cd(fpath);


%% Go Through Folders and Rename
dir_list = dir;
dir_list = dir_list(3:end);
mkdir('BF');
bf_path = [fpath, filesep, 'BF'];

for i = 1:numel(dir_list)
    if isfolder(dir_list(i).name)
        %% Normal Data Case
        cd(dir_list(i).name);
        img_list = dir;
        img_list = img_list(3:end);
        delete(img_list(end).name); % Delete metadata file
        img_list = img_list(1:(end-1));
        
        % Get the Number of Sub Images
        [~, num_si, ~, ~] = seti_folder_name_parser(dir_list(i).name);
        
        % Saving pattern is brightfield then sequential sub images
        % Rename and Move Files
        counter = 1;
        for z = 1:(num_z+1)
            % File Naming convention comes from prior version which had
            % tiling acquisition fully enabled. It can easily be re-enabled
            % by adding a few lines here and modifying the beanshell
            % acquisition script.
            name_base = [run_name '_1x_1y_'  num2str(z) 'z_'];
            for img = 1:(num_si+1)
                if img == 1
                    % Brightfield
                    movefile(img_list(counter).name, ...
                        [bf_path, filesep, name_base, 'BR.tif'] );
                    counter = counter + 1;
                else
                    % Sub Images
                    movefile(img_list(counter).name, ...
                        [name_base, rec_type_variables{num_si}{img-1}, ...
                        '.tif'] );
                    counter = counter + 1;
                end
            end
        end
        
    end
end




% Original Code from 2018/07/19
%{
for i = 1:numel(dir_list)
    if isdir(dir_list(i).name)
        if ~strcmpi(dir_list(i).name, 'Bright Field') && ...
                ~strcmpi(dir_list(i).name, 'BF')
            %% Normal Data Case
            cd(dir_list(i).name);
            img_list = dir;
            img_list = img_list(3:end);
            delete(img_list(end).name); % Delete metadata file
            img_list = img_list(1:(end-1));
            
            % Get the Number of Sub Images
            [~, num_si, ~, ~] = seti_folder_name_parser(dir_list(i).name);
            
            % Rename Files
            counter = 0;
            for j = 1:num_z
                for k = 1:num_y
                    for l = 1:num_x
                        for m = 1:num_si
                            counter = counter + 1;
                            movefile(img_list(counter).name, [run_name ...
                                '_' num2str(l) 'x_' num2str(k) 'y_' ...
                                num2str(j) 'z_' ...
                                rec_type_variables{num_si}{m} '.tif']);
                        end
                    end
                end
            end
            cd(fpath);
            
            
        else
            %% Bright Field Case
            cd(dir_list(i).name);
            img_list = dir;
            img_list = img_list(3:end);
            delete(img_list(end).name); % Delete metadata file
            img_list = img_list(1:(end-1));
            
            % Rename Files
            counter = 0;
            for j = 1:num_z
                for k = 1:num_y
                    for l = 1:num_x
                        counter = counter + 1;
                        movefile(img_list(counter).name, [run_name '_' ...
                            num2str(l) 'x_' num2str(k) 'y_' num2str(j) ...
                            'z_BR.tif']);
                    end
                end
            end
            cd(fpath);
        end
    end
end
%}

%% Clean Navigation
cd(hpath);

end
