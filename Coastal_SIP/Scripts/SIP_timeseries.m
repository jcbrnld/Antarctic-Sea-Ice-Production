% Jacob Arnold

% 05-May-2022

% plot SIP, dSIV, and transport with linear trends

% ONLY RUN SECTIONS 5 and 6... OTHERS NEED TO BE UPDATED [[OR]] IGNORED

%% THIS SECTION (sec 1) IS OUTDATED. This averaged weekly data into months and is irrelevant. All sections below are good
for mm = 0:18
    if mm < 10
        sector = ['0', num2str(mm)];
    else
        sector = num2str(mm);
    end
    
    disp(['Sector ',sector,'...'])

    load(['ICE/Production/data/SIP/without_daily_monthly_yearly/sector',sector,'.mat']);
    %SIP.P = SIP.P';

    %%% overall
    p = polyfit(SIP.pdn, SIP.P, 1);
    y = polyval(p, SIP.pdn); 
    slope = y(523) - y(1); % km^3/decade
    figure;
    plot(SIP.pdn, SIP.P, 'linewidth', .8, 'color', [0.02,0.02,0.02]); plot_dim(1000,300);
    hold on;
    pfit = plot(SIP.pdn, y, '--r', 'linewidth', 1.2);
    %plot(newdn, filtSIP, 'linewidth', 1.5, 'color', [0.7,0.2,0.2]);
    xticks(dnticker(1997,2022));
    datetick('x', 'mm-yyyy', 'keepticks')
    xtickangle(27)
    xlim([min(SIP.pdn)-50, max(SIP.pdn)+50]);
    ylabel('Sea Ice Production [km^3]');
    title(['Sector ',sector,' Sea Ice Production']);
    yline(0,  'color', [0.01,.02,.01], 'linewidth', 1.2);
    legend(pfit, ['Slope = ',num2str(slope),' km^3 dec^-^1']); grid on;
    print(['ICE/Production/Figures/SIP/withLinFit/sector',sector,'SIP.png'], '-dpng', '-r400');

    %&% monthly

    for ii = 1:12
        mind = find(SIP.pdv(:,2)==ii);

        monthlyP(ii) = nanmean(SIP.P(mind));
        monthlytrans(ii) = nanmean(SIP.transport(mind));
        monthlydSIV(ii) = nanmean(SIP.dSIV(mind));
        
        clear mind
    end
    monthlyP(13) = monthlyP(1);
    monthlytrans(13) = monthlytrans(1);
    monthlydSIV(13) = monthlydSIV(1);

    mp = double(max(monthlyP));
    mp5p = mp/20; % 5% 
    adj = mp+mp5p;
    
    figure; plot_dim(600,300);
    plot(monthlyP, 'linewidth', 1.4)
    xlim([0.7, 13.3]); ylim([min(monthlyP)+(min(monthlyP)/20), mp+3*mp5p]);
    title(['Sector ',sector,' monthly mean SIP']);
    ylabel('SIP [km^3]');
    xticks(1:12);
    yline(0,'color', [0.02,.02,.02], 'linewidth', 0.8);
    xline(6.5, 'color', [0.3,0.6,0.4], 'linewidth', 0.8);
    xline(9.5, 'color', [0.3,0.6,0.4], 'linewidth', 0.8);
    xline(12.5, 'color', [0.3,0.6,0.4], 'linewidth', 0.8);
    xline(3.5, 'color', [0.3,0.6,0.4], 'linewidth', 0.8);
    text(7.5,adj, 'Winter', 'fontsize', 13)
    text(1.25,adj, 'Summer', 'fontsize', 13)
    text(10.5,adj, 'Spring', 'fontsize', 13)
    text(4.5,adj, 'Autumn', 'fontsize', 13)

    print(['ICE/Production/Figures/SIP/Monthly/Sector',sector,'monthProd.png'], '-dpng', '-r300')
    %grid on

    %%% monthly with trans and dSIV
    maxes = [max(monthlyP), max(monthlytrans), max(monthlydSIV)];mm = double(max(maxes));
    mins = [min(monthlyP), min(monthlytrans), min(monthlydSIV)];


    figure; plot_dim(600,300);
    p1 = plot(monthlyP, 'linewidth', 1.4);
    hold on
    p2 = plot(monthlytrans, 'linewidth', 1.2);
    p3 = plot(monthlydSIV, 'linewidth', 1.2);
    xlim([0.7, 13.3]); ylim([min(mins)-2, mm+mm/5]);
    title(['Sector ',sector,' monthly mean SIP']);
    ylabel('SIP [km^3]');
    xticks(1:12);
    yline(0,'color', [0.02,.02,.02], 'linewidth', 0.8);
    xline(6.5, 'color', [0.3,0.6,0.4], 'linewidth', 0.8);
    xline(9.5, 'color', [0.3,0.6,0.4], 'linewidth', 0.8);
    xline(12.5, 'color', [0.3,0.6,0.4], 'linewidth', 0.8);
    xline(3.5, 'color', [0.3,0.6,0.4], 'linewidth', 0.8);
    text(7.5,mm+mm/20, 'Winter', 'fontsize', 13)
    text(1.25,mm+mm/20, 'Summer', 'fontsize', 13)
    text(10.5,mm+mm/20, 'Spring', 'fontsize', 13)
    text(4.5,mm+mm/20, 'Autumn', 'fontsize', 13)
    legend([p1,p2,p3], 'SIP', 'Transport', '\Delta SIV', 'location', 'south', 'orientation', 'horizontal')

    print(['ICE/Production/Figures/SIP/Monthly/Sector',sector,'monthProd_withTransAnddSIV.png'], '-dpng', '-r300')
    %grid on
    clearvars 
