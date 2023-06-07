% Create combined seasonal SIP timeseries 


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
for mm = 1:length(secs)
    sector = secs{mm};
    disp(['Adding combined seasonal to sector ',sector,'...']);
    load(['ICE/Production/data/SIP/without_combined_seasonal/sector',sector,'.mat']);


    counter = 1;
    for ii = 1:23
        sdv(counter,1:3) = SIP.summer.dv(ii,:);
        sP(counter) = SIP.summer.P(ii);
        sE(counter) = SIP.summer.E(ii);
        sdSIV(counter) = SIP.summer.dSIV(ii);

        counter = counter+1;

        sdv(counter,1:3) = SIP.fall.dv(ii,:);
        sP(counter) = SIP.fall.P(ii);
        sE(counter) = SIP.fall.E(ii);
        sdSIV(counter) = SIP.fall.dSIV(ii);

        counter = counter+1;

        sdv(counter,1:3) = SIP.winter.dv(ii,:);
        sP(counter) = SIP.winter.P(ii);
        sE(counter) = SIP.winter.E(ii);
        sdSIV(counter) = SIP.winter.dSIV(ii);

        counter = counter+1;

        sdv(counter,1:3) = SIP.spring.dv(ii,:);
        sP(counter) = SIP.spring.P(ii);
        sE(counter) = SIP.spring.E(ii);
        sdSIV(counter) = SIP.spring.dSIV(ii);


        counter = counter+1;

    end

    sdn = datenum(sdv);
    ma = max([max(SIP.winter.P), max(SIP.spring.P), max(SIP.summer.P), max(SIP.fall.P)]);
        mi = min([min(SIP.winter.P), min(SIP.spring.P), min(SIP.summer.P), min(SIP.fall.P)]);

    p = polyfit(sdn, sP', 1);
    y = polyval(p, sdn); slope = round(((y(2)-y(1))/(sdn(2)-sdn(1)))*3652.4*100)/100; % slope /decade
    sper = slope/y(1)*100;
    
    figure;plot_dim(900,270);
    plot(sdn, sP, 'color', [.01,.01,.01], 'linewidth', 1.2);
    hold on
    s1 = scatter(SIP.winter.dn, SIP.winter.P, 26, [0.1,0.5,0.8], 'filled');
    s2 = scatter(SIP.spring.dn, SIP.spring.P, 26, [0.1,0.6,0.4], 'filled');
    s3 = scatter(SIP.summer.dn, SIP.summer.P, 26, [0.9,0.3,0.75], 'filled');
    s4 = scatter(SIP.fall.dn, SIP.fall.P, 26, [0.9,0.6,0.3], 'filled'); 
    l = plot(sdn, y, '--', 'color', [.01,.01,.01], 'linewidth', 1);
    xticks(dnticker(1997,2021));
    datetick('x', 'mm-yyyy', 'keepticks');
    xtickangle(30);
    xlim([min(SIP.dn), max(SIP.dn)]);
    title(['Sector ',sector,' Seasonal SIP']);
    ylim([mi-(ma-mi)*0.17, ma+ma/20]);
    legend([s1,s3,l], 'Winter', 'Summer', ['Slope = ',num2str(slope),' km^3 dec^-^1'],...
        'fontsize', 10, 'location', 'south', 'orientation', 'horizontal');

    ylabel('SIP [km^3 season^-^1]');
    grid on
    
    SIP.seasonal.P = sP;
    SIP.seasonal.E = sE;
    SIP.seasonal.dSIV = sdSIV;
    SIP.seasonal.dv = sdv;
    SIP.seasonal.dn = datenum(sdv);
    
    
    
    save(['ICE/Production/data/SIP/noJunkinJunkout/sector',sector,'.mat'], 'SIP', '-v7.3');
    
    print(['ICE/Production/figures/SIP/season_timeseries/sector',sector,'seasonal.png'], '-dpng', '-r400');

    clearvars -except secs
end