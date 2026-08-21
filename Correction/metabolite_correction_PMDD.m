function [mega1A, mega2A, edit1A, edit2A,mega1B, mega2B, edit1B, edit2B] =metabolite_correction_PMDD(data, folder)

filePattern = fullfile(folder, '*.csv');
csvDir = dir(filePattern);
csvFilelist = {csvDir.name};

extractedNumbersCell = regexp(csvFilelist, '\d+', 'match', 'once');
numericArray = str2double(extractedNumbersCell);
[~, idx] = sort(numericArray, 'MissingPlacement','first');
csvFilelist = csvFilelist(idx);

load(data);

gabamega = find(strcmp(mega1A.Properties.VariableNames, 'GABA'));
gabaedit = find(strcmp(edit1A.Properties.VariableNames, 'GABA'));
Aspmega = find(strcmp(mega1A.Properties.VariableNames, 'Asp'));
Aspedit = find(strcmp(edit1A.Properties.VariableNames, 'Asp'));
TChmega = find(strcmp(mega1A.Properties.VariableNames, 'TCh'));
TChedit = find(strcmp(edit1A.Properties.VariableNames, 'TCH'));
TCrmega = find(strcmp(mega1A.Properties.VariableNames, 'TCr'));
TCredit = find(strcmp(edit1A.Properties.VariableNames, 'TCr'));
Glumega = find(strcmp(mega1A.Properties.VariableNames, 'Glu'));
Gluedit = find(strcmp(edit1A.Properties.VariableNames, 'Glu'));
Glnmega = find(strcmp(mega1A.Properties.VariableNames, 'Gln'));
Glnedit = find(strcmp(edit1A.Properties.VariableNames, 'Gln'));
Gshmega = find(strcmp(mega1A.Properties.VariableNames, 'GSH'));
Gshedit = find(strcmp(edit1A.Properties.VariableNames, 'GSH'));
Insmega = find(strcmp(mega1A.Properties.VariableNames, 'Ins'));
Insedit = find(strcmp(edit1A.Properties.VariableNames, 'Ins'));
Lacmega = find(strcmp(mega1A.Properties.VariableNames, 'Lac'));
Lacedit = find(strcmp(edit1A.Properties.VariableNames, 'Lac'));
NAAmega = find(strcmp(mega1A.Properties.VariableNames, 'NAA'));
NAAedit = find(strcmp(edit1A.Properties.VariableNames, 'NAA'));
NAAGmega = find(strcmp(mega1A.Properties.VariableNames, 'NAAG'));
NAAGedit = find(strcmp(edit1A.Properties.VariableNames, 'NAAG'));
Scyllomega = find(strcmp(mega1A.Properties.VariableNames, 'Scyllo'));
Scylloedit = find(strcmp(edit1A.Properties.VariableNames, 'Scyllo'));

metab = {'GABA', 'Asp', 'TCh', 'TCr', 'Glu', 'Gln', 'GSH', 'Ins', 'Lac', 'NAA', 'NAAG', 'Scyllo', 'Row', 'Col'};

allHeaders_mega = mega1A.Properties.VariableNames;
ismetab = ismember(allHeaders_mega, metab);
has_ = contains(allHeaders_mega, '_');
hasSD = contains(allHeaders_mega, 'SD', 'IgnoreCase', true);

excludeMask = ismetab | has_ | hasSD;
keepMask = ~excludeMask;
keepColNumbers_mega = find(keepMask);

allHeaders_edit = edit1A.Properties.VariableNames;
ismetab_edit = ismember(allHeaders_edit, metab);
has_edit = contains(allHeaders_edit, '_');
hasSD_edit = contains(allHeaders_edit, 'SD', 'IgnoreCase', true);

excludeMask_edit = ismetab_edit | has_edit | hasSD_edit;
keepMask_edit = ~excludeMask_edit;
keepColNumbers_edit = find(keepMask_edit);

