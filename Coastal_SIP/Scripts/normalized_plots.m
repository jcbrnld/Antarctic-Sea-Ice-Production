% Jacob Arnold

% 09-Jun-2022
% Plot normalized SIP data for all sectors
% Also plot groups individually
% also do export, dSIV, icein, and iceout


for ii = 1:18
    if ii < 10
        sector = ['0', num2str(ii)];
    else
        sector = num2str(ii);
    end
    
    load(['ICE/Production/data/SIP/sector',sector,'.mat']);
    P(:,ii) = SIP.year.P;
    dn = SIP.year.dn;
    E(:,ii) = SIP.year.E;
    IN(:,ii) = SIP.year.icein;
    OUT(:,ii) = SIP.year.iceout;
   
    secs{ii} = sector;
    clear SIP
end
    
% Normalize
P = normalize(P);
E = normalize(E);
IN = normalize(IN);
OUT = normalize(OUT);


c = distinguishable_colors(18);
figure; plot_dim(1230,270);
plot(dn, P, 'linewidth', 1);
xticks(dnticker(1997,2021)); datetick('x', 'mm-yyyy', 'keepticks'); xtickangle(27);
xlim([min(dn)-50, max(dn)+50]);
colororder(c);
legend(secs, 'location', 'north', 'orientation', 'horizontal')
title('Normalized SIP')
grid on
print('ICE/Production/figures/COMPARISONS/normalizedSIP_ALL.png', '-dpng', '-r400');

figure; plot_dim(1230,270);
plot(dn, E, 'linewidth', 1);
xticks(dnticker(1997,2021)); datetick('x', 'mm-yyyy', 'keepticks'); xtickangle(27);
xlim([min(dn)-50, max(dn)+50]);
colororder(c);
legend(secs, 'location', 'north', 'orientation', 'horizontal')
title('Normalized net export')
grid on
print('ICE/Production/figures/COMPARISONS/normalizedE_ALL.png', '-dpng', '-r400');

figure; plot_dim(1230,270);
plot(dn, IN, 'linewidth', 1);
xticks(dnticker(1997,2021)); datetick('x', 'mm-yyyy', 'keepticks'); xtickangle(27);
xlim([min(dn)-50, max(dn)+50]);
colororder(c);
legend(secs, 'location', 'north', 'orientation', 'horizontal')
title('Normalized positive import')
grid on
print('ICE/Production/figures/COMPARISONS/normalizedicein_ALL.png', '-dpng', '-r400');

figure; plot_dim(1230,270);
plot(dn, OUT, 'linewidth', 1);
xticks(dnticker(1997,2021)); datetick('x', 'mm-yyyy', 'keepticks'); xtickangle(27);
xlim([min(dn)-50, max(dn)+50]);
colororder(c);
legend(secs, 'location', 'north', 'orientation', 'horizontal')
title('Normalized positive export')
grid on
print('ICE/Production/figures/COMPARISONS/normalizediceout_ALL.png', '-dpng', '-r400');

% Plot groups separately 
% 1:7
% 8:12
% 13:18
g{1} = 1:7;
g{2} = 8:12;
g{3} = 13:18;
namer = {'1-7', '8-12', '13-18'};
for ii = 1:3
    
    figure; plot_dim(1230,270);
    plot(dn, P(:,g{ii}), 'linewidth', 1);
    xticks(dnticker(1997,2021)); datetick('x', 'mm-yyyy', 'keepticks'); xtickangle(27);
    xlim([min(dn)-50, max(dn)+50]);
    legend(secs{g{ii}}, 'location', 'north', 'orientation', 'horizontal')
    title('Normalized SIP')
    colororder(c(g{ii},:));
    grid on
    print(['ICE/Production/figures/COMPARISONS/normalizedSIP_secs',namer{ii},'.png'], '-dpng', '-r400');
    
    figure; plot_dim(1230,270);
    plot(dn, E(:,g{ii}), 'linewidth', 1);
    xticks(dnticker(1997,2021)); datetick('x', 'mm-yyyy', 'keepticks'); xtickangle(27);
    xlim([min(dn)-50, max(dn)+50]);
    legend(secs{g{ii}}, 'location', 'north', 'orientation', 'horizontal')
    title('Normalized net export')
    colororder(c(g{ii},:));
    grid on
    print(['ICE/Production/figures/COMPARISONS/normalizedE_secs',namer{ii},'.png'], '-dpng', '-r400');
    
    figure; plot_dim(1230,270);
    plot(dn, IN(:,g{ii}), 'linewidth', 1);
    xticks(dnticker(1997,2021)); datetick('x', 'mm-yyyy', 'keepticks'); xtickangle(27);
    xlim([min(dn)-50, max(dn)+50]);
    legend(secs{g{ii}}, 'location', 'north', 'orientation', 'horizontal')
    title('Normalized positive import')
    colororder(c(g{ii},:));
    grid on
    print(['ICE/Production/figures/COMPARISONS/normalizedicein_secs',namer{ii},'.png'], '-dpng', '-r400');
    
    figure; plot_dim(1230,270);
    plot(dn, OUT(:,g{ii}), 'linewidth', 1);
    xticks(dnticker(1997,2021)); datetick('x', 'mm-yyyy', 'keepticks'); xtickangle(27);
    xlim([min(dn)-50, max(dn)+50]);
    legend(secs{g{ii}}, 'location', 'north', 'orientation', 'horizontal')
    title('Normalized positive export')
    colororder(c(g{ii},:));
    grid on
    print(['ICE/Production/figures/COMPARISONS/normalizediceout_secs',namer{ii},'.png'], '-dpng', '-r400');
    
    
end

