% Jacob Arnold

% 16-May-2022

% Create seasonal timeseries of SIP for sectors 00-18
% - plot winter and summer and all 4 seasons as anomaly timeseries 
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
    
    load(['ICE/Production/data/SIP/without_seasonal/sector',sector,'.mat']);


    % Sum the seasons 
    yrs = (1998:2020)';
    for ii = 1:length(yrs)

         wii = find(((SIP.daydv(:,2)==6 & SIP.daydv(:,3)>=16) | (SIP.daydv(:,2)==7) |... % winter index for year(ii)
        (SIP.daydv(:,2)==8) | (SIP.daydv(:,2)==9 & SIP.daydv(:,3)<=15)) & SIP.daydv(:,1)==yrs(ii));
        spi = find(((SIP.daydv(:,2)==9 & SIP.daydv(:,3)>=16) | (SIP.daydv(:,2)==10) |... % spring index for year(ii)
        (SIP.daydv(:,2)==11) | (SIP.daydv(:,2)==12 & SIP.daydv(:,3)<=15)) & SIP.daydv(:,1)==yrs(ii));
        sui = find(((SIP.daydv(:,2)==12 & SIP.daydv(:,3)>=16) | (SIP.daydv(:,2)==1) |... % summer index for year(ii)
        (SIP.daydv(:,2)==2) | (SIP.daydv(:,2)==3 & SIP.daydv(:,3)<=15)) & SIP.daydv(:,1)==yrs(ii));
        aui = find(((SIP.daydv(:,2)==3 & SIP.daydv(:,3)>=16) | (SIP.daydv(:,2)==4) |... % fall index for year(ii)
        (SIP.daydv(:,2)==5) | (SIP.daydv(:,2)==6 & SIP.daydv(:,3)<=15)) & SIP.daydv(:,1)==yrs(ii));

        wintP(ii) = sum(SIP.dayP(wii), 'omitnan');
        wintT(ii) = sum(SIP.dayT(wii));
        wintDSIV(ii) = sum(SIP.dayDSIV(wii));

        spriP(ii) = sum(SIP.dayP(spi));
        spriT(ii) = sum(SIP.dayT(spi));
        spriDSIV(ii) = sum(SIP.dayDSIV(spi));

        summP(ii) = sum(SIP.dayP(sui));
        summT(ii) = sum(SIP.dayT(sui));
        summDSIV(ii) = sum(SIP.dayDSIV(sui));

        fallP(ii) = sum(SIP.dayP(aui));
        fallT(ii) = sum(SIP.dayT(aui));
        fallDSIV(ii) = sum(SIP.dayDSIV(aui));


        clear wii spi sui aui

    end

    %   Winter               Spring               Summer                Fall
    wintdv(:,1) = yrs;   spridv(:,1) = yrs;   summdv(:,1) = yrs;   falldv(:,1) = yrs;
    wintdv(:,2) = 8;     spridv(:,2) = 11;    summdv(:,2) = 2;     falldv(:,2) = 5;
    wintdv(:,3) = 1;     spridv(:,3) = 1;     summdv(:,3) = 1;     falldv(:,3) = 1;

    wintdn = datenum(wintdv);
    spridn = datenum(spridv);
    summdn = datenum(summdv);
    falldn = datenum(falldv);

    o = SIP; clear SIP;
    
    % add seasons to structure and save
    SIP.winter.P = wintP;
    SIP.winter.E = wintT;
    SIP.winter.dSIV = wintDSIV;
    SIP.winter.dn = wintdn;
    SIP.winter.dv = wintdv;

    SIP.spring.P = spriP;
    SIP.spring.E = spriT;
    SIP.spring.dSIV = spriDSIV;
    SIP.spring.dn = spridn;
    SIP.spring.dv = spridv;

    SIP.summer.P = summP;
    SIP.summer.E = summT;
    SIP.summer.dSIV = summDSIV;
    SIP.summer.dn = summdn;
    SIP.summer.dv = summdv;

    SIP.fall.P = fallP;
    SIP.fall.E = fallT;
    SIP.fall.dSIV = fallDSIV;
    SIP.fall.dn = falldn;
    SIP.fall.dv = falldv;


    % Improve organization in SIP structures 
    SIP.P = o.P;
    SIP.E = o.transport;
    SIP.dSIV = o.dSIV;
    SIP.dn = o.pdn;
    SIP.dv = o.pdv;
    SIP.longdn = o.longdn;
    SIP.longdv = o.longdv;
    SIP.day.P = o.dayP;
    SIP.day.E = o.dayT;
    SIP.day.dSIV = o.dayDSIV;
    SIP.day.dn = o.daydn;
    SIP.day.dv = o.daydv;
    SIP.month.P = o.monthP;
    SIP.month.E = o.monthT;
    SIP.month.dSIV = o.monthDSIV;
    SIP.month.dn = o.monthdn;
    SIP.month.dv = o.monthdv;
    SIP.year.P = o.yearP;
    SIP.year.E = o.yearT;
    SIP.year.dSIV = o.yearDSIV;
    SIP.year.dn = o.yeardn;
    SIP.year.dv = o.yeardv;
    SIP.RLmonthly = o.RLmonthly_mean;
    SIP.comment{1,1} = 'P = sea ice PRODUCTION [km^3/(day or week or month or season or year)]';
    SIP.comment{2,1} = 'E is sea ice EXPORT across the flux gate. same units as P';
    SIP.comment{3,1} = 'dSIV is CHANGE IN SIV within the gate from week to week. same units as P';
    SIP.comment{4,1} = 'E (and therefore P) only extend through 2020 while dSIV reaches through 2021';
    SIP.comment{5,1} = 'Day, month, season, and year are summed P, E, and dSIV over the respective periods. ie the units change from km^3/week to km^3/(year or month or season)';



    save(['ICE/Production/data/SIP/without_combined_seasonal/sector',sector,'.mat'], 'SIP', '-v7.3');

    clearvars -except secs
