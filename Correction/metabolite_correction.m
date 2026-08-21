function [mega1, edit1, mega2, edit2] =metabolite_correction(data, folder)

filePattern = fullfile(folder, '*.csv');
csvDir = dir(filePattern);
csvFilelist = {csvDir.name};

extractedNumbersCell = regexp(csvFilelist, '\d+', 'match', 'once');
numericArray = str2double(extractedNumbersCell);
[~, idx] = sort(numericArray, 'MissingPlacement','first');
csvFilelist = csvFilelist(idx);

load(data);

gabamega = find(strcmp(mega1.Properties.VariableNames, 'GABA'));
gabaedit = find(strcmp(edit1.Properties.VariableNames, 'GABA'));
Aspmega = find(strcmp(mega1.Properties.VariableNames, 'Asp'));
Aspedit = find(strcmp(edit1.Properties.VariableNames, 'Asp'));
TChmega = find(strcmp(mega1.Properties.VariableNames, 'TCh'));
TChedit = find(strcmp(edit1.Properties.VariableNames, 'TCH'));
TCrmega = find(strcmp(mega1.Properties.VariableNames, 'TCr'));
TCredit = find(strcmp(edit1.Properties.VariableNames, 'TCr'));
Glumega = find(strcmp(mega1.Properties.VariableNames, 'Glu'));
Gluedit = find(strcmp(edit1.Properties.VariableNames, 'Glu'));
Glnmega = find(strcmp(mega1.Properties.VariableNames, 'Gln'));
Glnedit = find(strcmp(edit1.Properties.VariableNames, 'Gln'));
Gshmega = find(strcmp(mega1.Properties.VariableNames, 'GSH'));
Gshedit = find(strcmp(edit1.Properties.VariableNames, 'GSH'));
Insmega = find(strcmp(mega1.Properties.VariableNames, 'Ins'));
Insedit = find(strcmp(edit1.Properties.VariableNames, 'Ins'));
Lacmega = find(strcmp(mega1.Properties.VariableNames, 'Lac'));
Lacedit = find(strcmp(edit1.Properties.VariableNames, 'Lac'));
NAAmega = find(strcmp(mega1.Properties.VariableNames, 'NAA'));
NAAedit = find(strcmp(edit1.Properties.VariableNames, 'NAA'));
NAAGmega = find(strcmp(mega1.Properties.VariableNames, 'NAAG'));
NAAGedit = find(strcmp(edit1.Properties.VariableNames, 'NAAG'));
Scyllomega = find(strcmp(mega1.Properties.VariableNames, 'Scyllo'));
Scylloedit = find(strcmp(edit1.Properties.VariableNames, 'Scyllo'));

metab = {'GABA', 'Asp', 'TCh', 'TCr', 'Glu', 'Gln', 'GSH', 'Ins', 'Lac', 'NAA', 'NAAG', 'Scyllo', 'Row', 'Col'};

allHeaders_mega = mega1.Properties.VariableNames;
ismetab = ismember(allHeaders_mega, metab);
has_ = contains(allHeaders_mega, '_');
hasSD = contains(allHeaders_mega, 'SD', 'IgnoreCase', true);

excludeMask = ismetab | has_ | hasSD;
keepMask = ~excludeMask;
keepColNumbers_mega = find(keepMask);

allHeaders_edit = edit1.Properties.VariableNames;
ismetab_edit = ismember(allHeaders_edit, metab);
has_edit = contains(allHeaders_edit, '_');
hasSD_edit = contains(allHeaders_edit, 'SD', 'IgnoreCase', true);

excludeMask_edit = ismetab_edit | has_edit | hasSD_edit;
keepMask_edit = ~excludeMask_edit;
keepColNumbers_edit = find(keepMask_edit);

