% Jacob Arnold
% 13-Jun-2022
% Digging into sector 6 SIP regime shift

% Plot climatological annual cycles of SIP, icein, iceout, net export,
% air temp, winds, and watever else before and from 2009


load ICE/Production/data/SIP/sector06.mat;
%load /Volumes/Data/Research_long/ECMWF/matfiles/h_timescale/sector06_ecmwf_Ht.mat;

for ii = 1:12
    b4loc = find(SIP.month.dv(:,2)==ii & SIP.month.dv(:,1)<2009); % to create mean climatological cycle
    afloc = find(SIP.month.dv(:,2)==ii & SIP.month.dv(:,1)>=2009);
    
    b4P(ii,1) = mean(SIP.month.P(b4loc));
    b4E(ii,1) = mean(SIP.month.E(b4loc));
    b4dSIV(ii,1) = mean(SIP.month.dSIV(b4loc));
    b4in(ii,1) = mean(SIP.month.icein(b4loc));
    b4out(ii,1) = mean(SIP.month.iceout(b4loc));
    
    afP(ii,1) = mean(SIP.month.P(afloc));
    afE(ii,1) = mean(SIP.month.E(afloc));
    afdSIV(ii,1) = mean(SIP.month.dSIV(afloc));
    afin(ii,1) = mean(SIP.month.icein(afloc));
    afout(ii,1) = mean(SIP.month.iceout(afloc));
    

    clear b4loc afloc
end

b4P(13) = b4P(1);
b4E(13) = b4E(1);
b4dSIV(13) = b4dSIV(1);
b4in(13) = b4in(1);
b4out(13) = b4out(1);

afP(13) = afP(1);
afE(13) = afE(1);
afdSIV(13) = afdSIV(1);
afin(13) = afin(1);
afout(13) = afout(1);


%% And plot

