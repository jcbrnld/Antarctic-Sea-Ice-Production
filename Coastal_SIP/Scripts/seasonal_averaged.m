% Jacob Arnold

% 02-May-2022

% Calculate mean seasonal SIP, SIE, dSIV for all sectors

for ii = 0:18
    if ii < 10
        sector = ['0', num2str(ii)];
    else
        sector = num2str(ii);
    end
    
    load(['ICE/Production/data/SIP/sector',sector,'.mat']);
    
    wintP(ii+1,1) = nanmean(SIP.winter.P);
    sprP(ii+1,1) = nanmean(SIP.spring.P);
    summP(ii+1,1) = nanmean(SIP.summer.P);
    fallP(ii+1,1) = nanmean(SIP.fall.P);
    
    wintE(ii+1,1) = nanmean(SIP.winter.E);
    sprE(ii+1,1) = nanmean(SIP.spring.E);
    summE(ii+1,1) = nanmean(SIP.summer.E);
    fallE(ii+1,1) = nanmean(SIP.fall.E);
    
    wintdSIV(ii+1,1) = nanmean(SIP.winter.dSIV);
    sprdSIV(ii+1,1) = nanmean(SIP.spring.dSIV);
    summdSIV(ii+1,1) = nanmean(SIP.summer.dSIV);
    falldSIV(ii+1,1) = nanmean(SIP.fall.dSIV);
    
   clear SIP sector 
end
    

seas_vals = [wintP, sprP, summP, fallP, wintE, sprE, summE, fallE, wintdSIV, sprdSIV, summdSIV, falldSIV];

