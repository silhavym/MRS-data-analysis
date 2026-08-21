function  gannet_path_PMDD(folder)

listing = dir(folder);
allNames = {listing([listing.isdir]).name};
folders = allNames(cellfun(@(x) x(1) ~= '.', allNames));

for i = 1:numel(folders)

    current_top_path = fullfile(folder, folders{i});

    sub_listing = dir(current_top_path);
    sub_allName = {sub_listing([sub_listing.isdir]).name};
    nested_folders = sub_allName(cellfun(@(x) x(1) ~='.', sub_allName));

    originalDir = pwd;
   

    for j=1:numel(nested_folders)

        os = fullfile(current_top_path, nested_folders{j});
        groups = groupFolders(os);
        full = fullfile(os, groups.MPRAGE{1});
        niifiles = dir(fullfile(full, '*.nii'));

        cd(os);
    
        if isfield(groups, 'PFC') && isfield(groups, 'auditif')
            otherA = dir(fullfile(os, groups.PFC.ON{1}));
            otherB = dir(fullfile(os, groups.auditif.ON{1}));

            niifiles_1 = customGannetLoad(otherA(1).folder);
            t1= fullfile(niifiles(1).folder, niifiles(1).name);
            niifiles_2 = GannetCoRegister(niifiles_1, {t1});
            niifiles_3 = GannetSegment(niifiles_2);
        
            niifiles_4 = customGannetLoad(otherB(1).folder);
            niifiles_5 = GannetCoRegister(niifiles_4, {fullfile(niifiles(1).folder, niifiles(1).name)});
            niifiles_6 = GannetSegment(niifiles_5);

        elseif isfield(groups, 'DLPFC') && isfield(groups, 'visual')
            otherA = dir(fullfile(os, groups.DLPFC.ON{1}));
            otherB = dir(fullfile(os, groups.visual.ON{1}));

            niifiles_1 = customGannetLoad(otherA(1).folder);
            niifiles_2 = GannetCoRegister(niifiles_1, {fullfile(niifiles(1).folder, niifiles(1).name)});
            niifiles_3 = GannetSegment(niifiles_2);
        
            niifiles_4 = customGannetLoad(otherB(1).folder);
            niifiles_5 = GannetCoRegister(niifiles_4, {fullfile(niifiles(1).folder, niifiles(1).name)});
            niifiles_6 = GannetSegment(niifiles_5);

        end

        cd(originalDir);
        
    end

end


end 