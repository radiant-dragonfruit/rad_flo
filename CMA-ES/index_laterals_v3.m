function [I,D,s] = index_laterals_v3(x,grid,bb,ord)

roots{1} = 0:grid.dx:max(grid.x);
roots{2} = 0:grid.dy:max(grid.y);
roots{3} = min(grid.z):grid.dz:max(grid.z);

s = reshape(x(1,:)',[5 length(x)/5])';
t_x = roots{1} - bb.x;
t_x(t_x>0) = NaN;
[~,bb_x] = max(t_x);
t_y = roots{2} - bb.y;
t_y(t_y>0) = NaN;
[~,bb_y] = max(t_y);
I = cell(length(s(:,1)),1);
D = cell(length(s(:,1)),1);

for k = 1:length(s(:,1))
    dirs = ['n' 's' 'e' 'w'];
    ni_x = round(s(k,end)/grid.dx);
    ni_y = round(s(k,end)/grid.dy);
    n_lats = round(s(k,2));
    t_z = roots{3} - s(k,1);
    t_z(t_z>0) = NaN;
    [~,ind_z] = max(t_z);
    d = 1;
    if strcmp(ord,'det')
        while d <= n_lats
            switch dirs(d)
                case 'n'
                    i_x = bb_x;
                    i_y = linspace(bb_y+1,bb_y+ni_y,ni_y);
                    i_z = ind_z;
                    I{k}(d,:) = i_x + (i_y - 1) * grid.nx + (i_z - 1) * (grid.nx * grid.ny);
                    D{k}(d,1:ni_y) = 'y';
                case 'e'
                    i_x = linspace(bb_x+1,bb_y+ni_x,ni_x);
                    i_y = bb_y;
                    i_z = ind_z;
                    I{k}(d,:) = i_x + (i_y - 1) * grid.nx + (i_z - 1) * (grid.nx * grid.ny);
                    D{k}(d,1:ni_x) = 'x';
                case 's'
                    i_x = bb_x;
                    i_y = linspace(bb_y-1,bb_y-ni_y,ni_y);
                    i_z = ind_z;
                    I{k}(d,:) = i_x + (i_y - 1) * grid.nx + (i_z - 1) * (grid.nx * grid.ny);
                    D{k}(d,1:ni_y) = 'y';
                case 'w'
                    i_x = linspace(bb_x-1,bb_y-ni_x,ni_x);
                    i_y = bb_y;
                    i_z = ind_z;
                    I{k}(d,:) = i_x + (i_y - 1) * grid.nx + (i_z - 1) * (grid.nx * grid.ny);
                    D{k}(d,1:ni_x) = 'x';
            end
            d = d + 1;
        end
    elseif strcmp(ord,'ran')
        while d <= n_lats
            i_dir = randperm(numel(dirs),1);
            c_dir = dirs(i_dir);
            switch c_dir
                case 'n'
                    i_x = bb_x;
                    i_y = linspace(bb_y+1,bb_y+ni_y,ni_y);
                    i_z = ind_z;
                    I{k}(d,:) = i_x + (i_y - 1) * grid.nx + (i_z - 1) * (grid.nx * grid.ny);
                    D{k}(d,1:ni_y) = 'y';
                case 'e'
                    i_x = linspace(bb_x+1,bb_y+ni_x,ni_x);
                    i_y = bb_y;
                    i_z = ind_z;
                    I{k}(d,:) = i_x + (i_y - 1) * grid.nx + (i_z - 1) * (grid.nx * grid.ny);
                    D{k}(d,1:ni_x) = 'x';
                case 's'
                    i_x = bb_x;
                    i_y = linspace(bb_y-1,bb_y-ni_y,ni_y);
                    i_z = ind_z;
                    I{k}(d,:) = i_x + (i_y - 1) * grid.nx + (i_z - 1) * (grid.nx * grid.ny);
                    D{k}(d,1:ni_y) = 'y';
                case 'w'
                    i_x = linspace(bb_x-1,bb_y-ni_x,ni_x);
                    i_y = bb_y;
                    i_z = ind_z;
                    I{k}(d,:) = i_x + (i_y - 1) * grid.nx + (i_z - 1) * (grid.nx * grid.ny);
                    D{k}(d,1:ni_x) = 'x';
            end
            d = d + 1;
            dirs(i_dir) = [];
        end
    end
end
end


