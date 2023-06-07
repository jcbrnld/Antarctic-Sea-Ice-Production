% Jacob Arnold

% 07-Jul-2022

% Try filtering SIP data at different lengths

filtlength = 16;

secs = ja_aagatedregions(0);
for ii = 1:length(secs)
    sector = secs{ii};
    load(['ICE/Production/data/SIP/sector',sector,'.mat']);
    
    f = filtout(SIP.P, filtlength, 'boxcar');
    
    
    figure; plot_dim(1000,250);
    plot(SIP.dn, SIP.P, 'color', [0.5,0.7,0.5,0.7]);
    hold on
    plot(SIP.dn, f, 'color', [0.1,0.3,0.1], 'linewidth',1.1);
    xticks(dnticker(1997,2022));
    datetick('x', 'mm-yyyy', 'keepticks');
    xtickangle(30);
    xlim([min(SIP.dn)-50, max(SIP.dn)+50]);
    grid on
    title(['Sector ',sector,' SIP with ',num2str(filtlength),' week low pass filter']);
    ylabel('SIP [km^3/week]');
    
    
    print(['ICE/Production/figures/SIP/weekly/filtered/length',num2str(filtlength),'/sector',sector,'_',num2str(filtlength),'-weekLPfilt.png'], '-dpng', '-r400');
    
    clearvars -except filtlength secs
end

    
    
    
    
    
    


