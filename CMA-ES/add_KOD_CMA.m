function [C_nu,m_nu,n_nu] = add_KOD_CMA(C,sigma,m)
    sig = sigma(1:5);
    sigma = horzcat(sigma,sig);
    n_nu = length(m) + 5;
    C_nu = eye(n_nu) .* sigma.^2;
    [i,j] = size(C);
    C_nu(1:i,1:j) = C;
    if rand(1) > 0.5
        new_lat = [m(1)+10 2 0 0 100];
    else
        new_lat = [m(6)-10 2 0 0 100];
    end
    m_nu = horzcat(m,new_lat);
end