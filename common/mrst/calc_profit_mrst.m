function profit = calc_profit_mrst(s,Qw,dayrate,T_res,T_sc,gas_cost)
    if Qw >= 0
        Qw = 0;
    end
    P = abs(Qw) * 1e5 * 4.19 * (T_res - T_sc) * 3600;
    rev = P * gas_cost;

   
    drilling_cost = (sum(round(s(:,2)))/2.2) * dayrate;

    profit = rev - drilling_cost;

end