for i=1:length(csvFilelist) 

    

    csv = fullfile(folder, csvFilelist{i});
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

    subj_idx = ceil(i/4)
    file_type = mod(i,4)


    if file_type ==1
        %MEGA-diff section 
       	display('1a')
       	fwm 
    	fgm 
    	fcsf
        mega1A{subj_idx,Aspmega} = mega1A{subj_idx,Aspmega} * (value_without_mega / (exp(-68/130)*(fwm+fgm)));
        mega1A{subj_idx,TChmega} = mega1A{subj_idx,TChmega} * (value_without_mega / (exp(-68/207)*(fwm+fgm)));
        mega1A{subj_idx,TCrmega} = mega1A{subj_idx,TCrmega} * (value_without_mega / (exp(-68/158)*(fwm+fgm)));
        mega1A{subj_idx,Glumega} = mega1A{subj_idx,Glumega} * (value_without_mega / (exp(-68/191)*(fwm+fgm)));
        mega1A{subj_idx, Glnmega} = mega1A{subj_idx,Glnmega} * (value_without_mega / (exp(-68/191)*(fwm+fgm)));
        mega1A{subj_idx,gabamega} = mega1A{subj_idx,gabamega} * (value_without_mega / (exp(-68/88)*(fwm+fgm)));
        mega1A{subj_idx,Gshmega} = mega1A{subj_idx,Gshmega} * (value_without_mega / (exp(-68/78)*(fwm+fgm)));
        mega1A{subj_idx,Insmega} = mega1A{subj_idx,Insmega} * (value_without_mega / (exp(-68/197)*(fwm+fgm)));
        mega1A{subj_idx,Lacmega} = mega1A{subj_idx,Lacmega} * (value_without_mega / (exp(-68/125)*(fwm+fgm)));
        mega1A{subj_idx,NAAmega} = mega1A{subj_idx,NAAmega} * (value_without_mega / (exp(-68/288)*(fwm+fgm)));
        mega1A{subj_idx,NAAGmega} = mega1A{subj_idx,NAAGmega} * (value_without_mega / (exp(-68/288)*(fwm+fgm)));
        mega1A{subj_idx,Scyllomega} = mega1A{subj_idx,Scyllomega} * (value_without_mega / (exp(-68/150)*(fwm+fgm)));

        %MEGA-off section
        edit1A{subj_idx,Aspedit} = edit1A{subj_idx,Aspedit} * (value_without_edit / (exp(-68/130)*(fwm+fgm)));
        edit1A{subj_idx,TChedit} = edit1A{subj_idx,TChedit} * (value_without_edit / (exp(-68/207)*(fwm+fgm)));
        edit1A{subj_idx,TCredit} = edit1A{subj_idx,TCredit} * (value_without_edit / (exp(-68/158)*(fwm+fgm)));
        edit1A{subj_idx,Gluedit} = edit1A{subj_idx,Gluedit} * (value_without_edit / (exp(-68/191)*(fwm+fgm)));
        edit1A{subj_idx, Glnedit} = edit1A{subj_idx,Glnedit} * (value_without_edit / (exp(-68/191)*(fwm+fgm)));
        edit1A{subj_idx,gabaedit} = edit1A{subj_idx,gabaedit} * (value_without_edit / (exp(-68/88)*(fwm+fgm)));
        edit1A{subj_idx,Gshedit} = edit1A{subj_idx,Gshedit} * (value_without_edit / (exp(-68/78)*(fwm+fgm)));
        edit1A{subj_idx,Insedit} = edit1A{subj_idx,Insedit} * (value_without_edit / (exp(-68/197)*(fwm+fgm)));
        edit1A{subj_idx,Lacedit} = edit1A{subj_idx,Lacedit} * (value_without_edit / (exp(-68/125)*(fwm+fgm)));
        edit1A{subj_idx,NAAedit} = edit1A{subj_idx,NAAedit} * (value_without_edit / (exp(-68/288)*(fwm+fgm)));
        edit1A{subj_idx,NAAGedit} = edit1A{subj_idx,NAAGedit} * (value_without_edit / (exp(-68/288)*(fwm+fgm)));
        edit1A{subj_idx,Scylloedit} = edit1A{subj_idx,Scylloedit} * (value_without_edit / (exp(-68/150)*(fwm+fgm)));


    elseif file_type == 2
        %MEGA-diff section 
       	display('2a')
       	fwm 
    	fgm
    	fcsf 
        mega2A{subj_idx,Aspmega} = mega2A{subj_idx,Aspmega} * (value_without_mega / (exp(-68/130)*(fwm+fgm)));
        mega2A{subj_idx,TChmega} = mega2A{subj_idx,TChmega} * (value_without_mega / (exp(-68/207)*(fwm+fgm)));
        mega2A{subj_idx,TCrmega} = mega2A{subj_idx,TCrmega} * (value_without_mega / (exp(-68/158)*(fwm+fgm)));
        mega2A{subj_idx,Glumega} = mega2A{subj_idx,Glumega} * (value_without_mega / (exp(-68/191)*(fwm+fgm)));
        mega2A{subj_idx, Glnmega} = mega2A{subj_idx,Glnmega} * (value_without_mega / (exp(-68/191)*(fwm+fgm)));
        mega2A{subj_idx,gabamega} = mega2A{subj_idx,gabamega} * (value_without_mega / (exp(-68/88)*(fwm+fgm)));
        mega2A{subj_idx,Gshmega} = mega2A{subj_idx,Gshmega} * (value_without_mega / (exp(-68/78)*(fwm+fgm)));
        mega2A{subj_idx,Insmega} = mega2A{subj_idx,Insmega} * (value_without_mega / (exp(-68/197)*(fwm+fgm)));
        mega2A{subj_idx,Lacmega} = mega2A{subj_idx,Lacmega} * (value_without_mega / (exp(-68/125)*(fwm+fgm)));
        mega2A{subj_idx,NAAmega} = mega2A{subj_idx,NAAmega} * (value_without_mega / (exp(-68/288)*(fwm+fgm)));
        mega2A{subj_idx,NAAGmega} = mega2A{subj_idx,NAAGmega} * (value_without_mega / (exp(-68/288)*(fwm+fgm)));
        mega2A{subj_idx,Scyllomega} = mega2A{subj_idx,Scyllomega} * (value_without_mega / (exp(-68/150)*(fwm+fgm)));

        %MEGA-off section
        edit2A{subj_idx,Aspedit} = edit2A{subj_idx,Aspedit} * (value_without_edit / (exp(-68/130)*(fwm+fgm)));
        edit2A{subj_idx,TChedit} = edit2A{subj_idx,TChedit} * (value_without_edit / (exp(-68/207)*(fwm+fgm)));
        edit2A{subj_idx,TCredit} = edit2A{subj_idx,TCredit} * (value_without_edit / (exp(-68/158)*(fwm+fgm)));
        edit2A{subj_idx,Gluedit} = edit2A{subj_idx,Gluedit} * (value_without_edit / (exp(-68/191)*(fwm+fgm)));
        edit2A{subj_idx, Glnedit} = edit2A{subj_idx,Glnedit} * (value_without_edit / (exp(-68/191)*(fwm+fgm)));
        edit2A{subj_idx,gabaedit} = edit2A{subj_idx,gabaedit} * (value_without_edit / (exp(-68/88)*(fwm+fgm)));
        edit2A{subj_idx,Gshedit} = edit2A{subj_idx,Gshedit} * (value_without_edit / (exp(-68/78)*(fwm+fgm)));
        edit2A{subj_idx,Insedit} = edit2A{subj_idx,Insedit} * (value_without_edit / (exp(-68/197)*(fwm+fgm)));
        edit2A{subj_idx,Lacedit} = edit2A{subj_idx,Lacedit} * (value_without_edit / (exp(-68/125)*(fwm+fgm)));
        edit2A{subj_idx,NAAedit} = edit2A{subj_idx,NAAedit} * (value_without_edit / (exp(-68/288)*(fwm+fgm)));
        edit2A{subj_idx,NAAGedit} = edit2A{subj_idx,NAAGedit} * (value_without_edit / (exp(-68/288)*(fwm+fgm)));
        edit2A{subj_idx,Scylloedit} = edit2A{subj_idx,Scylloedit} * (value_without_edit / (exp(-68/150)*(fwm+fgm)));


    elseif file_type == 3
        %MEGA-diff section 
       	display('1B')
       	fwm 
        fgm
    	fcsf 
        mega1B{subj_idx, Aspmega} = mega1B{subj_idx,Aspmega} * value_without_mega / (exp(-68/130)*(fwm+fgm));
        mega1B{subj_idx,TChmega} = mega1B{subj_idx,TChmega} * value_without_mega / (exp(-68/207)*(fwm+fgm));
        mega1B{subj_idx,TCrmega} = mega1B{subj_idx,TCrmega} * value_without_mega / (exp(-68/158)*(fwm+fgm));
        mega1B{subj_idx,Glumega} = mega1B{subj_idx,Glumega} * value_without_mega / (exp(-68/191)*(fwm+fgm));
        mega1B{subj_idx, Glnmega} = mega1B{subj_idx,Glnmega} * value_without_mega / (exp(-68/191)*(fwm+fgm));
        mega1B{subj_idx,gabamega} = mega1B{subj_idx,gabamega} * value_without_mega / (exp(-68/88)*(fwm+fgm));
        mega1B{subj_idx,Gshmega} = mega1B{subj_idx,Gshmega} * value_without_mega / (exp(-68/78)*(fwm+fgm));
        mega1B{subj_idx,Insmega} = mega1B{subj_idx,Insmega} * value_without_mega / (exp(-68/197)*(fwm+fgm));
        mega1B{subj_idx,Lacmega} = mega1B{subj_idx,Lacmega} * value_without_mega / (exp(-68/125)*(fwm+fgm));
        mega1B{subj_idx,NAAmega} = mega1B{subj_idx,NAAmega} * value_without_mega / (exp(-68/288)*(fwm+fgm));
        mega1B{subj_idx,NAAGmega} = mega1B{subj_idx,NAAGmega} * value_without_mega / (exp(-68/288)*(fwm+fgm));
        mega1B{subj_idx,Scyllomega} = mega1B{subj_idx,Scyllomega} * value_without_mega / (exp(-68/150)*(fwm+fgm));

        %MEGA-off section
        edit1B{subj_idx,Aspedit} = edit1B{subj_idx,Aspedit} * (value_without_edit / (exp(-68/130)*(fwm+fgm)));
        edit1B{subj_idx,TChedit} = edit1B{subj_idx,TChedit} * (value_without_edit / (exp(-68/207)*(fwm+fgm)));
        edit1B{subj_idx,TCredit} = edit1B{subj_idx,TCredit} * (value_without_edit / (exp(-68/158)*(fwm+fgm)));
        edit1B{subj_idx,Gluedit} = edit1B{subj_idx,Gluedit} * (value_without_edit / (exp(-68/191)*(fwm+fgm)));
        edit1B{subj_idx, Glnedit} = edit1B{subj_idx,Glnedit} * (value_without_edit / (exp(-68/191)*(fwm+fgm)));
        edit1B{subj_idx,gabaedit} = edit1B{subj_idx,gabaedit} * (value_without_edit / (exp(-68/88)*(fwm+fgm)));
        edit1B{subj_idx,Gshedit} = edit1B{subj_idx,Gshedit} * (value_without_edit / (exp(-68/78)*(fwm+fgm)));
        edit1B{subj_idx,Insedit} = edit1B{subj_idx,Insedit} * (value_without_edit / (exp(-68/197)*(fwm+fgm)));
        edit1B{subj_idx,Lacedit} = edit1B{subj_idx,Lacedit} * (value_without_edit / (exp(-68/125)*(fwm+fgm)));
        edit1B{subj_idx,NAAedit} = edit1B{subj_idx,NAAedit} * (value_without_edit / (exp(-68/288)*(fwm+fgm)));
        edit1B{subj_idx,NAAGedit} = edit1B{subj_idx,NAAGedit} * (value_without_edit / (exp(-68/288)*(fwm+fgm)));
        edit1B{subj_idx,Scylloedit} = edit1B{subj_idx,Scylloedit} * (value_without_edit / (exp(-68/150)*(fwm+fgm)));

    elseif file_type == 0
        %MEGA-diff section 
       	display('2b')
       	fwm
    	fgm 
    	fcsf
        mega2B{subj_idx,Aspmega} = mega2B{subj_idx,Aspmega} * value_without_mega / (exp(-68/130)*(fwm+fgm));
        mega2B{subj_idx,TChmega} = mega2B{subj_idx,TChmega} * value_without_mega / (exp(-68/207)*(fwm+fgm));
        mega2B{subj_idx,TCrmega} = mega2B{subj_idx,TCrmega} * value_without_mega / (exp(-68/158)*(fwm+fgm));
        mega2B{subj_idx,Glumega} = mega2B{subj_idx,Glumega} * value_without_mega / (exp(-68/191)*(fwm+fgm));
        mega2B{subj_idx, Glnmega} = mega2B{subj_idx,Glnmega} * value_without_mega / (exp(-68/191)*(fwm+fgm));
        mega2B{subj_idx,gabamega} = mega2B{subj_idx,gabamega} * value_without_mega / (exp(-68/88)*(fwm+fgm));
        mega2B{subj_idx,Gshmega} = mega2B{subj_idx,Gshmega} * value_without_mega / (exp(-68/78)*(fwm+fgm));
        mega2B{subj_idx,Insmega} = mega2B{subj_idx,Insmega} * value_without_mega / (exp(-68/197)*(fwm+fgm));
        mega2B{subj_idx,Lacmega} = mega2B{subj_idx,Lacmega} * value_without_mega / (exp(-68/125)*(fwm+fgm));
        mega2B{subj_idx,NAAmega} = mega2B{subj_idx,NAAmega} * value_without_mega / (exp(-68/288)*(fwm+fgm));
        mega2B{subj_idx,NAAGmega} = mega2B{subj_idx,NAAGmega} * value_without_mega / (exp(-68/288)*(fwm+fgm));
        mega2B{subj_idx,Scyllomega} = mega2B{subj_idx,Scyllomega} * value_without_mega / (exp(-68/150)*(fwm+fgm));

        %MEGA-off section
        edit2B{subj_idx,Aspedit} = edit2B{subj_idx,Aspedit} * (value_without_edit / (exp(-68/130)*(fwm+fgm)));
        edit2B{subj_idx,TChedit} = edit2B{subj_idx,TChedit} * (value_without_edit / (exp(-68/207)*(fwm+fgm)));
        edit2B{subj_idx,TCredit} = edit2B{subj_idx,TCredit} * (value_without_edit / (exp(-68/158)*(fwm+fgm)));
        edit2B{subj_idx,Gluedit} = edit2B{subj_idx,Gluedit} * (value_without_edit / (exp(-68/191)*(fwm+fgm)));
        edit2B{subj_idx, Glnedit} = edit2B{subj_idx,Glnedit} * (value_without_edit / (exp(-68/191)*(fwm+fgm)));
        edit2B{subj_idx,gabaedit} = edit2B{subj_idx,gabaedit} * (value_without_edit / (exp(-68/88)*(fwm+fgm)));
        edit2B{subj_idx,Gshedit} = edit2B{subj_idx, Gshedit} * (value_without_edit / (exp(-68/78)*(fwm+fgm)));
        edit2B{subj_idx,Insedit} = edit2B{subj_idx,Insedit} * (value_without_edit / (exp(-68/197)*(fwm+fgm)));
        edit2B{subj_idx,Lacedit} = edit2B{subj_idx,Lacedit} * (value_without_edit / (exp(-68/125)*(fwm+fgm)));
        edit2B{subj_idx,NAAedit} = edit2B{subj_idx,NAAedit} * (value_without_edit / (exp(-68/288)*(fwm+fgm)));
        edit2B{subj_idx,NAAGedit} = edit2B{subj_idx,NAAGedit} * (value_without_edit / (exp(-68/288)*(fwm+fgm)));
        edit2B{subj_idx,Scylloedit} = edit2B{subj_idx,Scylloedit} * (value_without_edit / (exp(-68/150)*(fwm+fgm)));

    end

end




   



