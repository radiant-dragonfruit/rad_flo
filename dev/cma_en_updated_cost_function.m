
clear
load('data/EnOpt.mat')
swp = S_hist{1};
j = 1;
for i = 1:50
    if norm(swp - S_hist{i}) ~= 0
        en_wpl{j} = swp;
        i_log(j) = i;
        swp = S_hist{i};
        j = j + 1;
    end
end
en_val = val(i_log);

load('data/CMA.mat')
j = 1;
swp = res(1,:);
for i = 1:50
    if norm(swp - res(i,:)) > 3.5
        cma_wpl{j,1} = swp;
        swp = res(i,:);
        j = j+1;
    end
end

%%
roots = [20 40 60 80];
j = 1;
for i = 1:50
    for m = 1:11
        En(j,1) = depth_factor(roots,O{i,1}(m,1:5:end));
        En(j,2) = round(O{i,1}(m,2))*O{i,1}(m,5) + round(O{i,1}(m,7))*O{i,1}(m,end);
        En(j,3) = O{i,2}(m);
        En(j,4) = round(O{i,1}(m,2));
        En(j,5) = round(O{i,1}(m,7));
        CMA(j,1) = depth_factor(roots,S_hist{i}(m,1:5:end));
        CMA(j,2) = round(S_hist{i}(m,2))*S_hist{i}(m,5) + round(S_hist{i}(m,7))*S_hist{i}(m,end);
        CMA(j,3) = J_values{i}(m);
        CMA(j,4) = round(S_hist{i}(m,2));
        CMA(j,5) = round(S_hist{i}(m,7));
        j = j + 1;
    end
end

[xi,yi] = meshgrid(-20:1.25:25,100:25:800);
v_en = griddata(En(:,1),En(:,2),En(:,3),xi,yi);
v_cma = griddata(CMA(:,1),CMA(:,2),CMA(:,3),xi,yi);

figure
hold on
grid on
scatter3(En(:,1),En(:,2),En(:,3))
scatter3(CMA(:,1),CMA(:,2),CMA(:,3))
surf(xi,yi,v_en)
surf(xi,yi,v_cma)
legend('EnOpt','CMA-ES')

%%

ex_en = En(En(:,2) > 450 & En(:,2)<=500,:);
ex_cma = CMA(CMA(:,2)>450 & CMA(:,2)<=500,:);
ex_en(ex_en(:,4) == 5,:) = NaN;
%%

figure
hold on
grid on
scatter3(ex_en(:,1),ex_en(:,4),ex_en(:,3))
scatter3(ex_cma(:,1),ex_cma(:,4),ex_cma(:,3))


