function lcm_1region(A)

% Single-region MEGAPRESS LCM processing
%
% A{i,1} = difference / MEGA spectrum
% A{i,2} = edit OFF spectrum
% A{i,3} = water spectrum
% A{i,4} = subject / folder name

% Update path
path = '/zpool/data/matthew/Lcm_test';

% Make sure the output directory exists
if ~isfolder(path)
    error('Directory does not exist: %s', path);
end

% Loop through subjects
for i = 1:size(A,1)

    %% Subject name

    subject = char(A{i,4});


    %% File paths

    filepath_1 = sprintf( ...
        '%s/region1_mega%s', ...
        path, subject);

    filepath_2 = sprintf( ...
        '%s/region1_editoff%s', ...
        path, subject);

    filepath_3 = sprintf( ...
        '%s/region1_water%s', ...
        path, subject);


    %% Write LCM files

    io_writelcm(A{i,3}, filepath_3, 68);

    io_writelcm(A{i,2}, filepath_2, 68);

    io_writelcm(A{i,1}, filepath_1, 68);


    %% Create LCM control files

    cmd_1 = sprintf( ...
        '../tools/new_lcmctrl_sh/createLCMcontrol.sh ' ...
        '../tools/new_lcmctrl_sh/tmp_pt_MEGA_3T_diff.control ' ...
        'region1_mega%s region1_water%s', ...
        subject, subject);

    cmd_2 = sprintf( ...
        '../tools/new_lcmctrl_sh/createLCMcontrol.sh ' ...
        '../tools/new_lcmctrl_sh/tmp_pt_MEGA_3T_off.control ' ...
        'region1_editoff%s region1_water%s', ...
        subject, subject);


    %% Run LCM control-file generation

    system(cmd_1);

    system(cmd_2);

end

end
