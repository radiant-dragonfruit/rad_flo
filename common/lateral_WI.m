function [WI,w_loc,order] = lateral_WI(I,P,grid,K,d_l,d_bb)

    req.x = 0.28 * sqrt(sqrt(K.Kh./K.Kv)*grid.dz^2 + sqrt(K.Kh./K.Kv)*grid.dy^2) ./ ((K.Kh./K.Kv).^0.25 + (K.Kh./K.Kv).^0.25);
    req.y = 0.28 * sqrt(sqrt(K.Kh./K.Kv)*grid.dz^2 + sqrt(K.Kh./K.Kv)*grid.dx^2) ./ ((K.Kh./K.Kv).^0.25 + (K.Kh./K.Kv).^0.25);
    req.z = 0.28 * sqrt(sqrt(K.Kh./K.Kh)*grid.dx^2 + sqrt(K.Kh./K.Kh)*grid.dy^2) ./ ((K.Kh./K.Kh).^0.25 + (K.Kh./K.Kh).^0.25);
    WI_c = cell(length(I),1);
    
    for l = 1:length(I)
        for c = 1:length(I{l}(1,:))
            if l == 1
                i_x = I{l}(1,c);
                i_y = I{l}(2,c);
                i_z = I{l}(3,c);
                if c == length(I{l}(1,:))
                    break
                end
                WI_c{l}(1,c) = i_x + (i_y - 1) * grid.nx + (i_z - 1) * (grid.nx * grid.ny);
                WIx = (2*pi*sqrt(K.Kh(i_x,i_y,i_z)*K.Kv(i_x,i_y,i_z)) * P{l}(1,c)) / (log(req.x(i_x,i_y,i_z)/(d_bb/2)));
                WIy = (2*pi*sqrt(K.Kh(i_x,i_y,i_z)*K.Kv(i_x,i_y,i_z)) * P{l}(2,c)) / (log(req.y(i_x,i_y,i_z)/(d_bb/2)));
                WIz = (2*pi*sqrt(K.Kh(i_x,i_y,i_z)*K.Kh(i_x,i_y,i_z)) * P{l}(3,c)) / (log(req.z(i_x,i_y,i_z)/(d_bb/2)));
                WI_c{l}(2,c) = sqrt(WIx^2 + WIy^2 + WIz^2);
            else
                i_x = I{l}(1,c);
                i_y = I{l}(2,c);
                i_z = I{l}(3,c);
                WI_c{l}(1,c) = i_x + (i_y - 1) * grid.nx + (i_z - 1) * (grid.nx * grid.ny);
                WIx = (2*pi*sqrt(K.Kh(i_x,i_y,i_z)*K.Kv(i_x,i_y,i_z)) * P{l}(1,c)) / (log(req.x(i_x,i_y,i_z)/(d_l/2)));
                WIy = (2*pi*sqrt(K.Kh(i_x,i_y,i_z)*K.Kv(i_x,i_y,i_z)) * P{l}(2,c)) / (log(req.y(i_x,i_y,i_z)/(d_l/2)));
                WIz = (2*pi*sqrt(K.Kh(i_x,i_y,i_z)*K.Kh(i_x,i_y,i_z)) * P{l}(3,c)) / (log(req.z(i_x,i_y,i_z)/(d_l/2)));
                WI_c{l}(2,c) = sqrt(WIx^2 + WIy^2 + WIz^2);
            end
        end
    end
    
    WI_locs(1,:) = WI_c{1}(1,:);
    WI_locs(2,:) = WI_c{1}(2,:); 
    
    for l = 2:length(WI_c)
        connection = find(WI_c{1}(1,:) == WI_c{l}(1,1));
        WI_locs(2,connection) = WI_locs(2,connection) + WI_c{l}(2,1);
        WI_locs = horzcat(WI_locs,WI_c{l}(:,2:end));
    end
    w_loc = WI_locs(1,:);
    WI = WI_locs(2,:);
    
    [~,order] = sort(WI_locs(1,:));
    w_loc = sort(WI_locs(1,:));
    WI_u = WI_locs(2,:);
    WI = WI_u(order);
    
end