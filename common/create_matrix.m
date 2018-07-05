function M = create_matrix(input_s,type,data,roots)
    if isempty(roots)
        roots = [20 40 60 80];
    end
    if strcmp(type,'En')
        if strcmp(data,'all')
            M = zeros(20*9,3);
            for i = 1:length(input_s.O)
                for j = 1:length(input_s.O{i,1})
                    ind = j + 9*(i-1);
                    M(ind,1) = depth_factor(roots,input_s.O{i,1}{j,1}(:,1));
                    l_k1 = round(input_s.O{i,1}{j,1}(1,2)) * input_s.O{i,1}{j,1}(1,end);
                    l_k2 = round(input_s.O{i,1}{j,1}(2,2)) * input_s.O{i,1}{j,1}(2,end);
                    M(ind,2) = l_k1 + l_k2;
                    M(ind,3) = input_s.O{i,2}(j);
                end
            end
        elseif strcmp(data,'res')
            M = zeros(20,3);
            for i = 1:20
                if isempty(input_s.res{i})
                    M(i,1) = NaN;
                    M(i,2) = NaN;
                    M(i,3) = NaN;
                else
                    M(i,1) = depth_factor(roots,input_s.res{i}(:,1));
                    l_k1 = round(input_s.res{i}(1,2)) * input_s.res{i}(1,5);
                    l_k2 = round(input_s.res{i}(2,2)) * input_s.res{i}(2,end);
                    M(i,2) = l_k1 + l_k2;
                    M(i,3) = input_s.val(i);
                end
            end
        end
    elseif strcmp(type,'CMA')
        n = 20 * 11;
        if strcmp(data,'all')
            M = zeros(n,3);
            for i = 1:length(input_s.S)
                k = length(input_s.S{i,1}(:,1));
                for j = 1:k
                    ind = j + k*(i-1);
                    M(ind,1) = depth_factor(roots,input_s.S{i,1}(j,1:5:end));
                    M(ind,2) = round(input_s.S{i,1}(j,2)) * input_s.S{i,1}(j,5);
                    for l = 1:(length(input_s.S{i,1}(j,:))/5)-1
                        M(ind,2) = M(ind,2) + round(input_s.S{i,1}(j,2 + (l*5))) * input_s.S{i,1}(j,5+(l*5));
                    end
                    M(ind,3) = input_s.J{i,1}(j,1);
                end
            end
        elseif strcmp(data,'res')
            M = zeros(20,3);
            for i = 1:20
                M(i,1) = depth_factor(roots,input_s.res{i}(1,1:5:end));
                l_k1 = round(input_s.res{i}(1,2)) * input_s.res{i}(1,5);
                l_k2 = round(input_s.res{i}(1,7)) * input_s.res{i}(1,end);
                M(i,2) = l_k1 + l_k2;
                M(i,3) = input_s.val(i);
            end
        end
    end
end