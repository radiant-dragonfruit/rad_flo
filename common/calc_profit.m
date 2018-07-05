function [profit,Wv] = calc_profit(s,case_name,dayrate,T_res,T_sc,gas_cost)

    Wv = read_prt(case_name);
    P = Wv * 1e3 * 4.19 * (T_res - T_sc) / (365*24);
    rev = P * gas_cost;

    n_lats = sum(round(s(:,2)));

    drilling_cost = n_lats/2.2 * dayrate;

    profit = rev - drilling_cost;

end