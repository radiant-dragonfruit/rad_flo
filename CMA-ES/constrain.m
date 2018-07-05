function new_lat = constrain(old_lat)
    n_kicks = length(old_lat(:,1));
    for i = 1:n_kicks
        z = old_lat(i,1);
        n = old_lat(i,2);
        az = old_lat(i,3);
        in = old_lat(i,4);
        l = old_lat(i,5);
        
        if z < 0
            z = 7.5;
        elseif z > 300
            z = 292.5;
        end
        if n < 0
            n = 0.1;
        elseif n > 4
            n = 4;
        end
        if l < 0
            l = 0.1;
        elseif l > 100
            l = 100;
        end
        if i == 1
            new_lat = [z n az in l];
        else
            new_lat = vertcat(new_lat,[z n az in l]);
        end
    end
end