end








%% seasonal

secs = ja_aagatedregions(0); % 0 specifier includes sector 00
for mm = 1:length(secs)
    sector = secs{mm};
    
    disp(['Sector ',sector,'...'])
                                
    load(['ICE/Production/data/SIP/without_daily_monthly_yearly/sector',sector,'.mat']);

    % winter is jun16:sep15
    % summer is dec16:mar15
    wini = find((SIP.pdv(:,2)==6 & SIP.pdv(:,3)>=16) | (SIP.pdv(:,2)==7) |...
        (SIP.pdv(:,2)==8) | (SIP.pdv(:,2)==9 & SIP.pdv(:,3)<=15));
    sumi = find((SIP.pdv(:,2)==12 & SIP.pdv(:,3)>=16) | (SIP.pdv(:,2)==1) |...
        (SIP.pdv(:,2)==2) | (SIP.pdv(:,2)==3 & SIP.pdv(:,3)<=15));

    wp = SIP.P(wini);
    wdn = SIP.pdn(wini);
    sp = SIP.P(sumi);
    sdn = SIP.pdn(sumi);

    p1 = polyfit(SIP.pdn, SIP.P, 1);
    y1 = polyval(p1, SIP.pdn);s1 = (y1(2)-y1(1))/(SIP.pdn(2)-SIP.pdn(1))*3652.5; % days in a decade
    p2 = polyfit(wdn, wp, 1);
    y2 = polyval(p2, wdn);s2 = (y2(2)-y2(1))/(wdn(2)-wdn(1))*3652.5; % days in a decade
    p3 = polyfit(sdn, sp, 1);
    y3 = polyval(p3, sdn);s3 = (y3(2)-y3(1))/(sdn(2)-sdn(1))*3652.5; % days in a decade

    figure;
    plot_dim(900,270);
    plot(SIP.pdn, SIP.P, 'color', [0.02,.02,.02]);
    hold on
    scatter(wdn, wp, 13, [0.2,0.5,0.8],'filled');
    scatter(sdn, sp, 13, [0.9,0.35,0.3], 'filled');
    p1 = plot(SIP.pdn, y1, '--' ,'color', [0.02,.02,.02], 'linewidth', 1.2);
    p2 = plot(wdn, y2, '--', 'color', [0.2,0.5,0.8], 'linewidth', 1.2);
    p3 = plot(sdn, y3, '--', 'color', [0.9,0.35,0.3], 'linewidth', 1.2);

    xticks(dnticker(1997,2022));
    datetick('x', 'mm-yyyy', 'keepticks')
    xtickangle(27)
    xlim([min(SIP.pdn)-50, max(SIP.pdn)+50]);
    ylabel('Sea Ice Production [km^3]');
    title(['Sector ',sector,' Weekly Sea Ice Production']);
    %yline(0,  'color', [0.01,.02,.01], 'linewidth', 1.2);
    grid on
    legend([p1, p2, p3], ['Slope = ',num2str(s1),' km^3 dec^-^1'], ['Winter: slope = ',num2str(s2),' km^3 dec^-^1'],...
        ['Summer: slope = ',num2str(s3),' km^3 dec^-^1'], 'location', 'south', 'orientation', 'horizontal');

    print(['ICE/Production/Figures/SIP/Seasonal/sector',sector,'seasonalSIP.png'], '-dpng', '-r400');

    clearvars -except secs

