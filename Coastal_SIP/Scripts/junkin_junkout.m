% Jacob Arnold

% 02-June-2022

% Junk in and junk out
% Look at gate.trans and sum the <0 and >0 portions to get junk in and junk
% out. Add to SIP structures. 
s0icein = zeros(1209,1);
s0dayin = zeros(8463,1);
s0monthin = zeros(276,1);
s0yearin = zeros(23,1);
s0winterin = zeros(23,1);
s0springin = zeros(23,1);
s0summerin = zeros(23,1);
s0fallin = zeros(23,1);
s0seasonalin = zeros(92,1);

s0iceout = zeros(1209,1);
s0dayout = zeros(8463,1);
s0monthout = zeros(276,1);
s0yearout = zeros(23,1);
s0winterout = zeros(23,1);
s0springout = zeros(23,1);
s0summerout = zeros(23,1);
s0fallout = zeros(23,1);
s0seasonalout = zeros(92,1);

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
    disp(['Adding junkin junkout to sector ',sector,'...']);
    load(['ICE/Production/data/SIP/noJunkinJunkout/sector',sector,'.mat']);

    load(['ICE/Sectors/Gates/mat_files/sector_gates/sector',sector,'.mat']);
    
    
    for ll = 1:length(gate.trans(1,:))
        neg = find(gate.trans(:,ll)<0);
        pos = find(gate.trans(:,ll)>0);
        
        junkin(ll,1) = sum(gate.trans(neg,ll), 'omitnan'); % Don't forget this is still in m^3/s
        junkout(ll,1) = sum(gate.trans(pos, ll), 'omitnan');
        
    end
    
    % unit conversion
    % m^3/week = m^3/s * 60s/m * 60m/h * 24h/d * 7d/week
    junkin = junkin.*60*60*24*7;
    junkout = junkout.*60*60*24*7;
    
    % km^3/week = m^3/week * 1/1000^3
    junkin = junkin./(1000^3);
    junkout = junkout./(1000^3);
    junkin = junkin(2:end);
    junkout = junkout(2:end);
    % Add weekly to SIP structure
    SIP.icein = junkin;
    SIP.iceout = junkout;
    
    
    % now make daily dataset
    dn = SIP.day.dn;
    for ww = 1:length(SIP.dn)
        djin = junkin(ww)/7; % daily junk in/out
        djout = junkout(ww)/7;
        
        loc = find(dn==SIP.longdn(ww));
        dailyin(loc-3:loc+3,1) = djin;
        dailyout(loc-3:loc+3,1) = djout;
        
        clear djin djout
    end
    
    % Add to SIP.day 
    SIP.day.icein = dailyin;
    SIP.day.iceout = dailyout;
    
    % Now sum for monthly, yearly, and seasonal
    years = 1998:2020; counter = 1; c2 = 1;
    for yy = 1:length(years)
        yloc = find(SIP.day.dv(:,1)==years(yy));
        
        yearicein(yy,1) = sum(SIP.day.icein(yloc), 'omitnan');
        yeariceout(yy,1) = sum(SIP.day.iceout(yloc), 'omitnan');
        for mm = 1:12
            loc = find(SIP.day.dv(:,1)==years(yy) & SIP.day.dv(:,2)==mm);
            
            monthicein(counter,1) = sum(SIP.day.icein(loc), 'omitnan');
            monthiceout(counter,1) = sum(SIP.day.iceout(loc), 'omitnan');
            
            counter = counter + 1;
            clear loc
        end
        
        % Seasons
        wii = find(((SIP.day.dv(:,2)==6 & SIP.day.dv(:,3)>=16) | (SIP.day.dv(:,2)==7) |... % winter index for year(yy)
        (SIP.day.dv(:,2)==8) | (SIP.day.dv(:,2)==9 & SIP.day.dv(:,3)<=15)) & SIP.day.dv(:,1)==years(yy));
        spi = find(((SIP.day.dv(:,2)==9 & SIP.day.dv(:,3)>=16) | (SIP.day.dv(:,2)==10) |... % spring index for year(yy)
        (SIP.day.dv(:,2)==11) | (SIP.day.dv(:,2)==12 & SIP.day.dv(:,3)<=15)) & SIP.day.dv(:,1)==years(yy));
        sui = find(((SIP.day.dv(:,2)==12 & SIP.day.dv(:,3)>=16) | (SIP.day.dv(:,2)==1) |... % summer index for year(yy)
        (SIP.day.dv(:,2)==2) | (SIP.day.dv(:,2)==3 & SIP.day.dv(:,3)<=15)) & SIP.day.dv(:,1)==years(yy));
        aui = find(((SIP.day.dv(:,2)==3 & SIP.day.dv(:,3)>=16) | (SIP.day.dv(:,2)==4) |... % fall index for year(yy)
        (SIP.day.dv(:,2)==5) | (SIP.day.dv(:,2)==6 & SIP.day.dv(:,3)<=15)) & SIP.day.dv(:,1)==years(yy));
        
        wintericein(yy,1) = sum(SIP.day.icein(wii), 'omitnan');
        wintericeout(yy,1) = sum(SIP.day.iceout(wii), 'omitnan');
        
        springicein(yy,1) = sum(SIP.day.icein(spi), 'omitnan');
        springiceout(yy,1) = sum(SIP.day.iceout(spi), 'omitnan');
        
        summericein(yy,1) = sum(SIP.day.icein(sui), 'omitnan');
        summericeout(yy,1) = sum(SIP.day.iceout(sui), 'omitnan');
        
        fallicein(yy,1) = sum(SIP.day.icein(aui), 'omitnan');
        falliceout(yy,1) = sum(SIP.day.iceout(aui), 'omitnan');
        
        seasonicein(c2,1) = summericein(yy); 
        seasoniceout(c2,1) = summericeout(yy); 
        c2 = c2+1;
        
        seasonicein(c2,1) = fallicein(yy);
        seasoniceout(c2,1) = falliceout(yy);
        c2 = c2+1;
        
        seasonicein(c2,1) = wintericein(yy);
        seasoniceout(c2,1) = wintericeout(yy);
        c2 = c2+1;
        
        seasonicein(c2,1) = springicein(yy);
        seasoniceout(c2,1) = springiceout(yy);
        c2 = c2+1;
        
        clear wii spi sui aui

    end
    
  
    % Add to structure
    SIP.month.icein = monthicein;
    SIP.month.iceout = monthiceout;
    SIP.year.icein = yearicein;
    SIP.year.iceout = yeariceout;
    SIP.winter.icein = wintericein;
    SIP.winter.iceout = wintericeout;
    SIP.spring.icein = springicein;
    SIP.spring.iceout = springiceout;
    SIP.summer.icein = summericein;
    SIP.summer.iceout = summericeout;
    SIP.fall.icein = fallicein;
    SIP.fall.iceout = falliceout;
    SIP.seasonal.icein = seasonicein;
    SIP.seasonal.iceout = seasoniceout;
    SIP.comment{length(SIP.comment)+1} = 'icein and iceout are the sum of ice transported in and out through the flux gate. Units are km^3/time. icein+iceout = E';

    figure; plot_dim(900,270)
    plot(SIP.year.dn, -SIP.year.icein, 'color', [0.2,0.4,0.8], 'linewidth', 1.2);
    hold on
    plot(SIP.year.dn, SIP.year.iceout, 'color', [0.7,0.2,0.2], 'linewidth', 1.2);
    %plot(SIP.year.dn, SIP.year.E, 'color', [.01,.01,.01])
    xticks(dnticker(1997,2021));
    datetick('x', 'mm-yyyy', 'keepticks');
    xtickangle(27);
    xlim([min(SIP.year.dn)-50, max(SIP.year.dn)+50]);
    legend('Ice in', 'Ice out', 'fontsize', 11);
    title(['Sector ',sector,' yearly Ice cross-gate transport components']);
    ylabel('Ice Transport [km^3]');
    grid on
    print(['ICE/Production/figures/Export/inout/sector',sector,'_iceiniceout.png'], '-dpng', '-r400');
    
    
    save(['ICE/Production/data/SIP/noGrowDecay/sector',sector,'.mat'], 'SIP', '-v7.3');
    
    
    
    % Build for sector 00
    s0icein = s0icein+SIP.icein;
    s0dayin = s0dayin+SIP.day.icein;
    s0monthin = s0monthin+SIP.month.icein;
    s0yearin = s0yearin+SIP.year.icein;
    s0winterin = s0winterin+SIP.winter.icein;
    s0springin = s0springin+SIP.spring.icein;
    s0summerin = s0summerin+SIP.summer.icein;
    s0fallin = s0fallin+SIP.fall.icein;
    s0seasonalin = s0seasonalin+SIP.seasonal.icein;
    
    s0iceout = s0iceout+SIP.iceout;
    s0dayout = s0dayout+SIP.day.iceout;
    s0monthout = s0monthout+SIP.month.iceout;
    s0yearout = s0yearout+SIP.year.iceout;
    s0winterout = s0winterout+SIP.winter.iceout;
    s0springout = s0springout+SIP.spring.iceout;
    s0summerout = s0summerout+SIP.summer.iceout;
    s0fallout = s0fallout+SIP.fall.iceout;
    s0seasonalout = s0seasonalout+SIP.seasonal.iceout;
    
    
    
    
    clearvars -except s0icein s0iceout s0dayin s0dayout s0monthin s0monthout s0yearin s0yearout...
        s0winterin s0winterout s0springin s0springout s0summerin s0summerout s0fallin s0fallout...
        s0seasonalin s0seasonalout secs selection
    


