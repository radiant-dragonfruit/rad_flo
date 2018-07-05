function [res] = Optimization_v4(opt_ctrl,res_ctrl,m_init)

% Location of backbone in the reservoir
% For the simplified model the backbone is placed in the center and
% penetrates the whole reservoir
bb.x = 500;
bb.y = 500;

% Diameter of the backbone and the laterals
% Backbone diameter is 5"
% Lateral diameter is 2"
d_bb = (5.5 * 2.54) / 100;
d_l = (2 * 2.54) /100;

J_values = cell(opt_ctrl.n_its,1);
S_hist = cell(opt_ctrl.n_its,1);
m = m_init;
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
m_hist = cell(opt_ctrl.n_its,1);
J_i = -25000;
val = zeros(opt_ctrl.n_its,1);
step = opt_ctrl.i_step;
V = zeros(c.lambda,1);
%%
for i = 1:opt_ctrl.n_its
    % Create population with point picked from multivariate distribution
    x = mvnrnd(m,step*C,c.lambda);
    x_c = constrain_CMA(x,res_ctrl.z);
    tic
    % Simulate individual members
    for mem = 1:c.lambda
        s = reshape(x(mem,:),[5 2])';
        lateral_parametrization(s,bb,res_ctrl.z,d_bb,d_l,'file')    % Creates output file for WIC calculation
        run_wic(opt_ctrl,res_ctrl.cid);                             % Performs WIC calculation, results.dat is created in apropriate caselib folder
        run_opm(opt_ctrl.cse,res_ctrl.cid);                         % Run forward simulation using OPM flow
        [J(mem),V(mem)] = calc_profit(s,opt_ctrl.prt,res_ctrl.d_rate,res_ctrl.T_res,res_ctrl.T_sc,res_ctrl.g_cost);
        delete('debug_info.dat','walltime.txt');                    % Delete the files used to determine when wic and opm have finished running
    end
    
    % Rank solutions and compute new m vector
    J_values{i} = J;
    S_hist{i} = x_c;
    [~,ord_j] = sort(J,'descend');
    x_s = x_c(ord_j,:);
    y = (x_s(1:c.mu,:) - m) ./ step;
    y_w = y .* c.w_i';
    m_nu = m + step * (sum(y_w,1));
    
    % Parametrize new control vector and perform reservoir simulation
    lateral_parametrization(m_nu,bb,res_ctrl.z,d_bb,d_l,'file');
    run_wic(opt_ctrl,res_ctrl.cid);
    run_opm(opt_ctrl.cse,res_ctrl.cid);
    [J_n,~] = calc_profit(s,opt_ctrl.prt,res_ctrl.d_rate,res_ctrl.T_res,res_ctrl.T_sc,res_ctrl.g_cost);
    delete('debug_info.dat','walltime.txt');
    
   % If the objective function for m_nu is higher than the previous step,
   % update all required values for the CMA-ES algorithm
   % If there is no increase, repeat with current settings to find
   % (hopefully) find some higher values.
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
    res = m;
end


