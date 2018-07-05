function res_struct = extract_data(file,type)
    if strcmp(type,'En')
        load(file)
        res_struct.val = J_values;
        res_struct.res = S_hist;
        res_struct.g = g_hist;
        res_struct.O = O;
    elseif strcmp(type,'CMA')
        load(file)
        res_struct.J = J_values;
        res_struct.res = m_hist;
        res_struct.S = S_hist;
        res_struct.val = J;
    end
end