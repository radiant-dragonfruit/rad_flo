function Qw = read_prt(case_name)

prt_data = fopen(case_name);
done = 0;
while done == 0
    line = fgetl(prt_data);
    if strfind(line,'Currently')
        v_c = line;
    elseif strfind(line,'Originally')
        v_i = line;
    elseif line == -1
        disp('done')
        break
    end
end

pos = strfind(v_c,':');
b = pos(3) + 1;
e = pos(4) - 1;

cur_str = v_c(b:e);
ini_str = v_i(b:e);
fclose(fid);
Qw = str2double(ini_str) - str2double(cur_str);


