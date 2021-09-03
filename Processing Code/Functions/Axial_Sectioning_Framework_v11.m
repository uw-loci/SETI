function [] = Axial_Sectioning_Framework_v11(...
    steering_code_raw_data_flag, microscope_configuration, ...
    img_save_type, rec_mode, file_path, bit_depth, sim_points, ...
    save_intermediaries_flag, flat_field_flag, flat_field_path, ...
    overlap_percent, threshold_percent, position_file_path)
%% Axial Sectioning Structured Illumination Reconstruction Framework
%   By: Niklas Gahm
%   2017/06/29
%
%   This is a framework called by a corresponding GUI which loads a series 
%   of images, processes, reconstructs, tiles, and saves them for an axial 
%   sectioning system.
% 
%   Supported Filetypes:
%       .tif
% 
%   Supported Reconstruction Types
%       3_Sub_Image - Basic SIM reconstruction with 3 images {i,j,k}
%       4_Sub_Image - Basic SIM reconstruction with 3 images {i,j,k,u}
%       5_Sub_Image - Basic SIM reconstruction with 3 images {i,j,k,u,w}
% 
%   Supported Reconstruction Modes
%       Image Batch - This is for reconstructing a set of arbritrary
%                   in-focus images
%       Image Stack - This is for reconstructing an image cube from a batch
%                   of raw images
%       Rejection Profile - This is for generating an out-of-field 
%                   rejection profile from a batch of images which 
%                   will have theory matched to each rejection profile 
%                   generated
% 
%   Supported Tiling Modes
%       SETI 1.5 Supports not having exact positions and uses a method of
%                   cross-correlation and estimated overlap percentage. It
%                   is sub-optimal in it's reconstruciton.
%       SETI 2.0 Supports xy position file based tiling 
% 
%   Common Actuators Used for Stepping:
%       SETI - Newport Precision 100 TPI - 254 um per 1 turn
% 
%   2017/06/29 - Started 
%   2017/06/29 - Finished Initial Version
%   2017/07/05 - Finished Adding In-Focus Batch Mode
%   2017/07/05 - Finished Adding 4 and 5 Sub-Image Reconstruction
%   2017/07/06 - Finished Adding Out-Of-Focus Batch Mode
%   2017/07/06 - Finished Adding Single lp/mm Rejection Profile Generation
%   2017/07/12 - Finished Adding Multiple Rejection Profile Generation
%   2017/07/16 - Finished Adding uManager Reorganizer and Fixed Title Bug 
%   2017/08/07 - Fixed Ascending Order Bug
%   2017/12/04 - Fixed Rejection Profile Theory 
%   2017/12/06 - Improved User Interface
%   2018/11/30 - Finished Full Release Version 



%% Setup the Workspace
format longe; 

    
%% Navigation Setup
addpath('Functions');
addpath('Functions\bfmatlab');
home_path = pwd;


%% Suppress Useless Warnings
warning('off', 'MATLAB:MKDIR:DirectoryExists');


%% Load Microscope Settings
fprintf('\n\nLoading Microscope Configuration\n');
[pixel_lpmm_conv, obj_na, obj_mag, f_number, wavelength, ...
    refractive_index_medium, working_distance] = ...
[ pixel_lpmm_conversion, obj_na, obj_mag, f_number, ...
    wavelength, refractive_index_medium, working_distance, ...
    um_pixel_conversion, SETI_version ] = ...
    Microscope_Configuration_Loader(microscope_configuration);


%% Generate Necessary Arch Paths and Extract Information from Folder Name
fprintf('\nGenerating Paths\n');
[ run_name, file_path, arch_path, cut_depth, meas_scale, num_x, num_y, ...
    num_z ] = arch_path_generator(file_path);


%% Calculated Variables
max_int = (2^bit_depth) - 1;


%% Generate Useful Struct of Naming Conventions
rec_type_variables = {{'i'}, {'i', 'j'}, {'i', 'j', 'k'}, ...
    {'i', 'j', 'k', 'u'}, {'i', 'j', 'k', 'u', 'w'}};


