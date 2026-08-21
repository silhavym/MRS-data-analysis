function table= createtable(folder)

table=[];

files = dir(folder)
validfiles = files(~ismember({files.name}, {'.', '..'}));

for i=1:length(validfiles)
     input = readtable(fullfile(validfiles(1).folder, validfiles(i).name));
     table = [table;input];
end

end
