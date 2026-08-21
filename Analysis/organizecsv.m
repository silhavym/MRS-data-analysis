function organizecsv(folder)

if nargin <1
    folder = pwd;
end

filePattern = fullfile(folder, '*.csv');
files = dir(filePattern);

if isempty(files)
    error('No .csv files found')
end

fileList = string({files.name});

categories = ["region1_editoff", "region2_editoff", "region1_mega", "region2_mega"];

for i=1:length(categories)
    cat = categories(i);

    matchedFiles = fileList(startsWith(fileList,cat));

    if isempty(matchedFiles)
        fprintf('Skipping "%s" (No matching files).\n', cat)
    end

    targetFolder = fullfile(folder,cat);

    if ~exist(targetFolder, 'dir')
        mkdir(targetFolder)
    end

    for j=1:length(matchedFiles)
        sourcePath = fullfile(folder, matchedFiles(j));
        destPath = fullfile(targetFolder, matchedFiles(j));

        copyfile(sourcePath, destPath);
    end
end
end
