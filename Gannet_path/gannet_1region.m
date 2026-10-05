function gannet_1region(folder, regionName)

listing = dir(folder);
allNames = {listing([listing.isdir]).name};
folders = allNames(cellfun(@(x) x(1) ~= '.', allNames));


%% Make Gannet output folder

mkdir(folder, 'Gannet');

gannetFolder = fullfile(folder, 'Gannet');


%% Loop through subjects

for i = 1:numel(folders)

    os = fullfile(folder, folders{i});

    %% Group files using the existing groupFolders function

    groups = groupFolders(os);


    %% Determine region

    if nargin < 2

        regionFields = fieldnames(groups);

        % Remove MPRAGE since it is not a brain region
        regionFields = regionFields(~strcmp(regionFields, 'MPRAGE'));

        if numel(regionFields) ~= 1
            error(['More than one brain region was found for %s. ' ...
                   'Please specify the region name as the second input.'], ...
                   folders{i});
        end

        regionName = regionFields{1};

    end


    %% Check that the requested region exists

    if ~isfield(groups, regionName)
        error('Region "%s" not found for subject %s.', ...
              regionName, folders{i});
    end


    %% Get the MPRAGE

    if ~isfield(groups, 'MPRAGE') || isempty(groups.MPRAGE)
        error('No MPRAGE found for subject %s.', folders{i});
    end

    full = fullfile(os, groups.MPRAGE{1});

    niifiles = dir(fullfile(full, '*.nii'));

    if isempty(niifiles)
        error('No NIfTI file found in MPRAGE folder for subject %s.', ...
              folders{i});
    end


    %% Get the ON MEGAPRESS scan for this region

    if ~isfield(groups.(regionName), 'ON') || ...
            isempty(groups.(regionName).ON)

        error('No ON scan found for region "%s" in subject %s.', ...
              regionName, folders{i});

    end


    otherA = dir(fullfile(os, groups.(regionName).ON{1}));

    if isempty(otherA)
        error('No files found in the ON folder for subject %s.', ...
              folders{i});
    end


    %% Change to subject directory

    cd(os);


    %% Load MEGAPRESS data into Gannet

    niifiles_1 = customGannetLoad(otherA(1).folder);


    %% Coregister to MPRAGE

    t1 = fullfile( ...
        niifiles(1).folder, ...
        niifiles(1).name);

    niifiles_2 = GannetCoRegister( ...
        niifiles_1, {t1});


    %% Segment

    niifiles_3 = GannetSegment(niifiles_2);


    %% Optional: save results in the Gannet directory

    % Change to Gannet output directory if desired
    % cd(gannetFolder);


end

end
