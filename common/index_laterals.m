function [I,P,D] = index_laterals(par,grid,s)

% Index laterals that are not aligned to a grid
% returns the projections in i, j and k directions and the index of the
% blocks in which the lateral is present.

roots{1} = 0:grid.dx:max(grid.x);
roots{2} = 0:grid.dy:max(grid.y);
roots{3} = min(grid.z):grid.dz:max(grid.z);

tot_lats = sum(round(s(:,2)));

if isnan(tot_lats)
    tot_lats = 1;
end

I = cell(tot_lats+1,1);
P = cell(tot_lats+1,1);
D = cell(tot_lats+1,1);

lateral = 1;
n_kicks = length(s(:,1));
for l = 1:n_kicks + 1
    % The first run of the loop parametrizes the backbone
    if l == 1
        lat.loc = [par(l,1) par(l,4); par(l,2) par(l,5); par(l,3) par(l,6)];
        bb_sections = ((lat.loc(3,2) - lat.loc(3,1))/grid.dz) + 1;
        for i = 1:length(lat.loc)
            t_1 = roots{i} - lat.loc(i,1);
            t_2 = roots{i} - lat.loc(i,2);
            t_1(t_1>0) = NaN;
            t_2(t_2>0) = NaN;
            [~,lat.ind(i,1)] = max(t_1);
            [~,lat.ind(i,2)] = max(t_2);
        end
        I{lateral} = [ones(1,bb_sections) * lat.ind(1,1); ones(1,bb_sections) * lat.ind(2,1);...
            linspace(lat.ind(3,1),lat.ind(3,2),bb_sections)];
        P{lateral} = [zeros(1,bb_sections); zeros(1,bb_sections); ones(1,bb_sections) * grid.dz];
        D{lateral}(1:length(I{1})) = 'z';
        lateral = lateral + 1;
    % Subsequent loops parametrize the rest of the laterals in the kick-off
    % locations
    else
        n_lats = round(s(l-1,2));
        % If lateral length is less than zero, remove laterals from that
        % kick-off
        if s(l-1,5) <= 0
            n_lats = 0;
        end
        % If there are NaNs in the lateral controls, set number of laterals
        % to zero
        if sum(isnan(s(l-1,:))) > 0
            n_lats = 0;
            s(l-1,:) = [par(lateral,3) 0 0 0 1];
        end
        % If there is less than one lateral, add a dummy lateral of length
        % 10cm for that kick-off
        if n_lats < 1
            lat.loc = [par(lateral,1) par(lateral,1) + 0.1; par(lateral,2) par(lateral,5); par(lateral,3) par(lateral,6)];
            s(l-1,5) = 0.1;
            n_lats = n_lats + 1;
        end
        angles = 0:n_lats-1;
        offset = angles .* (360/n_lats);
        lat.loc = [par(lateral,1) par(lateral,4); par(lateral,2) par(lateral,5); par(lateral,3) par(lateral,6)];
        
        for j = 1:n_lats
            lat.alpha = s(l-1,3) + offset(j);
            lat.phi = s(l-1,4);
            lat.end = [cos(deg2rad(lat.alpha)) * s(l-1,5) + lat.loc(1,1)... 
                sin(deg2rad(lat.alpha)) * s(l-1,5) + lat.loc(2,1)...
                sin(deg2rad(lat.phi)) * s(l-1,5) + lat.loc(3,1)];
            for i = 1:length(lat.loc)
                t_1 = roots{i} - lat.loc(i,1);
                t_2 = roots{i} - lat.loc(i,2);
                t_1(t_1>0) = NaN;
                t_2(t_2>0) = NaN;
                [~,lat.ind(i,1)] = max(t_1);
                [~,lat.ind(i,2)] = max(t_2);
            end
            rem_length = s(l-1,5);
            step.x = roots{1}(lat.ind(1,1)+1) - lat.loc(1,1);
            step.y = roots{2}(lat.ind(2,1)+1) - lat.loc(2,1);
            step.z = roots{3}(lat.ind(3,1)+1) - lat.loc(3,1);
            a_rad = deg2rad(lat.alpha);
            i_rad = 0;
            ind = [lat.ind(1,1); lat.ind(2,1); lat.ind(3,1)];
            proj = zeros(3,1);
            k = 1;
            v = [cos(a_rad) sin(a_rad) sin(i_rad)];
            w = [lat.loc(1,1) lat.loc(2,1) lat.loc(3,1)];
            if abs(cos(a_rad)) >= sqrt(2)/2
                d = 'y';
            else
                d = 'x';
            end

            while rem_length > 0

                bounds(1,:) = [roots{1}(ind(1,k)) roots{1}(ind(1,k)+1)];
                bounds(2,:) = [roots{2}(ind(2,k)) roots{2}(ind(2,k)+1)];
                bounds(3,:) = [roots{3}(ind(3,k)) roots{3}(ind(3,k)+1)];

                t = min([max((bounds(1,:) - w(1))./v(1)), max((bounds(2,:) - w(2))./v(2)), max((bounds(3,:) - w(3))./v(3))]);
                w_n = w + t.*v;
                proj(:,k) = abs(w_n - w);
                section_length = norm(proj(:,k));
                dir(k) = d;

                if section_length < rem_length
                    rem_length = rem_length - section_length;
                    w = w_n;
                else
                    proj(:,k) = abs(lat.end' - w');
                    break
                end

                k = k + 1;

                for i = 1:3
                    if w(i) == bounds(i,1)
                        ind(i,k) = ind(i,k-1) - 1;
                    elseif w(i) == bounds(i,2)
                        ind(i,k) = ind(i,k-1) + 1;
                    else
                        ind(i,k) = ind(i,k-1);
                    end
                end
            end

            I{lateral} = ind;
            P{lateral} = proj;
            D{lateral} = dir;
            lateral = lateral + 1;
            clear dir
        end
    end       
end
end