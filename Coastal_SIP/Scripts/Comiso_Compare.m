% Jacob Arnold

% 29-Jul-2022

% Compare Ross SIP: mine vs Comiso et al., 2011



% reconstruct Comiso timeseries from their figure 13

cdv(:,1) = [1992:2008];
cdv(:,2) = 7; 
cdv(:,3) = 1;
cdn = datenum(cdv);
cSIP(:,1) = [415, 270, 345, 375, 355, 330, 475, 470, 705, 555, 400, 605, 600, 650, 515, 790, 540];


load ICE/Production/data/SIP/sector14.mat;

%%



figure;plot_dim(1500,270);
plot(SIP.year.dn, SIP.year.P, 'linewidth', 1.1, 'color', [.01,.01,.01]);
hold on
plot(cdn, cSIP, 'linewidth', 1.1, 'color', [0.9,0.2,0.2]);
xticks(dnticker(1990,2022));
datetick('x', 'yyyy', 'keepticks');
xlim([min(cdn)-50, max(SIP.year.dn)+50]);
grid on


%% overlap years

o(:,1) = SIP.year.P(1:11);
o(:,2) = cSIP(7:end);

corrcoef(o)






