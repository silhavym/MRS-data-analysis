function groups = groupFolders(Dir)

if nargin <1
    Dir = pwd;
end
listing = dir(Dir);
allNames = {listing([listing.isdir]).name};
folders = allNames(cellfun(@(x) x(1) ~= '.', allNames));

groups = struct();

groups.MPRAGE = {};

for i= 1:numel(folders)
    name = folders{i};

    tok = regexp(name, 'wsupp-(?<wsupp>ON|OFF)_voi-(?<region>[^_]+)','names');

    if ~isempty(tok)
 
        regionKey = matlab.lang.makeValidName(tok.region);
        wsuppKey = tok.wsupp;

        if ~isfield(groups, regionKey)
            groups.(regionKey) = struct('ON', {{}}, 'OFF', {{}});
        end 

        groups.(regionKey).(wsuppKey){end+1}= name;
    else 
        groups.MPRAGE{end+1} = name;
    end


end



   



           

  


