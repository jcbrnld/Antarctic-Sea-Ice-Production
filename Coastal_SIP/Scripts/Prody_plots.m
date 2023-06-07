% Jacob Arnold
% 26-Apr-2023
% Create timeseries of SIP in the 15 AA sectors with yyaxis productivity


%% Plot top productivity sectors (07,06,14)

secs = {'07', '06', '14'};
figure; plot_dim(700,170);
cols = [0.99,0.3,0.3; 0.2,0.8,0.3; 0.1,0.4,0.9];
for ii = 1:length(secs)
    sector = secs{ii};
    load(['ICE/Production/data/SIP/sector',sector,'.mat']);
    load(['ICE/Sectors/Gates/mat_files/sector_gates_withError/sector',sector,'.mat']);
    aaa = gate.inside.total_area;
    clear gate
    prody = (SIP.year.P./aaa).*1000;
    dn = SIP.year.dn;
    
    pp = polyfit(dn', prody, 1);
    yy = polyval(pp, dn);
    %slope(ii) = (((yy(2)-yy(1))/(dn(2)-dn(1)))/nanmean(prody))*365.24*100;
    slope(ii) = ((yy(5)-yy(4)))*10; % m/decade
    slope(ii) = round(slope(ii)*100)/100;
    
    pl{ii} = plot(SIP.year.dn, prody, 'color', cols(ii,:), 'linewidth', 1);
    hold on
    plot(dn, yy, '--', 'color', cols(ii,:), 'linewidth', 1);
    
    clear SIP sector aaa prody
end
xticks(dnticker(1997,2022));
datetick('x', 'yy', 'keepticks');
ylabel('Productivity [m]');
legend([pl{1},pl{2},pl{3}], ['Prydz ',num2str(slope(1)),' m/dec'], ['Darnley ',num2str(slope(2)),' m/dec'],...
    ['Ross ',num2str(slope(3)),' m/dec'], 'orientation', 'horizontal', 'location', 'south', 'fontsize', 13)
 xlim([min(dn)-50, max(dn)+50]);
ax = gca;
ax.FontSize = 15;
ylim([-1,7]);
print('ICE/Production/figures/Productivity/topthree.png', '-dpng', '-r400');


%% divide middle into 02 and 10 aaand 12b, 16, 08b

secs = {'02', '10'};
figure; plot_dim(700,170);
 cols = [0.99,0.3,0.3; 0.2,0.8,0.3; 0.1,0.4,0.9];


for ii = 1:length(secs)
    sector = secs{ii};
    load(['ICE/Production/data/SIP/sector',sector,'.mat']);
    load(['ICE/Sectors/Gates/mat_files/sector_gates_withError/sector',sector,'.mat']);
    aaa = gate.inside.total_area;
    clear gate
    prody = (SIP.year.P./aaa).*1000;
    dn = SIP.year.dn;
    
    pp = polyfit(dn', prody, 1);
    yy = polyval(pp, dn);
    %slope(ii) = (((yy(2)-yy(1))/(dn(2)-dn(1)))/nanmean(prody))*365.24*100;
    slope(ii) = ((yy(5)-yy(4)))*10; % m/decade
    slope(ii) = round(slope(ii)*100)/100;
    
    pl{ii} = plot(SIP.year.dn, prody, 'color', cols(ii,:), 'linewidth', 1);
    hold on
    plot(dn, yy, '--', 'color', cols(ii,:), 'linewidth', 1);
    
    clear SIP sector aaa prody
end
xticks(dnticker(1997,2022));
datetick('x', 'yy', 'keepticks');
ylabel('Productivity [m]');
legend([pl{1},pl{2}], ['S. Weddell ',num2str(slope(1)),' m/dec'], ['Sabrina ',num2str(slope(2)),' m/dec'],...
    'orientation', 'horizontal', 'location', 'south', 'fontsize', 13)
 xlim([min(dn)-50, max(dn)+50]);
ax = gca;
ax.FontSize = 15;
ylim([-1,4]);
print('ICE/Production/figures/Productivity/middle5_top2.png', '-dpng', '-r400');


%%  '12b', '16', '08b'


secs = {'12b', '16', '08b'};
figure; plot_dim(700,170);
 cols = [0.99,0.3,0.3; 0.2,0.8,0.3; 0.1,0.4,0.9];

for ii = 1:length(secs)
    sector = secs{ii};
    load(['ICE/Production/data/SIP/sector',sector,'.mat']);
    load(['ICE/Sectors/Gates/mat_files/sector_gates_withError/sector',sector,'.mat']);
    aaa = gate.inside.total_area;
    clear gate
    prody = (SIP.year.P./aaa).*1000;
    dn = SIP.year.dn;
    
    pp = polyfit(dn', prody, 1);
    yy = polyval(pp, dn);
    %slope(ii) = (((yy(2)-yy(1))/(dn(2)-dn(1)))/nanmean(prody))*365.24*100;
    slope(ii) = ((yy(5)-yy(4)))*10; % m/decade
    slope(ii) = round(slope(ii)*100)/100;
    
    pl{ii} = plot(SIP.year.dn, prody, 'color', cols(ii,:), 'linewidth', 1);
    hold on
    plot(dn, yy, '--', 'color', cols(ii,:), 'linewidth', 1);
    
    clear SIP sector aaa prody
end
xticks(dnticker(1997,2022));
datetick('x', 'yy', 'keepticks');
ylabel('Productivity [m]');
legend([pl{1},pl{2},pl{3}], ...
    ['Mertz ',num2str(slope(1)),' m/dec'],['Amundsen ',num2str(slope(2)),' m/dec'], ['Shackleton ',num2str(slope(3)),' m/dec'],...
    'orientation', 'horizontal', 'location', 'south', 'fontsize', 13)
 xlim([min(dn)-50, max(dn)+50]);
ax = gca;
ax.FontSize = 15;
ylim([-1,4]);
print('ICE/Production/figures/Productivity/middle5_lower3.png', '-dpng', '-r400');

%%  '09', '17', '11'


secs = {'09', '17', '11'};
figure; plot_dim(700,170);
 cols = [0.99,0.3,0.3; 0.2,0.8,0.3; 0.1,0.4,0.9];

for ii = 1:length(secs)
    sector = secs{ii};
    load(['ICE/Production/data/SIP/sector',sector,'.mat']);
    load(['ICE/Sectors/Gates/mat_files/sector_gates_withError/sector',sector,'.mat']);
    aaa = gate.inside.total_area;
    clear gate
    prody = (SIP.year.P./aaa).*1000;
    dn = SIP.year.dn;
    
    pp = polyfit(dn', prody, 1);
    yy = polyval(pp, dn);
    %slope(ii) = (((yy(2)-yy(1))/(dn(2)-dn(1)))/nanmean(prody))*365.24*100;
    slope(ii) = ((yy(5)-yy(4)))*10; % m/decade
    slope(ii) = round(slope(ii)*100)/100;
    
    pl{ii} = plot(SIP.year.dn, prody, 'color', cols(ii,:), 'linewidth', 1);
    hold on
    plot(dn, yy, '--', 'color', cols(ii,:), 'linewidth', 1);
    
    clear SIP sector aaa prody yy pp 
end
xticks(dnticker(1997,2022));
datetick('x', 'yy', 'keepticks');
ylabel('Productivity [m]');
legend([pl{1},pl{2},pl{3}], ...
    ['Vincennes ',num2str(slope(1)),' m/dec'],['Bellingshausen ',num2str(slope(2)),' m/dec'], ['Porpoise ',num2str(slope(3)),' m/dec'],...
    'orientation', 'horizontal', 'location', 'south', 'fontsize', 13)
 xlim([min(dn)-50, max(dn)+50]);
ax = gca;
ax.FontSize = 15;
ylim([-2,4]);
print('ICE/Production/figures/Productivity/lowthree.png', '-dpng', '-r400');

clear pl slope


%%

sector = '02';
load(['ICE/Production/data/SIP/sector',sector,'.mat']);
load(['ICE/Sectors/Gates/mat_files/sector_gates/sector',sector,'_gb15s_shelf.mat']);
clear gate2;
prody = (SIP.year.P./gate.inside.total_area).*1000;

filtH = filtout(nanmean(gate.midH), 16);
dtickv(:,1) = 1996:4:2022;
dtickv(:,2) = 1;
dtickv(:,3) = 1;
dtickersmall = datenum(dtickv);

ff = polyfit(gate.dn, filtH, 1);
yy = polyval(ff, gate.dn);

ff1 = polyfit(gate.dn', nanmean(gate.midH),1);
yy1 = polyval(ff1, gate.dn);
slope1 = (((yy1(2)-yy1(1))/(gate.dn(2)-gate.dn(1)))/nanmean(nanmean(gate.midH)))*365.24*100;
sl1p = (slope1/nanmean(nanmean(gate.midH)))*100;
slope1 = round(slope1*10)/10;

ff2 = polyfit(SIP.year.dn', SIP.year.P, 1);
yy2 = polyval(ff2, SIP.year.dn);
slope2 = (((yy2(2)-yy2(1))/(SIP.year.dn(2)-SIP.year.dn(1)))/nanmean(SIP.year.P))*365.24*100;
slope2 = round(slope2*10)/10;

figure;plot_dim(500,150)
plot(SIP.year.dn, SIP.year.P, 'color', [0.01,.01,.01, .4], 'linewidth', 1.1);
xticks(dnticker(1997,2023));
ylim([0,2.7])
datetick('x', 'yy', 'keepticks');
ylabel('SIP [10^4 km^3]');
text(SIP.year.dn(2), 0.4, 'Ross Sea', 'fontsize', 13);

yyaxis('right')
plot(SIP.year.dn, prody, 'linewidth', 1)
ax = gca;
ax.YAxis(2).Color = 'k';



xlim([min(SIP.year.dn)-50, max(SIP.year.dn)+50]);
ylabel('Productivity [m]');

axes('Position',[.61 .605 .28 .279])
box on
plot(gate.dn,filtH, 'color', [.01,.01,.01]);
hold on
plot(gate.dn, yy, '--r', 'linewidth', 1.1);
xticks(dtickersmall);
datetick('x', 'yy', 'keepticks');
xlim([min(SIP.dn)-50, max(SIP.dn)+50]);
ylabel('SIT [m]');




%print(['ICE/Production/figures/SIP/WithProdyHinset/sector',sector,'.png'], '-dpng', '-r400');


%% mean yearly H

years = unique(gate.dv(:,1));years(1) = [];
mH = nanmean(gate.midH);
for ii = 1:length(years)
    yloc = find(gate.dv(:,1)==years(ii));
    ymH(ii) = nanmean(mH(yloc));
end

figure;plot(SIP.year.dn, SIP.productivity)
yyaxis('right');plot(SIP.year.dn, ymH);


% highly correlated 

ff3 = polyfit(SIP.year.dn', ymH, 1);
yy3 = polyval(ff3, SIP.year.dn);
slope3 = (((yy3(2)-yy3(1))/(SIP.year.dn(2)-SIP.year.dn(1)))/nanmean(ymH))*365.24*100;
slope3 = round(slope3*10)/10;


%% Same as two pannels above but inset it mean yearly H

figure;plot_dim(500,150)
plot(SIP.year.dn, SIP.year.P, 'color', [0.01,.01,.01, .4], 'linewidth', 1.1);
xticks(dnticker(1997,2023));
ylim([0,2.7])
datetick('x', 'yy', 'keepticks');
ylabel('SIP [10^4 km^3]');

yyaxis('right')
plot(SIP.year.dn, SIP.productivity)
yline(1.94, 'linewidth', 1.1);
xlim([min(SIP.year.dn)-50, max(SIP.year.dn)+50]);
ylabel('Productivity [m]');

axes('Position',[.61 .605 .28 .279])
box on
plot(SIP.year.dn,ymH, 'color', [.01,.01,.01]);
hold on
plot(SIP.year.dn, yy3, '--r', 'linewidth', 1.1);
xticks(dtickersmall);
datetick('x', 'yy', 'keepticks');
xlim([min(SIP.dn)-50, max(SIP.dn)+50]);
ylabel('SIT [m]');






%% plot mult. productivities 
% doesn't work 

sectors = {'14', '02'};

for ii = 1:length(sectors)
    sector = sectors{ii};
    load(['ICE/Production/data/SIP/sector',sector,'.mat']);
    
    figure;plot_dim(500,150)
    plot(SIP.year.dn, SIP.productivity);
    hold on
    dn = SIP.year.dn;
    clear SIP
end
xticks(dnticker(1997,2023));
datetick('x', 'yy', 'keepticks');
yline(1.94, 'linewidth', 1.1);
xlim([min(SIP.year.dn)-50, max(SIP.year.dn)+50]);
ylabel('Productivity [m]');












