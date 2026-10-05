% Pipeline for MEGAPRESS - ONE BRAIN REGION
% Uses groupFolders to organize the files.
%
% Example:
%
%   [region, edit_OFF, water] = ...
%       io_loadspec_dicom_MEGA_1region(parentFolder, 'PFC');
%
% Or, if there is only one region in parentFolder:
%
%   [region, edit_OFF, water] = ...
%       io_loadspec_dicom_MEGA_1region(parentFolder);

function [region, edit_OFF, water] =  io_loadspec_dicom_MEGA_1region(parentFolder, regionName)


%% Group the files using the original groupFolders function

group = groupFolders(parentFolder);


%% Determine which region to use

if nargin < 2

    % No region specified.
    % Automatically use the only region available.

    regionFields = fieldnames(group);

    if numel(regionFields) ~= 1
        error(['More than one brain region was found. ' ...
               'Please specify the region name as the second input, ' ...
               'e.g. io_loadspec_dicom_MEGA_1(parentFolder, ''PFC'').']);
    end

    regionName = regionFields{1};

end


%% Check that the requested region exists

if ~isfield(group, regionName)
    error('Region "%s" was not found in groupFolders output.', regionName);
end


%% Get the ON and OFF scans for this region

data = group.(regionName).ON;
test = group.(regionName).OFF;


if isempty(data)
    error('No ON scans found for region "%s".', regionName);
end

if isempty(test)
    error('No OFF scans found for region "%s".', regionName);
end


disp(['Using region: ' regionName]);


%% Water OFF

water_1 = io_loadspec_dicom_siemens( ...
    fullfile(parentFolder, test{1}));

water = op_averaging(water_1);

water = op_alignMPSubspecs(water, 'i');

water = op_combinesubspecs(water, 'diff');


%% Concatenate the ON scans

reference = io_loadspec_dicom_siemens( ...
    fullfile(parentFolder, data{1}));

for i = 2:numel(data)

    loop = io_loadspec_dicom_siemens( ...
        fullfile(parentFolder, data{i}));

    reference = op_concatAverages(reference, loop);

end


%% Remove bad averages

set(0, 'DefaultFigureVisible', 'off');

com_rm = op_rmbadaverages(reference, 3);


%% Alignment / drift correction

avgAlignDomain = 'f';

driftCorr = 'y';

out_rm = com_rm;

rng('default');

sat = 'n';


while sat == 'n' || sat == 'N'

    iter = 0;
    iterin = 10;
    p = 100;

    fscum = zeros(size(out_rm, 2), 1);
    phscum = zeros(size(out_rm, 2), 1);


    while (abs(p(1)) > 0.0003 && iter < iterin)

        iter = iter + 1;

        close all;

        rng(5);

        tmax = 0.25 + 0.003 * randn(1);

        ppmmin = 1.6 + 0.01 * randn(1);

        ppmmaxarray = [ ...
            3.5 + 0.01 * randn(1,2), ...
            4   + 0.01 * randn(1,3), ...
            5.5 + 0.01 * randn(1,1)];

        ppmax = ppmmaxarray(randi(6,1));


        switch avgAlignDomain

            case 't'

                [out_aa, fs, phs] = ...
                    op_alignAverages(out_rm, tmax, 'n');


            case 'f'

                [out_aa, fs, phs] = ...
                    op_alignAverages_fd( ...
                        out_rm, ppmmin, ppmax, tmax, 'n');


            otherwise

                error('ERROR')

        end


        %% Calculate frequency drift

        x_fit = (1:size(fs,1))';

        fs_fit = fs(:,1);

        p = polyfit(x_fit, fs_fit, 1);

        fscum = fscum + fs_fit;

        phscum = phscum + phs(:,1);


        %% Apply drift correction

        if driftCorr == 'y' || driftCorr == 'Y'
            out_rm = out_aa;
        end

    end

    sat = 'y';

end


%% Turn figures back on

set(0, 'DefaultFigureVisible', 'on');


%% Average aligned ON scans

com_av = op_averaging(out_rm);

com_av = op_alignMPSubspecs(com_av, 'i');


%% Take OFF and ON subspectra

edit_OFF = op_takesubspec(com_av, 1);

edit_ON = op_takesubspec(com_av, 2);


%% Phase correction

[region, edit_OFF] = phase_correction(edit_OFF, edit_ON);

end
