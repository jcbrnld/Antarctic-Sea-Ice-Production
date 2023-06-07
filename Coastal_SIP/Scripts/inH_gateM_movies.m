% Jacob Arnold

% 06-Sep-2022

% Create movies of interior SIT and gate normal motion vectors 
% also plot SIP timeseries with vertical line tracking progress 




secs = ja_aagatedregions(5);

for ss = 4:length(secs)
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
    
    fP = filtout(SIP.P, 13);
    
    for ii = 1:length(SIP.P)
        if ismember(ii,cntr)
            disp(['Finished through... ' datestr(SIP.dn(ii))])
        end
        
        figure;
        s1 = subplot(4,1,1:3); 
        set(s1, 'Position', [0.1,0.3,0.81,0.6])
        if str2num(sector) == 01
            plot_dim(800,950);
        else
            plot_dim(800,800);
        end
        
        zeroind = find(H(:,ii)<=0.05);
        cat2 = find(H(:,ii)>0.05 & H(:,ii)<0.3);
        m_basemap_subplot('m', londom, latdom);
        scat1 = m_scatter(lon, lat, sdot+sdot*multfac, H(:,ii), 'filled');
        %________
        cmap = colormap(colormapinterp(mycolormap('id3'),10, [0.99    0.76    0.6469], [0,0,0])); % ASSIGN this color to 0
        % Scatter plot specifc categories
        m_scatter(lon(zeroind), lat(zeroind), sdot+sdot*multfac, cmap(1,:), 'filled'); % [0.2,0.01,0.15]
        m_scatter(lon(cat2), lat(cat2), sdot+sdot*multfac, cmap(2,:), 'filled'); % [0.2,0.01,0.15]
        m_plot(gate.lon, gate.lat, 'm', 'linewidth', 1.1);
        m_quiver(gate.midlon, gate.midlat, gate.midnx(:,ii), gate.midny(:,ii),'color', [.02,.02,.02], 'linewidth', 1.1, 'ShowArrowHead', 'off');
        m_scatter(gate.midlon(isfinite(gate.midn(:,ii))), gate.midlat(isfinite(gate.midn(:,ii))), sdot*1.5, [.01,.01,.01], 'filled')

        cbh = colorbar;
        cbh.Ticks = [-0.3:0.3:2.4];
        cbh.Label.String = ('Sea Ice Thickness [m]');
        cbh.FontSize = 13;
        cbh.Label.FontSize = 15;
        cbh.Label.FontWeight = 'bold';
        caxis([-0.3,2.7]);
        %cbh.TickDirection = 'out'
        cbh.TickLength = tickl;
        cbh.TickLabels = {'0','0.05','0.3','0.6','0.9','1.2','1.5','1.8','2.1','2.4'}; % if including nan

        title(['Sector ',sector,': ',datestr(SIP.dn(ii))],...
             'fontsize', 15, 'fontweight', 'bold');

        s2 = subplot(4,1,4);
        linevar = SIP.P;
        set(s2, 'Position', s2pos)

        %plot(SIP.dn, linevar, 'linewidth', 1,'color', [0.01,0.01,0.01,.2]); hold on
        plot(SIP.dn, fP, 'linewidth', 1.4, 'color', [0.05,0.5,0.4]);
        xline(SIP.dn(ii), 'linewidth', 1.2, 'color', [0.9, 0.3, 0.4]);
        xticks(dnticker(1997,2022));
        xtickangle(27)
        datetick('x', 'mm-yyyy', 'keepticks')
        xlim([min(SIP.dn)-50, max(SIP.dn)+50]);
        ylabel('SIP [km^3 wk^-^1]', 'fontweight', 'bold')
        grid on
        yline(0, '--m');

        F(ii) = getframe(gcf);

        clear nanlocs s1 s2 
        close gcf

    end
    
    writerobj = VideoWriter(['ICE/Production/figures/Videos/sector',sector,'_SIT_GateSIM_SIP.mp4'], 'MPEG-4');

    writerobj.FrameRate = 5;
    open (writerobj);

    for jj=1:length(F)
        frame = F(jj);
        writeVideo(writerobj, frame);
    end
    close(writerobj);
    disp(['Success! Sector ',sector,' Video saved'])

    clearvars -except secs

end
