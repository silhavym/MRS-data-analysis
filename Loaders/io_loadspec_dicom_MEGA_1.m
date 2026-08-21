% Pipeline for MEGAPRESS- takes one patient at a time 
% Goes through them in provided order 
% A is followed by B for PMDD study

function [region1, edit_OFF1, water1, ...
    region2, edit_OFF2, water2] =io_loadspec_dicom_MEGA_1(parentFolder)

% Seperates the files into different fields
group = groupFolders(parentFolder);

if isfield(group, 'PFC') && isfield(group, 'auditif')
    disp('Using PFC/auditif')
    data1 = group.PFC.ON;
    test1 = group.PFC.OFF;
    data2 = group.auditif.ON;
    test2 = group.auditif.OFF;
elseif isfield(group, 'DLPFC') && isfield(group, 'visual')
    disp('Using DLPFC/visual')
    data1 = group.DLPFC.ON;
    test1 = group.DLPFC.OFF;
    data2 = group.visual.ON;
    test2 = group.visual.OFF;
end

% Water OFF

water_1 = io_loadspec_dicom_siemens(fullfile(parentFolder, test1{1}));
water4 = op_averaging(water_1);
water4 = op_alignMPSubspecs(water4, 'i');
water1 = op_combinesubspecs(water4, 'diff');
water_2 = io_loadspec_dicom_siemens(fullfile(parentFolder, test2{1}));
water5 = op_averaging(water_2);
water5 = op_alignMPSubspecs(water5, 'i');
water2 = op_combinesubspecs(water5, 'diff');

% ConcatAvg of the Scans

reference1 = io_loadspec_dicom_siemens(fullfile(parentFolder, data1{1}));
for i = 2:numel(data1)
    loop = io_loadspec_dicom_siemens(fullfile(parentFolder, data1{i}));
    reference1 = op_concatAverages(reference1, loop);
end

set(0, 'DefaultFigureVisible', 'off')


com1_rm = op_rmbadaverages(reference1,3); 

avgAlignDomain ='f';
driftCorr = 'y';
sat = 'n';
out_rm2 = com1_rm;
rng('default')

while sat=='n' || sat =='N'
    iter = 0;
    iterin = 10;
    p = 100;
    fscum = zeros(size(out_rm2,2),1);
    phscum = zeros(size(out_rm2,2),1);

    while (abs(p(1))>0.0003 && iter<iterin)
        iter = iter+1;
        close all

        rng(5);

        tmax = 0.25 + 0.003*randn(1);
        ppmmin = 1.6 + 0.01*randn(1);
        ppmmaxarray=[3.5 + 0.01*randn(1,2), 4 + 0.01*randn(1,3), 5.5 + 0.01*randn(1,1)];
        ppmax=ppmmaxarray(randi(6,1));

        switch avgAlignDomain
            case 't'
                [out_aa, fs,phs] = op_alignAverages(out_rm2, tmax, 'n');
            case 'f'
                [out_aa, fs, phs] = op_alignAverages_fd(out_rm2, ppmmin, ppmax, tmax, 'n');
            otherwise 
                error('ERROR')
        end

        x_fit = (1:size(fs,1))'; 
        fs_fit = fs(:,1);
        p=polyfit(x_fit,fs_fit,1);
        fscum = fscum + fs_fit;
        phscum = phscum + phs(:,1);

        if driftCorr== 'y' || driftCorr=='Y'
            out_rm1=out_aa;
        end
    end
    sat= 'y';
end

set(0, 'DefaultFigureVisible', 'on')

com1_av = op_averaging(out_rm1);
com1_av = op_alignMPSubspecs(com1_av, 'i');
edit_OFF1 = op_takesubspec(com1_av, 1);
edit1_ON = op_takesubspec(com1_av, 2);

[region1, edit_OFF1] = phase_correction(edit_OFF1, edit1_ON);


reference2 = io_loadspec_dicom_siemens(fullfile(parentFolder, data2{1}));
for i = 2:numel(data2)
    loop = io_loadspec_dicom_siemens(fullfile(parentFolder, data2{i}));
    reference2 = op_concatAverages(reference2, loop);
end

set(0, 'DefaultFigureVisible', 'off')


com2_rm = op_rmbadaverages(reference2,3); 

avgAlignDomain ='f';
driftCorr = 'y';
sat = 'n';
out_rm2 = com2_rm;
rng('default')

while sat=='n' || sat =='N'
    iter = 0;
    iterin = 10;
    p = 100;
    fscum = zeros(size(out_rm2,2),1);
    phscum = zeros(size(out_rm2,2),1);

    while (abs(p(1))>0.0003 && iter<iterin)
        iter = iter+1;
        close all

        rng(5);

        tmax = 0.25 + 0.003*randn(1);
        ppmmin = 1.6 + 0.01*randn(1);
        ppmmaxarray=[3.5 + 0.01*randn(1,2), 4 + 0.01*randn(1,3), 5.5 + 0.01*randn(1,1)];
        ppmax=ppmmaxarray(randi(6,1));

        switch avgAlignDomain
            case 't'
                [out_aa, fs,phs] = op_alignAverages(out_rm2, tmax, 'n');
            case 'f'
                [out_aa, fs, phs] = op_alignAverages_fd(out_rm2, ppmmin, ppmax, tmax, 'n');
            otherwise 
                error('ERROR')
        end

        x_fit = (1:size(fs,1))'; 
        fs_fit = fs(:,1);
        p=polyfit(x_fit,fs_fit,1);
        fscum = fscum + fs_fit;
        phscum = phscum + phs(:,1);

        if driftCorr== 'y' || driftCorr=='Y'
            out_rm2=out_aa;
        end
    end
    sat= 'y';
end

set(0, 'DefaultFigureVisible', 'on')

com2_av = op_averaging(out_rm2);
com2_av = op_alignMPSubspecs(com2_av, 'i');
edit_OFF2 = op_takesubspec(com2_av, 1);
edit2_ON = op_takesubspec(com2_av, 2);

[region2, edit_OFF2] = phase_correction(edit_OFF2, edit2_ON);

end 