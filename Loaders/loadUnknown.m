%Loading the unknown functions
function out = loadUnknown(Folderpath,Bo,spectralwidth,te,tr)

files = dir(fullfile(Folderpath, '*'));
files= files(~[files.isdir] & ~startsWith({files.name}, '.'));

threshold= 0.8; 

output = {};

for i=1:length(files)
    filepath= fullfile(Folderpath, files(i).name);

    output{i}= io_loadspec_IMA(filepath, Bo,spectralwidth, te, tr); 
    
    if ~isfield(output{i}.dims, 'extras')
        output{i}.dims.extras = 0;
    end
end

reference = output{1};
group1 = {output{1}};
groupinbetween ={};
group2 = {} ;
unmatched = {} ;

for i=2:length(files)
    if corr(reference.specs, output{i}.specs)>=threshold
        group1{end+1} = output{i};
    else
        groupinbetween{end+1} = output{i};
    end

end

check= groupinbetween{1};

for i=2:numel(groupinbetween)
    if corr(check.specs, groupinbetween{i}.specs)>=threshold
        group2{end+1} = groupinbetween{i};
    else 
        unmatched{end+1}= groupinbetween{i};
    end
end

if isempty(group2) && numel(groupinbetween)>= 2
    backup= groupinbetween{2};
    for i=1:numel(unmatched)
        if corr(backup.specs, unmatched{i}.specs) >= threshold
            group2{end+1} = unmatched{i};
        end
    end
end            
            
for i=2: length(group1)
    reference = op_concatAverages(reference, group1{i});
end


start = group2{1};

for i=2:length(group2)
    start= op_concatAverages(start, group2{i});
end

if ndims(reference.specs) == 2
    reference.specs = reshape(reference.specs, size(reference.specs,1), 1, size(reference.specs,2));
    reference.sz = size(reference.specs);
end 

if ndims(start.specs) == 2
    start.specs = reshape(start.specs, size(start.specs,1), 1, size(start.specs,2));
    start.sz = size(start.specs);
end 

reference_avg = op_averaging(reference);
start_avg = op_averaging(start)

Option1 = op_subtractScans(start_avg, reference_avg);
Option2 = op_subtractScans(reference_avg, start_avg);

disp(op_plotspec(Option1));
disp(op_plotspec(Option2));
choice = input('((1 or 2): ')

switch choice
    case 1 
        out = Option1;
    case 2
        out = Option2;
    otherwise 
        disp('Invalid')
end


S
   
