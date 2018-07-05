function Qw = lat_sim_v2(I,D,G,T,rock,fluid,Pressure,r,t)
   
empty_kod = 0;
for k = 1:length(I)
    if isempty(I{k}) == 0
        for l = 1:length(I{k}(:,1))
            w_loc = I{k}(l,:);
            dir = D{k}(l,:);
            l_id = [num2str(k) '.' num2str(l)];
            if exist('W') < 1 
                W = addWell([], G, rock, w_loc, 'Type', 'bhp', ...
                    'InnerProduct', 'ip_tpf','Sign',-1,'val', ...
                    Pressure.well, 'Radius', r, 'Dir', dir, 'name', l_id);
            else
                W = addWell(W, G, rock, w_loc, 'Type', 'bhp', ...
                    'InnerProduct', 'ip_tpf','Sign',-1,'val', ...
                    Pressure.well, 'Radius', r, 'Dir', dir, 'name', l_id);
            end
        end
    else
        empty_kod = empty_kod + 1;
    end
end

    if empty_kod == length(I)
        Qw = 0;
    else
        resSol = initState(G, W, Pressure.res);
        resSol.wellSol = initWellSol(W,Pressure.well);
        bc = pside([],G,'Front',Pressure.res);
        bc = pside(bc,G,'Right',Pressure.res);
        bc = pside(bc,G,'Back',Pressure.res);
        bc = pside(bc,G,'Left',Pressure.res);

        gravity off
        resSol = incompTPFA(resSol, G, T, fluid, 'bc', bc, 'wells', W);
        Qw = 0;
        for q = 1:length(resSol.wellSol(1,:))
            Qw = Qw + sum(resSol.wellSol(q).flux) * t;
        end
    end
end