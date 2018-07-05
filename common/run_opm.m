function run_opm(case_folder,case_id)
    b = 'bash -c ''flow ';
    e_1 = horzcat(case_folder,'\',case_id,'.DATA simulation.param''&');
    e_2 = strrep(e_1,'C:','\mnt\c');
    e_3 = strrep(e_2,'\','/');
    opm_cmd = horzcat(b,e_3);
    system(opm_cmd);
    exit_file = horzcat(pwd,'\walltime.txt');
    while ~exist(exit_file,'file')                         % Wait for OPM to perform entire simulation, walltime.txt is created upon completion
        pause(60);
    end
end