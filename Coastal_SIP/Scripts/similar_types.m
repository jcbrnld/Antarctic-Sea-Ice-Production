% Jacob Arnold
% 27-May-2022

% Compare yearly SIP timeseries for sectors of the same type 




% Three types: 
% +E; +dSIV  --> sectors 2, 3, 7
% +E; -dSIV  --> sectors 4, 5, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17
% -E; -dSIV  --> sectors 1, 6, 18


%% ++

sectors = {'02', '03', '07'};
for ii = 1:length(sectors)
    sector = sectors{ii};
    load(['ICE/Production/data/SIP/sector',sector,'.mat']);
    yP(:,ii) = SIP.year.P;
    yE(:,ii) = SIP.year.E;
    ydSIV(:,ii) = SIP.year.dSIV;
    
    sP(:,ii) = SIP.seasonal.P;
    sE(:,ii) = SIP.seasonal.E;
    sdSIV(:,ii) = SIP.seasonal.dSIV;
    
    
    ydn = SIP.year.dn;
    sdn = SIP.seasonal.dn;
    clear SIP
    
end



figure;
plot_dim(900,900);

subplot(3,1,1)
plot(ydn, yP, 'linewidth', 1.2);
legend('02', '03', '07', 'fontsize', 11, 'location', 'south', 'orientation', 'horizontal')
title('Type 1 (++) Yearly SIP')
xticks(dnticker(1997,2021));
datetick('x', 'mm-yyyy', 'keepticks')
xtickangle(30);
xlim([min(dn)-50, max(dn)+50]);

subplot(3,1,2)
plot(ydn, yE, 'linewidth', 1.2);
legend('02', '03', '07', 'fontsize', 11, 'location', 'south', 'orientation', 'horizontal')
title('Type 1 (++) Yearly Export')
xticks(dnticker(1997,2021));
datetick('x', 'mm-yyyy', 'keepticks')
xtickangle(30);
xlim([min(dn)-50, max(dn)+50]);

subplot(3,1,3)
plot(ydn, ydSIV, 'linewidth', 1.2);
legend('02', '03', '07', 'fontsize', 11, 'location', 'south', 'orientation', 'horizontal')
title('Type 1 (++) Yearly dSIV')
xticks(dnticker(1997,2021));
datetick('x', 'mm-yyyy', 'keepticks')
xtickangle(30);
xlim([min(dn)-50, max(dn)+50]);

print(['ICE/Production/figures/SIP/same_types/type1YEARLY.png'], '-dpng', '-r400');



figure;
plot_dim(900,900);

subplot(3,1,1)
plot(sdn, sP, 'linewidth', 1.2);
legend('02', '03', '07', 'fontsize', 11, 'location', 'south', 'orientation', 'horizontal')
title('Type 1 (++) Seasonal SIP')
xticks(dnticker(1997,2021));
datetick('x', 'mm-yyyy', 'keepticks')
xtickangle(30);
xlim([min(dn)-50, max(dn)+50]);

subplot(3,1,2)
plot(sdn, sE, 'linewidth', 1.2);
legend('02', '03', '07', 'fontsize', 11, 'location', 'south', 'orientation', 'horizontal')
title('Type 1 (++) Seasonal Export')
xticks(dnticker(1997,2021));
datetick('x', 'mm-yyyy', 'keepticks')
xtickangle(30);
xlim([min(dn)-50, max(dn)+50]);

subplot(3,1,3)
plot(sdn, sdSIV, 'linewidth', 1.2);
legend('02', '03', '07', 'fontsize', 11, 'location', 'south', 'orientation', 'horizontal')
title('Type 1 (++) Seasonal dSIV')
xticks(dnticker(1997,2021));
datetick('x', 'mm-yyyy', 'keepticks')
xtickangle(30);
xlim([min(dn)-50, max(dn)+50]);

print(['ICE/Production/figures/SIP/same_types/type1SEASONAL.png'], '-dpng', '-r400');



%% For all sectors make timeseries of sector type per year

secs = [2, 3, 7]; type = [];
for ii = 1:length(secs)
    if secs(ii) < 10
        sector = ['0', num2str(secs(ii))];
    else
        sector = num2str(secs(ii));
    end
    
    load(['ICE/Production/data/SIP/sector',sector,'.mat']);
    
    years = 1998:2020; 
    for yy = 1:length(years)
        loc = find(SIP.year.dv(:,1) == years(yy));
        if SIP.year.E(loc)>0 & SIP.year.dSIV(loc)>0
            type(yy,ii) = 1;
        elseif SIP.year.E(loc)>0 & SIP.year.dSIV(loc)<0
            type(yy,ii) = 2;
        elseif SIP.year.E(loc)<0 & SIP.year.dSIV(loc)>0
            type(yy,ii) = 3;
        elseif SIP.year.E(loc)<0 & SIP.year.dSIV(loc)<0
            type(yy,ii) = 4;
        end
        
        clear loc
        
    end
    
    
    
