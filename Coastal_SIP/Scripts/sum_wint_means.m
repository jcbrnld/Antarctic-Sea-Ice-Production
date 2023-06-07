% Jacob Arnold

% 08-Sep-2022




% plot winter and summer mean gate SIM and interior H conditions 


secs = ja_aagatedregions(5);

for ss = 1:length(secs)
    sector = secs{ss};
    s = sector(1:2);
    
    load(['ICE/Production/data/SIP/sector',sector,'.mat']);
    load(['ICE/Sectors/Gates/mat_files/sector_gates/sector',sector,'_gb15s_shelf.mat']);
    clear gate2
    H = gate.inside.Hin(:,2:1210); % grab just H matching SIM dates
    lon = gate.inside.lon;
    lat = gate.inside.lat;
    [lpos, xpos, s2pos, tickl, multfac] = sector_movie_params(s,1);
    
    cntr = [1:50:2000];
    [londom, latdom] = sectordomain(str2num(s));
    sdot = sectordotsize(str2num(sector));
    
    % find winter indices
    % winter only
    %wloc = find((gate.dv(:,2)==6 & gate.dv(:,3)>15) | gate.dv(:,2)==7 | gate.dv(:,2)==8 | (gate.dv(:,2)==9 & gate.dv(:,3)<=15));
    
    % fall and winter
    wloc = find((gate.dv(:,2)==3 & gate.dv(:,3)>15) | gate.dv(:,2)==4 | gate.dv(:,2)==5 | ...
    gate.dv(:,2)==6 | gate.dv(:,2)==7 | gate.dv(:,2)==8 | (gate.dv(:,2)==9 & gate.dv(:,3)<=15));

    wintH = nanmean(gate.inside.Hin(:,wloc),2);
    wintmidnx = nanmean(gate.midnx(:,wloc),2);
    wintmidny = nanmean(gate.midny(:,wloc),2);

    zeroind = find(wintH<=0.05);
    cat2 = find(wintH>0.05 & wintH<0.3);
    m_basemap('m', londom, latdom);
    scat1 = m_scatter(lon, lat, sdot+sdot*multfac, wintH, 'filled');
    
    cmap = colormap(colormapinterp(mycolormap('id3'),10, [0.99    0.76    0.6469], [0,0,0])); % ASSIGN this color to 0
    % Scatter plot specifc categories
    m_scatter(lon(zeroind), lat(zeroind), sdot+sdot*multfac, cmap(1,:), 'filled'); % [0.2,0.01,0.15]
    m_scatter(lon(cat2), lat(cat2), sdot+sdot*multfac, cmap(2,:), 'filled'); % [0.2,0.01,0.15]
    m_plot(gate.lon, gate.lat, 'm', 'linewidth', 1.1);
    m_quiver(gate.midlon, gate.midlat, wintmidnx, wintmidny,'color', [.02,.02,.02], 'linewidth', 1.1, 'ShowArrowHead', 'off');
    m_scatter(gate.midlon(isfinite(wintmidnx)), gate.midlat(isfinite(wintmidny)), sdot*1.5, [.01,.01,.01], 'filled')

    cbh = colorbar;
    cbh.Ticks = [-0.3:0.3:2.4];
    cbh.Label.String = ('Sea Ice Thickness [m]');
    cbh.FontSize = 13;
    cbh.Label.FontSize = 15;
    cbh.Label.FontWeight = 'bold';
    caxis([-0.3,2.7]);
    %cbh.TickDirection = 'out'
    %cbh.TickLength = tickl;
    cbh.TickLabels = {'0','0.05','0.3','0.6','0.9','1.2','1.5','1.8','2.1','2.4'}; % if including nan
    title(['Sector ',sector,' Fall and Winter mean SIT and Perpendicular SIM']);
    print(['ICE/Production/figures/mean_conditions/fal_win_means.png'], '-dpng', '-r400');
    
    % Summer only
    %sloc = find((gate.dv(:,2)==12 & gate.dv(:,3)>15) | gate.dv(:,2)==1 | gate.dv(:,2)==2 | (gate.dv(:,2)==3 & gate.dv(:,3)<=15));
    
    % Spring and Summer
    sloc = find((gate.dv(:,2)==9 & gate.dv(:,3)>15) | gate.dv(:,2)==10 | gate.dv(:,2)==11 | ...
    gate.dv(:,2)==12 | gate.dv(:,2)==1 | gate.dv(:,2)==2 | (gate.dv(:,2)==3 & gate.dv(:,3)<=15));

    sumH = nanmean(gate.inside.Hin(:,sloc),2);
    summidnx = nanmean(gate.midnx(:,sloc),2);
    summidny = nanmean(gate.midny(:,sloc),2);

    zeroind = find(sumH<=0.05);
    cat2 = find(sumH>0.05 & sumH<0.3);
    m_basemap('m', londom, latdom);
    scat1 = m_scatter(lon, lat, sdot+sdot*multfac, sumH, 'filled');
    
    cmap = colormap(colormapinterp(mycolormap('id3'),10, [0.99    0.76    0.6469], [0,0,0])); % ASSIGN this color to 0
    % Scatter plot specifc categories
    m_scatter(lon(zeroind), lat(zeroind), sdot+sdot*multfac, cmap(1,:), 'filled'); % [0.2,0.01,0.15]
    m_scatter(lon(cat2), lat(cat2), sdot+sdot*multfac, cmap(2,:), 'filled'); % [0.2,0.01,0.15]
    m_plot(gate.lon, gate.lat, 'm', 'linewidth', 1.1);
    m_quiver(gate.midlon, gate.midlat, summidnx, summidny,'color', [.02,.02,.02], 'linewidth', 1.1, 'ShowArrowHead', 'off');
    m_scatter(gate.midlon(isfinite(summidnx)), gate.midlat(isfinite(summidny)), sdot*1.5, [.01,.01,.01], 'filled')

    cbh = colorbar;
    cbh.Ticks = [-0.3:0.3:2.4];
    cbh.Label.String = ('Sea Ice Thickness [m]');
    cbh.FontSize = 13;
    cbh.Label.FontSize = 15;
    cbh.Label.FontWeight = 'bold';
    caxis([-0.3,2.7]);
    %cbh.TickDirection = 'out'
    %cbh.TickLength = tickl;
    cbh.TickLabels = {'0','0.05','0.3','0.6','0.9','1.2','1.5','1.8','2.1','2.4'}; % if including nan
    title(['Sector ',sector,' Spring and Summer mean SIT and Perpendicular SIM']);

    print(['ICE/Production/figures/mean_conditions/spr_sum_means.png'], '-dpng', '-r400');

    clearvars -except secs
end






