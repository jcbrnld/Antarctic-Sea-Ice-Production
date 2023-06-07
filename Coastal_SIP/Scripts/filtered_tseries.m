% Jacob Arnold

% 07-Sep-2022

% Make 16 week filtered timeseries of SIP, dSIV, and E
% See Cody's thesis page 25


secs = ja_aagatedregions(3);

for ii = 1%:length(secs)
    sector = secs{ii};
    load(['ICE/Production/data/SIP/sector',sector,'.mat']);
    
    P = filtout(SIP.P, 16);
    dSIV = filtout(SIP.dSIV, 16);
    E = filtout(SIP.E, 16);

    % find range
    ma = max([max(dSIV), max(E)]);
    mi = min([min(dSIV), min(E)]);
    ra = ma-mi;
    
    % dSIV and E
    figure;plot_dim(1090,230);
    yline(0, '--','color', [.01,.01,.01], 'linewidth', 1.1);    hold on
    p1 = plot(SIP.dn, dSIV, 'color', [0.4,0.7,0.5], 'linewidth', 1.1);
    p2 = plot(SIP.dn, E, 'color', [0.85,0.1,0.1], 'linewidth', 1.1);
    xticks(dnticker(1997,2022));
    datetick('x', 'yyyy', 'keepticks');
    %xtickangle(27)
    xlim([min(SIP.dn)-50, max(SIP.dn)+50]);
    grid on
    ylabel('[km^3]', 'fontsize', 12)
    ylim([mi-ra*.2, ma+ra*.2]);
    legend([p2, p1], 'Net SIV Exchange', 'Interior SIV Change', 'location', 'northeastoutside', 'fontsize', 13)
    title(['Sector ',sector]);
    box on
    print(['ICE/Production/figures/16_week_filt/sector',sector,'dSIVandE.png'], '-dpng', '-r500');
    

    % P
    pra = max(P)-min(P);
    
    figure;plot_dim(1000,230);
    yline(0, 'color', [.01,.01,.01], 'linewidth', 1);    hold on
    p3 = plot(SIP.dn, P, 'linewidth', 1.1, 'color', [0.3,0.6,0.8]);
    xticks(dnticker(1997,2022));
    datetick('x', 'yyyy', 'keepticks');
    %xtickangle(27)
    xlim([min(SIP.dn)-50, max(SIP.dn)+50]);
    grid on
    ylabel('[km^3]', 'fontsize', 12)
    %ylim([min(P)-pra*.2, max(P)+pra*.2]);
    ylim([mi-ra*.3, ma+ra*.3]); % same ylim
    legend([p3], 'SIP', 'location', 'northeastoutside', 'fontsize', 13)
    title(['Sector ',sector]);
    box on
    print(['ICE/Production/figures/16_week_filt/sector',sector,'SIP.png'], '-dpng', '-r500');
    

    clearvars -except secs
end



%% Plot icein and iceout in the same way 

secs = ja_aagatedregions(3);

for ii = 1:length(secs)
    sector = secs{ii};
    load(['ICE/Production/data/SIP/sector',sector,'.mat']);
    
    in = filtout(SIP.icein, 16);
    out = filtout(SIP.iceout, 16);
    E = filtout(SIP.E, 16);

    % find range
    ma = max([max(in), max(out)]);
    mi = min([min(in), min(out)]);
    ra = ma-mi;
    
    % dSIV and E
    figure;plot_dim(1015,230);
    yline(0, '--','color', [.01,.01,.01], 'linewidth', 1);    hold on
    p1 = plot(SIP.dn, in, 'color', [0.2,0.8,0.7], 'linewidth', 1);
    p2 = plot(SIP.dn, out, 'color', [0.9,0.6,0.3], 'linewidth', 1);
    %p3 = plot(SIP.dn, E, 'color', [0.01,0.01,0.01, 0.4], 'linewidth', 1.1);
    xticks(dnticker(1997,2022));
    datetick('x', 'yyyy', 'keepticks');
    %xtickangle(27)
    xlim([min(SIP.dn)-50, max(SIP.dn)+50]);
    grid on
    ylabel('[km^3]', 'fontsize', 12)
    ylim([mi-ra*.2, ma+ra*.2]);
    %legend([p2, p1, p3], 'Gross Export', 'Gross Import', 'Net Export', 'location', 'south', 'orientation', 'horizontal', 'fontsize', 13)
    legend([p2, p1] , 'Export', 'Import', 'location', 'northeastoutside', 'fontsize', 13)
    title(['Sector ',sector]);
    box on
    print(['ICE/Production/figures/16_week_filt/sector',sector,'icein_iceout.png'], '-dpng', '-r500');
    

    clearvars -except secs
end