end

if selection==1
    %
    load ICE/Production/data/SIP/noJunkinJunkout/sector00.mat;
    SIP.icein = s0icein;
    SIP.iceout = s0iceout;
    SIP.day.icein = s0dayin;
    SIP.day.iceout = s0dayout;
    SIP.month.icein = s0monthin;
    SIP.month.iceout = s0monthout;
    SIP.year.icein = s0yearin;
    SIP.year.iceout = s0yearout;
    SIP.winter.icein = s0winterin;
    SIP.winter.iceout = s0winterout;
    SIP.spring.icein = s0springin;
    SIP.spring.iceout = s0springout;
    SIP.summer.icein = s0summerin;
    SIP.summer.iceout = s0summerout;
    SIP.fall.icein = s0fallin;
    SIP.fall.iceout = s0fallout;
    SIP.seasonal.icein = s0seasonalin;
    SIP.seasonal.iceout = s0seasonalout;
    SIP.comment{length(SIP.comment)+1} = 'icein and iceout are the sum of ice transported in and out through the flux gate. Units are km^3/time. icein+iceout = E';


    save('ICE/Production/data/SIP/noGrowDecay/sector00.mat', 'SIP', '-v7.3');

    figure; plot_dim(900,270)
    plot(SIP.year.dn, -SIP.year.icein, 'color', [0.2,0.4,0.8], 'linewidth', 1.2);
    hold on
    plot(SIP.year.dn, SIP.year.iceout, 'color', [0.7,0.2,0.2], 'linewidth', 1.2);
    %plot(SIP.year.dn, SIP.year.E, 'color', [.01,.01,.01])
    xticks(dnticker(1997,2021));
    datetick('x', 'mm-yyyy', 'keepticks');
    xtickangle(27);
    xlim([min(SIP.year.dn)-50, max(SIP.year.dn)+50]);
    legend('Ice in', 'Ice out', 'fontsize', 11);
    title(['Sector 00 yearly Ice cross-gate transport components']);
    ylabel('Ice Transport [km^3]');
    grid on
    print(['ICE/Production/figures/Export/inout/sector00_iceiniceout.png'], '-dpng', '-r400');

    
