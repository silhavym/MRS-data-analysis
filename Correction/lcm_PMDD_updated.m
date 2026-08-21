function lcm_PMDD_updated(A)

% region 1
for i=1:size(A,1)

% UPDATE PATH
path = '/zpool/data/matthew/Lcm_test';
cd(path)

    if mod(i,2) ~= 0
        filepath_1 = sprintf('%s/region1_megaA%s',path,char(A{i,7}));
        filepath_2 = sprintf('%s/region1_editoffA%s',path, char(A{i,7}));
        filepath_3 = sprintf('%s/region1_waterA%s',path, char(A{i,7}));

        io_writelcm(A{i,3}, filepath_3, 68);
        io_writelcm(A{i,2}, filepath_2, 68);
        io_writelcm(A{i,1}, filepath_1, 68);

        cmd_1 = sprintf('../tools/new_lcmctrl_sh/createLCMcontrol.sh ../tools/new_lcmctrl_sh/tmp_pt_MEGA_3T_diff.control region1_megaA%s region1_waterA%s', char(A{i,7}), char(A{i,7}));
        cmd_2 = sprintf('../tools/new_lcmctrl_sh/createLCMcontrol.sh ../tools/new_lcmctrl_sh/tmp_pt_MEGA_3T_off.control region1_editoffA%s region1_waterA%s', char(A{i,7}), char(A{i,7}));
        system(cmd_1)
        system(cmd_2)

        filepath_4 = sprintf('%s/region2_megaA%s',path, char(A{i,7}));
        filepath_5 = sprintf('%s/region2_editoffA%s', path, char(A{i,7}));
        filepath_6 = sprintf('%s/region2_waterA%s',path, char(A{i,7}));        

        io_writelcm(A{i,6}, filepath_6, 68);
        io_writelcm(A{i,5}, filepath_5, 68);
        io_writelcm(A{i,4}, filepath_4, 68);

        cmd_3 = sprintf('../tools/new_lcmctrl_sh/createLCMcontrol.sh ../tools/new_lcmctrl_sh/tmp_pt_MEGA_3T_diff.control region2_megaA%s region2_waterA%s', char(A{i,7}), char(A{i,7}));
        cmd_4 = sprintf('../tools/new_lcmctrl_sh/createLCMcontrol.sh ../tools/new_lcmctrl_sh/tmp_pt_MEGA_3T_off.control region2_editoffA%s region2_waterA%s', char(A{i,7}), char(A{i,7}));
        system(cmd_3)
        system(cmd_4)        

    elseif mod(i,2) == 0
        filepath_1 = sprintf('%s/region1_megaB%s',path, char(A{i,7}));
        filepath_2 = sprintf('%s/region1_editoffB%s',path, char(A{i,7}));
        filepath_3 = sprintf('%s/region1_waterB%s',path, char(A{i,7}));

        io_writelcm(A{i,3}, filepath_3, 68);
        io_writelcm(A{i,2}, filepath_2, 68);
        io_writelcm(A{i,1}, filepath_1, 68);

        cmd_1 = sprintf('../tools/new_lcmctrl_sh/createLCMcontrol.sh ../tools/new_lcmctrl_sh/tmp_pt_MEGA_3T_diff.control region1_megaB%s region1_waterB%s', char(A{i,7}), char(A{i,7}));
        cmd_2 = sprintf('../tools/new_lcmctrl_sh/createLCMcontrol.sh ../tools/new_lcmctrl_sh/tmp_pt_MEGA_3T_off.control region1_editoffB%s region1_waterB%s', char(A{i,7}), char(A{i,7}));
        system(cmd_1)
        system(cmd_2)

        filepath_4 = sprintf('%s/region2_megaB%s',path, char(A{i,7}));
        filepath_5 = sprintf('%s/region2_editoffB%s',path, char(A{i,7}));
        filepath_6 = sprintf('%s/region2_waterB%s',path, char(A{i,7}));        

        io_writelcm(A{i,6}, filepath_6, 68);
        io_writelcm(A{i,5}, filepath_5, 68);
        io_writelcm(A{i,4}, filepath_4, 68);

        cmd_3 = sprintf('../tools/new_lcmctrl_sh/createLCMcontrol.sh ../tools/new_lcmctrl_sh/tmp_pt_MEGA_3T_diff.control region2_megaB%s region2_waterB%s', char(A{i,7}), char(A{i,7}));
        cmd_4 = sprintf('../tools/new_lcmctrl_sh/createLCMcontrol.sh ../tools/new_lcmctrl_sh/tmp_pt_MEGA_3T_off.control region2_editoffB%s region2_waterB%s', char(A{i,7}),char(A{i,7}));
        system(cmd_3)
        system(cmd_4)  
    end

end

end


