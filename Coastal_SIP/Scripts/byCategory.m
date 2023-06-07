% Jacob Arnold

% 09-Jun-2022

% make non-normlaized plots of sectors with similar features in the
% normalized plots (see ICE/Production/figures/COMPARISON/normalized)


secs = {'08', '09', '10', '11', '12'};
for ii = 1:length(secs)
    sector = secs{ii};
    load(['ICE/Production/data/SIP/sector',sector,'.mat']);
    

    P(:,ii) = SIP.year.P;
    IN(:,ii) = SIP.year.icein;
    OUT(:,ii) = SIP.year.iceout;
    growIN(:,ii) = SIP.grow.icein;
    growOUT(:,ii) = SIP.grow.iceout;
    decayIN(:,ii) = SIP.decay.icein;
    decayOUT(:,ii) = SIP.decay.iceout;
    
    dn = SIP.year.dn;
    clear SIP
end
c = distinguishable_colors(18);
figure;plot_dim(1000,270);
plot(dn, P, 'linewidth', 1);
xticks(dnticker(1997,2021)); datetick('x', 'mm-yyyy', 'keepticks'); xtickangle(27);
xlim([min(dn)-50, max(dn)+50]);
ylim([-100,220]);
grid on
title('Yearly Sea Ice Production');
ylabel('SIP [km^3]');
legend(secs, 'location', 'north', 'orientation', 'horizontal')
colororder(c(8:12,:))
print('ICE/Production/figures/COMPARISONS/sectors_08to12/SIP.png', '-dpng', '-r300');

figure;plot_dim(1000,270);
plot(dn, IN, 'linewidth', 1);
xticks(dnticker(1997,2021)); datetick('x', 'mm-yyyy', 'keepticks'); xtickangle(27);
xlim([min(dn)-50, max(dn)+50]);
ylim([0,300]);corrco
grid on
title('Yearly Sea Ice Import');
ylabel('SIP [km^3]');
legend(secs, 'location', 'north', 'orientation', 'horizontal')
colororder(c(8:12,:))
print('ICE/Production/figures/COMPARISONS/sectors_08to12/icein.png', '-dpng', '-r300');

figure;plot_dim(1000,270);
plot(dn, OUT, 'linewidth', 1);
xticks(dnticker(1997,2021)); datetick('x', 'mm-yyyy', 'keepticks'); xtickangle(27);
xlim([min(dn)-50, max(dn)+50]);
ylim([0,300]);
grid on
title('Yearly Sea Ice positive export');
ylabel('SIP [km^3]');
legend(secs, 'location', 'north', 'orientation', 'horizontal')
colororder(c(8:12,:))
print('ICE/Production/figures/COMPARISONS/sectors_08to12/iceout.png', '-dpng', '-r300');

% Seasons
% grow/decay
figure;plot_dim(1000,270);
plot(dn, growIN, 'linewidth', 1);
xticks(dnticker(1997,2021)); datetick('x', 'mm-yyyy', 'keepticks'); xtickangle(27);
xlim([min(dn)-50, max(dn)+50]);
ylim([0,200]);
grid on
title('Growing Season Sea Ice import');
ylabel('SIP [km^3]');
legend(secs, 'location', 'north', 'orientation', 'horizontal')
colororder(c(8:12,:))
print('ICE/Production/figures/COMPARISONS/sectors_08to12/growIcein.png', '-dpng', '-r300');

figure;plot_dim(1000,270);
plot(dn, growOUT, 'linewidth', 1);
xticks(dnticker(1997,2021)); datetick('x', 'mm-yyyy', 'keepticks'); xtickangle(27);
xlim([min(dn)-50, max(dn)+50]);
ylim([0,200]);
grid on
title('Growing Season Sea Ice positive export');
ylabel('SIP [km^3]');
legend(secs, 'location', 'north', 'orientation', 'horizontal')
colororder(c(8:12,:))
print('ICE/Production/figures/COMPARISONS/sectors_08to12/growIceout.png', '-dpng', '-r300');

figure;plot_dim(1000,270);
plot(dn, decayIN, 'linewidth', 1);
xticks(dnticker(1997,2021)); datetick('x', 'mm-yyyy', 'keepticks'); xtickangle(27);
xlim([min(dn)-50, max(dn)+50]);
ylim([0,200]);
grid on
title('Decaying Season Sea Ice Import');
ylabel('SIP [km^3]');
legend(secs, 'location', 'north', 'orientation', 'horizontal')
colororder(c(8:12,:))
print('ICE/Production/figures/COMPARISONS/sectors_08to12/decayIcein.png', '-dpng', '-r300');

figure;plot_dim(1000,270);
plot(dn, decayOUT, 'linewidth', 1);
xticks(dnticker(1997,2021)); datetick('x', 'mm-yyyy', 'keepticks'); xtickangle(27);
xlim([min(dn)-50, max(dn)+50]);
ylim([0,200]);
grid on
title('Decaying Season Sea Ice Positive Export');
ylabel('SIP [km^3]');
legend(secs, 'location', 'north', 'orientation', 'horizontal')
colororder(c(8:12,:))
print('ICE/Production/figures/COMPARISONS/sectors_08to12/decayIceout.png', '-dpng', '-r300');







