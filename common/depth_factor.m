function [x] = depth_factor(roots,z)
    n = length(z);
    fz = zeros(n,1);
    f = zeros(n,4);
    for i = 1:n
        f(i,:) = roots - z(i);
    end
    s = sign(f);
    f = abs(f);
    
    for i = 1:n
        [~,ind] = min(f(i,:));
        if sum(s(i,1:2)) == 0 || sum(s(i,3:4))== 0
            fz(i) = f(i,ind) * -1;
        else
            fz(i) = f(i,ind);
        end
    end
    
    x = sum(fz);
end