for i=1:length(csvFilelist)/2 

    ii = 2*i -1;

    csv = fullfile(folder, csvFilelist{ii});
    data = readtable(csv);

    fwm = data.fWM(1);
    fgm = data.fGM(1);
    fcsf = data.fCSF(1);

    value_without_mega = ( (36100*exp(-68/79.2)*(1-exp(-3200/832)))*fwm+ ...
                     (43300*exp(-68/110)*(1-exp(-3200/1331)))*fgm + ...
                     (53800*exp(-68/503)*(1-exp(-3200/3817)))*fcsf ) / (35880*.43);

    value_without_edit = ((36100*exp(-68/79.2)*(1-exp(-3200/832)))*fwm+ ...
                     (43300*exp(-68/110)*(1-exp(-3200/1331)))*fgm + ...
                     (53800*exp(-68/503)*(1-exp(-3200/3817)))*fcsf) / (35880*.7);

        %MEGA-diff section 
        mega1{i,Aspmega} = mega1{i,Aspmega} * (value_without_mega / (exp(-68/130)*(fwm+fgm)));
        mega1{i,TChmega} = mega1{i,TChmega} * (value_without_mega / (exp(-68/207)*(fwm+fgm)));
        mega1{i,TCrmega} = mega1{i,TCrmega} * (value_without_mega / (exp(-68/158)*(fwm+fgm)));
        mega1{i,Glumega} = mega1{i,Glumega} * (value_without_mega / (exp(-68/191)*(fwm+fgm)));
        mega1{i, Glnmega} = mega1{i,Glnmega} * (value_without_mega / (exp(-68/191)*(fwm+fgm)));
        mega1{i,gabamega} = mega1{i,gabamega} * (value_without_mega / (exp(-68/88)*(fwm+fgm)));
        mega1{i,Gshmega} = mega1{i,Gshmega} * (value_without_mega / (exp(-68/78)*(fwm+fgm)));
        mega1{i,Insmega} = mega1{i,Insmega} * (value_without_mega / (exp(-68/197)*(fwm+fgm)));
        mega1{i,Lacmega} = mega1{i,Lacmega} * (value_without_mega / (exp(-68/125)*(fwm+fgm)));
        mega1{i,NAAmega} = mega1{i,NAAmega} * (value_without_mega / (exp(-68/288)*(fwm+fgm)));
        mega1{i,NAAGmega} = mega1{i,NAAGmega} * (value_without_mega / (exp(-68/288)*(fwm+fgm)));
        mega1{i,Scyllomega} = mega1{i,Scyllomega} * (value_without_mega / (exp(-68/150)*(fwm+fgm)));

        %MEGA-off section
        edit1{i,Aspedit} = edit1{i,Aspedit} * (value_without_edit / (exp(-68/130)*(fwm+fgm)));
        edit1{i,TChedit} = edit1{i,TChedit} * (value_without_edit / (exp(-68/207)*(fwm+fgm)));
        edit1{i,TCredit} = edit1{i,TCredit} * (value_without_edit / (exp(-68/158)*(fwm+fgm)));
        edit1{i,Gluedit} = edit1{i,Gluedit} * (value_without_edit / (exp(-68/191)*(fwm+fgm)));
        edit1{i, Glnedit} = edit1{i,Glnedit} * (value_without_edit / (exp(-68/191)*(fwm+fgm)));
        edit1{i,gabaedit} = edit1{i,gabaedit} * (value_without_edit / (exp(-68/88)*(fwm+fgm)));
        edit1{i,Gshedit} = edit1{i,Gshedit} * (value_without_edit / (exp(-68/78)*(fwm+fgm)));
        edit1{i,Insedit} = edit1{i,Insedit} * (value_without_edit / (exp(-68/197)*(fwm+fgm)));
        edit1{i,Lacedit} = edit1{i,Lacedit} * (value_without_edit / (exp(-68/125)*(fwm+fgm)));
        edit1{i,NAAedit} = edit1{i,NAAedit} * (value_without_edit / (exp(-68/288)*(fwm+fgm)));
        edit1{i,NAAGedit} = edit1{i,NAAGedit} * (value_without_edit / (exp(-68/288)*(fwm+fgm)));
        edit1{i,Scylloedit} = edit1{i,Scylloedit} * (value_without_edit / (exp(-68/150)*(fwm+fgm)));

        for j=1:length(keepColNumbers_mega)
            mega1{i,keepColNumbers_mega(j)} = mega1{i,keepColNumbers_mega(j)} * value_without_mega;
        end

        for j=1:(keepColNumbers_edit)
            edit1{i, keepColNumbers_edit(j)} = edit1{i, keepColNumbers_edit(j)} * value_without_edit;
        end
end