end







%% seasonal BUT 2 season --> combine autumn+winter and spring+summer

secs = ja_aagatedregions(0); % 0 specifier includes sector 00
for mm = 1:length(secs)
    sector = secs{mm};
    
    disp(['Sector ',sector,'...'])
                                
    load(['ICE/Production/data/SIP/without_daily_monthly_yearly/sector',sector,'.mat']);

    % winter is jun16:sep15
    % summer is dec16:mar15
    wini = find((SIP.pdv(:,2)==3 & SIP.pdv(:,3)>=16) | (SIP.pdv(:,2)==4) | (SIP.pdv(:,2)==5) |...
        (SIP.pdv(:,2)==6) |(SIP.pdv(:,2)==7) | (SIP.pdv(:,2)==8) | (SIP.pdv(:,2)==9 & SIP.pdv(:,3)<=15));
    sumi = find((SIP.pdv(:,2)==9 & SIP.pdv(:,3)>=16) | (SIP.pdv(:,2)==10) |(SIP.pdv(:,2)==11) |...
        (SIP.pdv(:,2)==12) | (SIP.pdv(:,2)==1) | (SIP.pdv(:,2)==2) | (SIP.pdv(:,2)==3 & SIP.pdv(:,3)<=15));

    wp = SIP.P(wini);
    wdn = SIP.pdn(wini);
    sp = SIP.P(sumi);
    sdn = SIP.pdn(sumi);

    p1 = polyfit(SIP.pdn, SIP.P, 1);
    y1 = polyval(p1, SIP.pdn);s1 = (y1(2)-y1(1))/(SIP.pdn(2)-SIP.pdn(1))*3652.5; % days in a decade
    p2 = polyfit(wdn, wp, 1);
    y2 = polyval(p2, wdn);s2 = (y2(2)-y2(1))/(wdn(2)-wdn(1))*3652.5; % days in a decade
    p3 = polyfit(sdn, sp, 1);
    y3 = polyval(p3, sdn);s3 = (y3(2)-y3(1))/(sdn(2)-sdn(1))*3652.5; % days in a decade

    figure;
    plot_dim(900,270);
    plot(SIP.pdn, SIP.P, 'color', [0.02,.02,.02]);
    hold on
    scatter(wdn, wp, 13, [0.2,0.5,0.8]);
    scatter(sdn, sp, 13, [0.9,0.35,0.3]);
    p1 = plot(SIP.pdn, y1, '--' ,'color', [0.02,.02,.02], 'linewidth', 1.2);
    p2 = plot(wdn, y2, '--', 'color', [0.2,0.5,0.8], 'linewidth', 1.2);
    p3 = plot(sdn, y3, '--', 'color', [0.9,0.35,0.3], 'linewidth', 1.2);

    xticks(dnticker(1997,2022));
    datetick('x', 'mm-yyyy', 'keepticks')
    xtickangle(27)
    xlim([min(SIP.pdn)-50, max(SIP.pdn)+50]);
    ylabel('Sea Ice Production [km^3]');
    title(['Sector ',sector,' Weekly Sea Ice Production']);
    %yline(0,  'color', [0.01,.02,.01], 'linewidth', 1.2);
    grid on
    legend([p1, p2, p3], ['Slope = ',num2str(s1),' km^3 dec^-^1'], ['Autumn & Winter: slope = ',num2str(s2),' km^3 dec^-^1'],...
        ['Spring & Summer: slope = ',num2str(s3),' km^3 dec^-^1'], 'location', 'south', 'orientation', 'horizontal');

    print(['ICE/Production/Figures/SIP/Seasonal/sector',sector,'seasonal-2seasonSIP.png'], '-dpng', '-r400');

    clearvars -except secs

