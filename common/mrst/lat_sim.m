function Qw = lat_sim(WI,D,G,T,rock,fluid,w_loc,Pressure,r,t,order)
    
    dir_u = D{1};
    for d = 2:length(D)
        dir_u = horzcat(dir_u,D{d}(2:end));
    end
    dir = dir_u(order);

    W = addWell([], G, rock, w_loc, 'Type', 'bhp', ...
            'InnerProduct', 'ip_tpf','WI', WI, 'Sign', -1,'val', ...
            Pressure.well, 'Radius', r, 'Dir', dir, 'name', 'I');
    
    resSol = initState(G, W, Pressure.res);
    resSol.wellSol = initWellSol(W,Pressure.well);
    bc = pside([],G,'Front',Pressure.res);
    bc = pside(bc,G,'Right',Pressure.res);
    bc = pside(bc,G,'Back',Pressure.res);
    bc = pside(bc,G,'Left',Pressure.res);

    gravity off
    resSol = incompTPFA(resSol, G, T, fluid, 'bc', bc, 'wells', W);
    Qw = sum(resSol.wellSol.flux) * t;
end