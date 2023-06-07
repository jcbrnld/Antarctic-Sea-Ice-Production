% Jacob Arnold

% 07-Jul-2022

% Compare fancy borders (flux gates with more inflections which more
% closely follow the 1000 m isobath) VS simple borders (flux gates with as
% few inflections as reasonably possible)


secs = ja_aagatedregions(0);
for ii = 1:length(secs)
    sector = secs{ii};
    
    loadname1 = ['ICE/Production/data/SIP/sector',sector,'.mat'];
    load(loadname1);
    sSIP = SIP;
    clear SIP;
    
    loadname2 = ['ICE/Production/data/SIP/old_SIPproducts/fancy_borders/sector',sector,'.mat'];
    if exist(loadname2)==0
        continue
    else
        load(['ICE/Production/data/SIP/old_SIPproducts/fancy_borders/sector',sector,'.mat']);
        fSIP = SIP;
        clear SIP
    end

    %

    figure;
    plot_dim(900,270);
    p1 = plot(fSIP.year.dn, fSIP.year.P, 'linewidth', 1.1);
    hold on
    p2 = plot(sSIP.year.dn, sSIP.year.P, 'linewidth', 1.1);
    xticks(dnticker(1997,2021));
    datetick('x', 'mm-yyyy', 'keepticks');
    xtickangle(30);
    xlim([min(fSIP.year.dn)-50, max(fSIP.year.dn)+50]);
    grid on
    legend([p1, p2], 'Complex Gate', 'Simple Gate', 'fontsize', 13);
    ylabel('SIP [km^3]');
    title(['Sector ',sector,' Complex vs Simple flux gates']);
    
    print(['ICE/Production/figures/COMPARISONS/fancyVSsimple/yearly/sector',sector,'gatecompare.png'], '-dpng', '-r300');
    clearvars -except secs
    
end



%% same but monthly


secs = ja_aagatedregions(0);
for ii = 1:length(secs)
    sector = secs{ii};
    
    loadname1 = ['ICE/Production/data/SIP/sector',sector,'.mat'];
    load(loadname1);
    sSIP = SIP;
    clear SIP;
    
    loadname2 = ['ICE/Production/data/SIP/old_SIPproducts/fancy_borders/sector',sector,'.mat'];
    if exist(loadname2)==0
        continue
    else
        load(['ICE/Production/data/SIP/old_SIPproducts/fancy_borders/sector',sector,'.mat']);
        fSIP = SIP;
        clear SIP
    end

    %

    figure;
    plot_dim(900,270);
    p1 = plot(fSIP.month.dn, fSIP.month.P, 'linewidth', 1.1);
    hold on
    p2 = plot(sSIP.month.dn, sSIP.month.P, 'linewidth', 1.1);
    xticks(dnticker(1997,2021));
    datetick('x', 'mm-yyyy', 'keepticks');
    xtickangle(30);
    xlim([min(fSIP.year.dn)-50, max(fSIP.year.dn)+50]);
    grid on
    legend([p1, p2], 'Complex Gate', 'Simple Gate', 'fontsize', 13);
    ylabel('SIP [km^3]');
    title(['Sector ',sector,' Complex vs Simple flux gates']);
    
    print(['ICE/Production/figures/COMPARISONS/fancyVSsimple/sector',sector,'MONTHgatecompare.png'], '-dpng', '-r300');
    clearvars -except secs
    
end







































