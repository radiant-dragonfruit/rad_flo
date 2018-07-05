function [K, por] = mrst_box(grid, K_in, type)

    offset = max(grid.x)/2 + 50;
    offset = offset/grid.dx;
    K.Kh = ones(grid.nx,grid.ny,grid.nz) * K_in.lo;
    K.Kv = ones(grid.nx,grid.ny,grid.nz) * K_in.v;
    por = ones(grid.nx,grid.ny,grid.nz) * 0.07;
    K.hi = K_in.hi;
    K.lo = K_in.lo;
    K.v = K_in.v;
    if strcmp(type,'half')
        K.Kh(offset:end,:,:) = K_in.hi;
        por(offset:end,:,:) = 0.2;
    elseif strcmp(type,'half_layers')
        z_secs = 0:grid.nz/5:grid.nz;
        K.Kh(offset:end,:,z_secs(2):z_secs(3)) = K_in.hi;
        K.Kh(offset:end,:,z_secs(4):z_secs(5)) = K_in.hi;
        por(offset:end,:,z_secs(2):z_secs(3)) = 0.2;
        por(offset:end,:,z_secs(4):z_secs(5)) = 0.2;
    elseif strcmp(type,'layers')
        K.Kh(:,:,5:8) = K_in.hi;
        K.Kh(:,:,12:16) = K_in.hi;
        por(:,:,5:8) = 0.21;
        por(:,:,12:16) = 0.21;
    end

end