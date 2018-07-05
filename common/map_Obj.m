
close all;
clear;
load('\\tsn.tno.nl\Data\Projects\060\1\11943\Kluis\10 Project Execution\10 WPs\WP7\Task7.6\Diederik\Matlab\Optimization\Data\comb_3_runs.mat')

%%

for r = 1:3
    for i = 1:20
        if r == 1 && i == 1
            for en = 1:9
                EN(en,1:2) = O{r}{i,1}{en}(:,1)';
                ENh(en,1:2) = O_h{r}{i,1}{en}(:,1)';
                EN(en,3) = round(O{r}{i,1}{en}(1,2)) * round(O{r}{i,1}{en}(1,5),-1) +...
                    round(O{r}{i,1}{en}(2,2)) * round(O{r}{i,1}{en}(2,5),-1);
                ENh(en,3) = round(O_h{r}{i,1}{en}(1,2)) * round(O_h{r}{i,1}{en}(1,5),-1) +...
                    round(O_h{r}{i,1}{en}(2,2)) * round(O_h{r}{i,1}{en}(2,5),-1);
            end
            EN(:,4) = O{r}{i,2};
            ENh(:,4) = O_h{r}{i,2};
            CMA(:,1) = Sc{r}{i}(:,1);
            CMA(:,2) = Sc{r}{i}(:,6);
            CMA(:,3) = round(Sc{r}{i}(:,2)) .* round(Sc{r}{i}(:,5),-1) ...
                + round(Sc{r}{i}(:,7)) .* round(Sc{r}{i}(:,end),-1);
            CMA(:,4) = Jc{r}{i};
        else
            for en = 1:9
                en_u(en,1:2) = O{r}{i,1}{en}(:,1)';
                enh_u(en,1:2) = O_h{r}{i,1}{en}(:,1)';
                en_u(en,3) = round(O{r}{i,1}{en}(1,2)) * round(O{r}{i,1}{en}(1,5),-1) +...
                    round(O{r}{i,1}{en}(2,2)) * round(O{r}{i,1}{en}(2,5),-1);
                enh_u(en,3) = round(O_h{r}{i,1}{en}(1,2)) * round(O_h{r}{i,1}{en}(1,5),-1) +...
                    round(O_h{r}{i,1}{en}(2,2)) * round(O_h{r}{i,1}{en}(2,5),-1);
            end
            en_u(:,4) = O{r}{i,2};
            enh_u(:,4) = O_h{r}{i,2};
            cma_u(:,1) = Sc{r}{i}(:,1);
            cma_u(:,2) = Sc{r}{i}(:,6);
            cma_u(:,3) = round(Sc{r}{i}(:,2)) .* round(Sc{r}{i}(:,5),-1) ...
                + round(Sc{r}{i}(:,7)) .* round(Sc{r}{i}(:,end),-1);
            cma_u(:,4) = Jc{r}{i};
            EN = vertcat(EN,en_u);
            ENh = vertcat(ENh,enh_u);
            CMA = vertcat(CMA,cma_u);
        end
    end
end
EN(:,3) = round(EN(:,3),-2);
ENh(:,3) = round(ENh(:,3),-2);
CMA(:,3) = round(CMA(:,3),2);
%%
ENc = cell(8,1);
ENhc = cell(8,1);
CMAc = cell(8,1);

for i = 0:7
    up = (i+1) * 100;
    lo = i * 100;
    ENc{i+1} = EN(EN(:,3)> lo & EN(:,3)<= up,:);
    ENhc{i+1} = ENh(ENh(:,3)> lo & ENh(:,3)<= up,:);
    CMAc{i+1} = CMA(CMA(:,3)> lo & CMA(:,3)<= up,:);
end

%%
close
figure
hold on
for l = 1:8
    c = rand(1,3);
    scatter3(ENc{l}(:,1),ENc{l}(:,2),ENc{l}(:,4),36,c)
    scatter3(ENhc{l}(:,1),ENhc{l}(:,2),ENhc{l}(:,4),36,c)
    scatter3(CMAc{l}(:,1),CMAc{l}(:,2),CMAc{l}(:,4),36,c)
