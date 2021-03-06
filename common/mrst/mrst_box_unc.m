function [K_re,por_re,z_reals,t_reals] = mrst_box_unc(grid,K_in,reals)
    K_re = cell(reals,1);
    por_re = cell(reals,1);
    roots = 0:5:95;
    z_init = [20 60];
    t_init = 20;
    t_reals = round(normrnd(t_init,5,[reals,2]));
    z_reals = horzcat(normrnd(z_init(1),5,[reals,1]),normrnd(z_init(2),5,[reals,1]));
    z_reals = round(z_reals);
    for i = 1:reals
        K_re{i} = ones(grid.nx,grid.ny,grid.nz) * K_in.lo;
        por_re{i} = ones(grid.nx,grid.ny,grid.nz) * .07;
        zb_1 = roots - z_reals(i,1);
        zb_2 = roots - z_reals(i,2);
        zt_1 = roots - (z_reals(i,1) + t_reals(i,1));
        zt_2 = roots - (z_reals(i,2) + t_reals(i,2));
        zb_1(zb_1>0) = NaN;
        zb_2(zb_2>0) = NaN;
        zt_1(zt_1>0) = NaN;
        zt_2(zt_2>0) = NaN;
        [~,ind_b(1,1)] = max(zb_1);
        [~,ind_b(1,2)] = max(zb_2);
        [~,ind_t(1,1)] = max(zt_1);
        [~,ind_t(1,2)] = max(zt_2);
        K_re{i}(:,:,ind_b(1):ind_t(1)) = K_in.hi;
        K_re{i}(:,:,ind_b(2):ind_t(2)) = K_in.hi;
        por_re{i}(:,:,ind_b(1):ind_t(1)) = .21;
        por_re{i}(:,:,ind_b(2):ind_t(2)) = .21;
    end
end