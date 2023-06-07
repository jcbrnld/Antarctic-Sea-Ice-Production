% Jacob Arnold
% 09-Mar-2023

% grab SIP mean yearly +/- error estimates


clear all
lists = {'all', 'only valid', 'special', '-99 sectors'};
selection = listdlg('liststring', lists, 'promptstring', 'Which sector category?', 'selectionmode', 'single');
if selection == 1
    secs = ja_aagatedregions(0); 
elseif selection == 2
    secs = ja_aagatedregions(3);
elseif selection == 3
    secs = ja_aagatedregions(4);
elseif selection == 4
    secs = ja_aagatedregions(-99);    
end
for mm = 1:length(secs) %only for valid secs
    sector = secs{mm};
    load(['ICE/Production/data/SIP_with_error/sector',sector,'.mat']);
    m = nanmean(SIP.year.P);
    mu = nanmean(SIP.year.Pup);
    ml = nanmean(SIP.year.Plo);

    % build table of yearly means
    % columns are sectors
    % rows are: 
                % mean SIP
                % mean SIP upper bound
                % mean SIP lower bound
                % SIP+error
                % SIP-error
                % +%
                % -%
                
    tab(1,mm) = m;
    tab(2,mm) = mu;
    tab(3,mm) = ml;
    tab(4,mm) = mu-m;
    tab(5,mm) = m-ml;
    tab(6,mm) = (tab(4,mm)/tab(1,mm))*100;
    tab(7,mm) = (tab(5,mm)/tab(1,mm))*100;
    
    
    figure;plot_dim(900,200)
    plot(SIP.year.dn, SIP.year.P, 'linewidth', 1, 'color', 'm');
    hold on
    plot(SIP.year.dn, SIP.year.Pup, 'linewidth', 1, 'color', [.05,.05,.05]);
    plot(SIP.year.dn, SIP.year.Plo, 'linewidth', 1, 'color', [.05,.05,.05]);
    xticks(dnticker(1997,2022));
    datetick('x', 'yy', 'keepticks');
    grid on
    ylabel('Yearly SIP [km^3]');
    title(['Sector ',sector,' yearly SIP with error bounds']);
    ylim([min([SIP.year.P,SIP.year.Pup,SIP.year.Plo])-abs(m)*0.5, max([SIP.year.P,SIP.year.Pup,SIP.year.Plo])+abs(m)*0.5]);
    xlim([min(SIP.year.dn)-50, max(SIP.year.dn)+50]);
    
    print(['ICE/Production/figures/Error_Bounds/sector',sector,'witherror.png'], '-dpng', '-r300');
    
    clearvars -except tab secs
end
    