end

%% Secion 2 Fix SIP.E in 00 SKIP IF not working with sector 00 right now

load ICE/Production/data/SIP/without_combined_seasonal/sector00.mat;

SIP.E = SIP.E(:,1);

save('ICE/Production/data/SIP/without_combined_seasonal/sector00.mat', 'SIP', '-v7.3');
%% Section 3: NOW create the timeseries plots
% First the anomaly timeseries

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
    
    load(['ICE/Production/data/SIP/without_combined_seasonal/sector',sector,'.mat']);
    msize = 15;
    % winter anomaly
    wia = SIP.winter.P-nanmean(SIP.winter.P);
    % spring anomaly
    spa = SIP.spring.P-nanmean(SIP.spring.P);
    % summer anomaly
    sua = SIP.summer.P-nanmean(SIP.summer.P);
    % Fall anomaly
    faa = SIP.fall.P-nanmean(SIP.fall.P);
    mins = [min(wia), min(spa), min(sua), min(faa)]; maxes = [max(wia), max(spa), max(sua), max(faa)];
    ma = max(maxes); mi = min(mins);
    figure;
    plot_dim(900,270);
    p1 = plot(SIP.winter.dn, wia, '.-','markersize', msize,'color', [0.1,0.5,0.8], 'linewidth', 1.1);
    hold on
    p2 = plot(SIP.spring.dn, spa,'.-','markersize', msize, 'color', [0.1,0.6,0.4], 'linewidth', 1.1);
    p3 = plot(SIP.summer.dn, sua,'.-','markersize', msize, 'color', [0.9,0.3,0.75], 'linewidth', 1.1);
    p4 = plot(SIP.fall.dn, faa, '.-','markersize', msize,'color', [0.9,0.6,0.3], 'linewidth', 1.1);
   yline(0,  'color', [0.1,0.1,0.1], 'linewidth', 0.7);
    xticks(dnticker(1997,2021));
    datetick('x', 'mm-yyyy', 'keepticks');
    xtickangle(27);
    xlim([min(SIP.dn)-10, max(SIP.dn)+10]);
    legend([p1,p2,p3,p4], 'Winter', 'Spring', 'Summer', 'Fall',...
        'location', 'south', 'orientation', 'horizontal', 'fontsize', 11)
    grid on
    title(['Sector ', sector, ' Seasonal SIP Anomaly']);
    ylabel('SIP Anomaly [km^3]');
    ylim([mi+mi*.5, ma+ma/20]);

    print(['ICE/Production/figures/SIP/season_anomaly/sector',sector,'seasonAnom.png'], '-dpng', '-r400');
    clearvars -except secs

end




%% Section 4: Now the non-anomaly timeseries

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
    load(['ICE/Production/data/SIP/without_combined_seasonal/sector',sector,'.mat']);
    
    ma = max([max(SIP.winter.P), max(SIP.spring.P), max(SIP.summer.P), max(SIP.fall.P)]);
    mi = min([min(SIP.winter.P), min(SIP.spring.P), min(SIP.summer.P), min(SIP.fall.P)]);
   msize = 13;
    figure;
    plot_dim(900,270);
    p1 = plot(SIP.winter.dn, SIP.winter.P, '.-','markersize', msize,'color', [0.1,0.5,0.8], 'linewidth', 1.1);
    hold on
    yline(nanmean(SIP.winter.P), '--', 'color', [0.1,0.5,0.8], 'linewidth', 1);
    p2 = plot(SIP.spring.dn, SIP.spring.P,'.-','markersize', msize, 'color', [0.1,0.6,0.4], 'linewidth', 1.1);
    yline(nanmean(SIP.spring.P), '--', 'color', [0.1,0.6,0.4], 'linewidth', 1);
    p3 = plot(SIP.summer.dn, SIP.summer.P,'.-','markersize', msize, 'color', [0.9,0.3,0.75], 'linewidth', 1.1);
    yline(nanmean(SIP.summer.P), '--', 'color', [0.9,0.3,0.75], 'linewidth', 1);
    p4 = plot(SIP.fall.dn, SIP.fall.P, '.-','markersize', msize,'color', [0.9,0.6,0.3], 'linewidth', 1.1);
    yline(nanmean(SIP.fall.P), '--', 'color', [0.9,0.6,0.3], 'linewidth', 1);
    yline(0,  'color', [0.1,0.1,0.1], 'linewidth', 0.7);
    xticks(dnticker(1997,2021));
    datetick('x', 'mm-yyyy', 'keepticks');
    xtickangle(27);
    xlim([min(SIP.dn)-10, max(SIP.dn)+10]);
    legend([p1,p2,p3,p4], 'Winter', 'Spring', 'Summer', 'Fall',...
        'location', 'south', 'orientation', 'horizontal', 'fontsize', 11)
    grid on
    title(['Sector ', sector, ' Seasonal SIP']);
    ylabel('SIP [km^3]');
    ylim([mi-(ma-mi)*0.17, ma+ma/20]);

    print(['ICE/Production/figures/SIP/season_timeseries/sector',sector,'seasonTimeseries.png'], '-dpng', '-r400');
    clearvars -except secs

end




