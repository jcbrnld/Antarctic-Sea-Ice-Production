% Jacob Arnold
% 7-March-2023
% SIP error generation

% The idea is to calculate monthly standard error for interior H, gate H,
% and gate SIM
% Then recalculate SIM twice: once with H+error and SIM+error and once with
% H-error and SIM-error

secs = ja_aagatedregions; 

for ss = 2:length(secs)
    sector = secs{ss};
    disp(['Beginning sector ', sector,'...'])
    load(['ICE/Sectors/Gates/mat_files/sector_gates/sector',sector,'_gb15s_shelf.mat']);
    clear gate2

    %%%
    % standard error--> SE = std(data)/sqrt(length(data))

    % Calculate standard error
    for gg = 1:length(gate.midlon)
        data = gate.midH(gg,:); % H
        datat = gate.midt(gg,:); % t
        datan = gate.midn(gg,:); % n
        for mm = 1:12
            month_ind = find(gate.dv(:,2)==mm);
            
            % H
            SE(gg,mm) = std(data(month_ind), 'omitnan')/sqrt(length(month_ind)); % size = # grid points, 12
            SElong(gg,month_ind) = SE(gg,mm); % same size as original data

            % t and n (SIM)
            tSE(gg,mm) = std(datat(month_ind), 'omitnan')/sqrt(length(month_ind));
            tSElong(gg,month_ind) = tSE(gg,mm);
            nSE(gg,mm) = std(datan(month_ind), 'omitnan')/sqrt(length(month_ind));
            nSElong(gg,month_ind) = nSE(gg,mm);
            clear month_ind
        end
        overallSE(gg,1:length(data)) = std(data, 'omitnan')/sqrt(length(data)); % rather than monthly
        clear data
    end
    
    disp('Finished gate')

    indv = gate.longdv; 
    indn = gate.longdn;
    clear SIT
    %%% Now interior H SE

    % Calculate standard error
    disp('Starting interior')
    counter = 0:1000:100000;
    for gg = 1:length(gate.inside.lon)
        if ismember(gg,counter)
            disp(['Finished through grid point ',num2str(gg),' of ',num2str(length(gate.inside.lon)),'...']);
        end
        data = gate.inside.Hin(gg,:);
        for mm = 1:12
            month_ind = find(indv(:,2)==mm);

            SEin(gg,mm) = std(data(month_ind), 'omitnan')/sqrt(length(month_ind)); % size = # grid points, 12
            SEinlong(gg,month_ind) = SEin(gg,mm); % same size as original data

           
            clear month_ind
        end
        overallSEin(gg,1:length(data)) = std(data, 'omitnan')/sqrt(length(data)); % rather than monthly
        clear data
    end

    %%% plot example

    figure;plot_dim(900,400)
    subplot(2,1,1)
    plot(gate.dn, nanmean(gate.midH+SElong))
    hold on;
    plot(gate.dn, nanmean(gate.midH-SElong))
    xticks(dnticker(1998,2022));
    datetick('x', 'yy', 'keepticks')
    xlim([min(gate.dn)-50, max(gate.dn)+50]);
    ylabel('SIT [m]')
    title(['Sector ',sector, ' mean gate H +- monthly standard error']); 
    legend('+', '-');

    subplot(2,1,2)
    plot(indn, nanmean(gate.inside.Hin+SEinlong))
    hold on;
    plot(indn, nanmean(gate.inside.Hin-SEinlong))
    xticks(dnticker(1998,2022));
    datetick('x', 'yy', 'keepticks')
    xlim([min(indn)-50, max(indn)+50]);
    ylabel('SIT [m]')
    title(['Sector ',sector, ' mean interior H +- monthly standard error']); 
    legend('+', '-');
    print(['ICE/Sectors/Gates/Figures/ERROR_fl/sector',sector,'_stdERROR.png'], '-dpng', '-r300');

    close 
    
    gate.inside.Hinplus = gate.inside.Hin+SEinlong;
    gate.inside.Hinminus = gate.inside.Hin-SEinlong;
    gate.inside.dn = indn;
    gate.inside.dv = indv;
    gate.inside.HstdER = SEinlong;
    gate.inside.comment{end+1} = 'Hinplus and minus are Hin +- HstdER which is the monthly standard error at each grid point';

    gate.midHplus = gate.midH+SElong;
    gate.midHminus = gate.midH-SElong;
    gate.midtplus = gate.midt+tSElong;
    gate.midtminus = gate.midt-tSElong;
    gate.midnplus = gate.midn+nSElong;
    gate.midnminus = gate.midn-nSElong;
    
    gate.midHstdER = SElong;
    gate.midtstdER = tSElong;
    gate.midnstdER = nSElong;
    
    gate.comment{end+1} = 'midHplus and minus are midH+- midHstdER which is the monthly standard error at each gate midpoint';

    disp(['finished and saving sector ',sector])
    save(['ICE/Sectors/Gates/mat_files/sector_gates_withError/sector',sector,'.mat'], 'gate', '-v7.3');

    clearvars -except secs

end



