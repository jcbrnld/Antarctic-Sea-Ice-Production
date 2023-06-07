% Jacob Arnold

% 17-May-2022

% More production plots


% monthly and yearly timeseries
secs = ja_aagatedregions(0);
for ss = 1:length(secs)
    sector = secs{ss};
    
    load(['ICE/Production/data/SIP/sector',sector,'.mat']);
    mi = min([min(SIP.year.P), min(SIP.year.E), min(SIP.year.dSIV)]);
    ma = max([max(SIP.year.P), max(SIP.year.E), max(SIP.year.dSIV)]);
    
    figure;
    plot_dim(900,270);
    plot(SIP.year.dn, SIP.year.P, 'color', [.01,.01,.01], 'linewidth', 1.1);
    hold on
    %plot(SIP.year.dn, SIP.year.E, 'color', [0.8,0.3,0.25], 'linewidth', 1.1);
    %plot(SIP.year.dn, SIP.year.dSIV, 'color', [0.2,0.7,0.4], 'linewidth', 1.1);
    plot(SIP.year.dn, SIP.year.E, 'color', 'm', 'linewidth', 1.1);
    plot(SIP.year.dn, SIP.year.dSIV, 'color', [0.2,0.86,0.92], 'linewidth', 1.1);
    xticks(dnticker(1997,2021));
    datetick('x', 'mm-yyyy', 'keepticks');
    xtickangle(27);
    xlim([min(SIP.dn), max(SIP.dn)]);
    grid on
    title(['Sector ',sector,' Yearly SIP']);
    ylabel('SIP [km^3]');
    legend('Production', 'Export', '\DeltaSIV', 'orientation', 'horizontal', 'location', 'south', 'fontsize', 11);
    ylim([mi-(ma-mi)*0.17, ma+ma/20]);
    print(['ICE/Production/figures/SIP/yearly_timeseries/sector',sector,'yearly.png'], '-dpng', '-r300');
    
    
    mi = min([min(SIP.month.P), min(SIP.month.E), min(SIP.month.dSIV)]);
    ma = max([max(SIP.month.P), max(SIP.month.E), max(SIP.month.dSIV)]);
    
    figure;
    plot_dim(900,270);
    plot(SIP.month.dn, SIP.month.P, 'color', [.01,.01,.01], 'linewidth', 1.1);
    hold on
    plot(SIP.month.dn, SIP.month.E, 'color', 'm', 'linewidth', 1.1);
    plot(SIP.month.dn, SIP.month.dSIV, 'color', [0.2,0.86,0.92], 'linewidth', 1.1);
    %yline(nanmean(SIP.month.dSIV), '--', 'color', [0.2,0.86,0.92], 'linewidth', 1.1);
    xticks(dnticker(1997,2021));
    datetick('x', 'mm-yyyy', 'keepticks');
    xtickangle(27);
    xlim([min(SIP.dn), max(SIP.dn)]);
    grid on
    title(['Sector ',sector,' Monthly SIP']);
    ylabel('SIP [km^3]');
    legend(['Production: mean=',num2str(nanmean(SIP.month.P))], ['Export: mean=', num2str(nanmean(SIP.month.E))], ['\DeltaSIV: mean=',num2str(nanmean(SIP.month.dSIV))], 'orientation', 'horizontal', 'location', 'south', 'fontsize', 11);
    ylim([mi-(ma-mi)*0.17, ma+ma/20]);
    print(['ICE/Production/figures/SIP/monthly_timeseries/sector',sector,'monthly.png'], '-dpng', '-r300');
    
    clearvars -except secs
end



%% production and SAM and ENSO

load ICE/ENSO_SAM/indices.mat
for ss = 14
    if ss < 10
        sector = ['0',num2str(ss)];
    else
        sector = num2str(ss);
    end
    
    load(['ICE/Production/data/SIP/sector',sector,'.mat']);



    
    figure;
    colororder([0.1,0.3,0.5; 0.7,0.1,0.65; 0.3,0.8,0.7]);
    yyaxis('left')
     
    plot(SIP.month.dn, SIP.month.P);
    hold on; plot_dim(900,270);
    xticks(dnticker(1997,2021));
    datetick('x', 'mm-yyyy', 'keepticks');
    xtickangle(30);
    xlim([min(SIP.dn), max(SIP.dn)]);
    ylabel('SIP [km^3 month^-^1]');
    
    yyaxis('right')
    plot(indices.month.sdn(493:768), indices.month.SAM(493:768))
    ylabel('SAM Index');
    yline(0, '--');

    title(['Sector ',sector,' SIP and SAM Index']);
end










