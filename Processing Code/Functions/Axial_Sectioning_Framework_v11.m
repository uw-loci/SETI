function [] = Axial_Sectioning_Framework_v11(...
    steering_code_raw_data_flag, microscope_configuration, ...
    img_save_type, rec_mode, file_path, max_int, sim_points, ...
    save_intermediaries_flag, flat_field_flag, flat_field_path, ...
    overlap_percent, threshold_percent)
%% Axial Sectioning Structured Illumination Reconstruction Framework
%   By: Niklas Gahm
%   2017/06/29
%
%   This is a framework that loads up the needed images to be processed and
%   reconstructed for an axial sectioning system
%
%   Variables:
%       max_int - The maximum intensity to be used in an output image.
%       out_of_focus_flag - This is a binary flag for whether or not the
%                   image sequence being reconstructed is from an out of
%                   focus plane, if so an in-focus image needs to be
%                   acquired for normalization purposes. 
%       batch_flag - This is a binary flag to tell the script that
%                   all images in the folder should be processed using 
%                   the specified method
%       rejection_profile_flag - This is a binary flag to tell the script
%                   to generate a rejection profile from a series of images
%                   it needs to have batch_flag = 1 and 
%                   out_of_focus_flag = 1 to work. 
%       rejection_step_size - This is the step size between the image
%                   sequences used to generate the rejection profile. 
%       rejection_step_size_units - This is the units in which the step
%                   size are. This is used to display on the rejection
%                   profile graph, so please format it appropriately.
%       rejection_profile_name - This is the name that will be used to save
%                   all the rejection profiles that are used. 
%       steering_code_raw_data_flag - This is a flag that all the data is 
%                   straight from the co-designed steering code.
%       microscope_configuration - This is the configuration file to use
%                   which contains multiple variables based on the
%                   configuration of the hardware used. 
% 
%   Usage:
%           When you run the framework please select the first image of the
%       series that is being used for reconstruction, make sure that the
%       files end in {i, j, or k} for a 3 image reconstruction. If the
%       sequence is from an out-of-focus plane you will need to have an
%       in-focus image to normalize the intensity to. 
%           When using the in-focus batch mode, out_of_focus_flag = 0,
%       batch_flag = 1) this script will ignore all sub-folders within the 
%       folder selected.
%           When using the out-of-focus batch mode, (out_of_focus_flag = 1, 
%       batch_flag = 1) you will select a folder wherein all sub folders
%       will be ignored and it is assumed you are following a naming
%       convention of IF_[name]_[i,j,...] and OF_[name]_[1,2,...]_[i,j,...]
%       wherein [1,2,...] are the in-sequence stepping out from the
%       in-focus point. 
%           When using the rejection profile generator please follow the
%       out-of-focus batch mode usage guidelines. Make sure that your image
%       sequences are at an even step size spacing and that you fill in the
%       appropriate rejection_step_size and rejection_step_size_units. Also
%       each unique set of lp/mm need to be in their own folder. And there
%       need to be no other folders present. This assumes each sub-folder
%       is labelled as [lp/mm]_lpmm
%           The umanager_raw_flag mode exists solely to make the data
%       organizing easier. It should only be used the first time since it
%       solely exists to re-organize and re-name the data properly. It can
%       only be used in batch mode. 
% 
%   Supported Filetypes:
%       .tif
% 
%   Supported Microscope Configurations:
%       SETI_4x_460nm - SETI Microscope with 4x Nikon Plan APO using 460nm
%                   wavelength
%       SETI_10x_460nm - 
% 
%   Supported Reconstruction Types
%       3_Sub_Image - Basic SIM reconstruction with 3 images {i,j,k}
%       4_Sub_Image - Basic SIM reconstruction with 3 images {i,j,k,u}
%       5_Sub_Image - Basic SIM reconstruction with 3 images {i,j,k,u,w}
% 
%   Supported Reconstruction Modes
%       Single Image - This is for reconstructing a single in-focus image
%       Image Batch - This is for reconstructing a set of arbritrary
%                   in-focus images
%       Z-Stack - This is for reconstructing a z-stack from a batch of raw
%                   images
%       Atlas - This is for reconstructing an xy larger stitched together
%                   image
%       Atlas Z-Stack - This is for reconstructing an xy stitched together
%                   atlas image which also has multiple z-depths 
%       Rejection Profile - This is for generating an out-of-field 
%                   rejection profile from a batch of images which 
%                   will have theory matched to each rejection profile 
%                   generated
% 
%   Common Actuators Used for Stepping:
%       SETI - Newport Precision 100 TPI - 254 um per 1 turn
% 
%   To Be Added:
%       - Flat-Field Correction
%       - Add z-stack 3D Rendering Prep 
%       - Add Atlasing 
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
    Microscope_Configuration_Loader(microscope_configuration);


%% Generate Necessary Arch Paths and Extract Information from Folder Name
fprintf('\nGenerating Paths\n');
[run_name, file_path, arch_path, cut_depth, meas_scale, num_x, num_y, ...
    num_z] = arch_path_generator(file_path);


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
    rec_mode, file_path, img_save_type, save_intermediaries_flag, ...
    flat_field_flag, flat_field_path );


%% Reconstruction 
fprintf('\nReconstructing Images\n');
[ img_sets ] = sim_img_reconstructer_v3( img_sets, file_path, ...
    img_save_type );


% No Tiling or Rejection Profiles if the Image Sets are Just Random
% Locations in the Sample
if ~strcmp(rec_mode, 'Misc. Image Batch')
%% Generate Real lp/mm 
fprintf('\nCalculating Line Pair/mm\n');
[ img_sets ] = pixel_widths_2_lpmm_v2( img_sets,  f_number, obj_mag, ...
    pixel_lpmm_conv );


%% Sort Reconstructed Images 
fprintf('\nSorting Reconstructed Images\n');
[ img_sets ] = axial_set_img_sorter( img_sets, num_y, num_z );


%% Tiling/Mosaicing 
fprintf('\nTiling Reconstructed Images\n');
[ img_sets ] = axial_img_tiling_v3( img_sets, num_x, num_y, num_z, ...
    overlap_percent, threshold_percent);


%% Save Tiled Images as Stacks
fprintf('\nSaving Tiled Image Stacks\n');
axial_img_z_stack_saver(img_sets, file_path, img_save_type);


% If the Image Sets are Not Rejection Profile Based, Finish After
% Reconstruction
if strcmp(rec_mode, 'Rejection Profile')
%% Generate Rejection Profiles for Each Individual lp/mm Set
fprintf('\nGenerate Rejetion Profiles\n');
img_sets = axial_rejection_profile_generator(img_sets, file_path, ...
    cut_depth, meas_scale, save_intermediaries_flag);


%% Generate Rejection Profile Theory Matched to each lp/mm Set
fprintf('\nGenerate Rejetion Profile Theory for all lp/mm\n');
[ rejection_theory ] = sim_rejection_theory_v2( img_sets, meas_scale, ...
    cut_depth, sim_points, refractive_index_medium, obj_na, wavelength, ...
    file_path, save_intermediaries_flag); 


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