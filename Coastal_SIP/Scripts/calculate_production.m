% Jacob Arnold

% 04-May-2022

% Calculate sea ice production using sea ice transport across the flux gate
% and interior sea ice volume change.

% 1. find which interior grid points fall within the gate
% 2. Calculate SIV for each week at those grid points in km^3 
% 3. create timeseries of weekly volume change (size = length(dn)-1) units = km^3
% 4. average transport between all weeks so it temporally matches interior volume change timseries
% 5. convert transport from m^3/s to km^3/week
% 6. sum 3 and 5 outputs

clear all
lists = {'all', 'only valid', 'special', '-99 sectors'};
selection = listdlg('liststring', lists, 'promptstring', 'Which sector category?', 'selectionmode', 'single');
if selection == 1
    secs = ja_aagatedregions; 
elseif selection == 2
    secs = ja_aagatedregions(3);
elseif selection == 3
    secs = ja_aagatedregions(4);
elseif selection == 4
    secs = ja_aagatedregions(-99);    
end
for mm = 1:length(secs)
    sector = secs{mm}; s = sector(1:2);
    disp(['Beginning sector ',sector,'...'])
    [~, ~, ~, tickl, multfac] = sector_movie_params(s,1);
    load(['ICE/Sectors/Gates/mat_files/sector_gates/sector',sector,'.mat']);
    
    sectortouch = gate.sectors_touched;
    if ~iscell(sectortouch)
        load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sectortouch,'.mat']);
    elseif iscell(sectortouch)
        nsit.H = []; nsit.lon = []; nsit.lat = [];
        for ii = 1:length(sectortouch)
            load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sectortouch{ii},'.mat']);
            nsit.H = [nsit.H; SIT.H];
            nsit.lon = [nsit.lon; SIT.lon];
            nsit.lat = [nsit.lat; SIT.lat];
            nsit.dn = SIT.dn;nsit.dv = SIT.dv;
            clear SIT
        end
        SIT = nsit; clear nsit
    end

    %%% 1 and 2. find interior points and calc. SIV

    plon = gate.whole.lon;
    plat = gate.whole.lat;

    [px,py] = ll2ps(plat, plon); % poly x and y
    [gx,gy] = ll2ps(SIT.lat, SIT.lon); % grid x and y
    
    in = find(inpolygon(gx, gy, px, py));
    
    inH = SIT.H(in,:); % H within flux gate
    inV = sum((inH./1000).*(3.125^2), 1,'omitnan'); % convert H from m to km then multiply by grid cell area and sum

    figure;
    plot(SIT.dn, inV, 'linewidth', 1.1, 'color', [0.9,0.5,0.5]); plot_dim(1000,300);
    xticks(dnticker(1997,2022));
    datetick('x', 'mm-yyyy', 'keepticks')
    xtickangle(27)
    xlim([min(gate.dn)-50, max(gate.dn)+50]);
    ylabel('Sea Ice Volume [km^3]');
    title(['Sector ',sector,' Sea Ice Volume Within Gate']);
    %print(['ICE/Production/Figures/interior_volume/sector',sector,'int_volume.png'], '-dpng', '-r300');

    
    [londom, latdom] = sectordomain(str2num(s));
    m_basemap('m', londom, latdom); sectorexpand(str2num(s)); dots = sectordotsize(str2num(s));
    m_scatter(SIT.lon, SIT.lat, dots, [0.8,0.8,0.8], 'filled');
    m_scatter(SIT.lon(in), SIT.lat(in), dots, [0.5,0.6,0.8], 'filled')
    m_plot(gate.lon, gate.lat, 'color', [0.02,.02,.02], 'linewidth', 1.1);
    m_scatter(gate.lon, gate.lat, dots*3, [0.9,0.5,0.5], 'filled');
    title(['Sector ',sector,' grid points within gate']);
    %print(['ICE/Production/Figures/gridpoints_withingates/sector',sector,'gateandgrid.png'], '-dpng', '-r300');

    
    %%% 3 and 4. SIV change each week and average transport to each week pair
    newdn = SIT.dn(2:1210);
    for ww = 1:length(newdn)
        %newdn(ww) = SIT.dn(ww)+3; % just for plotting
        dSIV(ww) = inV(ww+1)-inV(ww);
        
        %mtrans(ww) = (gate.nettrans(ww)+gate.nettrans(ww+1))/2; % mean transport --> should be size(dn)-1
    end
    mtrans = gate.nettrans(2:end); % start with second week
    
    figure;
    plot(newdn, dSIV, 'linewidth', 1.1, 'color', [0.9,0.3,0.3]); plot_dim(1000,300);
    xticks(dnticker(1997,2022));
    datetick('x', 'mm-yyyy', 'keepticks')
    xtickangle(27)
    xlim([min(newdn)-50, max(newdn)+50]);
    ylabel('Sea Ice Volume [km^3]');
    title(['Sector ',sector,' Sea Ice Volume Change']);
    yline(0, '--', 'color', [0.02,.02,.02], 'linewidth', 1.2);
    %print(['ICE/Production/Figures/interior_volume_change/sector',sector,'int_volume_change.png'], '-dpng', '-r300');

   %%% 5. 
    transkm = (mtrans .* (60 * 60 * 24 * 7))./1000000000;
