function [region, edit_off] = phase_correction(struct_off, struct_on)

freq = struct_off.ppm;
spec_off = struct_off.specs;
spec_on = struct_on.specs;

f = figure('Name', 'Manual Phase Correction Tool', ...
    'Position', [100,100,850,850], ...
    'MenuBar','none', 'ToolBar','none', ...
    'Units','pixels');

phi_off = 0;
phi_on = 0;

y_off = real(spec_off .* exp(-1i *phi_off));
y_on = real(spec_on .* exp(-1i * phi_on));
y_diff = y_on - y_off;



ax1 = axes('Parent', f, 'Units', 'pixels', 'Position', [90, 600, 750, 180]);
ax2 = axes('Parent', f, 'Units', 'pixels', 'Position', [90, 400, 750, 180]);
ax3 = axes('Parent', f, 'Units', 'pixels', 'Position', [90, 180, 750, 180]);



%Plots
p1 = plot(ax1, freq, y_off, 'LineWidth', 1.2, 'Color', '#0072BD');
title(ax1, 'Edit-OFF Spectrum')
set(ax1, 'Xdir', 'reverse');
grid(ax1, 'on');

p2 = plot(ax2, freq, y_on, 'LineWidth', 1.2, 'Color', '#D95319');
title(ax2, 'Edit-ON Spectrum')
set(ax2, 'Xdir', 'reverse');
grid(ax2, 'on');

p3 = plot(ax3, freq, y_diff, 'LineWidth', 1.2, 'Color', '#7E2F8E');
title(ax3, 'Difference Spectrum')
set(ax3, 'Xdir', 'reverse');
xlabel(ax3, 'Chemical Shift');
grid(ax3, 'on');

target_range = [0,5];
xlim(ax1, target_range);
xlim(ax2, target_range);
xlim(ax3, target_range);

%Panel 
bg_panel = uipanel('Parent', f, 'Units', 'pixels', 'Position', [15,15,870,130], 'Title' , 'Phase Control');

%Sliders 

uicontrol('Parent', bg_panel, 'Style', 'text', 'Position', [30 88 110 20], 'String', 'Phase OFF (deg):', ...
    'HorizontalAlignment', 'right', 'FontWeight', 'bold');

sld_off = uicontrol('Parent', bg_panel, 'Style', 'slider', 'Min', -180, 'Max', 180, 'Value', 0, ...
    'Position', [150 90 500 20], 'Callback', @update_plot);

uicontrol('Parent', bg_panel, 'Style', 'text', 'Position', [30 58 110 20], 'String', 'Phase OFF (deg):', ...
    'HorizontalAlignment', 'right', 'FontWeight', 'bold');

sld_on = uicontrol('Parent', bg_panel, 'Style', 'slider', 'Min', -180, 'Max', 180, 'Value', 0, ...
    'Position', [150 60 500 20], 'Callback', @update_plot);

uicontrol('Style', 'pushbutton', 'String', 'Save Output & Close', ...
    'Position', [325 15 150 35], 'FontWeight','bold', ...
    'BackgroundColor', '#77AC30', 'ForegroundColor', 'white', ...
    'Callback', @(src, event) uiresume(f));

uiwait(f)

if isvalid(f)
    deg_off = get(sld_off, 'Value');
    deg_on = get(sld_on, 'Value');
    
    phi_off_rad = deg_off * (pi/180);
    phi_on_rad = deg_on * (pi/180);

    phase_factor_off = exp(-1i * phi_off_rad);
    phase_factor_on = exp(-1i *phi_on_rad);

    edit_off = struct_off;
    edit_off.specs = struct_off.specs .* phase_factor_off;
    edit_off.fids = struct_off.fids .* phase_factor_off;

    edit_on = struct_on;
    edit_on.specs = struct_on.specs .* phase_factor_on;
    edit_on.fids = struct_on.fids .* phase_factor_on;
    
    together = op_concatSubspecs(edit_off, edit_on);

    region = op_combinesubspecs(together, 'summ');
    

    close(f);

else 
    disp('No work')

    region_1 = op_concatSubspecs(struct_on, struct_off);
    region = op_combinesubspecs(region_1, 'summ');

end

    function update_plot(~,~)

    if ~isvalid(p1) || ~isvalid(p2) || ~isvalid(p3)
    return;
    end
    
    
    deg_off = get(sld_off, 'Value');
    deg_on = get(sld_on, 'Value');
    
    phi_off_rad = deg_off * (pi/180);
    phi_on_rad = deg_on * (pi/180);

    new_off = real(spec_off .* exp(-1i * phi_off_rad));
    new_on = real(spec_on .* exp(-1i * phi_on_rad));
    
    set(p1, 'YData', new_off);
    set(p2, 'YData', new_on);
    set(p3, 'YData', new_on - new_off);
    
    title(ax1, sprintf('Edit-OFF Spectrum (phase: %.1f)', deg_off))
    title(ax2, sprintf('Edit-ON Spectrum (phase: %.1f)', deg_on))
    
    ylim(ax3, 'auto');
    end

end