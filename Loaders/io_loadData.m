function data = io_loadData(parentFolder)

listing = dir(parentFolder);
allNames = {listing([listing.isdir]).name};
folders = allNames(cellfun(@(x) x(1) ~= '.', allNames));
data = cell(numel(folders), 7);

try 
    for i= 1: numel(folders)
        path = fullfile(parentFolder, folders{i});
        [a,b,c,d,e,f] = io_loadspec_dicom_MEGA_1(path);
        data{i,1} = a; % difference region 1
        data{i,2} = b; % edit_off region 1
        data{i,3} = c; % water region 1 
        data{i,4} = d; % difference region 2
        data{i,5} = e; % edit_off region 2 
        data{i,6} = f; % water region 2
        data{i,7} = folders{i}; 
    end
catch 
    data = cell(numel(folders)*2, 6);
    subs = {};
    subParents = {};

    for i = 1:numel(folders)
        path = fullfile(parentFolder, folders{i});
        d2 = dir(path);
        allnames = {d2([d2.isdir]).name};
        newSubs = allnames(cellfun(@(x) x(1) ~= '.', allnames));

        subs = [subs, newSubs];
        subParents = [subParents, repmat({path}, 1, numel(newSubs))];
    end

    for j= 1: numel(subs)
        subpath = fullfile(subParents{j}, subs{j});
        [a,b,c,d,e,f] = io_loadspec_dicom_MEGA_1(subpath);
        data{j,1} = a;
        data{j,2} = b;
        data{j,3} = c;
        data{j,4} = d;
        data{j,5} = e;
        data{j,6} = f;
        data{j,7} = subs{j};
    end
end