end
xlabel('z1 [m]')
ylabel('z2 [m]')
legend('EnOpt','EnOpt extra laterals','CMA')
grid on

%%

[xi,yi] = meshgrid(0:100,0:100);
v_all = griddata(data(:,1),data(:,2),data(:,4),xi,yi);
mesh(xi,yi,v_all);








%%
%{
En1 = extract_data('EnOptSimple4.mat','En');
En2 = extract_data('EnOptSimple5.mat','En');
En3 = extract_data('EnOptSimple6.mat','En');
CMA1 = extract_data('CMASimple3.mat','CMA');
CMA2 = extract_data('CMASimple4.mat','CMA');
CMA3 = extract_data('CMASimple5.mat','CMA');

%%

En1_m = create_matrix(En1,'En','all');
En2_m = create_matrix(En2,'En','all');
En3_m = create_matrix(En3,'En','all');
CMA1_m = create_matrix(CMA1,'CMA','all');
CMA2_m = create_matrix(CMA2,'CMA','all');
CMA3_m = create_matrix(CMA3,'CMA','all');
En1_r = create_matrix(En1,'En','res');
En2_r = create_matrix(En2,'En','res');
En3_r = create_matrix(En3,'En','res');
CMA1_r = create_matrix(CMA1,'CMA','res');
CMA2_r = create_matrix(CMA2,'CMA','res');
CMA3_r = create_matrix(CMA3,'CMA','res');

data = vertcat(En1_m,En2_m,En3_m,CMA1_m,CMA2_m,CMA3_m);
%%
%}
roots = [20 40 60 80];
for r = 1:3
    roots_u = [z_reals{r}(:,1) z_reals{r}(:,1) + t_reals{r}(:,1) z_reals{r}(:,2) z_reals{r}(:,2) + t_reals{r}(:,2)]; 
    for i = 1:20
        en_z = zeros(9,1);
        enh_z = zeros(9,1);
        en_l = zeros(9,1);
        enh_l = zeros(9,1);
        enu_z = zeros(9,1);
        enu_l = zeros(9,1);
        cma_z = zeros(11,1);
        if r == 1 && i == 1
            for en = 1:9
                en_z(en) = depth_factor(roots,O{r}{i}{en}(:,1));
                enh_z(en) = depth_factor(roots,O_h{r}{i}{en}(:,1));
                en_l(en) = (round(O{r}{i}{en}(1,2)) * O{r}{i}{en}(1,5)) + (round(O{r}{i}{en}(2,2)) * O{r}{i}{en}(2,5));
                enh_l(en) = (round(O_h{r}{i}{en}(1,2)) * O_h{r}{i}{en}(1,5)) + (round(O_h{r}{i}{en}(2,2)) + O_h{r}{i}{en}(2,5));
                enu_z(en) = depth_factor(roots_u(en,:),O_u{r}{i}{en}(:,1));
                enu_l(en) = (round(O_u{r}{i}{en}(1,2)) * O_u{r}{i}{en}(1,5)) + (round(O_u{r}{i}{en}(2,2)) + O_u{r}{i}{en}(2,5));
            end
            for c = 1:11
                cma_z(c) = depth_factor(roots,Sc{r}{i}(c,1:5:end));
            end
            CMA(:,1) = cma_z;
            En(:,1) = en_z;
            Enh(:,1) = enh_z;
            Enu(:,1) = enu_z;
            En(:,2) = en_l;
            Enh(:,2) = enh_l;
            Enu(:,2) = enu_l;
            CMA(:,2) = round(Sc{r}{i}(:,2)) .* Sc{r}{i}(:,5)...
                + round(Sc{r}{i}(:,7) .* Sc{r}{i}(:,end));
            CMA(:,3) = Jc{r}{i};
            En(:,3) = O{r}{i,2};
            Enh(:,3) = O_h{r}{i,2};
            Enu(:,3) = O_u{r}{i,2};
        else
            n_empty = 0;
            for en = 1:9
                en_z(en) = depth_factor(roots,O{r}{i}{en}(:,1));
                enh_z(en) = depth_factor(roots,O_h{r}{i}{en}(:,1));
                en_l(en) = (round(O{r}{i}{en}(1,2)) * O{r}{i}{en}(1,5)) + (round(O{r}{i}{en}(2,2)) * O{r}{i}{en}(2,5));
                enh_l(en) = (round(O_h{r}{i}{en}(1,2)) * O_h{r}{i}{en}(1,5)) + (round(O_h{r}{i}{en}(2,2)) * O_h{r}{i}{en}(2,5));
                if ~isempty(O_u{r}{i}) == 1
                    enu_z(en) = depth_factor(roots_u(en,:),O_u{r}{i}{en}(:,1));
                    enu_l(en) = (round(O_u{r}{i}{en}(1,2)) * O_u{r}{i}{en}(1,5)) + (round(O_u{r}{i}{en}(2,2)) + O_u{r}{i}{en}(2,5));
                end
                
            end
            for c = 1:11
                cma_z(c) = depth_factor(roots,Sc{r}{i}(c,1:5:end));
            end
            Ent(:,1) = en_z;
            Ent(:,2) = en_l;
            Ent(:,3) = O{r}{i,2};
            Enht(:,1) = enh_z;
            Enht(:,2) = enh_l;
            Enht(:,3) = O_h{r}{i,2};
            Enut(:,1) = enu_z;
            Enut(:,2) = enu_l;
            if ~isempty(O_u{r}{i,2})
                Enut(:,3) = O_u{r}{i,2};
            else
                Enut(1:9,3) = NaN; 
            end
            CMAt(:,1) = cma_z;
            CMAt(:,2) = round(Sc{r}{i}(:,2)) .* Sc{r}{i}(:,5)...
                + round(Sc{r}{i}(:,7) .* Sc{r}{i}(:,end));
            CMAt(:,3) = Jc{r}{i};
            En = vertcat(En,Ent);
            Enh = vertcat(Enh,Enht);
            CMA = vertcat(CMA,CMAt);
            Enu = vertcat(Enu,Enut);
        end
    end