for i=1:(length(csvFilelist)/2)

    ii=2*i;

    csv = fullfile(folder, csvFilelist{ii});
    data = readtable(csv);

    fwm = data.fWM(1);
    fgm = data.fGM(1);
    fcsf = data.fCSF(1);

    value_without_mega = ((36100*exp(-68/79.2)*(1-exp(-3200/832))*fwm)+ ...
                     (36100*exp(-68/110)*(1-exp(-3200/1331))*fgm) + ...
                     (36100*exp(-68/503)*(1-exp(-3200/3817))*fcsf)) / (35880*.43);

    value_without_edit = ((36100*exp(-68/79.2)*(1-exp(-3200/832))*fwm)+ ...
                     (36100*exp(-68/110)*(1-exp(-3200/1331))*fgm) + ...
                     (36100*exp(-68/503)*(1-exp(-3200/3817))*fcsf)) / (35880*.7);

        %MEGA-diff section 
        mega2{i,Aspmega} = mega2{i,Aspmega} * value_without_mega / (exp(-68/130)*(fwm+fgm));
        mega2{i,TChmega} = mega2{i,TChmega} * value_without_mega / (exp(-68/207)*(fwm+fgm));
        mega2{i,TCrmega} = mega2{i,TCrmega} * value_without_mega / (exp(-68/158)*(fwm+fgm));
        mega2{i,Glumega} = mega2{i,Glumega} * value_without_mega / (exp(-68/191)*(fwm+fgm));
        mega2{i, Glnmega} = mega2{i,Glnmega} * value_without_mega / (exp(-68/191)*(fwm+fgm));
        mega2{i,gabamega} = mega2{i,gabamega} * value_without_mega / (exp(-68/88)*(fwm+fgm));
        mega2{i,Gshmega} = mega2{i,Gshmega} * value_without_mega / (exp(-68/78)*(fwm+fgm));
        mega2{i,Insmega} = mega2{i,Insmega} * value_without_mega / (exp(-68/197)*(fwm+fgm));
        mega2{i,Lacmega} = mega2{i,Lacmega} * value_without_mega / (exp(-68/125)*(fwm+fgm));
        mega2{i,NAAmega} = mega2{i,NAAmega} * value_without_mega / (exp(-68/288)*(fwm+fgm));
        mega2{i,NAAGmega} = mega2{i,NAAGmega} * value_without_mega / (exp(-68/288)*(fwm+fgm));
        mega2{i,Scyllomega} = mega2{i,Scyllomega} * value_without_mega / (exp(-68/150)*(fwm+fgm));

        %MEGA-off section
        edit2{i,Aspedit} = edit2{i,Aspedit} * (value_without_edit / (exp(-68/130)*(fwm+fgm)));
        edit2{i,TChedit} = edit2{i,TChedit} * (value_without_edit / (exp(-68/207)*(fwm+fgm)));
        edit2{i,TCredit} = edit2{i,TCredit} * (value_without_edit / (exp(-68/158)*(fwm+fgm)));
        edit2{i,Gluedit} = edit2{i,Gluedit} * (value_without_edit / (exp(-68/191)*(fwm+fgm)));
        edit2{i, Glnedit} = edit2{i,Glnedit} * (value_without_edit / (exp(-68/191)*(fwm+fgm)));
        edit2{i,gabaedit} = edit2{i,gabaedit} * (value_without_edit / (exp(-68/88)*(fwm+fgm)));
        edit2{i,Gshedit} = edit2{i,Gshedit} * (value_without_edit / (exp(-68/78)*(fwm+fgm)));
        edit2{i,Insedit} = edit2{i,Insedit} * (value_without_edit / (exp(-68/197)*(fwm+fgm)));
        edit2{i,Lacedit} = edit2{i,Lacedit} * (value_without_edit / (exp(-68/125)*(fwm+fgm)));
        edit2{i,NAAedit} = edit2{i,NAAedit} * (value_without_edit / (exp(-68/288)*(fwm+fgm)));
        edit2{i,NAAGedit} = edit2{i,NAAGedit} * (value_without_edit / (exp(-68/288)*(fwm+fgm)));
        edit2{i,Scylloedit} = edit2{i,Scylloedit} * (value_without_edit / (exp(-68/150)*(fwm+fgm)));


        for j=1:length(keepColNumbers_mega)
            mega2{i,keepColNumbers_mega(j)} = mega2{i,keepColNumbers_mega(j)} * value_without_mega;
        end

        for j=1:(keepColNumbers_edit)
            edit2{i, keepColNumbers_edit(j)} = edit2{i, keepColNumbers_edit(j)} * value_without_edit;
        end
end


end