%% Rename Data Appropriately If Raw from Steering Code
if steering_code_raw_data_flag == 1
    fprintf('\nRenaming Raw Files\n');
    raw_data_renamer_v2(file_path, run_name, num_x, num_y, ...
        num_z, rec_type_variables);
end


%% Load in Images
fprintf('\nLoading Images\n');
[ img_sets ] = axial_framework_img_loader( file_path );


%% Pre-Processing 
fprintf('\nPre-Processing Data\n');
[ img_sets ] = axial_framework_pre_processing_v2( img_sets, max_int, ...
    bit_depth, rec_mode, file_path, img_save_type, ...
    save_intermediaries_flag, flat_field_flag, flat_field_path );


%% Reconstruction 
fprintf('\nReconstructing Images\n');
[ img_sets ] = sim_img_reconstructer_v3( img_sets, file_path, ...
    img_save_type, bit_depth );


% No Tiling or Rejection Profiles if the Image Sets are Just Random
% Locations in the Sample
if ~strcmp(rec_mode, 'Individual Images')
%% Generate Real lp/mm 
fprintf('\nCalculating Line Pair/mm\n');
[ img_sets ] = pixel_widths_2_lpmm_v2( img_sets,  f_number, obj_mag, ...
    pixel_lpmm_conversion );


%% Sort Reconstructed Images 
fprintf('\nSorting Reconstructed Images\n');
[ img_sets ] = axial_set_img_sorter( img_sets, num_y, num_z );

% Update the XYZ positions with actual positions if known
if strcmp(SETI_version, '2.0')
    [ xyz_map ] = SETI_position_file_loader(position_file_path);
    for i = 1:numel(img_sets)
        [ img_sets(i).images_reconstructed ] = ...
            SETI_spatiotemporal_assignment( ...
            img_sets(i).images_reconstructed, xyz_map );
    end
end


%% Tiling/Mosaicing 
fprintf('\nTiling Reconstructed Images\n');
switch SETI_version
    case '1.5'
        [ img_sets ] = axial_img_tiling_v3( img_sets, num_x, num_y, ...
            num_z, overlap_percent, threshold_percent);
        
    case '2.0'
        for i = 1:numel(img_sets)
            [ img_sets(i).images_tiled.original ] = ...
                SETI_position_file_img_tiling( ...
                img_sets(i).images_reconstructed, xyz_map, ...
                um_pixel_conversion );
        end
        % Clean Reconstructed Memory Usage
        img_sets = rmfield(img_sets, 'images_reconstructed');
        
    otherwise
        error(['\nUnsupported SETI Version. Please Update the Axial ' ...
            'Sectioning Framework Tiling Section.\n']);
end


%% Save Tiled Images as Stacks
fprintf('\nSaving Tiled Image Stacks\n');
axial_img_z_stack_saver(img_sets, file_path, img_save_type, bit_depth);


% If the Image Sets are Not Rejection Profile Based, Finish After
% Reconstruction
if strcmp(rec_mode, 'Rejection Profile')
    %% Generate Rejection Profiles for Each Individual lp/mm Set
    fprintf('\nGenerate Rejetion Profiles\n');
    img_sets = axial_rejection_profile_generator(img_sets, file_path, ...
        cut_depth, meas_scale, save_intermediaries_flag);
    
    
    %% Generate Rejection Profile Theory Matched to each lp/mm Set
    fprintf('\nGenerate Rejetion Profile Theory for all lp/mm\n');
    [ rejection_theory ] = sim_rejection_theory_v2( img_sets, ...
        meas_scale, cut_depth, sim_points, refractive_index_medium, ...
        obj_na, wavelength, file_path, save_intermediaries_flag);
    
    
    %% Generates the Combined Rejection Profile
    fprintf('\nGenerate the Combined Rejetion Profiles\n');
    sim_theory_profile_combiner(img_sets, rejection_theory, meas_scale, ...
        file_path, run_name);
end
end


%% Confirm Completion
fprintf('\nProcessing Complete\n\n');

%% Return to Starting Point
cd(home_path);
end