function [c] = update_constants(n)
c.lambda = round(4 + 3*log(n));
c.mu = floor(c.lambda/2);
c.w_i = CMA_weight(c.mu);
c.mu_eff = sum(c.w_i.^2);
c.mu_cov = c.mu_eff;
c.c_sig = (c.mu_eff+2)/(n+c.mu_eff+3);
c.c_c = 4/(n+4);
c.c_cov = 2/(n+sqrt(2))^2;
c.d_sig = 1 + 2 * max([0 real(sqrt((c.mu_eff-1)/(n+1)))-1]) + c.c_sig;
c.Xi_n = sqrt(n)*(1-(1/(4*n))+(1/(21*n^2)));
end