end




%% Seasonal --->> sum the seasons

secs = ja_aagatedregions(0); % 0 specifier includes sector 00
for mm = 1:length(secs)
    sector = secs{mm};
    
    disp(['Sector ',sector,'...'])
                                
    load(['ICE/Production/data/SIP/without_daily_monthly_yearly/sector',sector,'.mat']);

    % winter is jun16:sep15
    % summer is dec16:mar15

    years = unique(SIP.daydv(:,1)); years(1) = []; years(end) = []; % forget about '97 and '21 since we only have a few months or days
    sdv = []; yc = 1;
    for ii = 1:length(years);
        wii = find(((SIP.daydv(:,2)==6 & SIP.daydv(:,3)>=16) | (SIP.daydv(:,2)==7) |... % winter index for year(ii)
        (SIP.daydv(:,2)==8) | (SIP.daydv(:,2)==9 & SIP.daydv(:,3)<=15)) & SIP.daydv(:,1)==years(ii));

        spi = find(((SIP.daydv(:,2)==9 & SIP.daydv(:,3)>=16) | (SIP.daydv(:,2)==10) |... % winter index for year(ii)
        (SIP.daydv(:,2)==11) | (SIP.daydv(:,2)==12 & SIP.daydv(:,3)<=15)) & SIP.daydv(:,1)==years(ii));

        sui = find(((SIP.daydv(:,2)==12 & SIP.daydv(:,3)>=16) | (SIP.daydv(:,2)==1) |... % summer index for year(ii)
        (SIP.daydv(:,2)==2) | (SIP.daydv(:,2)==3 & SIP.daydv(:,3)<=15)) & SIP.daydv(:,1)==years(ii));
        
        aui = find(((SIP.daydv(:,2)==3 & SIP.daydv(:,3)>=16) | (SIP.daydv(:,2)==4) |... % summer index for year(ii)
        (SIP.daydv(:,2)==5) | (SIP.daydv(:,2)==6 & SIP.daydv(:,3)<=15)) & SIP.daydv(:,1)==years(ii));
        
        
        wiSIP(ii) = sum(SIP.dayP(wii),'omitnan');
        spSIP(ii) = sum(SIP.dayP(spi),'omitnan');
        suSIP(ii) = sum(SIP.dayP(sui),'omitnan');
        auSIP(ii) = sum(SIP.dayP(aui),'omitnan');
        
        
        
        sdv(yc,1) = years(ii); sdv(yc,2) = 2; 
        seaSIP(yc) = suSIP(ii); % add summer of year(ii) to seasonal variable
        yc = yc+1; % increase counter by 1
        sdv(yc,1) = years(ii); sdv(yc,2) = 5; 
        seaSIP(yc) = auSIP(ii); % add summer of year(ii) to seasonal variable
        yc = yc+1; % increase counter by 1
        sdv(yc,1) = years(ii); sdv(yc,2) = 8; 
        seaSIP(yc) = wiSIP(ii); % add winter of year(ii) to seasonal variable
        yc = yc+1;
        sdv(yc,1) = years(ii); sdv(yc,2) = 11; 
        seaSIP(yc) = spSIP(ii); % add summer of year(ii) to seasonal variable
        yc = yc+1; % increase counter by 1
        
        clear si wi
    end
    sdv(:,3) = 1;
    sdn = datenum(sdv);
    
    figure;plot(sdn, seaSIP); plot_dim(900,270);
    xticks(dnticker(1998,2022))
    xlim([min(sdn)-100, max(sdn)+100]);
    datetick('x', 'mm/yyyy', 'keepticks')
    xtickangle(27)
    grid on
    ylabel('SIP [km^3');
    title('Seasonal SIP');
    
    clearvars -except secs