end

En1.val = Je{1};
En2.val = Je{2};
En3.val = Je{3};
En1.res = Se{1};
En2.res = Se{2};
En3.res = Se{3};

Enh1.val = Je_h{1};
Enh2.val = Je_h{2};
Enh3.val = Je_h{3};
Enh1.res = Se_h{1};
Enh2.res = Se_h{2};
Enh3.res = Se_h{3};

Enu1.val = Je_u{1};
Enu2.val = Je_u{2};
Enu3.val = Je_u{3};
Enu1.res = Se_u{1};
Enu2.res = Se_u{2};
Enu3.res = Se_u{3};

En1_r = create_matrix(En1,'En','res',[]);
En2_r = create_matrix(En2,'En','res',[]);
En3_r = create_matrix(En3,'En','res',[]);
Enh1_r = create_matrix(Enh1,'En','res',[]);
Enh2_r = create_matrix(Enh2,'En','res',[]);
Enh3_r = create_matrix(Enh3,'En','res',[]);
Enu1_r = create_matrix(Enu1,'En','res',[]);
Enu2_r = create_matrix(Enu2,'En','res',[]);
Enu3_r = create_matrix(Enu3,'En','res',[]);
%%

figure
hold on
grid minor
%scatter3(En(:,1),En(:,2),En(:,3),'o')
%scatter3(Enh(:,1),Enh(:,2),Enh(:,3),'d')
%scatter3(CMA(:,1),CMA(:,2),CMA(:,3),'s')
scatter3(Enu(:,1),Enu(:,2),Enu(:,3),'p')
xlabel('Combined distance to high K layers [m]')
ylabel('Total lateral length [m]')
%%

[xi,yi] = meshgrid(-20:2.5:25,0:25:800);
v_e = griddata(En(:,1),En(:,2),En(:,3),xi,yi);
v_eh = griddata(Enh(:,1),Enh(:,2),Enh(:,3),xi,yi);
v_eu = griddata(Enu(:,1),Enu(:,2),Enu(:,3),xi,yi);
v_cma = griddata(CMA(:,1),CMA(:,2),CMA(:,3),xi,yi);
%%
figure
hold on
grid minor
%surf(xi,yi,v_e)
%surf(xi,yi,v_eh)
%surf(xi,yi,v_cma)
surf(xi,yi,v_eu)
%%

