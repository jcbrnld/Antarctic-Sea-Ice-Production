% Jacob Arnold
% 07-Jun-2022

% Correlation between yearly import and export
% Highly correlated --> import and export increase and decrease
% concurrently meaning the sector acts as a corridor. 


%% Correct icein sign first --> its negative but positive is better
for ii = 0:18
    if ii < 10
        sector = ['0', num2str(ii)];
    else
        sector = num2str(ii);
    end
    disp(['Correcting icein sign for sector ',sector,'...'])
    load(['ICE/Production/data/SIP/wrong_iceinsign/sector',sector,'.mat']);
    
    SIP.icein = -SIP.icein;
    SIP.year.icein = -SIP.year.icein;
    SIP.winter.icein = -SIP.winter.icein;
    SIP.summer.icein = -SIP.summer.icein;
    SIP.spring.icein = -SIP.spring.icein;
    SIP.fall.icein = -SIP.fall.icein;
    SIP.day.icein = -SIP.day.icein;
    SIP.month.icein = -SIP.month.icein;
    SIP.seasonal.icein = -SIP.seasonal.icein;
    SIP.grow.icein = -SIP.grow.icein;
    SIP.decay.icein = -SIP.decay.icein;
    SIP.twoseason.icein = -SIP.twoseason.icein;
    
    save(['ICE/Production/data/SIP/sector',sector,'.mat'], 'SIP', '-v7.3');
    
    clearvars
end


%%

for ii = 0:18
    if ii < 10
        sector = ['0', num2str(ii)];
    else
        sector = num2str(ii);
    end
    
    load(['ICE/Production/data/SIP/sector',sector,'.mat']);
    
    c = corrcoef([SIP.year.icein, SIP.year.iceout]);
    
    icecorr(ii+1,1) = c(2);
    
    clear c SIP
    
end

% icecorr =
% 
%     0.7655
%     0.7035
%     0.2266
%     0.6257
%     0.0928
%     0.0236
%    -0.0649
%     0.3300
%     0.4225
%     0.5464
%     0.1949
%     0.0477
%     0.0853
%     0.5164
%     0.3296
%     0.4610
%     0.4115
%     0.2571
%     0.8591



%% Play with sector comparisons

% First sectors 01, 02, 03
sectors = {'01', '02', '03'}; l = length(sectors);

for ii = 1:l
    load(['ICE/Production/data/SIP/sector',sectors{ii},'.mat']);
    in(:,ii) = SIP.year.icein;
    out(:,ii) = SIP.year.iceout;
    clear SIP
end

years = 1998:2020;
figure; plot_dim(900,270);
plot(years, in, 'linewidth', 1.2); 
hold on
plot(years, out, 'linewidth', 1.2);
xticks(years); xlim([1997.5, 2020.5]);
xtickangle(20)
%                             BLUES                               REDS
%colororder([0.5,0.6,0.99; 0.2,0.4,0.99; 0.1,0.2,0.6; 0.99,0.6,0.6; 0.99,0.1,0.1;0.6,0.2,0.2])
c = colormapinterp(mycolormap('grp'), l*2); c(l+1:6,:) = flip(c(l+1:6,:));
colororder(c);
legend([sectors, sectors], 'location', 'north', 'orientation', 'horizontal', 'fontsize', 11)
title('Yearly gross import (green) and export (purple)');
ylabel('Yearly transport [km^3]')

%print('ICE/Production/figures/COMPARISONS/secs010203_IN_OUT.png', '-dpng', '-r400');





