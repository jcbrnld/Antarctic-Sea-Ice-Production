% Jacob Arnold

% 08-Jun-2022

% Correlation between yearly SIP and SIC
% negative correlation --> low SIC = more open water = more heat
% exchange = more SIP.

% Also look at growing season correlation

for ii = 0:18
    if ii < 10
        sector = ['0', num2str(ii)];
    else
        sector = num2str(ii);
    end
    
    load(['ICE/Production/data/SIP/sector',sector,'.mat']);
    load(['ICE/Concentration/ant-sectors/SIP_timescale/sector',sector,'.mat']);
    
    
    c = corrcoef(SIP.year.P, nanmean(SIC.year.sic), 'rows', 'pairwise');
    SIPSIC(ii+1,1) = c(2);
    
    c2 = corrcoef(SIP.year.E, nanmean(SIC.year.sic), 'rows', 'pairwise');
    SIESIC(ii+1,1) = c2(2);
    
    c3 = corrcoef(SIP.year.dSIV, nanmean(SIC.year.sic), 'rows', 'pairwise');
    SIVSIC(ii+1,1) = c3(2);
    
    c4 = corrcoef(SIP.year.icein, nanmean(SIC.year.sic), 'rows', 'pairwise');
    inSIC(ii+1,1) = c4(2);
    
    c5 = corrcoef(SIP.year.iceout, nanmean(SIC.year.sic), 'rows', 'pairwise');
    outSIC(ii+1,1) = c5(2);
    
    c6 = corrcoef(SIP.grow.P, nanmean(SIC.grow.sic), 'rows', 'pairwise');
    growSIPSIC(ii+1, 1) = c6(2);
    
    c7 = corrcoef(SIP.decay.P, nanmean(SIC.decay.sic), 'rows', 'pairwise');
    decaySIPSIC(ii+1,1) = c7(2);
    
    c8 = corrcoef(SIP.grow.icein, nanmean(SIC.grow.sic), 'rows', 'pairwise');
    growINSIC(ii+1,1) = c4(2);
    
    c9 = corrcoef(SIP.grow.iceout, nanmean(SIC.grow.sic), 'rows', 'pairwise');
    growOUTSIC(ii+1,1) = c5(2);
    
    c10 = corrcoef(SIP.decay.icein, nanmean(SIC.decay.sic), 'rows', 'pairwise');
    decayINSIC(ii+1,1) = c4(2);
    
    c11 = corrcoef(SIP.decay.iceout, nanmean(SIC.decay.sic), 'rows', 'pairwise');
    decayOUTSIC(ii+1,1) = c5(2);
    
    clear SIP SIC c c2 c3 c4 c5 c6 c7 c8 c9 c10 c11
    
end


    