%km^3/week = (m^3/s * 60s/m * 60m/h * 24h/d * 7d/w * 1km^3/1000000000m^3)
    figure;
    plot(newdn, transkm, 'linewidth', 1.1, 'color', [0.4,0.6,0.4]); plot_dim(1000,300);
    xticks(dnticker(1997,2022));
    datetick('x', 'mm-yyyy', 'keepticks')
    xtickangle(27)
    xlim([min(newdn)-50, max(newdn)+50]);
    ylabel('Sea Ice Volume [km^3]');
    title(['Sector ',sector,' Sea Ice Transport per week']);
    yline(0, '--', 'color', [0.02,.02,.02], 'linewidth', 1.2);
    %print(['ICE/Production/Figures/weekly_transport/sector',sector,'weeklytransport.png'], '-dpng', '-r300');

    figure;
    plot(newdn, dSIV, 'linewidth', 1.1, 'color', [0.9,0.3,0.3]); plot_dim(1000,300);
    hold on
    plot(newdn, transkm, 'linewidth', 1.1, 'color', [0.4,0.6,0.4]); plot_dim(1000,300);
    xticks(dnticker(1997,2022));
    datetick('x', 'mm-yyyy', 'keepticks')
    xtickangle(27)
    xlim([min(newdn)-50, max(newdn)+50]);
    ylabel('Sea Ice Volume [km^3]');
    title(['Sector ',sector,' Sea Ice Transport and interior volume change']);
    yline(0, '--', 'color', [0.02,.02,.02], 'linewidth', 1.2);
    %print(['ICE/Production/Figures/dv_and_trans/sector',sector,'weeklytransport_andvolume.png'], '-dpng', '-r300');

    
    fdSIV = filtout(dSIV, 13);
    ftranskm = filtout(transkm,13);
    
    figure;
    plot(newdn, dSIV,  'color', [0.9,0.3,0.3,.5]); plot_dim(1000,300);
    hold on
    plot(newdn, fdSIV, 'linewidth', 1.1, 'color', [0.6,0.2,0.2]);
    plot(newdn, transkm, 'color', [0.4,0.6,0.4,.5]); plot_dim(1000,300);
    plot(newdn, ftranskm, 'linewidth', 1.1, 'color', [0.2,0.5,0.2])
    xticks(dnticker(1997,2022));
    datetick('x', 'mm-yyyy', 'keepticks')
    xtickangle(27)
    xlim([min(newdn)-50, max(newdn)+50]);
    ylabel('Sea Ice Volume [km^3]');
    title(['Sector ',sector,' Sea Ice Transport and interior volume change']);
    yline(0, '--', 'color', [0.02,.02,.02], 'linewidth', 1.2);
    %print(['ICE/Production/Figures/dv_and_trans/filtered/sector',sector,'weeklytransport_andvolume.png'], '-dpng', '-r300');

    
    %%% 6. sum the two to get production 
    % only dn 1:
    P = dSIV(1:1209) + transkm(1:1209);
    
    filtSIP = filtout(P,13);
    figure;
    plot(newdn, P, 'linewidth', .8, 'color', [0.02,0.02,0.02]); plot_dim(1000,300);
    hold on;
    %plot(newdn, filtSIP, 'linewidth', 1.5, 'color', [0.7,0.2,0.2]);
    xticks(dnticker(1997,2022));
    datetick('x', 'mm-yyyy', 'keepticks')
    xtickangle(27)
    xlim([min(newdn)-50, max(newdn)+50]);
    ylabel('Sea Ice Production [km^3]');
    title(['Sector ',sector,' Sea Ice Production']);
    yline(0, '--', 'color', [0.99,.02,.6], 'linewidth', 1.2);
    %print(['ICE/Production/Figures/SIP/plain/sector',sector,'weeklyproductoin.png'], '-dpng', '-r300');
    
    SIP.longdn = SIT.dn(2:end);
    SIP.longdv = SIT.dv(2:end,:);
    SIP.pdn = newdn';
    SIP.pdv = datevec(newdn);
    SIP.P = P;
    SIP.transport = transkm(1:1209);
    SIP.dSIV = dSIV;
    SIP.comment = {'Notice there is no SIM data after 2020 so SIP only goes through december 2020'; 
        'longdn and longdv are dn and dv of SIT'; 'middn and middv are for the middle day of each week described by SIP';...
        'SIP is sea ice production'; 'transport is sea ice transport across the flux gate over each week period';...
        'dSIV is interior volume change within the gate'};
    
    save(['ICE/Production/data/SIP/without_daily_monthly_yearly/sector',sector,'.mat'], 'SIP', '-v7.3');
    
    clearvars  -except secs
    close all
    
