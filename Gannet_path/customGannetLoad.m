function MRS_struct = customGannetLoad(metab, ref)

if nargin < 2 
    ref_files =[];
end

if ischar(metab) || isstring(metab)
    metab = {metab};
end

%--------------------------------------------------------------------------

MRS_struct.version.Gannet = 'Custom Loader';
MRS_struct.ii = 0;
MRS_struct.p.target = {'GABA'};
MRS_struct.p.Reference_suppression = 1;
MRS_struct.p.LB = 3;
MRS_struct.info.version.Gannet ={ '3.5.3' };
MRS_struct.info.version.load = '260312';

num_subjects = length(metab);

for ii = 1:num_subjects
    MRS_struct.ii = ii;
    current_folder = metab{ii};

    if ~exist(current_folder, 'dir')
        error('Not a valid directory');
    end
    
    all_items = dir(current_folder);
    file_path = {};
    for k=1:length(all_items)
        if ~all_items(k).isdir && ~startsWith(all_items(k).name, '.')
            file_path{end+1} = fullfile(current_folder, all_items(k).name);
        end
    end

    n_avg = length(file_path);
    if n_avg == 0
        error('No data files found inside')
    end


    for i =1: length(file_path)
        info = dicominfo(file_path{i});
        infos{i} = info;
    end


    
    if isfield(infos{1}, 'SpectroscopyData')

        fprintf('Detected XA-style spectroscopy DICOM.\n');

        % Get the CSA information directly from the dicom file (not from dicomInfo)
        phoenixTxt = extractPhoenixFromDicomFile(file_path{ii});

        % ---------- read data ----------
        % NOW VE11 / E11 FORMAT
    elseif isfield(infos{1}, 'Private_7fe1_1010')

        fprintf('Detected VE11/E11 private CSA spectroscopy DICOM.\n');

        % Read CSA header 
        phoenixTxt = extractPhoenixfromDicomInfo(infos{ii});

    end

    n_points = safe_num(parse_csa_numeric(phoenixTxt, 'sSpecPara.lVectorSize'), 2048);
    sw_val = safe_num(parse_csa_numeric(phoenixTxt, 'sSpecPara.dSweepWidth'), 1200);

    
    MRS_struct.p.npoints(ii) = n_points;
    MRS_struct.p.sw(ii) = sw_val;

    MRS_struct.p.TE(ii) = safe_num((getPhoenixValue(phoenixTxt, 'alTE[0]', true) / 1000),68);
    MRS_struct.p.TR(ii) = safe_num((getPhoenixValue(phoenixTxt, 'alTR[0]', true) / 1000),2);
    MRS_struct.p.n_averages(ii) = getPhoenixValue(phoenixTxt, 'sSpecPara.lVectorSize', true);
    MRS_struct.p.SequenceFilename{ii} = getPhoenixValue(phoenixTxt, 'tSequenceFileName',false);
    MRS_struct.p.npoints(ii) = n_points;
    MRS_struct.p.LarmorFreq(ii) = safe_num(parse_csa_numeric(phoenixTxt, 'sMagneticFieldMR.dImagingFrequency'), 123.2471);

    %Voxel Rotation & Normal Vectors
    MRS_struct.p.VoI_InPlaneRot(ii) = safe_num(getPhoenixValue(phoenixTxt, 'sSpecPara.sVoI.dInPlaneRot', true), 0);
    MRS_struct.p.NormCor(ii) =       safe_num(getPhoenixValue(phoenixTxt, 'sSpecPara.sVoI.sNormal.dCor', true), 0);
    MRS_struct.p.NormSag(ii) =        safe_num(getPhoenixValue(phoenixTxt, 'sSpecPara.sVoI.sNormal.dSag', true), 0);
    MRS_struct.p.NormTra(ii) =        safe_num(getPhoenixValue(phoenixTxt, 'sSpecPara.sVoI.sNormal.dTra', true), 0);

    thk = getPhoenixValue(phoenixTxt, 'sSpecPara.sVoI.dThickness', true);
    phf = getPhoenixValue(phoenixTxt, 'sSpecPara.sVoI.dPhaseFOV',true);
    rdf = getPhoenixValue(phoenixTxt, 'sSpecPara.sVoI.dReadoutFOV', true);
    MRS_struct.p.voxdim(ii,:) = [rdf, phf, thk];

    sag = safe_num(getPhoenixValue(phoenixTxt, 'sSpecPara.sVoI.sPosition.dSag', true), 0);
    cor = safe_num(getPhoenixValue(phoenixTxt, 'sSpecPara.sVoI.sPosition.dCor', true), 0);
    tra = safe_num(getPhoenixValue(phoenixTxt, 'sSpecPara.sVoI.sPosition.dTra', true), 0);
    MRS_struct.p.voxoff(ii,:) = [sag, cor, tra];

    MRS_struct.p.TablePosition(ii,:) = [0,0,0];
    MRS_struct.p.Siemens{ii} = 'Struct Info Parsed';
    MRS_struct.p.RFCoilCombination{ii} = 'Generalized least sqaures';

    zft_target = 39318;
    MRS_struct.p.ZeroFillTo(ii) = zft_target;
    MRS_struct.p.zf(ii) = zft_target / n_points ;
    MRS_struct.p.dt(ii) = 1 / sw_val ;
    MRS_struct.p.SpecRes(ii) = sw_val / n_points ;
    MRS_struct.p.SpecResNominal(ii) = sw_val / zft_target;
    MRS_struct.p.Tacq(ii) = n_points / sw_val;
    MRS_struct.p.weighted_averaging_method{ii} = 'MSE';
    MRS_struct.p.HERMES = 0;
    MRS_struct.p.PRIAM = 0;
    MRS_struct.p.HERCULES = 0;
    MRS_struct.p.vox= {'vox1'};
    MRS_struct.p.bids = 0;
    MRS_struct.p.numScans = 1;
    MRS_struct.p.vendor = 'Siemens_dicom';
    MRS_struct.p.hide = 1;
    MRS_struct.p.append = 0;
    MRS_struct.p.mat = 0;
    MRS_struct.p.reference = 'Cr';
    MRS_struct.p.normalize = 0;
    MRS_struct.p.csv = 1;
    MRS_struct.p.AlignmentTechnique = 'SpecReg';



    raw_fids = zeros(n_points, n_avg);
    for idx = 1:n_avg  
            x = dicominfo(file_path{idx});
            
            if isfield(x, 'Private_7fe1_1010')
                raw_payload = x.Private_7fe1_1010;
                tmp = typecast(raw_payload, 'single');
                data = double(tmp(1:2:end)) - 1i*double(tmp(2:2:end));
                data = data(:);
                raw_fids(:, idx) = data;
            elseif isfield(x, 'SpectroscopyData')
                raw_payload = x.SpectroscopyData;
                data = double(raw_payload);
                data = data(1:2:end) + 1i*data(2:2:end);
                data = data(:);
                raw_fids(:, idx) = data;
            else
                error('No spectroscopy data')
            end      
    end

    MRS_struct.metabfile{ii} = current_folder;
    MRS_struct.fids.data= raw_fids;
    MRS_struct.fids.ON_OFF = repmat([1 0], 1, n_avg/2);

    dt_step = 1/ sw_val;
    time_axis = (0:n_points -1)'* dt_step;
    lb_filter = exp(-pi * MRS_struct.p.LB * time_axis);
    filtered_fids = raw_fids .* repmat(lb_filter, 1, n_avg);
    unaligned_spectra = fftshift(fft(filtered_fids, [], 1), 1);

    aligned_fids = zeros(n_points, n_avg);
    ref_spec = unaligned_spectra(:,1);

    all_shifts_hz = zeros(1, n_avg);

    for idx = 1:n_avg
        current_spec = unaligned_spectra(:, idx);
        [corr_val, lags] = xcorr(abs(current_spec), abs(ref_spec));
        [~, max_idx] = max(corr_val);
        best_lag = lags(max_idx);
        freq_shift_hz = (best_lag / n_points) * sw_val;
        phase_offset = angle(current_spec' * ref_spec);

        all_shifts_hz(idx) = freq_shift_hz;

        aligned_fids(:, idx) = filtered_fids(:, idx) .* exp(1i *(2*pi* freq_shift_hz * time_axis + phase_offset));
    end
    aligned_spectra = fftshift(fft(aligned_fids, [], 1), 1);

    on_indices = 1:2:n_avg;
    off_indices = 2:2:n_avg;
    target_metab = MRS_struct.p.target{1};

    MRS_struct.spec.vox1.(target_metab).on(ii,:) = mean(aligned_spectra(:, on_indices),2).';
    MRS_struct.spec.vox1.(target_metab).off(ii,:) = mean(aligned_spectra(:, off_indices),2).';
    MRS_struct.spec.vox1.(target_metab).diff(ii,:) = MRS_struct.spec.vox1.(target_metab).on(ii,:) - MRS_struct.spec.vox1.(target_metab).off(ii,:);

    f_axis = ((-n_points/2):(n_points/2)-1) * (sw_val/n_points);
    ppm_axis = 4.68 + f_axis / MRS_struct.p.LarmorFreq(ii);
    MRS_struct.spec.freq = flip(ppm_axis);

    MRS_struct.out.SpectralRegistration.f(ii, :) = all_shifts_hz;
    MRS_struct.out.AvgDeltaF0(ii) = mean(all_shifts_hz);
end

%--------------------------Helper functions--------------------------------
    function txt = extractPhoenixfromDicomInfo(info)

    fields = fieldnames(info);
    txt = '';
    for f = 1:length(fields)
        fld = fields{f};
        try
            val = info.(fld);

            % Only inspect potentially useful private fields
            if contains(lower(fld),'private') || ...
                    contains(lower(fld),'csa')

                % Numeric arrays -> char
                if isnumeric(val) || islogical(val)
                    try
                    val = char(val');
                    catch
                        continue;
                    end
                end

                % Cell arrays
                if iscell(val)
                    continue;
                end

                % Convert to char safely
                val = char(val(:)');

                % Keep only fields containing protocol text
                if contains(val,'ASCCONV') || ...
                        contains(val,'alTE') || ...
                        contains(val,'tSequenceFileName')

                    txt = [txt val]; %#ok<AGROW>

                end
            end

        catch
        end
    end

    end

%% ---------------------------------------------------------------------

    function val = parse_csa_numeric(txt,pattern)

    val = [];

    expr = [pattern '.*?([-+]?[0-9]*\.?[0-9]+)'];

    tok = regexp(txt,expr,'tokens','once');

    if isempty(tok)
        return;
    end

    val = str2double(tok{1});

    end

%% ---------------------------------------------------------------------

    function txt = extractPhoenixFromDicomFile(fname)

    fid = fopen(fname,'r');

    raw = fread(fid,'uint8=>char')';

    fclose(fid);

    i1 = strfind(raw,'ASCCONV BEGIN');
    i2 = strfind(raw,'ASCCONV END');

    if isempty(i1) || isempty(i2)
        txt = '';
        return
    end

    txt = raw(i1(1):i2(1)+length('ASCCONV END'));

    end 

%% --------------------------------------------------------------------
    function value = getPhoenixValue(txt,param,isNumeric)

    value = [];

    % Find parameter
    idx = strfind(txt,param);

    if isempty(idx)
        return
    end

    idx = idx(1);

% Find '=' after parameter
    eqIdx = strfind(txt(idx:end),'=');

    if isempty(eqIdx)
        return
    end

    eqIdx = idx + eqIdx(1) - 1;

% Find next newline
    nlIdx = regexp(txt(eqIdx:end),'[\r\n]','once');

    if isempty(nlIdx)
        return
    end

    nlIdx = eqIdx + nlIdx - 2;

% Extract text between '=' and newline
    value = strtrim(txt(eqIdx+1:nlIdx));

    if isNumeric
    % Convert to numeric
        value = str2double(value);
    end

    end

    function out = safe_num(val, default)
        if isempty(val) || any(isnan(val))
            out = default;
        else
            out= val;
        end
    end

%% -----------------------------------------------------------------------

end
