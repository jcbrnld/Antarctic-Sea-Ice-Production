% Jacob Arnold
% 15-Jun-2022

% far east sectors investigation (08-12)

for ii = 1:5
    nums = 8:12;
    if nums(ii) < 10
        sector = ['0', num2str(nums(ii))];
    else
        sector = num2str(nums(ii));
    end
    
    load(['ICE/Production/data/SIP/sector',sector,'.mat']);
    load(['ICE/Motion/Data/NSIDC/sector',sector,'.mat']);
    
    yP(ii,:) = SIP.year.P;
    
    years = 1998:2020;
    for yy = 1:length(years);
        loc = find(SIM.dv(:,1)==years(yy));
        tyu(yy) = nanmean(SIM.uh(:,loc), 'all');
        tyv(yy) = nanmean(SIM.vh(:,loc), 'all');
        clear loc
    end
    yu(ii,:) = tyu;
    yv(ii,:) = tyv; 
    
    clear tyu tyv SIP SIM
    
end
cP = sum(yP);
mu = nanmean(yu);
mv = nanmean(yv);
%%

figure;plot_dim(900,250);
plot(years, cP, 'linewidth', 1.2, 'color', [.05,.05,.05]);
xlim([1997.5, 2020.5]); ylim([-150, 650])
ylabel('Yearly SIP [km^3]')
yyaxis('right');
plot(years, mv, 'linewidth', 1.2)
xticks(years); 
grid on
ylabel('SIM [cm/s]');
ylim([-0.05, 0.7])
title('Sectors 08-12 combined yearly SIP and average ice v');
legend('SIP', 'ICE v', 'fontsize', 12, 'location', 'north', 'orientation', 'horizontal');

print('ICE/Production/figures/Investigations/Far_east/total_SIP_ICEv.png', '-dpng', '-r400');



%% look at the winds

for ii = 1:5
    nums = 8:12;
    if nums(ii) < 10
        sector = ['0', num2str(nums(ii))];
    else
        sector = num2str(nums(ii));
    end
    
    load(['/Volumes/Data/Research_long/ECMWF/matfiles/h_timescale/sector',sector,'_ecmwf_Ht.mat']); 
    
    years = 1998:2020;
    for yy = 1:length(years)
        loc  = find(ecmwf.dv(:,1)==years(yy));
        ywu(ii,yy) = nanmean(ecmwf.u(:,loc), 'all');
        ywv(ii,yy) = nanmean(ecmwf.v(:,loc), 'all');
        yt2m(ii,yy) = nanmean(ecmwf.t2m(:,loc), 'all');
        
        clear loc
    end
    

    clear ecmwf
end


mwu = nanmean(ywu);
mwv = nanmean(ywv);
mt2m = nanmean(yt2m);

%% Check out all 3 separately

p1 = polyfit(years, mv, 1);
y1 = polyval(p1, years); slope1 = (((y1(2)-y1(1))*10)/mv(1))*100; % %/decade

% 1. v
p2 = polyfit(years, mwv, 1);
y2 = polyval(p2, years); slope2 = (((y2(2)-y2(1))*10)/mwv(1))*100;
figure;plot_dim(900,250);
l1 = plot(years, mv, 'linewidth', 1.2, 'color', [.05,.05,.05]);
hold on
plot(years, y1, '--', 'linewidth', 1.2, 'color', [.05,.05,.05]);
xlim([1997.5, 2020.5]); %ylim([-150, 650])
ylabel('ice v [cm/s]')
yyaxis('right'); ax = gca; ax.YColor = [0.2, 0.7, 0.3];
l2 = plot(years, mwv, 'linewidth', 1.2, 'color', [0.2, 0.7, 0.3]); hold on
plot(years, y2, 'linewidth', 1.2, 'color', [0.2, 0.7, 0.3]);
xticks(years); 
grid on
ylabel('wind v [m/s]');
%ylim([-0.05, 0.7])
title('Sectors 08-12 yearly mean ice v and wind v');
legend([l1, l2], ['ice v; Slope = ',num2str(slope1),' %/dec'], ['Wind v; Slope = ',num2str(slope2),' %/dec'],...
    'fontsize', 12, 'location', 'north', 'orientation', 'horizontal');
print('ICE/Production/figures/Investigations/Far_east/icevVSwindv.png', '-dpng', '-r400');

% 2. u
p2 = polyfit(years, -mwu, 1);
y2 = polyval(p2, years); slope2 = (((y2(2)-y2(1))*10)/-mwu(1))*100;
figure;plot_dim(900,250);
l1 = plot(years, mv, 'linewidth', 1.2, 'color', [.05,.05,.05]);hold on
plot(years, y1, '--', 'linewidth', 1.2, 'color', [.05,.05,.05]);
xlim([1997.5, 2020.5]);% ylim([-150, 650])
ylabel('ice v [cm/s]')
yyaxis('right'); ax = gca; ax.YColor = [0.2, 0.4, 0.8];
l2 = plot(years, -mwu, 'linewidth', 1.2, 'color', [0.2, 0.4, 0.8]); hold on
plot(years, y2, 'linewidth', 1.2, 'color', [0.2, 0.4, 0.8]);
xticks(years); 
grid on
ylabel('wind -u [m/s]');
%ylim([-0.05, 0.7])
title('Sectors 08-12 yearly mean ice v and wind u');
legend([l1, l2], ['ice v; Slope = ',num2str(slope1),' %/dec'], ['Wind -u; Slope = ',num2str(slope2),' %/dec'],...
    'fontsize', 12, 'location', 'north', 'orientation', 'horizontal');
print('ICE/Production/figures/Investigations/Far_east/icevVSwindu.png', '-dpng', '-r400');


% 3. t2m
p2 = polyfit(years, mt2m, 1);
y2 = polyval(p2, years); slope2 = (((y2(2)-y2(1))*10)/abs(mt2m(1)))*100;
figure;plot_dim(900,250);
l1 = plot(years, mv, 'linewidth', 1.2, 'color', [.05,.05,.05]); hold on
plot(years, y1, '--', 'linewidth', 1.2, 'color', [.05,.05,.05]);
xlim([1997.5, 2020.5]); %ylim([-150, 650])
ylabel('ice v [cm/s]')
yyaxis('right'); ax = gca; ax.YColor = [0.9, 0.2, 0.7];
l2 = plot(years, mt2m, 'linewidth', 1.2, 'color', [0.9, 0.2, 0.7]); hold on
plot(years, y2, 'linewidth', 1.2, 'color', [0.9, 0.2, 0.7]);
xticks(years); 
grid on
ylabel('Temperature [\circC]');
%ylim([-0.05, 0.7])
title('Sectors 08-12 yearly mean ice v and air temperature');
legend([l1, l2], ['ice v; Slope = ',num2str(slope1),' %/dec'], ['Air Temp; Slope = ',num2str(slope2),' %/dec'],...
    'fontsize', 12, 'location', 'north', 'orientation', 'horizontal');
print('ICE/Production/figures/Investigations/Far_east/icevVSairT.png', '-dpng', '-r400');















