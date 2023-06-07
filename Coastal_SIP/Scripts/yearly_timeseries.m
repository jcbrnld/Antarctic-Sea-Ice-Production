% Jacob Arnold

% 13-July-2022

% Yearly timeseries of SIP
% Also return table of trends



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
for ii = 1:length(secs)
    sector = secs{ii};
    load(['ICE/Production/data/SIP/sector',sector,'.mat']);
    
    p = polyfit(SIP.year.dn, SIP.year.P', 1);
    y = polyval(p, SIP.year.dn); 
%     slope(ii,1) = ((y(2)-y(1))/(SIP.year.dn(2)-SIP.year.dn(1)))*3652.4; %SIP/decade trend
%     slope2(ii,1) = (slope(ii)/y(round(length(y)/2)))*100; % %/decade trend
     slope3(ii,1) = y(2)-y(1); % trend/year
    %slope4(ii,1) = (slope3(ii)/y(round(length(y)/2)))*100; % %/year
    %slope4(ii, 1) = mean(diff(y)./abs(diff(SIP.year.P')), 'all')*100;
    slope4(ii,1) = (slope3(ii)/abs(nanmean(SIP.year.P)))*100;
    
    differ = max(SIP.year.P)-min(SIP.year.P);
    figure;
    plot_dim(800,180);
    p1 = plot(SIP.year.dn, SIP.year.P, 'linewidth', 1.1, 'color', [0.9,0.3,0.3]);
    hold on
    p2 = plot(SIP.year.dn, y, '--', 'linewidth', 1.1, 'color', [.1,.1,.1]);
    xticks(dnticker(1997,2021));
    datetick('x', 'mm-yyyy', 'keepticks');
    xtickangle(30);
    xlim([min(SIP.year.dn)-50, max(SIP.year.dn)+50]);
    title(['Sector ',sector,' yearly SIP']);
    ylim([min(SIP.year.P)-differ*.25, max(SIP.year.P)+differ*.25]);
    yline(0);
    %yticks([-70:20:300])
    legend(p2, ['Slope = ',num2str(slope4(ii)), '% yr^-^1'], 'fontsize', 12);
    ylabel('SIP [km^3]');
    
    
    print(['ICE/Production/figures/SIP/yearly_timeseries/sector',sector,'.png'], '-dpng', '-r400');

    clear SIP p y sector
    
end

%%

% Same but for growth season (fall and winter) production


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
for ii = 1:length(secs)
    sector = secs{ii};
    load(['ICE/Production/data/SIP/sector',sector,'.mat']);
    
    p = polyfit(SIP.grow.dn, SIP.grow.P, 1);
    y = polyval(p, SIP.grow.dn); 
%     slope(ii,1) = ((y(2)-y(1))/(SIP.grow.dn(2)-SIP.grow.dn(1)))*3652.4; %SIP/decade trend
%     slope2(ii,1) = (slope(ii)/y(round(length(y)/2)))*100; % %/decade trend
     slope3(ii,1) = y(2)-y(1); % trend/grow
    %slope4(ii,1) = (slope3(ii)/y(round(length(y)/2)))*100; % %/grow
    %slope4(ii, 1) = mean(diff(y)./abs(diff(SIP.grow.P')), 'all')*100;
    slope4(ii,1) = (slope3(ii)/abs(nanmean(SIP.grow.P)))*100;
    meanvals(ii,1) = nanmean(SIP.grow.P);
    
    differ = max(SIP.grow.P)-min(SIP.grow.P);
    figure;
    plot_dim(800,180);
    p1 = plot(SIP.grow.dn, SIP.grow.P, 'linewidth', 1.1, 'color', [0.9,0.3,0.3]);
    hold on
    p2 = plot(SIP.grow.dn, y, '--', 'linewidth', 1.1, 'color', [.1,.1,.1]);
    xticks(dnticker(1997,2021));
    datetick('x', 'mm-yyyy', 'keepticks');
    xtickangle(30);
    xlim([min(SIP.grow.dn)-50, max(SIP.grow.dn)+50]);
    title(['Sector ',sector,' Growing Season (Fall and Winter) SIP']);
    ylim([min(SIP.grow.P)-differ*.25, max(SIP.grow.P)+differ*.25]);
    yline(0);
    %yticks([-70:20:300])
    legend(p2, ['Slope = ',num2str(slope4(ii)), '% yr^-^1'], 'fontsize', 12);
    ylabel('SIP [km^3]');
    
    
    print(['ICE/Production/figures/SIP/growingSeasonTimeseries/sector',sector,'.png'], '-dpng', '-r400');

    clear SIP p y sector
    
end









