% Jacob Arnold

% 28-Sep-2022

% view/test estimating SIP error with +- 1 standard deviation



% as always test with sabrina

sector = '02';
load(['ICE/Production/data/SIP/sector',sector,'.mat']);

%%

% use 16 week filtered data
P = filtout(SIP.P, 16);
dev = std(P);

up = P+dev;
dn = P-dev;

figure;
plot(SIP.dn, P);
hold on
plot(SIP.dn, up);
plot(SIP.dn, dn);
yline(0);
xticks(dnticker(1997,2022));
datetick('x', 'mm-yyyy', 'keepticks');
xlim([min(SIP.dn)-50, max(SIP.dn)+50]);
xtickangle(27);






