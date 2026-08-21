function  gannet_path(folder)

listing = dir(folder);
allNames = {listing([listing.isdir]).name};
folders = allNames(cellfun(@(x) x(1) ~= '.', allNames));

mkdir(folder, 'Gannet');
cd(fullfile(folder, 'Gannet'));

for i = 1:numel(folders)


    os = fullfile(folder, folders{i});
    groups = groupFolders(os);
    full = fullfile(os, groups.MPRAGE{1});
    niifiles = dir(fullfile(full, '*.nii'));

    originalDir = pwd;
    cd(os);
    
    if isfield(groups, 'PFC') && isfield(groups, 'auditif')
        otherA = dir(fullfile(os, groups.PFC.ON{1}));
        otherB = dir(fullfile(os, groups.auditif.ON{1}));
        
        [~, nameA, ~] = fileparts(otherA(1).name);
        [~, nameB, ~] = fileparts(otherB(1).name);

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


end 