%% Section 5: Same as previous but with linear fits rather than mean dashed line


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
    
    load(['ICE/Production/data/SIP/without_combined_seasonal/sector',sector,'.mat']);
   
    ma = max([max(SIP.winter.P), max(SIP.spring.P), max(SIP.summer.P), max(SIP.fall.P)]);
    mi = min([min(SIP.winter.P), min(SIP.spring.P), min(SIP.summer.P), min(SIP.fall.P)]);
    msize = 13;
    q1 = polyfit(SIP.winter.dn', SIP.winter.P, 1); y1 = polyval(q1, SIP.winter.dn); s1 = ((y1(2)-y1(1))/(SIP.winter.dn(2)-SIP.winter.dn(1)))*3652.4; % days in a decade
    q2 = polyfit(SIP.spring.dn', SIP.spring.P, 1); y2 = polyval(q2, SIP.spring.dn); s2 = ((y2(2)-y2(1))/(SIP.spring.dn(2)-SIP.spring.dn(1)))*3652.4; % days in a decade
    q3 = polyfit(SIP.summer.dn', SIP.summer.P, 1); y3 = polyval(q3, SIP.summer.dn); s3 = ((y3(2)-y3(1))/(SIP.summer.dn(2)-SIP.summer.dn(1)))*3652.4; % days in a decade
    q4 = polyfit(SIP.fall.dn', SIP.fall.P, 1);     y4 = polyval(q4, SIP.fall.dn);   s4 = ((y4(2)-y4(1))/(SIP.fall.dn(2)-SIP.fall.dn(1)))*3652.4; % days in a decade
    % 2 decimals:
    s1 = round(s1*100)/100; s2 = round(s2*100)/100; s3 = round(s3*100)/100; s4 = round(s4*100)/100;
   
    figure;
    plot_dim(900,270);
    p1 = plot(SIP.winter.dn, SIP.winter.P,'.-','markersize', msize, 'color', [0.1,0.5,0.8], 'linewidth', 1.1);
    hold on
        plot(SIP.winter.dn, y1, '--', 'color', [0.1,0.5,0.8], 'linewidth', 1);
    p2 = plot(SIP.spring.dn, SIP.spring.P,'.-','markersize', msize, 'color', [0.1,0.6,0.4], 'linewidth', 1.1);
        plot(SIP.spring.dn, y2, '--', 'color', [0.1,0.6,0.4], 'linewidth', 1);
    p3 = plot(SIP.summer.dn, SIP.summer.P,'.-','markersize', msize, 'color', [0.9,0.3,0.75], 'linewidth', 1.1);
        plot(SIP.summer.dn, y3, '--', 'color', [0.9,0.3,0.75], 'linewidth', 1);
    p4 = plot(SIP.fall.dn, SIP.fall.P,'.-','markersize', msize, 'color', [0.9,0.6,0.3], 'linewidth', 1.1);
        plot(SIP.fall.dn, y4, '--', 'color', [0.9,0.6,0.3], 'linewidth', 1);
    yline(0,  'color', [0.1,0.1,0.1], 'linewidth', 0.7);
    xticks(dnticker(1997,2021));
    datetick('x', 'mm-yyyy', 'keepticks');
    xtickangle(27);
    xlim([min(SIP.dn)-10, max(SIP.dn)+10]);
    legend([p1,p2,p3,p4], ['Winter [',num2str(s1),' km^3 dec^-^1]'], ['Spring [',num2str(s2),' km^3 dec^-^1]'],...
        ['Summer [',num2str(s3),' km^3 dec^-^1]'], ['Fall [',num2str(s4),' km^3 dec^-^1]'],...
        'location', 'south', 'orientation', 'horizontal', 'fontsize', 11)
    grid on
    title(['Sector ', sector, ' Seasonal SIP']);
    ylabel('SIP [km^3]');
    ylim([mi-(ma-mi)*0.17, ma+ma/20]);

    print(['ICE/Production/figures/SIP/season_timeseries/sector',sector,'seasonTimeseriesLINEARfit.png'], '-dpng', '-r400');
    clearvars -except secs
 
end

%% Section 6: same but for Export 
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
    
    load(['ICE/Production/data/SIP/without_combined_seasonal/sector',sector,'.mat']);
    msize = 13;
    ma = max([max(SIP.winter.E), max(SIP.spring.E), max(SIP.summer.E), max(SIP.fall.E)]);
    mi = min([min(SIP.winter.E), min(SIP.spring.E), min(SIP.summer.E), min(SIP.fall.E)]);
    
    q1 = polyfit(SIP.winter.dn', SIP.winter.E, 1); y1 = polyval(q1, SIP.winter.dn); s1 = ((y1(2)-y1(1))/(SIP.winter.dn(2)-SIP.winter.dn(1)))*3652.4; % days in a decade
    q2 = polyfit(SIP.spring.dn', SIP.spring.E, 1); y2 = polyval(q2, SIP.spring.dn); s2 = ((y2(2)-y2(1))/(SIP.spring.dn(2)-SIP.spring.dn(1)))*3652.4; % days in a decade
    q3 = polyfit(SIP.summer.dn', SIP.summer.E, 1); y3 = polyval(q3, SIP.summer.dn); s3 = ((y3(2)-y3(1))/(SIP.summer.dn(2)-SIP.summer.dn(1)))*3652.4; % days in a decade
    q4 = polyfit(SIP.fall.dn', SIP.fall.E, 1);     y4 = polyval(q4, SIP.fall.dn);   s4 = ((y4(2)-y4(1))/(SIP.fall.dn(2)-SIP.fall.dn(1)))*3652.4; % days in a decade
    % 2 decimals:
    s1 = round(s1*100)/100; s2 = round(s2*100)/100; s3 = round(s3*100)/100; s4 = round(s4*100)/100;
   
    figure;
    plot_dim(900,270);
    p1 = plot(SIP.winter.dn, SIP.winter.E, '.-','markersize', msize,'color', [0.1,0.5,0.8], 'linewidth', 1.1);
    hold on
        plot(SIP.winter.dn, y1, '--', 'color', [0.1,0.5,0.8], 'linewidth', 1);
    p2 = plot(SIP.spring.dn, SIP.spring.E,'.-','markersize', msize, 'color', [0.1,0.6,0.4], 'linewidth', 1.1);
        plot(SIP.spring.dn, y2, '--', 'color', [0.1,0.6,0.4], 'linewidth', 1);
    p3 = plot(SIP.summer.dn, SIP.summer.E, '.-','markersize', msize,'color', [0.9,0.3,0.75], 'linewidth', 1.1);
        plot(SIP.summer.dn, y3, '--', 'color', [0.9,0.3,0.75], 'linewidth', 1);
    p4 = plot(SIP.fall.dn, SIP.fall.E, '.-','markersize', msize,'color', [0.9,0.6,0.3], 'linewidth', 1.1);
        plot(SIP.fall.dn, y4, '--', 'color', [0.9,0.6,0.3], 'linewidth', 1);
    yline(0,  'color', [0.1,0.1,0.1], 'linewidth', 0.7);
    xticks(dnticker(1997,2021));
    datetick('x', 'mm-yyyy', 'keepticks');
    xtickangle(27);
    xlim([min(SIP.dn)-10, max(SIP.dn)+10]);
    legend([p1,p2,p3,p4], ['Winter [',num2str(s1),' km^3 dec^-^1]'], ['Spring [',num2str(s2),' km^3 dec^-^1]'],...
        ['Summer [',num2str(s3),' km^3 dec^-^1]'], ['Fall [',num2str(s4),' km^3 dec^-^1]'],...
        'location', 'south', 'orientation', 'horizontal', 'fontsize', 11)
    grid on
    title(['Sector ', sector, ' Seasonal Export']);
    ylabel('Export [km^3]');
    ylim([mi-(ma-mi)*0.17, ma+ma/20]);

    print(['ICE/Production/figures/Export/season_timeseries/sector',sector,'seasonTimeseriesLINEARfit.png'], '-dpng', '-r400');
    clearvars -except secs

end
%% Section 7: same but for dSIV
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
    
    load(['ICE/Production/data/SIP/without_combined_seasonal/sector',sector,'.mat']);
    
    ma = max([max(SIP.winter.dSIV), max(SIP.spring.dSIV), max(SIP.summer.dSIV), max(SIP.fall.dSIV)]);
    mi = min([min(SIP.winter.dSIV), min(SIP.spring.dSIV), min(SIP.summer.dSIV), min(SIP.fall.dSIV)]);
       msize = 13;
    q1 = polyfit(SIP.winter.dn', SIP.winter.dSIV, 1); y1 = polyval(q1, SIP.winter.dn); s1 = ((y1(2)-y1(1))/(SIP.winter.dn(2)-SIP.winter.dn(1)))*3652.4; % days in a decade
    q2 = polyfit(SIP.spring.dn', SIP.spring.dSIV, 1); y2 = polyval(q2, SIP.spring.dn); s2 = ((y2(2)-y2(1))/(SIP.spring.dn(2)-SIP.spring.dn(1)))*3652.4; % days in a decade
    q3 = polyfit(SIP.summer.dn', SIP.summer.dSIV, 1); y3 = polyval(q3, SIP.summer.dn); s3 = ((y3(2)-y3(1))/(SIP.summer.dn(2)-SIP.summer.dn(1)))*3652.4; % days in a decade
    q4 = polyfit(SIP.fall.dn', SIP.fall.dSIV, 1);     y4 = polyval(q4, SIP.fall.dn);   s4 = ((y4(2)-y4(1))/(SIP.fall.dn(2)-SIP.fall.dn(1)))*3652.4; % days in a decade
    % 2 decimals:
    s1 = round(s1*100)/100; s2 = round(s2*100)/100; s3 = round(s3*100)/100; s4 = round(s4*100)/100;
   
    figure;
    plot_dim(900,270);
    p1 = plot(SIP.winter.dn, SIP.winter.dSIV, '.-','markersize', msize, 'color', [0.1,0.5,0.8], 'linewidth', 1.1);
    hold on
        plot(SIP.winter.dn, y1, '--', 'color', [0.1,0.5,0.8], 'linewidth', 1);
    p2 = plot(SIP.spring.dn, SIP.spring.dSIV, '.-','markersize', msize, 'color', [0.1,0.6,0.4], 'linewidth', 1.1);
        plot(SIP.spring.dn, y2, '--', 'color', [0.1,0.6,0.4], 'linewidth', 1);
    p3 = plot(SIP.summer.dn, SIP.summer.dSIV, '.-','markersize', msize, 'color', [0.9,0.3,0.75], 'linewidth', 1.1);
        plot(SIP.summer.dn, y3, '--', 'color', [0.9,0.3,0.75], 'linewidth', 1);
    p4 = plot(SIP.fall.dn, SIP.fall.dSIV, '.-','markersize', msize, 'color', [0.9,0.6,0.3], 'linewidth', 1.1);
        plot(SIP.fall.dn, y4, '--', 'color', [0.9,0.6,0.3], 'linewidth', 1);
    yline(0,  'color', [0.1,0.1,0.1], 'linewidth', 0.7);
    xticks(dnticker(1997,2021));
    datetick('x', 'mm-yyyy', 'keepticks');
    xtickangle(27);
    xlim([min(SIP.dn)-10, max(SIP.dn)+10]);
    legend([p1,p2,p3,p4], ['Winter [',num2str(s1),' km^3 dec^-^1]'], ['Spring [',num2str(s2),' km^3 dec^-^1]'],...
        ['Summer [',num2str(s3),' km^3 dec^-^1]'], ['Fall [',num2str(s4),' km^3 dec^-^1]'],...
        'location', 'south', 'orientation', 'horizontal', 'fontsize', 11)
    grid on
    title(['Sector ', sector, ' Seasonal \DeltaSIV']);
    ylabel('Export [km^3]');
    ylim([mi-(ma-mi)*0.17, ma+ma/20]);

    print(['ICE/Production/figures/dSIV/season_timeseries/sector',sector,'seasonTimeseriesLINEARfit.png'], '-dpng', '-r400');
    clearvars -except secs

end





%% Section one but for error SIP (09-March-2023)

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
for mm = 2:length(secs) % start at 2 to skip sector 00
    sector = secs{mm};
    
    load(['ICE/Production/data/SIP_with_error/before_restructure/sector',sector,'.mat']);
    SIP.dSIVup = SIP.dSIVplus;
    SIP.dSIVlo = SIP.dSIVminus;

    % Sum the seasons 
    yrs = (1998:2020)';
    for ii = 1:length(yrs)

         wii = find(((SIP.daydv(:,2)==6 & SIP.daydv(:,3)>=16) | (SIP.daydv(:,2)==7) |... % winter index for year(ii)
        (SIP.daydv(:,2)==8) | (SIP.daydv(:,2)==9 & SIP.daydv(:,3)<=15)) & SIP.daydv(:,1)==yrs(ii));
        spi = find(((SIP.daydv(:,2)==9 & SIP.daydv(:,3)>=16) | (SIP.daydv(:,2)==10) |... % spring index for year(ii)
        (SIP.daydv(:,2)==11) | (SIP.daydv(:,2)==12 & SIP.daydv(:,3)<=15)) & SIP.daydv(:,1)==yrs(ii));
        sui = find(((SIP.daydv(:,2)==12 & SIP.daydv(:,3)>=16) | (SIP.daydv(:,2)==1) |... % summer index for year(ii)
        (SIP.daydv(:,2)==2) | (SIP.daydv(:,2)==3 & SIP.daydv(:,3)<=15)) & SIP.daydv(:,1)==yrs(ii));
        aui = find(((SIP.daydv(:,2)==3 & SIP.daydv(:,3)>=16) | (SIP.daydv(:,2)==4) |... % fall index for year(ii)
        (SIP.daydv(:,2)==5) | (SIP.daydv(:,2)==6 & SIP.daydv(:,3)<=15)) & SIP.daydv(:,1)==yrs(ii));

        wintPup(ii) = sum(SIP.dayPup(wii), 'omitnan');
        wintTup(ii) = sum(SIP.dayTup(wii));
        wintDSIVup(ii) = sum(SIP.dayDSIVup(wii));
        wintPlo(ii) = sum(SIP.dayPlo(wii), 'omitnan');
        wintTlo(ii) = sum(SIP.dayTlo(wii));
        wintDSIVlo(ii) = sum(SIP.dayDSIVlo(wii));

        spriPup(ii) = sum(SIP.dayPup(spi));
        spriTup(ii) = sum(SIP.dayTup(spi));
        spriDSIVup(ii) = sum(SIP.dayDSIVup(spi));
        spriPlo(ii) = sum(SIP.dayPlo(spi));
        spriTlo(ii) = sum(SIP.dayTlo(spi));
        spriDSIVlo(ii) = sum(SIP.dayDSIVlo(spi));
        
        summPup(ii) = sum(SIP.dayPup(sui));
        summTup(ii) = sum(SIP.dayTup(sui));
        summDSIVup(ii) = sum(SIP.dayDSIVup(sui));
        summPlo(ii) = sum(SIP.dayPlo(sui));
        summTlo(ii) = sum(SIP.dayTlo(sui));
        summDSIVlo(ii) = sum(SIP.dayDSIVlo(sui));
        
        fallPup(ii) = sum(SIP.dayPup(aui));
        fallTup(ii) = sum(SIP.dayTup(aui));
        fallDSIVup(ii) = sum(SIP.dayDSIVup(aui));
        fallPlo(ii) = sum(SIP.dayPlo(aui));
        fallTlo(ii) = sum(SIP.dayTlo(aui));
        fallDSIVlo(ii) = sum(SIP.dayDSIVlo(aui));

        clear wii spi sui aui

    end

    %   Winter               Spring               Summer                Fall
    wintdv(:,1) = yrs;   spridv(:,1) = yrs;   summdv(:,1) = yrs;   falldv(:,1) = yrs;
    wintdv(:,2) = 8;     spridv(:,2) = 11;    summdv(:,2) = 2;     falldv(:,2) = 5;
    wintdv(:,3) = 1;     spridv(:,3) = 1;     summdv(:,3) = 1;     falldv(:,3) = 1;

    wintdn = datenum(wintdv);
    spridn = datenum(spridv);
    summdn = datenum(summdv);
    falldn = datenum(falldv);

    o = SIP; clear SIP;
    
    % add seasons to structure and save
    SIP.winter.Pup = wintPup;
    SIP.winter.Eup = wintTup;
    SIP.winter.dSIVup = wintDSIVup;
    SIP.winter.Plo = wintPlo;
    SIP.winter.Elo = wintTlo;
    SIP.winter.dSIVlo = wintDSIVlo;
    SIP.winter.dn = wintdn;
    SIP.winter.dv = wintdv;

    SIP.spring.Pup = spriPup;
    SIP.spring.Eup = spriTup;
    SIP.spring.dSIVup = spriDSIVup;
    SIP.spring.Plo = spriPlo;
    SIP.spring.Elo = spriTlo;
    SIP.spring.dSIVlo = spriDSIVlo;
    SIP.spring.dn = spridn;
    SIP.spring.dv = spridv;

    SIP.summer.Pup = summPup;
    SIP.summer.Eup = summTup;
    SIP.summer.dSIVup = summDSIVup;
    SIP.summer.Plo = summPlo;
    SIP.summer.Elo = summTlo;
    SIP.summer.dSIVlo = summDSIVlo;
    SIP.summer.dn = summdn;
    SIP.summer.dv = summdv;

    SIP.fall.Pup = fallPup;
    SIP.fall.Eup = fallTup;
    SIP.fall.dSIVup = fallDSIVup;
    SIP.fall.Plo = fallPlo;
    SIP.fall.Elo = fallTlo;
    SIP.fall.dSIVlo = fallDSIVlo;
    SIP.fall.dn = falldn;
    SIP.fall.dv = falldv;


    % Improve organization in SIP structures 
    SIP.Pup = o.Pup;
    SIP.Eup = o.transportup;
    SIP.dSIVup = o.dSIVup;
    SIP.Plo = o.Plo;
    SIP.Elo = o.transportlo;
    SIP.dSIVlo = o.dSIVlo;
    SIP.dn = o.pdn;
    SIP.dv = o.pdv;
    SIP.longdn = o.longdn;
    SIP.longdv = o.longdv;
    
    SIP.day.Pup = o.dayPup;
    SIP.day.Eup = o.dayTup;
    SIP.day.dSIVup = o.dayDSIVup;
    SIP.day.Plo = o.dayPlo;
    SIP.day.Elo = o.dayTlo;
    SIP.day.dSIVlo = o.dayDSIVlo;
    SIP.day.dn = o.daydn;
    SIP.day.dv = o.daydv;
    
    SIP.month.Pup = o.monthPup;
    SIP.month.Eup = o.monthTup;
    SIP.month.dSIVup = o.monthDSIVup;
    SIP.month.Plo = o.monthPlo;
    SIP.month.Elo = o.monthTlo;
    SIP.month.dSIVlo = o.monthDSIVlo;
    SIP.month.dn = o.monthdn;
    SIP.month.dv = o.monthdv;
    
    SIP.year.Pup = o.yearPup;
    SIP.year.Eup = o.yearTup;
    SIP.year.dSIVup = o.yearDSIVup;
    SIP.year.Plo = o.yearPlo;
    SIP.year.Elo = o.yearTlo;
    SIP.year.dSIVlo = o.yearDSIVlo;
    SIP.year.dn = o.yeardn;
    SIP.year.dv = o.yeardv;
    
    SIP.comment{1,1} = 'P = sea ice PRODUCTION [km^3/(day or week or month or season or year)]';
    SIP.comment{2,1} = 'E is sea ice EXPORT across the flux gate. same units as P';
    SIP.comment{3,1} = 'dSIV is CHANGE IN SIV within the gate from week to week. same units as P';
    SIP.comment{4,1} = 'E (and therefore P) only extend through 2020 while dSIV reaches through 2021';
    SIP.comment{5,1} = 'Day, month, season, and year are summed P, E, and dSIV over the respective periods. ie the units change from km^3/week to km^3/(year or month or season)';

    SIPe = SIP; clear SIP
    load(['ICE/Production/data/SIP/sector',sector,'.mat'])
    SIPe.P = SIP.P;
    SIPe.E = SIP.E;
    SIPe.dSIV = SIP.dSIV;
    SIPe.day.P = SIP.day.P;
    SIPe.day.E = SIP.day.E;
    SIPe.day.dSIV = SIP.day.dSIV;
    SIPe.month.P = SIP.month.P;
    SIPe.month.E = SIP.month.E;
    SIPe.month.dSIV = SIP.month.dSIV;
    SIPe.year.P = SIP.year.P;
    SIPe.year.E = SIP.year.E;
    SIPe.year.dSIV = SIP.year.dSIV;
    
    clear SIP;
    SIP = SIPe; clear SIPe

    save(['ICE/Production/data/SIP_with_error/sector',sector,'.mat'], 'SIP', '-v7.3');

    clearvars -except secs
end












%% Section 8 sea ice productivity and other things THIS IS OUTDATED... DO NOT RUN UNTIL FIXING LOOPING SYNTAX/NUMBER



% productivity is production divided by area 
% units: km^3/year * 1/km^2 = km/year --> or m/year 
% cody used mean km^3/year times area

% let's do both mean and a timeseries of productivity 

zeronum = 0;
for mm = 1:19
    if mm < 10
        sector = ['0', num2str(mm)];
    elseif mm == 19;
        sector = '00';
    else
        sector = num2str(mm);
    end
    
    if strcmp(sector,'03') | strcmp(sector,'04') | strcmp(sector,'07')
        load(['ICE/Sectors/Gates/mat_files/sector_gates/sector',sector,'b.mat']);
        gb = gate; clear gate
        load(['ICE/Sectors/Gates/mat_files/sector_gates/sector',sector,'.mat']);
        numin = length(gb.inside.in)+length(gate.inside.in);
        zeronum = zeronum+numin;
    elseif strcmp(sector,'00')
        numin = zeronum;
    else
        load(['ICE/Sectors/Gates/mat_files/sector_gates/sector',sector,'.mat']);
        numin = length(gate.inside.in);
        zeronum = zeronum+numin;
    end
    
    areain(mm,1) = numin*(3.125^2);
 
    
    
    load(['ICE/Production/data/SIP/sector',sector,'.mat']);
    
    
    % mean yearly production
    myp(mm,1) = nanmean(SIP.year.P);
    myP98to13 = nanmean(SIP.year.P(1:16));
    myP14to20 = nanmean(SIP.year.P(17:end));
    myP02to14 = nanmean(SIP.year.P(5:17));
    mypw = nanmean(SIP.winter.P);
    mypsp = nanmean(SIP.spring.P);
    mypsu = nanmean(SIP.summer.P);
    mypf = nanmean(SIP.fall.P);
    
    % briefly let's see % of P accounted for by E
    mye = nanmean(SIP.year.E);
    myE98to13 = nanmean(SIP.year.E(1:16));
    myE14to20 = nanmean(SIP.year.E(17:end));
    myE02to14 = nanmean(SIP.year.E(5:17));
    myew = nanmean(SIP.winter.E);
    myesp = nanmean(SIP.spring.E);
    myesu = nanmean(SIP.summer.E);
    myef = nanmean(SIP.fall.E);
    
    % and overall % of P accounted for by dSIV
    mydsiv = nanmean(SIP.year.dSIV);
    
    
    perE(mm,1) = mye/myp(mm)*100;
    perE98to13(mm,1) = myE98to13/myP98to13*100;
    perE14to20(mm,1) = myE14to20/myP14to20*100;
    perE02to14(mm,1) = myE02to14/myP02to14*100;
    perEW(mm,1) = myew/mypw*100;
    perESp(mm,1) = myesp/mypsp*100;
    perESu(mm,1) = myesu/mypsu*100;
    perEF(mm,1) = myef/mypf*100;
    perdSIV(mm,1) = mydsiv/myp(mm)*100;
    
    % productivity [m/year]
    prody(mm,1) = (myp(mm)/areain(mm))*1000;
    
    cor1 = corrcoef(SIP.P, SIP.E);
    c1(mm,1) = cor1(2);
    cor2 = corrcoef(SIP.P, SIP.dSIV(1:length(SIP.P)));
    c2(mm,1) = cor2(2);
    cor3 = corrcoef(SIP.E, SIP.dSIV(1:length(SIP.P)));
    c3(mm,1) = cor3(2);
    cor4 = corrcoef(SIP.winter.P, SIP.fall.P);
    c4(mm,1) = cor4(2);
    
    
    %disp(['Sector ',sector ,' sea ice productivity: ',num2str(prody(mm)),' m/y']);
    %disp(['Sector ',sector ,' mean annual sea ice production: ',num2str(myp(mm)),' km^3/y']);
    %disp(['Sector ',sector ,' area: ',num2str(areain(mm)),' km^2']);
    %disp(['Sector ',sector ,' cotribution [%] of E to P : ',num2str(perE(mm)),' %']);
    %disp(['Sector ',sector ,': 1998-2013 cotribution [%] of E to P : ',num2str(perE98to13(mm)),' %']);
    %disp(['Sector ',sector ,': 2014-2020 cotribution [%] of E to P : ',num2str(perE14to20(mm)),' %']);


    clearvars -except perdSIV zeronum prody myp areain perE perE98to13 perE14to20 perE02to14 perEW perESp perESu perEF c1 c2 c3 c4
    
end



% -- Productivity --
% Sector 00 sea ice productivity: 4.6377 m/y
% Sector 01 sea ice productivity: -1.5949 m/y
% Sector 02 sea ice productivity: 5.7394 m/y
% Sector 03 sea ice productivity: 31.5229 m/y
% Sector 04 sea ice productivity: 15.9266 m/y
% Sector 05 sea ice productivity: 11.5783 m/y
% Sector 06 sea ice productivity: -3.7518 m/y
% Sector 07 sea ice productivity: 6.5854 m/y
% Sector 08 sea ice productivity: 1.7269 m/y
% Sector 09 sea ice productivity: 2.5069 m/y
% Sector 10 sea ice productivity: 1.7458 m/y
% Sector 11 sea ice productivity: 0.71278 m/y
% Sector 12 sea ice productivity: 1.66 m/y
% Sector 13 sea ice productivity: 11.2125 m/y
% Sector 14 sea ice productivity: 7.8243 m/y
% Sector 15 sea ice productivity: 10.672 m/y
% Sector 16 sea ice productivity: 4.5251 m/y
% Sector 17 sea ice productivity: 1.6602 m/y
% Sector 18 sea ice productivity: -1.056 m/y

% -- Mean annual production --
% Sector 00 mean annual sea ice production: 3625.8161 km^3/y
% Sector 01 mean annual sea ice production: -99.8706 km^3/y
% Sector 02 mean annual sea ice production: 707.522 km^3/y
% Sector 03 mean annual sea ice production: 287.3512 km^3/y
% Sector 04 mean annual sea ice production: 74.7554 km^3/y
% Sector 05 mean annual sea ice production: 265.9394 km^3/y
% Sector 06 mean annual sea ice production: -54.5655 km^3/y
% Sector 07 mean annual sea ice production: 280.0217 km^3/y
% Sector 08 mean annual sea ice production: 42.1625 km^3/y
% Sector 09 mean annual sea ice production: 53.0136 km^3/y
% Sector 10 mean annual sea ice production: 31.3092 km^3/y
% Sector 11 mean annual sea ice production: 17.815 km^3/y
% Sector 12 mean annual sea ice production: 51.7749 km^3/y
% Sector 13 mean annual sea ice production: 358.8346 km^3/y
% Sector 14 mean annual sea ice production: 957.3222 km^3/y
% Sector 15 mean annual sea ice production: 222.2783 km^3/y
% Sector 16 mean annual sea ice production: 301.8352 km^3/y
% Sector 17 mean annual sea ice production: 169.114 km^3/y
% Sector 18 mean annual sea ice production: -40.797 km^3/y

% -- Sector area --
% Sector 00 area: 781806.25 km^2
% Sector 01 area: 62618.75 km^2
% Sector 02 area: 123275 km^2
% Sector 03 area: 9115.625 km^2
% Sector 04 area: 4693.75 km^2
% Sector 05 area: 22968.75 km^2
% Sector 06 area: 14543.75 km^2
% Sector 07 area: 42521.875 km^2
% Sector 08 area: 24415.625 km^2
% Sector 09 area: 21146.875 km^2
% Sector 10 area: 17934.375 km^2
% Sector 11 area: 24993.75 km^2
% Sector 12 area: 31190.625 km^2
% Sector 13 area: 32003.125 km^2
% Sector 14 area: 122353.125 km^2
% Sector 15 area: 20828.125 km^2
% Sector 16 area: 66703.125 km^2
% Sector 17 area: 101865.625 km^2
% Sector 18 area: 38634.375 km^2



% -- Contribution of E to P --
% Sector 00 cotribution [%] of E to P : 100.2597 %
% Sector 01 cotribution [%] of E to P : 97.7369 %
% Sector 02 cotribution [%] of E to P : 99.6264 %
% Sector 03 cotribution [%] of E to P : 99.9719 %
% Sector 04 cotribution [%] of E to P : 100.074 %
% Sector 05 cotribution [%] of E to P : 100.0343 %
% Sector 06 cotribution [%] of E to P : 99.74 %
% Sector 07 cotribution [%] of E to P : 99.9312 %
% Sector 08 cotribution [%] of E to P : 101.6682 %
% Sector 09 cotribution [%] of E to P : 101.1938 %
% Sector 10 cotribution [%] of E to P : 101.3458 %
% Sector 11 cotribution [%] of E to P : 104.8048 %
% Sector 12 cotribution [%] of E to P : 100.6028 %
% Sector 13 cotribution [%] of E to P : 100.1542 %
% Sector 14 cotribution [%] of E to P : 100.2835 %
% Sector 15 cotribution [%] of E to P : 100.3484 %
% Sector 16 cotribution [%] of E to P : 100.7422 %
% Sector 17 cotribution [%] of E to P : 100.3119 %
% Sector 18 cotribution [%] of E to P : 99.8825 %

% -- 1998-2013 contribution of E to P --
% Sector 00: 1998-2013 cotribution [%] of E to P : 100.2474 %
% Sector 01: 1998-2013 cotribution [%] of E to P : 100.0048 %
% Sector 02: 1998-2013 cotribution [%] of E to P : 98.9205 %
% Sector 03: 1998-2013 cotribution [%] of E to P : 99.9508 %
% Sector 04: 1998-2013 cotribution [%] of E to P : 100.1424 %
% Sector 05: 1998-2013 cotribution [%] of E to P : 100.3544 %
% Sector 06: 1998-2013 cotribution [%] of E to P : 99.3742 %
% Sector 07: 1998-2013 cotribution [%] of E to P : 99.9656 %
% Sector 08: 1998-2013 cotribution [%] of E to P : 101.0911 %
% Sector 09: 1998-2013 cotribution [%] of E to P : 100.6635 %
% Sector 10: 1998-2013 cotribution [%] of E to P : 99.7497 %
% Sector 11: 1998-2013 cotribution [%] of E to P : 99.562 %
% Sector 12: 1998-2013 cotribution [%] of E to P : 99.0201 %
% Sector 13: 1998-2013 cotribution [%] of E to P : 100.139 %
% Sector 14: 1998-2013 cotribution [%] of E to P : 100.3938 %
% Sector 15: 1998-2013 cotribution [%] of E to P : 100.3732 %
% Sector 16: 1998-2013 cotribution [%] of E to P : 101.7317 %
% Sector 17: 1998-2013 cotribution [%] of E to P : 102.496 %
% Sector 18: 1998-2013 cotribution [%] of E to P : 102.2889 %

% -- 2014-2020 contribution of E to P
% Sector 00: 2014-2020 cotribution [%] of E to P : 100.2889 %
% Sector 01: 2014-2020 cotribution [%] of E to P : 88.908 %
% Sector 02: 2014-2020 cotribution [%] of E to P : 100.831 %
% Sector 03: 2014-2020 cotribution [%] of E to P : 100.0327 %
% Sector 04: 2014-2020 cotribution [%] of E to P : 100.01 %
% Sector 05: 2014-2020 cotribution [%] of E to P : 99.6615 %
% Sector 06: 2014-2020 cotribution [%] of E to P : 75.078 %
% Sector 07: 2014-2020 cotribution [%] of E to P : 99.8253 %
% Sector 08: 2014-2020 cotribution [%] of E to P : 109.4409 %
% Sector 09: 2014-2020 cotribution [%] of E to P : 108.1942 %
% Sector 10: 2014-2020 cotribution [%] of E to P : 140.6867 %
% Sector 11: 2014-2020 cotribution [%] of E to P : -32.6465 %
% Sector 12: 2014-2020 cotribution [%] of E to P : 137.6018 %
% Sector 13: 2014-2020 cotribution [%] of E to P : 100.1863 %
% Sector 14: 2014-2020 cotribution [%] of E to P : 99.976 %
% Sector 15: 2014-2020 cotribution [%] of E to P : 100.2658 %
% Sector 16: 2014-2020 cotribution [%] of E to P : 97.7598 %
% Sector 17: 2014-2020 cotribution [%] of E to P : 94.6775 %
% Sector 18: 2014-2020 cotribution [%] of E to P : 97.8461 %









