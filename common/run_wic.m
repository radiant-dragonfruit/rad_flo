function run_wic(opt_ctrl,case_id)
    
    % Full path to wic tool exe
    wic_tool = string(horzcat(opt_ctrl.wic,'\wicalc.exe'));
    % Path to EGRID file fo current reservoir
    res_grid = string(horzcat(opt_ctrl.cse,'\',case_id,'.EGRID'));
    % Well parametrization file location
    par = string(horzcat(pwd,'\exp.dat'));
    % Location of output file
    out_file = string(horzcat(opt_ctrl.cse,'\results.dat'));
    
    wic_string = [wic_tool,'--grid',res_grid,'--well-filedef',par,'--debug','--compdat >',out_file];
    wic_cmd = sprintf('%s %s %s %s %s %s %s%s',wic_string);
    system(wic_cmd);
    while ~exist('debug_info.dat','file')                       % Wait till wictool has finished, check for debug_info.dat before continuing
        pause(30);
    end
end    
    
