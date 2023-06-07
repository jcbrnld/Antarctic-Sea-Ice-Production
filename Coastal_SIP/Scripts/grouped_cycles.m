% Jacob Arnold

% 15-Aug-2022

% Create plots of climatological annual cycles of SIP for groups of sectors 



%% Start with sinks

figure; plot_dim(600,290);
colororder(colormapinterp(mycolormap('grp'), 4));
secs = {'01', '08C', '12A', '18A'};
for ii = 1:length(secs)
    sector = secs{ii};
    load(['ICE/Production/data/SIP/sector',sector,'.mat']);

    plot(1:13, SIP.RLmonthly.P, 'linewidth', 1.1);
    hold on
end
yline(0, '--', 'linewidth', 1.1, 'color', [0.01,.01,.01]);
secnames = {'W. Weddell', 'Bowman', 'Adelie', 'Marguerite'};
legend(secnames);
xlim([.7,13.3]);
xticks(1:12);
xticklabels({'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'});
ylabel('Monthly SIP [km^3]');
print(['ICE/Production/figures/SIP/Monthly/grouped/sinkSectors.png'], '-dpng', '-r500');
