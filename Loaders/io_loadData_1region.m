function data = io_loadData(parentFolder, regionName)

listing = dir(parentFolder);
allNames = {listing([listing.isdir]).name};

% Remove hidden folders such as "." and ".."
folders = allNames(cellfun(@(x) x(1) ~= '.', allNames));


%% Preallocate
data = cell(numel(folders), 4);


try

    %% Standard structure
    % Each folder is assumed to contain one brain region

    for i = 1:numel(folders)

        path = fullfile(parentFolder, folders{i});

        if nargin >= 2
            [a,b,c] = io_loadspec_dicom_MEGA_1region(path, regionName);
        else
            [a,b,c] = io_loadspec_dicom_MEGA_1region(path);
        end

        data{i,1} = a;  % difference / edited region
        data{i,2} = b;  % edit OFF
        data{i,3} = c;  % water
        data{i,4} = folders{i};  % subject/folder name

    end


catch

    %% Alternative structure
    % If the first structure fails, look one level deeper.
    %
    % For example:
    %
    % parentFolder/
    %     subject1/
    %         region/
    %     subject2/
    %         region/

    subs = {};
    subParents = {};

    for i = 1:numel(folders)

        path = fullfile(parentFolder, folders{i});

        d2 = dir(path);

        allnames = {d2([d2.isdir]).name};

        newSubs = allnames(cellfun(@(x) x(1) ~= '.', allnames));

        subs = [subs, newSubs];
        subParents = [subParents, ...
            repmat({path}, 1, numel(newSubs))];

    end


    %% Preallocate for the discovered subfolders

    data = cell(numel(subs), 4);


    %% Load each region

    for j = 1:numel(subs)

        subpath = fullfile(subParents{j}, subs{j});

        if nargin >= 2
            [a,b,c] = io_loadspec_dicom_MEGA_1region(subpath, regionName);
        else
            [a,b,c] = io_loadspec_dicom_MEGA_1region(subpath);
        end

        data{j,1} = a;  % difference / edited region
        data{j,2} = b;  % edit OFF
        data{j,3} = c;  % water
        data{j,4} = subs{j};  % folder/subject name

    end

end

end
