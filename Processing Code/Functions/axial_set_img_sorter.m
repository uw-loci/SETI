function [ img_sets ] = axial_set_img_sorter( img_sets, num_y, num_z )
%% Axial Image Set Sorter 
%   By: Niklas Gahm
%   2018/07/27
%
%   This code sorts the image sets and reconstructed images.
% 
%   Sorting Order:
%       - Pattern
%       - Number of Sub-Images
%       - line pair / mm
%       - % Aperture
%       - Position Coordinates 
% 
%   2018/07/27 - Started
%   2018/08/01 - Finished 



%% Sort on Pattern
perfect_bar_ind = [];
imperfect_bar_ind = [];
imperfect_sinewave_ind = [];
brightfield_ind = [];
for i = 1:numel(img_sets)
    if strcmp(img_sets(i).pattern, 'perfect bar')
        perfect_bar_ind = [perfect_bar_ind, i];
    elseif strcmp(img_sets(i).pattern, 'imperfect bar')
        imperfect_bar_ind = [imperfect_bar_ind, i];
    elseif strcmp(img_sets(i).pattern, 'imperfect sinewave')
        imperfect_sinewave_ind = [imperfect_sinewave_ind, i];
    elseif isempty(img_sets(i).pattern)
        % BrightField Case
        brightfield_ind = [brightfield_ind, i];
    end
end

if (numel(perfect_bar_ind) + numel(imperfect_bar_ind) + ...
        numel(imperfect_sinewave_ind) + numel(brightfield_ind)) ...
        < numel(img_sets)
    edge_sets = numel(img_sets);
else
    
    img_sets = [img_sets(brightfield_ind), img_sets(perfect_bar_ind), ...
        img_sets(imperfect_bar_ind), img_sets(imperfect_sinewave_ind)];
    edge_sets = [numel(brightfield_ind), (numel(perfect_bar_ind) + ...
        numel(brightfield_ind)), (numel(perfect_bar_ind) + ...
        numel(imperfect_bar_ind) + numel(brightfield_ind))];
    % Clean Edge Sets
    for i = 1:numel(edge_sets)
        for j = 2:numel(edge_sets)
            if edge_sets(j-1) == edge_sets(j)
                if j == numel(edge_sets)
                    edge_sets = edge_sets(1:(j-1));
                else
                    edge_sets = [edge_sets(1:(j-1)), edge_sets((j+1):end)];
                end
                break;
            end
        end
    end
end


%% Sort on Number of Sub-Images
temp = struct2cell(img_sets);
for i = 1:numel(edge_sets)
    bounds = [1,edge_sets(i)];
    if i ~= 1
        bounds(1) = edge_sets(i-1);
    end
    [~,rearranged_ind] = ...
        sort(cell2mat(squeeze(temp(4,1,(bounds(1)+1):bounds(2)))));
    img_sets((bounds(1)+1):bounds(2)) = ...
        img_sets(bounds(1) + rearranged_ind);
end


%% Sort on Line Pair / mm
temp = struct2cell(img_sets);
for i = 1:numel(edge_sets)
    bounds = [1,edge_sets(i)];
    if i ~= 1
        bounds(1) = edge_sets(i-1);
    end
    [~,rearranged_ind] = ...
        sort(cell2mat(squeeze(temp(7,1,(bounds(1)+1):bounds(2)))));
    img_sets((bounds(1)+1):bounds(2)) = ...
        img_sets(bounds(1) + rearranged_ind);
end


%% Sort on % Aperture
temp = struct2cell(img_sets);
for i = 1:numel(edge_sets)
    bounds = [1,edge_sets(i)];
    if i ~= 1
        bounds(1) = edge_sets(i-1);
    end
    [~,rearranged_ind] = ...
        sort(cell2mat(squeeze(temp(4,1,(bounds(1)+1):bounds(2)))));
    img_sets((bounds(1)+1):bounds(2)) = ...
        img_sets(bounds(1) + rearranged_ind);
end


%% Sort on Position Coordinates
for i = 1:numel(img_sets)
    temp = struct2cell(img_sets(i).images_reconstructed);
    % Sort on Z-Position
    [~,rearranged_ind] = sort(cell2mat(squeeze(temp(4,1,:))));
    img_sets(i).images_reconstructed = ...
        img_sets(i).images_reconstructed(rearranged_ind);
    z_edges = 1 : (numel(img_sets(i).images_reconstructed)/num_z) : ...
        numel(img_sets(i).images_reconstructed);
    for j = 1:numel(z_edges)
        % Sort on Y-Position
        temp = struct2cell(img_sets(i).images_reconstructed);
        if j ~= numel(z_edges)
            bounds = [z_edges(j), (z_edges(j+1)-1)];
        else
            bounds = [z_edges(j), numel(img_sets(i).images_reconstructed)];
        end
        if (bounds(1) ~= bounds(2)) && ((bounds(1)+1) ~= bounds(2))
            [~,rearranged_ind] = ...
                sort(cell2mat(squeeze(temp(3,1,(bounds(1)+1):bounds(2)))));
            img_sets(i).images_reconstructed((bounds(1)+1):bounds(2)) = ...
                img_sets(i).images_reconstructed(bounds(1) + ...
                rearranged_ind);
            y_edges = bounds(1):((bounds(2)-bounds(1)+1)/num_y):bounds(2);
            y_bound = bounds(2);
            for k = 1:numel(y_edges)
                % Sort on X-Position
                temp = struct2cell(img_sets(i).images_reconstructed);
                if k ~= numel(y_edges)
                    bounds = [y_edges(k), (y_edges(k+1)-1)];
                else
                    bounds = [y_edges(k), y_bound]; 
                end
                [~,rearranged_ind] = ...
                    sort(cell2mat(squeeze( ...
                    temp(2,1,(bounds(1)+1):bounds(2)))));
                img_sets(i).images_reconstructed( ...
                    (bounds(1)+1):bounds(2)) = ...
                    img_sets(i).images_reconstructed(bounds(1) + ...
                    rearranged_ind);
            end
        end
    end
end

end