%scatter3(data(:,1),data(:,2),data(:,3))


%tri = delaunay(data(:,1),data(:,2));
%trisurf(tri,data(:,1),data(:,2),data(:,3));

%sf = fit([data(:,1) data(:,2)],data(:,3),'poly25');
figure
%sf_plot = plot(sf);
hold on
grid on
%c1 = repmat([.7,.5,0],numel(En1_m),1);
%c2 = repmat([.2,.2,.7],numel(CMA1_m),1);
%{
scatter3(En1_m(:,1),En1_m(:,2),En1_m(:,3),'+','b')
scatter3(En2_m(:,1),En2_m(:,2),En2_m(:,3),'+','b')
scatter3(En3_m(:,1),En3_m(:,2),En3_m(:,3),'+','b')
scatter3(CMA1_m(:,1),CMA1_m(:,2),CMA1_m(:,3),'*','r')
scatter3(CMA2_m(:,1),CMA2_m(:,2),CMA2_m(:,3),'*','r')
scatter3(CMA3_m(:,1),CMA3_m(:,2),CMA3_m(:,3),'*','r')
%}
i_scl = (linspace(1,20,20)/20) .* 100;
scatter3(En1_r(:,1),En1_r(:,2),En1_r(:,3),i_scl,'b','s','filled')
scatter3(En2_r(:,1),En2_r(:,2),En2_r(:,3),i_scl,'r','s','filled')
scatter3(En3_r(:,1),En3_r(:,2),En3_r(:,3),i_scl,'g','s','filled')
scatter3(Enh1_r(:,1),Enh1_r(:,2),Enh1_r(:,3),i_scl,'b','d','filled')
scatter3(Enh2_r(:,1),Enh2_r(:,2),Enh2_r(:,3),i_scl,'r','d','filled')
scatter3(Enh3_r(:,1),Enh3_r(:,2),Enh3_r(:,3),i_scl,'g','d','filled')
scatter3(Enu1_r(:,1),Enu1_r(:,2),Enu1_r(:,3),i_scl,'b','p','filled')
scatter3(Enu2_r(:,1),Enu2_r(:,2),Enu2_r(:,3),i_scl,'r','p','filled')
scatter3(Enu3_r(:,1),Enu3_r(:,2),Enu3_r(:,3),i_scl,'g','p','filled')
%scatter3(15,400,-15000,'k','filled')

xlabel('Combined distance to high K layers [m]')
ylabel('Total lateral length [m]')
%set(sf_plot,'FaceAlpha', .7)
%%
close
figure
hold on
x = data(:,1);
y = data(:,2);
v = data(:,3);
[xq,yq] = meshgrid(-25:25,0:800);
vq = griddata(x,y,v,xq,yq,'natural');
jsurf = surf(xq,yq,vq);
set(jsurf,'edgecolor','none','FaceAlpha',.6)
xlabel('Combined distance to high K layers [m]')
ylabel('Total lateral length [m]')
scatter3(x,y,v);
%%

its = linspace(1,20,20);
bar_data(:,1) = En1.val;
bar_data(:,2) = En2.val;
bar_data(:,3) = En3.val;
bar_data(:,4) = CMA1.val;
bar_data(:,5) = CMA2.val;
bar_data(:,6) = CMA3.val;