% start with the basics first
% Before
ms = {'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};
figure;
plot_dim(600,350)
p1 = plot(1:13, b4P, 'linewidth', 1.2);
hold on
p2 = plot(1:13, b4E, 'linewidth', 1.2);
p3 = plot(1:13, b4dSIV, 'linewidth', 1.2);
xlim([0.75,13.25]);
xticks(1:12);
xticklabels(ms);
colororder([0.1,0.3,0.7; 0.8,0.2,0.2; 0.9,0.8,0.1]);
ylim([-37, 30]);
xline(3.5, 'color', [0.5,0.7,0.5], 'linewidth', 1);
xline(6.5, 'color', [0.5,0.7,0.5], 'linewidth', 1);
xline(9.5, 'color', [0.5,0.7,0.5], 'linewidth', 1);
xline(12.5, 'color', [0.5,0.7,0.5], 'linewidth', 1);
yline(0, '--', 'color', [0.5, 0.5, 0.5], 'linewidth', 1);
text(1.5, 25, 'Summer', 'fontsize', 11)
text(4.75, 25, 'Fall', 'fontsize', 11)
text(7.5, 25, 'Winter', 'fontsize', 11)
text(10.5, 25, 'Spring', 'fontsize', 11)
title('Sector 06 Climatologial Annual Cycle 1998-2008');
ylabel('[km^3/month]');
legend([p1,p2,p3], 'SIP', 'Export', '\Delta SIV', 'location', 'south', 'fontsize', 11, 'orientation', 'horizontal')
print('ICE/Production/figures/Sectors/sector06/climatological_cycle_1998-2008.png', '-dpng', '-r300');

% After
figure;
plot_dim(600,350)
p1 = plot(1:13, afP, 'linewidth', 1.2);
hold on
p2 = plot(1:13, afE, 'linewidth', 1.2);
p3 = plot(1:13, afdSIV, 'linewidth', 1.2);
xlim([0.75,13.25]);
xticks(1:12);
xticklabels(ms);
colororder([0.1,0.3,0.7; 0.8,0.2,0.2; 0.9,0.8,0.1]);
ylim([-37, 30]);
xline(3.5, 'color', [0.5,0.7,0.5], 'linewidth', 1);
xline(6.5, 'color', [0.5,0.7,0.5], 'linewidth', 1);
xline(9.5, 'color', [0.5,0.7,0.5], 'linewidth', 1);
xline(12.5, 'color', [0.5,0.7,0.5], 'linewidth', 1);
yline(0, '--', 'color', [0.5, 0.5, 0.5], 'linewidth', 1);
text(1.5, 25, 'Summer', 'fontsize', 11)
text(4.75, 25, 'Fall', 'fontsize', 11)
text(7.5, 25, 'Winter', 'fontsize', 11)
text(10.5, 25, 'Spring', 'fontsize', 11)
title('Sector 06 Climatologial Annual Cycle 2009-2020');
ylabel('[km^3/month]');
legend([p1,p2,p3], 'SIP', 'Export', '\Delta SIV', 'location', 'south', 'fontsize', 11, 'orientation', 'horizontal')
print('ICE/Production/figures/Sectors/sector06/climatological_cycle_2009-2020.png', '-dpng', '-r300');



%% 
% now look at in/out

figure;
plot_dim(600,350)
p1 = plot(1:13, b4in, 'linewidth', 1.2);
hold on
p2 = plot(1:13, b4out, 'linewidth', 1.2);
xlim([0.75,13.25]);
xticks(1:12);
xticklabels(ms);
colororder([0.2,0.8,0.9; 0.8,0.2,0.9]);
ylim([-6, 40]);
xline(3.5, 'color', [0.5,0.7,0.5], 'linewidth', 1);
xline(6.5, 'color', [0.5,0.7,0.5], 'linewidth', 1);
xline(9.5, 'color', [0.5,0.7,0.5], 'linewidth', 1);
xline(12.5, 'color', [0.5,0.7,0.5], 'linewidth', 1);
yline(0, '--', 'color', [0.5, 0.5, 0.5], 'linewidth', 1);
text(1.5, 37, 'Summer', 'fontsize', 11)
text(4.75, 37, 'Fall', 'fontsize', 11)
text(7.5, 37, 'Winter', 'fontsize', 11)
text(10.5, 37, 'Spring', 'fontsize', 11)
title('Sector 06 Climatologial Annual Cycle 1998-2008');
ylabel('[km^3/month]');
legend([p1,p2], 'Ice in', 'Ice out', 'location', 'south', 'fontsize', 11, 'orientation', 'horizontal')
print('ICE/Production/figures/Sectors/sector06/climatological_ICEIN-ICEOUT_1998-2008.png', '-dpng', '-r300');



figure;
plot_dim(600,350)
p1 = plot(1:13, afin, 'linewidth', 1.2);
hold on
p2 = plot(1:13, afout, 'linewidth', 1.2);
xlim([0.75,13.25]);
xticks(1:12);
xticklabels(ms);
colororder([0.2,0.8,0.9; 0.8,0.2,0.9]);
ylim([-6, 40]);
xline(3.5, 'color', [0.5,0.7,0.5], 'linewidth', 1);
xline(6.5, 'color', [0.5,0.7,0.5], 'linewidth', 1);
xline(9.5, 'color', [0.5,0.7,0.5], 'linewidth', 1);
xline(12.5, 'color', [0.5,0.7,0.5], 'linewidth', 1);
yline(0, '--', 'color', [0.5, 0.5, 0.5], 'linewidth', 1);
text(1.5, 37, 'Summer', 'fontsize', 11)
text(4.75, 37, 'Fall', 'fontsize', 11)
text(7.5, 37, 'Winter', 'fontsize', 11)
text(10.5, 37, 'Spring', 'fontsize', 11)
title('Sector 06 Climatologial Annual Cycle 2009-2020');
ylabel('[km^3/month]');
legend([p1,p2], 'Ice in', 'Ice out', 'location', 'south', 'fontsize', 11, 'orientation', 'horizontal')
print('ICE/Production/figures/Sectors/sector06/climatological_ICEIN-ICEOUT_2009-2020.png', '-dpng', '-r300');



%% Look at winds
% Timeseries of ice u and v showed an icrease in both with an increase in V
% corresponding to the regime shift time. 
% Now need to find what caused the ice motion direction to change


load /Volumes/Data/Research_long/ECMWF/matfiles/h_timescale/sector06_ecmwf_Ht.mat;
%%

years = 1998:2020;
for ii = 1:length(years)
    loc = find(ecmwf.dv(:,1)==years(ii));
    
    ywu(:,ii) = nanmean(ecmwf.u(:,loc),2);
    ywv(:,ii) = nanmean(ecmwf.v(:,loc),2);
    
    yt2m(:,ii) = nanmean(ecmwf.t2m(:,loc),2);
    ysp(:,ii) = nanmean(ecmwf.sp(:,loc),2);
    
    clear loc
end

%%

figure;plot_dim(1150,270);
plot(years, -nanmean(ywu), 'linewidth', 1.2);
hold on;
plot(years, nanmean(ywv), 'linewidth', 1.2);
xlim([1997.5, 2020.5]);
xticks(years);
title('Sector 06 yearly mean wind u and v');
legend('Wind -u', 'Wind v', 'fontsize', 12, 'location', 'north', 'orientation', 'horizontal')
grid on
ylabel('Wind Velocity [m/s]');
ylim([3.5, 6])
print('ICE/Production/figures/Sectors/sector06/yearlyWINDuv.png', '-dpng', '-r300');

%%

figure;plot_dim(1150,270);
plot(years, nanmean(yt2m), 'linewidth', 1.2);
yyaxis('right');
plot(years, nanmean(ysp), 'linewidth', 1.2);


%% Gate H

load ICE/Sectors/Gates/mat_files/sector_gates/sector06.mat

years = 1998:2020;
[gateH, ydn] = toyearly(gate.H, gate.dn);

gateH = nanmean(gateH);gateH(end) = [];




%%

figure; plot_dim(900,200);
plot(years, gateH, 'linewidth', 1.2, 'color', [0.9   0.2    0.2])
xlim([1997.5, 2020.5]);
xticks(years);
title('Sector 06 yearly mean gate SIT');
ylabel('SIT [m]'); grid on
print('ICE/Production/figures/Investigations/sector06/meanGateSIT.png', '-dpng', '-r400');




%% The difference is primarily in the winter. 

% Lets look at winter wind data
load /Volumes/Data/Research_long/ECMWF/matfiles/h_timescale/sector06_ecmwf_Ht.mat;
%%

years = 1998:2020;
for ii = 1:length(years)
    wiloc = find((ecmwf.dv(:,1)==years(ii)) & ((ecmwf.dv(:,2)==06 & ecmwf.dv(:,3)>15)...
        | ecmwf.dv(:,2)==07 | ecmwf.dv(:,2)==8 | (ecmwf.dv(:,2)==9 & ecmwf.dv(:,3)<=15)));
    sploc = find((ecmwf.dv(:,1)==years(ii)) & ((ecmwf.dv(:,2)==9 & ecmwf.dv(:,3)>15)...
        | ecmwf.dv(:,2)==10 | ecmwf.dv(:,2)==11 | (ecmwf.dv(:,2)==12 & ecmwf.dv(:,3)<=15)));
    suloc = find((ecmwf.dv(:,1)==years(ii)) & ((ecmwf.dv(:,2)==12 & ecmwf.dv(:,3)>15)...
        | ecmwf.dv(:,2)==1 | ecmwf.dv(:,2)==2 | (ecmwf.dv(:,2)==3 & ecmwf.dv(:,3)<=15)));
    faloc = find((ecmwf.dv(:,1)==years(ii)) & ((ecmwf.dv(:,2)==3 & ecmwf.dv(:,3)>15)...
        | ecmwf.dv(:,2)==4 | ecmwf.dv(:,2)==5 | (ecmwf.dv(:,2)==6 & ecmwf.dv(:,3)<=15)));
    


    wiu(ii,1) = nanmean(ecmwf.u(:,wiloc), 'all');
    spu(ii,1) = nanmean(ecmwf.u(:,sploc), 'all');
    suu(ii,1) = nanmean(ecmwf.u(:,suloc), 'all');
    fau(ii,1) = nanmean(ecmwf.u(:,faloc), 'all');
    
    wiv(ii,1) = nanmean(ecmwf.v(:,wiloc), 'all');
    spv(ii,1) = nanmean(ecmwf.v(:,sploc), 'all');
    suv(ii,1) = nanmean(ecmwf.v(:,suloc), 'all');
    fav(ii,1) = nanmean(ecmwf.v(:,faloc), 'all');

    wit(ii,1) = nanmean(ecmwf.t2m(:,wiloc), 'all');
    spt(ii,1) = nanmean(ecmwf.t2m(:,sploc), 'all');
    sut(ii,1) = nanmean(ecmwf.t2m(:,suloc), 'all');
    fat(ii,1) = nanmean(ecmwf.t2m(:,faloc), 'all');
    
    clear wiloc sploc suloc faloc
end

%%

p1 = polyfit(years, -wiu', 1);
y1 = polyval(p1, years); slope1 = 100*((y1(2)-y1(1))*10)/-wiu(1);

p2 = polyfit(years, SIP.winter.P, 1);
y2 = polyval(p2, years); slope2 = 100*((y2(2)-y2(1))*10)/abs(SIP.year.P(1));

figure; plot_dim(900,250)
l1 = plot(years, SIP.winter.P, 'linewidth', 1.2, 'color', [0.05,.05,.05]); hold on
plot(years, y2, '--', 'linewidth', 1.2, 'color', [0.05,.05,.05]);
%xline(2008, '--r', 'linewidth', 1.2);
ylim([-120, 70]);
ylabel('Yearly SIP [km^3]');
yyaxis('right');ax = gca; ax.YColor = [0.2, 0.6, 0.7];
l2 = plot(years, -wiu, 'linewidth', 1.2, 'color', [0.2, 0.6, 0.7]); hold on
plot(years, y1, '--', 'linewidth', 1.2, 'color', [0.2, 0.6, 0.7]);

legend([l1, l2], ['SIP; slope = ',num2str(slope2), ' %/dec'], ['Wind -u; slope = ',num2str(slope1),' %/dec'],...
    'fontsize', 11, 'location', 'north', 'orientation', 'horizontal');
xlim([1997.5, 2020.5]);
xticks(years);
ylabel('Wind -u velocity [m/s]')
title('Winter SIP and Wind U velocity')
grid on
%print('ICE/Production/figures/Investigations/sector06/WINTER_SIPandWindu.png', '-dpng', '-r300');

% v
p1 = polyfit(years, wiv', 1);
y1 = polyval(p1, years); slope1 = 100*((y1(2)-y1(1))*10)/wiv(1);

p2 = polyfit(years, SIP.winter.P, 1);
y2 = polyval(p2, years); slope2 = 100*((y2(2)-y2(1))*10)/abs(SIP.year.P(1));

figure; plot_dim(900,250)
l1 = plot(years, SIP.winter.P, 'linewidth', 1.2, 'color', [0.05,.05,.05]); hold on
plot(years, y2, '--', 'linewidth', 1.2, 'color', [0.05,.05,.05]);
%xline(2008, '--r', 'linewidth', 1.2);
ylabel('Yearly SIP [km^3]');
ylim([-120, 70]);
yyaxis('right');ax = gca; ax.YColor = [0.9, 0.5, 0.2];
l2 = plot(years, wiv, 'linewidth', 1.2, 'color', [0.9, 0.5, 0.2]); hold on
plot(years, y1, '--', 'linewidth', 1.2, 'color', [0.9, 0.5, 0.2]);

legend([l1, l2], ['SIP; slope = ',num2str(slope2), ' %/dec'], ['Wind v; slope = ',num2str(slope1),' %/dec'],...
    'fontsize', 11, 'location', 'north', 'orientation', 'horizontal');
xlim([1997.5, 2020.5]);
xticks(years);
ylim([3.6, 5.3])
grid on;
ylabel('Wind v velocity [m/s]')
title('Winter SIP and Wind U velocity')
%print('ICE/Production/figures/Investigations/sector06/WINTER_SIPandWindv.png', '-dpng', '-r300');



