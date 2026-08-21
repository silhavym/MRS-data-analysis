%Start with parent directory and get an array of processed files

function [out,info]= loadFolder(parentFolder)

%auto-detects subfolders
listing = dir(parentFolder);
listing = listing([listing.isdir] & ~ismember({listing.name}, {'.','..'}));
folders = fullfile(parentFolder, {listing.name});

%Removes files with under a certain amount of files (for these scans there
%tends to be at least 8 files in the folder) 

mask = false(1, length(folders));
for i = 1:length(folders)
    files = dir(fullfile(folders{i}, '*'));
    files = files(~[files.isdir]);
    mask(i) = numel(files)>=3;
end
folders= folders(mask);

%Use loadspec_dicom function 

for i = 1:length(folders)
    [out(i),info(i)] = io_loadspec_dicom_siemens(folders{i});
end

end