end
    
    







%% BELOW IS FOR Upper and lower bound Error (none of the first look plots above)
% Identical to above calculation but for error using transup and translo
% for upper and lower bounds in addition to Hinplus and Hinminus


clear all
lists = {'all', 'only valid', 'special', '-99 sectors'};
selection = listdlg('liststring', lists, 'promptstring', 'Which sector category?', 'selectionmode', 'single');
if selection == 1
    secs = ja_aagatedregions; 
elseif selection == 2
    secs = ja_aagatedregions(3);
elseif selection == 3
    secs = ja_aagatedregions(4);
elseif selection == 4
    secs = ja_aagatedregions(-99);    
end
for mm = 1:length(secs)
    sector = secs{mm}; s = sector(1:2);
    disp(['Beginning sector ',sector,'...'])
    [~, ~, ~, tickl, multfac] = sector_movie_params(s,1);
    load(['ICE/Sectors/Gates/mat_files/sector_gates_withError/sector',sector,'.mat']);
    
    sectortouch = gate.sectors_touched;
    if ~iscell(sectortouch)
        load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sectortouch,'.mat']);
    elseif iscell(sectortouch)
        nsit.H = []; nsit.lon = []; nsit.lat = [];
        for ii = 1:length(sectortouch)
            load(['ICE/ICETHICKNESS/Data/MAT_files/Final/Sectors/sector',sectortouch{ii},'.mat']);
            nsit.H = [nsit.H; SIT.H];
            nsit.lon = [nsit.lon; SIT.lon];
            nsit.lat = [nsit.lat; SIT.lat];
            nsit.dn = SIT.dn;nsit.dv = SIT.dv;
            clear SIT
        end
        SIT = nsit; clear nsit
    end

    %%% 1 and 2. find interior points and calc. SIV

    plon = gate.whole.lon;
    plat = gate.whole.lat;

    [px,py] = ll2ps(plat, plon); % poly x and y
    [gx,gy] = ll2ps(SIT.lat, SIT.lon); % grid x and y
    
    in = find(inpolygon(gx, gy, px, py));
    
    %inH = SIT.H(in,:); % H within flux gate
    inHplus = gate.inside.Hinplus;
    inHminus = gate.inside.Hinminus;
    
    inVplus = sum((inHplus./1000).*(3.125^2), 1,'omitnan'); % convert H from m to km then multiply by grid cell area and sum
    inVminus = sum((inHminus./1000).*(3.125^2), 1,'omitnan');
    
    %%% 3 and 4. SIV change each week and average transport to each week pair
    newdn = gate.dn(2:1210);
    for ww = 1:length(newdn)
        dSIVplus(ww) = inVplus(ww+1)-inVplus(ww);
        dSIVminus(ww) = inVminus(ww+1)-inVminus(ww);
        
    end
    mtransup = gate.nettransup(2:end); % start with second week
    mtranslo = gate.nettranslo(2:end);
    
   %%% 5. 
    transkmup = (mtransup .* (60 * 60 * 24 * 7))./1000000000;
    %km^3/week = (m^3/s * 60s/m * 60m/h * 24h/d * 7d/w * 1km^3/1000000000m^3)
    transkmlo = (mtranslo .* (60 * 60 * 24 * 7))./1000000000;
    
    
    %%% 6. sum the two to get production 
    % only dn 1:
    Pup = dSIVplus(1:1209) + transkmup(1:1209);
    Plo = dSIVminus(1:1209) + transkmlo(1:1209);

    SIP.longdn = SIT.dn(2:end);
    SIP.longdv = SIT.dv(2:end,:);
    SIP.pdn = newdn';
    SIP.pdv = datevec(newdn);
    SIP.Pup = Pup;
    SIP.Plo = Plo;
    SIP.transportup = transkmup(1:1209);
    SIP.transportlo = transkmlo(1:1209);
    SIP.dSIVplus = dSIVplus;
    SIP.dSIVminus = dSIVminus;
    SIP.ERcomment = {'Pup and Plo are upper and lower production estimates based on H and SIM +- standard error';...
        'transportup and transportlo are the same but for transport';...
        'dSIVplus and dSIVminus are ?SIV of H+-standard error'};
    
    figure;plot(SIP.Pup);hold on;plot(SIP.Plo);
    
    save(['ICE/Production/data/SIP_with_error/sector',sector,'.mat'], 'SIP', '-v7.3');
    
    clearvars  -except secs 

end
    
    














