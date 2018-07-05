
run('\\tsn.tno.nl\Data\Projects\060\1\11943\Kluis\10 Project Execution\10 WPs\WP7\Task7.6\Diederik\Matlab\mrst-2017b\startup.m')
mrstModule add incomp
%%

for i = 1:5
    [Se{i},Je{i},ge{i},O{i}] = Optimization_v2([15 2 0 0 100; 50 2 0 0 100]);
    [Se_h{i},Je_h{i},ge_h{i},O_h{i}] = Optimization_v2([15 3 0 0 100; 50 3 0 0 100]);
    [Se_u{i},Je_u{i},ge_u{i},O_u{i},z_reals{i},t_reals{i}] = Optimization_v25();
    [Sc{i},Jc{i},mc{i},val{i}] = Optimization_v3();
end

save('\\tsn.tno.nl\Data\Projects\060\1\11943\Kluis\10 Project Execution\10 WPs\WP7\Task7.6\Diederik\Matlab\Optimization\Data\comb_5_runs.mat')