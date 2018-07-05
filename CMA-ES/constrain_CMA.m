function x_r = constrain_CMA(x,z)
    x_r = x;
    for i = 1:length(x(:,1))
        % Make all later numbers positive
        x_r(i,2:5:end) = abs(x(i,2:5:end));
        % Set maximum length for laterals to 100
        lo_le = x(i,5:5:end) > 100;
        for l = 1:length(lo_le)
            if lo_le(l) == 1
                x_r(i,5*l) = 100;
            end
        end
        % Set maximum number of laterals
        lo_nl = x_r(i,2:5:end) > 4;
        for l = 1:length(lo_nl)
            if lo_nl(l) == 1
                x_r(i,2+(5*(l-1))) = 4;
            end
        end
        % Bound z values to reservoir
        lo_zl = x_r(i,1:5:end) < min(z) + 0.05*max(z);
        lo_zu = x_r(i,1:5:end) > max(z) - 0.05*max(z);
        for l = 1:length(lo_zl)
            if lo_zl(l) == 1
                x_r(i,1+(5*(l-1))) = min(z) + 0.075 * max(z);
            elseif lo_zu(l) == 1
                x_r(i,1+(5*(l-1))) = max(z) - 0.075 * max(z);
            end
        end
        
        for mem = 1:length(x(:,1))
            z_diff = abs(x_r(mem,1) - x_r(mem,6));
            if x_r(mem,1) < x_r(mem,6) && z_diff < 10
                x_r(mem,1) = x_r(mem,1) - 5;
                x_r(mem,6) = x_r(mem,6) + 5;
            elseif x_r(mem,1) > x_r(mem,6) && z_diff < 10
                x_r(mem,1) = x_r(mem,1) + 5;
                x_r(mem,6) = x_r(mem,6) - 5;
            end
        end
    end
end
