function csv(parentfolder)

    [~, name, ~] = fileparts(parentfolder);
    foldername = [name, '_CSV'];
    newFolder = fullfile( '/zpool/data/matthew/',foldername);

   if ~exist(newFolder, 'dir')
       mkdir(newFolder)
   else 
        fprintf('Directory already exists')
   end

   csvFiles = dir(fullfile(parentfolder, '**', '*.csv'));

   for k = 1:numel(csvFiles)
       if csvFiles(k).isdir, continue; end

       srcFilePath = fullfile(csvFiles(k).folder, csvFiles(k).name);
       [~, subname] = fileparts(csvFiles(k).folder);
       current = csvFiles(k).name;

       if strcmpi(current, 'Gannet_output.csv')
           region = 'region_1';
       elseif strcmpi(current, 'Gannet_output1.csv')
           region = 'region_2';
       else 
           continue;
       end
       
       newname = sprintf('%s_%s.csv', subname, region);
       filepath = fullfile(newFolder, newname);
       copyfile(srcFilePath,filepath);

   end
end













