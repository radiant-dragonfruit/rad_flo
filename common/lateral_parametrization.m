function par = lateral_parametrization(s,bb,z,d_bb,d_l,mode)

% Lateral parametrization step
% First, determine number of kick off points
% Then initizialize the export file
n_kicks = length(s(:,1));

if strcmp('file',mode) == 1
    formatSpec = '%s %f %f %f %f %f %f %f %f\n';
    filename = sprintf('%s','exp.dat');
    fid = fopen(filename,'w');
    for i = 0:n_kicks
        par_l{1} = 'WELL_1';
        par_l{4} = 0;
        % Parametrization of the backbone is kept constant
        if i == 0
            p_1 = [bb.x bb.y max(z)];
            p_2 = [bb.x bb.y min(z)];
            par_bb{1} = 'WELL_1';
            par_bb{2} = horzcat(p_1, p_2);
            par_bb{3} = d_bb;
            par_bb{4} = 0;
            fprintf(fid,formatSpec,par_bb{1,:});
        else
        % Parametrization of laterals
        % The "main" lateral is parametrized here
            s(i,2) = round(s(i,2));
            if abs(s(i,4)) > 30
                s(i,4) = sign(s(i,4)) * 30;
            elseif abs(s(i,4)) >= 15
                s(i,4) = sign(s(i,4)) * 30;
            else
                s(i,4) = 0;
            end
            n_lats = s(i,2);
            p_1 = [bb.x bb.y s(i,1)];
            a_rad = deg2rad(s(i,3));
            x_e = cos(a_rad) * s(i,5) + bb.x;
            y_e = sin(a_rad) * s(i,5) + bb.y;
            z_e = sin(deg2rad(s(i,4))) * s(i,5) + s(i,1);
            p_2 = [x_e y_e z_e];
            par_l{2} = horzcat(p_1,p_2);
            par_l{3} = d_l;
            fprintf(fid,formatSpec,par_l{1,:});
        % If the kick off point has more than one lateral, the rest are
        % parametrized here. The laterals are evenly spaced radially
            if n_lats > 1
                for l = 2:n_lats
                    rad_offset = deg2rad(360/n_lats);
                    a_rad = deg2rad(s(i,3)) + rad_offset * (l - 1);
                    p_1 = [bb.x bb.y s(i,1)];
                    x_e = cos(a_rad) * s(i,5) + bb.x;
                    y_e = sin(a_rad) * s(i,5) + bb.y;
                    z_e = sin(deg2rad(s(i,4))) * s(i,5) + s(i,1);
                    p_2 = [x_e y_e z_e];
                    par_l{2} = horzcat(p_1,p_2);
                    par_l{3} = d_l;
                    fprintf(fid,formatSpec,par_l{1,:});
                end
            end
        end
    end
    fclose(fid);
elseif strcmp('array',mode) == 1
    if sum(isnan(s(1,:))) > 0
        s(1,:) = [rand*max(z) 0 0 0 10];
    end
    if sum(isnan(s(2,:))) > 0
        s(2,:) = [rand*max(z) 0 0 0 10];
    end
    par = zeros(sum(round(s(:,2)))+1,7);
    ind = 1;
    for i = 0:n_kicks
        % Parametrization of the backbone is kept constant
        if i == 0
            p_1 = [bb(1) bb(2) min(z)];
            p_2 = [bb(1) bb(2) max(z)];
            par(ind,:) = horzcat(p_1, p_2,d_bb);
            ind = ind + 1;
        else
        % Parametrization of laterals
        % The "main" lateral is parametrized here
            s(i,2) = round(s(i,2));
            if abs(s(i,4)) > 30
                s(i,4) = sign(s(i,4)) * 30;
            elseif abs(s(i,4)) >= 15
                s(i,4) = sign(s(i,4)) * 30;
            else
                s(i,4) = 0;
            end
            n_lats = s(i,2);
            p_1 = [bb(1) bb(2) s(i,1)];
            a_rad = deg2rad(s(i,3));
            x_e = cos(a_rad) * s(i,5) + bb(1);
            y_e = sin(a_rad) * s(i,5) + bb(2);
            z_e = sin(deg2rad(s(i,4))) * s(i,5) + s(i,1);
            p_2 = [x_e y_e z_e];
            par(ind,:) = horzcat(p_1,p_2,d_l);
            ind = ind + 1;
        % If the kick off point has more than one lateral, the rest are
        % parametrized here. The laterals are evenly spaced radially
            if n_lats > 1
                for l = 2:n_lats
                    rad_offset = deg2rad(360/n_lats);
                    a_rad = deg2rad(s(i,3)) + rad_offset * (l - 1);
                    p_1 = [bb(1) bb(2) s(i,1)];
                    x_e = cos(a_rad) * s(i,5) + bb(1);
                    y_e = sin(a_rad) * s(i,5) + bb(2);
                    z_e = sin(deg2rad(s(i,4))) * s(i,5) + s(i,1);
                    p_2 = [x_e y_e z_e];
                    par(ind,:) = horzcat(p_1,p_2,d_l);
                    ind = ind +1;
                end
            end
        end
    end
end