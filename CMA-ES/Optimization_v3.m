function [S_hist,J_values,m_hist,val] = Optimization_v3()

warning('off','all');
n_its = 20;
res_type = 'layers';
step = 7;
max_step = 12;
% Dimensions of the reservoir
%%
grid.x = [0 1000];
grid.y = [0 1000];
grid.z = [0 100];

grid.dx = 10;
grid.dy = 10;
grid.dz = 5;

grid.nx = max(grid.x)/grid.dx;
grid.ny = max(grid.y)/grid.dy;
grid.nz = (grid.z(2)-grid.z(1))/grid.dz;

T_res = 75;
T_sc = 20;
t = 365;
Pressure.res = 250e5;
Pressure.well = 200e5;
gas_cost = 0.0356;
dayrate = 20000;

K.hi = 1000;
K.lo = 10;
K.v = 50;
[K, por] = mrst_box(grid, K, res_type);
K_v(:,1) = reshape(K.Kh,grid.nx*grid.ny*grid.nz,1);
K_v(:,2) = K_v(:,1);
K_v(:,3) = reshape(K.Kv,grid.nx*grid.ny*grid.nz,1);
por_v = reshape(por,grid.nx*grid.ny*grid.nz,1);

G = cartGrid([grid.nx grid.ny grid.nz], [grid.x(2) grid.y(2) grid.z(2)]);
G = computeGeometry(G);
rock = makeRock(G,K_v*milli*darcy,por_v);
fluid = initSingleFluid('mu' ,1*centi*poise,'rho', 1014*kilogram/meter^3);
T = computeTrans(G, rock, 'Verbose', true);


% Location of backbone in the reservoir
% For the simplified model the backbone is placed in the center and
% penetrates the whole reservoir
bb.x = 1005;
bb.y = 1005;

% Diameter of the backbone and the laterals
% Backbone diameter is 5"
% Lateral diameter is 2"
d_bb = (5 * 2.54) / 100;
d_l = (2 * 2.54) /100;


J_values = cell(n_its,1);
S_hist = cell(n_its,1);
m = [20 2 0 0 100 50 2 0 0 100];

r = d_l/2;


sigma = [2 .4 0 0 .5];
p = sigma;
for i = 1:(length(m)/5)-1
    sigma = horzcat(sigma,p);
end
C = eye(length(m)) .* sigma.^2;

n = length(m);
p = zeros(1,n);

c = update_constants(n);
J = zeros(c.lambda,1);
p_sig = zeros(1,n);
Qw = zeros(c.lambda,1);
m_hist = cell(n_its,1);
J_i = -25000;
val = zeros(n_its,1);
%%
for i = 1:n_its
    disp(['*** Iteration ' num2str(i)])
    x = mvnrnd(m,step*C,c.lambda);
    x_c = constrain_CMA(x,grid);
    tic
    
    for mem = 1:14
        [I,D,s] = index_laterals_v3(x_c(mem,:),grid,bb,'det');
        disp(['** Simulating member ' num2str(mem) ' of ' num2str(c.lambda)]);
        disp(['- ' num2str(round(x_c(mem,1:5:end))) ' m'])
        disp(['- ' num2str(round(x_c(mem,2:5:end))) ' [-]'])
        Qw(mem) = lat_sim_v2(I,D,G,T,rock,fluid,Pressure,r,t);
        cma_val(mem) = calc_profit_mrst(s,Qw(mem),dayrate,T_res,T_sc,gas_cost);
        disp(['> € ' round(num2str(J(mem)))])
        disp(['> ' num2str(Qw(mem)) ' m^3'])
    end

    disp([num2str(toc) 's for all FEs'])
    J_values{i} = J;
    S_hist{i} = x_c;
    [J_s,ord_j] = sort(J,'descend');
    x_s = x_c(ord_j,:);
    y = (x_s(1:c.mu,:) - m) ./ step;
    y_w = y .* c.w_i';
    m_nu = m + step * (sum(y_w,1));
    [I,D,s] = index_laterals_v3(m_nu,grid,bb,'det');
    disp('** Evaluating new mean with controls')
    disp(['- ' num2str(m(1,1:5))])
    disp(['- ' num2str(m(1,6:end))])
    Qw = lat_sim_v2(I,D,G,T,rock,fluid,Pressure,r,t);
    J_n = calc_profit_mrst(s,Qw,dayrate,T_res,T_sc,gas_cost);
    disp(['> € ' round(num2str(J_n))])
    disp(['> ' num2str(Qw) ' m^3'])
    if J_n > J_i
        p_nu = (1-c.c_c)*p + sqrt(c.c_c*(2-c.c_c)*c.mu_eff)*(m_nu-m)/step;
        C_mu = zeros(n);
        for j = 1:c.mu
            C_mu = C_mu + c.w_i(j) * y(j,:) .* y(j,:)';
        end
        [B,D] = eig(C);
        p_sig_nu = (1-c.c_sig).*p_sig + (sqrt(c.c_sig*(2-c.c_sig)*c.mu_eff) * B*D^2*B' * ((m_nu - m)/step)')';
        step_nu = step * exp((c.c_sig/c.d_sig)*((norm(p_sig_nu)/c.Xi_n) - 1));
        C_nu = (1-c.c_cov)*C + (c.c_cov/c.mu_cov)*(p_nu.*p_nu') + c.c_cov*(1-1/c.mu_cov)*C_mu;
        C = nearestSPD(C_nu);
        step = step_nu;
        if step > max_step
            step = max_step;
        end
        p = p_nu; 
        p_sig = p_sig_nu;
        J_i = J_n;
        m = m_nu;
    end
    
    %{
    if sum(sum(round(x_s(1:round(c.mu/2),2:5:end)))) >= round(c.mu/2) * 4 * length(m)/5
        [C,m,n] = add_KOD_CMA(C,sigma,m);
        c = update_constants(n);
        p = horzcat(p,zeros(1,5));
        p_sig = horzcat(p_sig,zeros(1,5));
    end
    %}
    m_hist{i} = m;
    val(i) = J_i;
end