end




































%% Remake plots with universal y axis scale  OUTDATED... DO not run until looping is fixed
 
 
 
for ii = 1:18
    if ii < 10
        sector = ['0', num2str(ii)];
    else
        sector = num2str(ii);
    end

    load(['ICE/Production/data/SIP/sector',sector,'.mat'])
 
    figure; plot_dim(900,270)
    plot(SIP.year.dn, -SIP.year.icein, 'color', [0.2,0.4,0.8], 'linewidth', 1.2);
    hold on
    plot(SIP.year.dn, SIP.year.iceout, 'color', [0.7,0.2,0.2], 'linewidth', 1.2);
    %plot(SIP.year.dn, SIP.year.E, 'color', [.01,.01,.01])
    xticks(dnticker(1997,2021));
    datetick('x', 'mm-yyyy', 'keepticks');
    xtickangle(27);
    xlim([min(SIP.year.dn)-50, max(SIP.year.dn)+50]);
    legend('Ice in', 'Ice out', 'fontsize', 11);
    title(['Sector ',sector,' yearly Ice cross-gate transport components']);
    ylabel('Ice Transport [km^3]');
    grid on
    ylim([0,2000])
    print(['ICE/Production/figures/Export/inout/sector',sector,'_iceiniceout.png'], '-dpng', '-r400');

    clearvars
    
end
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 