end


figure;
    plot_dim(900,250);
    for ss = 1:length(secs)
        scatter(years, type(:,ss), 'filled'); hold on
    end
    ylim([0.5,4.5]);
    xticks(years)
    xlim([1997,2021])



%% Make yearly SIP plots with trendlines

% monthly and yearly timeseries
for ss = 0:18
    if ss < 10
        sector = ['0',num2str(ss)];
    else
        sector = num2str(ss);
    end
    
    load(['ICE/Production/data/SIP/sector',sector,'.mat']);
    SIP.year.dn = SIP.year.dn';
    mi = min([min(SIP.year.P), min(SIP.year.E), min(SIP.year.dSIV)]);
    ma = max([max(SIP.year.P), max(SIP.year.E), max(SIP.year.dSIV)]);
    
    p1 = polyfit(SIP.year.dn, SIP.year.P, 1); p2 = polyfit(SIP.year.dn, SIP.year.E, 1); p3 = polyfit(SIP.year.dn, SIP.year.dSIV, 1);
    y1 = polyval(p1, SIP.year.dn); y2 = polyval(p2, SIP.year.dn); y3 = polyval(p3, SIP.year.dn);
    slope1 = ((y1(2)-y1(1))/(SIP.year.dn(2)-SIP.year.dn(1)))*3652.4; % KM^3/decade
    slope2 = ((y2(2)-y2(1))/(SIP.year.dn(2)-SIP.year.dn(1)))*3652.4; % KM^3/decade
    slope3 = ((y3(2)-y3(1))/(SIP.year.dn(2)-SIP.year.dn(1)))*3652.4; % KM^3/decade
    
    
    figure;
    plot_dim(900,270);
    s1 = plot(SIP.year.dn, SIP.year.P, 'color', [.01,.01,.01], 'linewidth', 1.1);
    hold on; yline(0, 'color', [.01,.01,.01]);
    %plot(SIP.year.dn, SIP.year.E, 'color', [0.8,0.3,0.25], 'linewidth', 1.1);
    %plot(SIP.year.dn, SIP.year.dSIV, 'color', [0.2,0.7,0.4], 'linewidth', 1.1);
    s2 = plot(SIP.year.dn, SIP.year.E, 'color', 'm', 'linewidth', 1.1);
    s3 = plot(SIP.year.dn, SIP.year.dSIV, 'color', [0.2,0.86,0.92], 'linewidth', 1.1);
    plot(SIP.year.dn, y1, '--', 'color', [.01,.01,.01], 'linewidth', 1.1);
    plot(SIP.year.dn, y2, '--', 'color', 'm', 'linewidth', 1.1);
    plot(SIP.year.dn, y3, '--', 'color', [0.2,0.86,0.92], 'linewidth', 1.1);
    
    
    xticks(dnticker(1997,2021));
    datetick('x', 'mm-yyyy', 'keepticks');
    xtickangle(27);
    xlim([min(SIP.dn), max(SIP.dn)]);
    grid on
    title(['Sector ',sector,' Yearly SIP']);
    ylabel('SIP [km^3]');
    legend([s1, s2, s3], ['Production [slope = ', num2str(slope1),'km^3/dec]'], ['Export [slope = ', num2str(slope2),'km^3/dec]'], ['\DeltaSIV [slope = ',num2str(slope3), 'km^3/dec]'],...
        'orientation', 'horizontal', 'location', 'south', 'fontsize', 11);
    ylim([mi-(ma-mi)*0.17, ma+ma/20]);
    print(['ICE/Production/figures/SIP/yearly_timeseries/sector',sector,'yearly_TRENDLINES.png'], '-dpng', '-r300');
    

    clearvars
end





%% overplot same types production


secs = [2, 3, 7]; secs = 1:18;
figure; plot_dim(900,270);
for ii = 1:length(secs)
    if secs(ii) < 10
        sector = ['0', num2str(secs(ii))];
    else
        sector = num2str(secs(ii));
    end
    
    load(['ICE/Production/data/SIP/sector',sector,'.mat']);



    P(:,ii) = SIP.year.P;
    E(:,ii) = SIP.year.E;
    dSIV(:,ii) = SIP.year.dSIV;
    
    plot(SIP.year.dn, P(:,ii), 'linewidth', 1.2); hold on
    
end


tp = normalize(P);
figure;plot_dim(900,270);
plot(tp, 'linewidth', 1.2); colororder(colormapinterp(colormap('jet'), 18));
legend('1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18')





















