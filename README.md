Preliminary: 

Download Required Programs:

Download the following Programs from Github:

FID-A
Gannet
SPM12

To do so run the following command in a linux terminal:

cd /path/to/folder
git clone https://github.com/x/y.git 

For FID-A the command is as follows: 

cd /path/to/folder
git clone https://github.com/CIC-methods/FID-A.git


I suggest you create a singular directory that contains these programs and the custom scripts provided. 

Generating a Path:

To be able to use these functions in MATLAB a path has to be generated.  

To do so use the following command:

addpath(genpath(‘/path/to/folder’))


Data Loading and Preprocessing:

To Load and Preprocess a Single Scan:

[raw, info] = io_loadspec_dicom_siemens(‘/path/to/scan’)

To Load and Preprocess a Singular Patient: 

[diff1, edit_off1, water1, diff2, edit_off2, water2] =  io_loadspec_dicom_MEGA_1('/path/to/directory')

*1 & 2 denote the different regions 

To Load and Preprocess a Section of an Entire Study: 

data = io_loadData('/path/to/parentfolder')

data is a y x 7 cell, the columns are ordered as follows:

[Difference Region 1, Edit Off Region 1, Water Region 1, Difference Region 2, Edit Off Region 2, Water Region 2, Patient id]

When you run this function you have to be present as it prompts the user to manually align the edit on and edit off spectra. Once the function finishes, save the data. 

To save data do the following:

save(‘/path/to/folder/data_name’)

LCModel Analysis:

Before beginning, several files need to be updated 

Enter the folder new_lcmctrl_sh. Then open tmp_pt_MEGA_3T_diff.control and tmp_pt_MEGA_3T_off.control 

Update the FILBAS path: 

This path should be updated to the path of jn_megapress_capetown_diff.basis and jn_megapress_capetown_off.basis respectively. 

Next you need to update lcm_audio_updated.m and lcm_PMDD_updated.m 

There is a variable called path, this needs to be changed to the path of the folder you want the LCModel output to go to. 

Additionally, in lcm_audio_updated.m and lcm_PMDD_updated.m depending on your naming convention you may have to update the cmd_1, cmd_2 … This needs to be changed to the path to new_lcmctrl_sh, while maintaining /new_lcmctrl_sh/createLCMcontrol.sh or whatever follows new_lcmctrl_sh. 

Analysis:


First load the data, this is done as follows:

load(‘path/to/folder/data_name’)

For the Audio study:

lcm_audio_updated(data_name)

To organize the csv files run the following:

organizecsv(‘/path/to/folder’)

For the PMDD study:

lcm_PMDD_updated(data_name)

To organize the csv files run the following:

organizecsv_pmdd(‘/path/to/folder’)

To Create MATLAB Tables:

After grouping the csv folder run the following:

Study_x_region_y_editoff/diff = createtable(‘/path/to/folder’)
*creates a .mat

Gannet (tissue correction: White Matter, Grey Matter, CSF):

For the Audio Study:

gannet_path(‘/path/to/folder’)

Example:

gannet_path(‘/zpool/data/studies/ARHL’)

For the PMDD study:

gannet_path_PMDD(‘/path/to/folder’)
_____________________________________________________________________________________

These functions will output in the patient folders.

To group them together run the following function: 
First update the path of newFolder  in the function csv, then 

csv(‘/path/to/folder’) 

[mega1, edit1, mega2, edit2] = metabolite_correction(table, csv)

[mega1A, mega2A, edit1A, edit2A, mega1B, mega2B, edit1B, edit2B] = metabolite_correction_PMDD(table, csv)

Where ‘table’ is the lcmodel output table generated (.mat file), and ‘csv’ is the csv folder that was generated in the gannet output. 

Example: 

[mega1, edit1, mega2, edit2] = metabolite_correction(ARHL.mat, ‘/zpool/data/matthew/ARHL_CSV’)

The outputs ‘mega1’,’edit1’,’mega2’, and ‘edit2’, are the tissue corrected metabolite concentrations for the mega-press difference spectra(‘mega’) and the mega-press edit-off spectra (‘edit’), for voxels 1 and 2. 