end

%% Section 5: Create a km^3/day dataset then reducing from there to monthly and yearly SIP
% Note that this is just dividing a week's SIP by 7 and assigning to all
% interior days, not increasing temporal resolution. (ie there's no new info)

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
    
    disp(['Sector ',sector,'...'])

    load(['ICE/Production/data/SIP/without_daily_monthly_yearly/sector',sector,'.mat']);

    ddn = (SIP.pdn(1)-3:SIP.pdn(end)+3)';
    ddv = datevec(ddn);

    dSIP = nan(length(ddv),1);
    dtran = dSIP;
    dvol = dSIP;

    for ii = 1:length(SIP.pdn)

        loc = find(ddn==SIP.pdn(ii));
        dSIP(loc-3:loc+3) = SIP.P(ii)/7; % make daily SIP dataset. Units = km^3/day
        dtran(loc-3:loc+3) = SIP.transport(ii)/7;
        dvol(loc-3:loc+3) = SIP.dSIV(ii)/7;
        
    end

    SIP.dayP = dSIP;
    SIP.dayT = dtran;
    SIP.dayDSIV = dvol;
    SIP.daydn = ddn;
    SIP.daydv = ddv;
    SIP.comment{length(SIP.comment)+1} = 'dayP, daydn and daydv are daily SIP created by dividing weekly SIP by 7 and assigning that value to each day within that week. Units: km^3/day';

    % NOW can create monthly SIP and annual SIP
    years = unique(SIP.daydv(:,1)); years(1) = [];  % forget about 1997 and 2021 - only has nov and dec data(97) and 1 week(21)
    counter = 1;
    for ii = 1:length(years)
        for mm = 1:12
            mloc = find(SIP.daydv(:,1)==years(ii) & SIP.daydv(:,2)==mm);

            mSIP(counter) = sum(SIP.dayP(mloc), 'omitnan');
            mtrans(counter) = sum(SIP.dayT(mloc), 'omitnan');
            mvol(counter) = sum(SIP.dayDSIV(mloc), 'omitnan');
            

            mdv(counter,1) = years(ii);
            mdv(counter,2) = mm;
            mdv(counter,3) = 15;
            counter = counter+1;
            clear mloc

        end
        yloc = find(SIP.daydv(:,1)==years(ii));

        ySIP(ii) = sum(SIP.dayP(yloc), 'omitnan');
        ytrans(ii) = sum(SIP.dayT(yloc), 'omitnan');
        yvol(ii) = sum(SIP.dayDSIV(yloc), 'omitnan');
        clear yloc

    end
    ydv(:,1) = years;
    ydv(:,2) = 7;
    ydv(:,3) = 1;
    ydn = datenum(ydv);

    mdn = datenum(mdv);

    figure;
    plot_dim(900,270);
    p1 = plot(SIP.pdn, SIP.P);
    hold on
    p2 = plot(mdn, mSIP, 'linewidth', 1.1);
    p3 = plot(ydn, ySIP, 'linewidth', 1.1);
    %yline(0, '--r', 'linewidth', 1);
    legend([p1,p2,p3], 'Weekly', 'Monthly', 'Yearly', 'fontsize', 12, 'orientation', 'horizontal')
    title(['Sector ',sector,' Sea Ice Production']);
    ylabel('SIP [km^3]');
    xticks(dnticker(1998,2021));
    datetick('x', 'mm-yyyy', 'keepticks');
    xtickangle(27);
    xlim([min(SIP.daydn)-50, max(SIP.daydn)+50]);
    grid on
    print(['ICE/Production/Figures/SIP/weekmonthyear/sector',sector,'MandY.png'], '-dpng', '-r400');

    SIP.yearP = ySIP;
    SIP.yearT = ytrans;
    SIP.yearDSIV = yvol;
    SIP.yeardn = ydn;
    SIP.yeardv = ydv;
    SIP.comment{length(SIP.comment)+1} = 'yearP, yeardn and yeardv are yearly SIP created by summing daily SIP within each year starting wth 1998. Units: km^3/year';

    SIP.monthP = mSIP;
    SIP.monthT = mtrans;
    SIP.monthDSIV = mvol;
    SIP.monthdn = mdn;
    SIP.monthdv = mdv;
    SIP.comment{length(SIP.comment)+1} = 'monthP, monthdn and monthdv are monthly SIP created by summing daily SIP within each month starting wth 01/1998. Units: km^3/month';

    save(['ICE/Production/data/SIP/without_RLmonthly/sector',sector,'.mat'], 'SIP', '-v7.3');

    clearvars -except secs
end

%% Section 6: now create climatological annual cycle plots 

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
    
    disp(['Sector ',sector,'...'])

    load(['ICE/Production/data/SIP/without_RLmonthly/sector',sector,'.mat']);

    for ii = 1:12
        loc = find(SIP.monthdv(:,2)==ii);
        monthlyP(ii) = nanmean(SIP.monthP(loc));
        monthlytrans(ii) = nanmean(SIP.monthT(loc));
        monthlydSIV(ii) = nanmean(SIP.monthDSIV(loc));
        clear loc
    end
    
    monthlyP(13) = monthlyP(1);
    monthlytrans(13) = monthlytrans(1);
    monthlydSIV(13) = monthlydSIV(1);

    mp = double(max(monthlyP));
    mp5p = mp/20; % 5% 
    adj = mp+mp5p;
    
    figure; plot_dim(600,300);
    plot(monthlyP, 'linewidth', 1.4)
    xlim([0.7, 13.3]); ylim([min(monthlyP)+(min(monthlyP)/20), mp+3*mp5p]);
    title(['Sector ',sector,' monthly mean SIP']);
    ylabel('SIP [km^3]');
    xticks(1:12);
    yline(0,'color', [0.02,.02,.02], 'linewidth', 0.8);
    xline(6.5, 'color', [0.3,0.6,0.4], 'linewidth', 0.8);
    xline(9.5, 'color', [0.3,0.6,0.4], 'linewidth', 0.8);
    xline(12.5, 'color', [0.3,0.6,0.4], 'linewidth', 0.8);
    xline(3.5, 'color', [0.3,0.6,0.4], 'linewidth', 0.8);
    text(7.5,adj, 'Winter', 'fontsize', 13)
    text(1.25,adj, 'Summer', 'fontsize', 13)
    text(10.5,adj, 'Spring', 'fontsize', 13)
    text(4.5,adj, 'Autumn', 'fontsize', 13)

    print(['ICE/Production/Figures/SIP/Monthly/Sector',sector,'monthProd.png'], '-dpng', '-r300')

    
    %%% monthly with trans and dSIV
    maxes = [max(monthlyP), max(monthlytrans), max(monthlydSIV)];mm = double(max(maxes));
    mins = [min(monthlyP), min(monthlytrans), min(monthlydSIV)];


    figure; plot_dim(600,300);
    p1 = plot(monthlyP, 'linewidth', 1.4);
    hold on
    p2 = plot(monthlytrans, 'linewidth', 1.2);
    p3 = plot(monthlydSIV, 'linewidth', 1.2);
    xlim([0.7, 13.3]); 
    ylim([min(mins)-(mm-min(mins))/5, mm+mm/4]);
    title(['Sector ',sector,' monthly mean SIP']);
    ylabel('SIP [km^3]');
    xticks(1:12);
    yline(0,'color', [0.02,.02,.02], 'linewidth', 0.8);
    xline(6.5, 'color', [0.3,0.6,0.4], 'linewidth', 0.8);
    xline(9.5, 'color', [0.3,0.6,0.4], 'linewidth', 0.8);
    xline(12.5, 'color', [0.3,0.6,0.4], 'linewidth', 0.8);
    xline(3.5, 'color', [0.3,0.6,0.4], 'linewidth', 0.8);
    text(7.5,mm+mm/20, 'Winter', 'fontsize', 13)
    text(1.25,mm+mm/20, 'Summer', 'fontsize', 13)
    text(10.5,mm+mm/20, 'Spring', 'fontsize', 13)
    text(4.5,mm+mm/20, 'Autumn', 'fontsize', 13)
    legend([p1,p2,p3], 'SIP', 'Export', '\Delta SIV', 'location', 'south', 'orientation', 'horizontal')
   

    print(['ICE/Production/Figures/SIP/Monthly/Sector',sector,'monthProd_withTransAnddSIV.png'], '-dpng', '-r300')
   
    SIP.RLmonthly_mean.P = monthlyP;
    SIP.RLmonthly_mean.T = monthlytrans;
    SIP.RLmonthly_mean.dSIV = monthlydSIV;
    save(['ICE/Production/data/SIP/without_seasonal/sector',sector,'.mat'], 'SIP', '-v7.3');
    
    
    clearvars -except secs
    
end








%% Same as section 5 above except for error

%%% Section 5e: Create a km^3/day dataset then reducing from there to monthly and yearly SIP
% Note that this is just dividing a week's SIP by 7 and assigning to all
% interior days, not increasing temporal resolution. (ie there's no new info)

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
for mm = 2:length(secs)
    sector = secs{mm};
    
    disp(['Sector ',sector,'...'])

    load(['ICE/Production/data/SIP_with_error/without_daily_monthly_yearly/sector',sector,'.mat']);

    ddn = (SIP.pdn(1)-3:SIP.pdn(end)+3)';
    ddv = datevec(ddn);

    dSIPup = nan(length(ddv),1);
    dSIPlo = nan(length(ddv),1);
    
    dtranup = dSIPup;
    dvolup = dSIPup;
    dtranlo = dSIPlo;
    dvollo = dSIPlo;

    for ii = 1:length(SIP.pdn)

        loc = find(ddn==SIP.pdn(ii));
        dSIPup(loc-3:loc+3) = SIP.Pup(ii)/7; % make daily SIP dataset. Units = km^3/day
        dSIPlo(loc-3:loc+3) = SIP.Plo(ii)/7; % make daily SIP dataset. Units = km^3/day
        dtranup(loc-3:loc+3) = SIP.transportup(ii)/7;
        dvolup(loc-3:loc+3) = SIP.dSIVplus(ii)/7;
        dtranlo(loc-3:loc+3) = SIP.transportlo(ii)/7;
        dvollo(loc-3:loc+3) = SIP.dSIVminus(ii)/7;
        
    end

    SIP.dayPup = dSIPup;
    SIP.dayPlo = dSIPlo;
    SIP.dayTup = dtranup;
    SIP.dayTlo = dtranlo;
    SIP.dayDSIVup = dvolup;
    SIP.dayDSIVlo = dvollo;
    SIP.daydn = ddn;
    SIP.daydv = ddv;
    SIP.comment = {'dayP, daydn and daydv are daily SIP created by dividing weekly SIP by 7 and assigning that value to each day within that week. Units: km^3/day';...
        'up suffix is the upper SIP estimate and lo suffix is the lower SIP estimate'};

    % NOW can create monthly SIP and annual SIP
    years = unique(SIP.daydv(:,1)); years(1) = [];  % forget about 1997 and 2021 - only has nov and dec data(97) and 1 week(21)
    counter = 1;
    for ii = 1:length(years)
        for mm = 1:12
            mloc = find(SIP.daydv(:,1)==years(ii) & SIP.daydv(:,2)==mm);

            mSIPup(counter) = sum(SIP.dayPup(mloc), 'omitnan');
            mtransup(counter) = sum(SIP.dayTup(mloc), 'omitnan');
            mvolup(counter) = sum(SIP.dayDSIVup(mloc), 'omitnan');
            
            mSIPlo(counter) = sum(SIP.dayPlo(mloc), 'omitnan');
            mtranslo(counter) = sum(SIP.dayTlo(mloc), 'omitnan');
            mvollo(counter) = sum(SIP.dayDSIVlo(mloc), 'omitnan');

            mdv(counter,1) = years(ii);
            mdv(counter,2) = mm;
            mdv(counter,3) = 15;
            counter = counter+1;
            clear mloc

        end
        yloc = find(SIP.daydv(:,1)==years(ii));

        ySIPup(ii) = sum(SIP.dayPup(yloc), 'omitnan');
        ytransup(ii) = sum(SIP.dayTup(yloc), 'omitnan');
        yvolup(ii) = sum(SIP.dayDSIVup(yloc), 'omitnan');
        
        ySIPlo(ii) = sum(SIP.dayPlo(yloc), 'omitnan');
        ytranslo(ii) = sum(SIP.dayTlo(yloc), 'omitnan');
        yvollo(ii) = sum(SIP.dayDSIVlo(yloc), 'omitnan');
        
        clear yloc

    end
    ydv(:,1) = years;
    ydv(:,2) = 7;
    ydv(:,3) = 1;
    ydn = datenum(ydv);

    mdn = datenum(mdv);

    figure;
    plot_dim(900,270);
    p1 = plot(SIP.pdn, SIP.Pup);
    hold on
    p2 = plot(mdn, mSIPup, 'linewidth', 1.1);
    p3 = plot(ydn, ySIPup, 'linewidth', 1.1);
    p4 = plot(ydn, ySIPlo, 'linewidth', 1.1);
    %yline(0, '--r', 'linewidth', 1);
    legend([p1,p2,p3,p4], 'Weekly', 'Monthly', 'Yearly up','Yearly lo', 'fontsize', 12, 'orientation', 'horizontal')
    title(['Sector ',sector,' Sea Ice Production']);
    ylabel('SIP [km^3]');
    xticks(dnticker(1998,2021));
    datetick('x', 'mm-yyyy', 'keepticks');
    xtickangle(27);
    xlim([min(SIP.daydn)-50, max(SIP.daydn)+50]);
    grid on

    SIP.yearPup = ySIPup;
    SIP.yearPlo = ySIPlo;
    SIP.yearTup = ytransup;
    SIP.yearTlo = ytranslo;
    SIP.yearDSIVup = yvolup;
    SIP.yearDSIVlo = yvollo;
    SIP.yeardn = ydn;
    SIP.yeardv = ydv;
    SIP.comment{length(SIP.comment)+1} = 'yearP, yeardn and yeardv are yearly SIP created by summing daily SIP within each year starting wth 1998. Units: km^3/year';

    SIP.monthPup = mSIPup;
    SIP.monthPlo = mSIPlo;
    SIP.monthTup = mtransup;
    SIP.monthTlo = mtranslo;
    SIP.monthDSIVup = mvolup;
    SIP.monthDSIVlo = mvollo;
    SIP.monthdn = mdn;
    SIP.monthdv = mdv;
    SIP.comment{length(SIP.comment)+1} = 'monthP, monthdn and monthdv are monthly SIP created by summing daily SIP within each month starting wth 01/1998. Units: km^3/month';

    save(['ICE/Production/data/SIP_with_error/sector',sector,'.mat'], 'SIP', '-v7.3');

    clearvars -except secs
end



