for i = 1:20
    EnvCMA{1}(i,1:2) = En1.res{i}(:,1)';
    EnvCMA{1}(i,3:4) = round(En1.res{i}(:,2)');
    EnvCMA{2}(i,1:2) = En2.res{i}(:,1)';
    EnvCMA{2}(i,3:4) = round(En2.res{i}(:,2)');
    EnvCMA{3}(i,1:2) = En3.res{i}(:,1)';
    EnvCMA{3}(i,3:4) = round(En3.res{i}(:,2)');
    EnvCMA{4}(i,1:2) = CMA1.res{i}(1,1:5:end);
    EnvCMA{4}(i,3:4) = round(CMA1.res{i}(1,2:5:end));
    EnvCMA{5}(i,1:2) = CMA2.res{i}(1,1:5:end);
    EnvCMA{5}(i,3:4) = round(CMA2.res{i}(1,2:5:end));
    EnvCMA{6}(i,1:2) = CMA3.res{i}(1,1:5:end);
    EnvCMA{6}(i,3:4) = round(CMA3.res{i}(1,2:5:end)); 
end

%%
figure
subplot(2,1,1)
hold on
icons = ['o' '*' '+' 'd' 's'];
for p = 1:3
    c = ['b' 'r' 'g'];
    for e = 1:length(EnvCMA{1}(:,1))
        nl1 = EnvCMA{p}(e,3) + 1;
        nl2 = EnvCMA{p}(e,4) + 1;
        scatter(its(e),EnvCMA{p}(e,1),c(p),icons(nl1),'filled');
        scatter(its(e),EnvCMA{p}(e,2),c(p),icons(nl2),'filled');
    end
end
scatter([0 0],[15 50],'k','filled')
plot([0 20],[20 20],'k--',[0 20],[40 40],'k--');
plot([0 20],[60 60],'k--',[0 20],[80 80],'k--');
axis([0 20 0 100])
h1 = gca;
set(h1,'YDir','reverse')
ylabel('Depth [z]')
xlabel('Iteration')
grid minor

subplot(2,1,2)
hold on
for p = 4:6
    c = ['b' 'r' 'g'];
    for e = 1:length(EnvCMA{4}(:,1))
        nl1 = EnvCMA{p}(e,3) + 1;
        nl2 = EnvCMA{p}(e,4) + 1;
        scatter(its(e),EnvCMA{p}(e,1),c(p - 3),icons(nl1),'filled');
        scatter(its(e),EnvCMA{p}(e,2),c(p - 3),icons(nl2),'filled');
    end
end
scatter([0 0],[15 50],'k','filled')
plot([0 20],[20 20],'k--',[0 20],[40 40],'k--');
plot([0 20],[60 60],'k--',[0 20],[80 80],'k--');
axis([0 20 0 100])
h2 = gca;
set(h2,'YDir','reverse')
ylabel('Depth [z]')
xlabel('Iteration')
grid minor

%%
figure
subplot(2,1,1)
b1 = bar(bar_data(:,1:3));
axis([0 20.5 -1.5e4 2e4])
grid on
xlabel('Iteration [-]')
ylabel('Objective function value [€]')
b1(1).FaceColor = 'b';
b1(2).FaceColor = 'r';
b1(3).FaceColor = 'g';
subplot(2,1,2)
b2 = bar(bar_data(:,4:6));
axis([0 20.5 -1.5e4 2e4])
grid on
xlabel('Iteration [-]')
ylabel('Objective function value [€]')
b2(1).FaceColor = 'b';
b2(2).FaceColor = 'r';
b2(3).FaceColor = 'g';



%%
figure
subplot(2,1,1)
hold on
scatter([0 0],[20 50],'k','filled')
scatter(its',En_11,'s','b')
scatter(its,En_12,'s','b')
scatter(its',En_21,'s','k')
scatter(its,En_22,'s','k')
scatter(its,CMA_1,'d','r')
scatter(its,CMA_2,'d','r')
scatter(9:20,CMA_3,'d','m')
plot([0 20],[15 15],'g--',[0 20],[35 35],'g--');
plot([0 20],[55 55],'c--',[0 20],[75 75],'c--');
title('Lateral kick-off locations')
ylabel('Depth [z]')
xlabel('Iteration')
axis([0 20 0 100])
h = gca;
set(h,'YDir','reverse')
subplot(2,1,2)
bar(bar_data)
axis([0 20 1.1*min(bar_data(:,2)) 1.1*max(bar_data(:,2))])
title('Objective function value comparison')
xlabel('Iteration')
ylabel('Objective function value [€]')
legend('EnOpt','CMA-ES')
%%
CF = zeros(20,11);
l_len = 0:10:100;
hrrate = 20000/24;

for l = 1:20
    CF(l,:) = (l * 10 + (l_len .* 2 /100)) * hrrate;
end
figure 
hold on
surf(CF)
ylabel('# laterals')
xlabel('Lateral length [10*m]')
title('Cost function map')
