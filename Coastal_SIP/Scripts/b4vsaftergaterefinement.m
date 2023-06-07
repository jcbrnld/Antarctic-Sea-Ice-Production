% compare SIP before and after gate refinement



sector = '17';
load(['ICE/Production/data/SIP/b4_gaterefinement/sector',sector,'.mat'])
oSIP = SIP; clear SIP;

load(['ICE/Production/data/SIP/sector',sector,'.mat']);

figure;plot_dim(900,250);
plot(oSIP.year.dn, oSIP.year.P, 'linewidth', 1.2);
hold on
plot(SIP.year.dn, SIP.year.P, 'color', 'm', 'linewidth', 1.2);
xticks(dnticker(1998,2021));
datetick('x', 'mm-yyyy', 'keepticks');
xtickangle(27)
xlim([min(SIP.year.dn)-50, max(SIP.year.dn)+50]);
ylabel('SIP [km^3]')
title(['Sector',sector,' before and after gate refinement']);
legend('old gates', 'new gates')
grid on

print(['ICE/Production/figures/SIP/oldvsnewgates/sector',sector,'oldvsnew.png'], '-dpng', '-r200')