% Jacob Arnold

% 11-Jul-2022

% Put together table of basic stats for all sectors SIP


% stats to calc;
% - mean weekly P 
% - mean yearly P
% - SIP trend [%/year]
% - mean grow season SIP
% - mean gate mid H
% - mean gate normal motion
% - gate length
% - grid area within gate
% - mean winter production
% - mean spring produciton
% - mean summer production
% - mean fall production


secs = ja_aagatedregions(4);
vals = nan(length(secs), 12);

for ii = 1:length(secs)
    sector = secs{ii};
    load(['ICE/Production/data/SIP/sector',sector,'.mat']);
    load(['ICE/Sectors/Gates/mat_files/sector_gates/sector',sector,'.mat']);
    p = polyfit(SIP.year.dn, SIP.year.P', 1);
    y = polyval(p, SIP.year.dn);
    slope = 100*((y(2)-y(1))/nanmean(SIP.year.P)); % %/year
    
    vals(ii,1) = nanmean(SIP.P); % mean weekly P [km^3]
    vals(ii,2) = nanmean(SIP.year.P); % mean yearly P [km^3]
    vals(ii,3) = slope; % SIP trend 
    vals(ii,4) = nanmean(SIP.grow.P); % grow season SIP
    vals(ii,5) = nanmean(gate.midH, 'all'); % - mean gate mid H
    vals(ii,6) = nanmean(gate.midn, 'all');  % - mean gate normal motion
    vals(ii,7) = gate.length; % - gate length [km]
    vals(ii,8) = length(gate.inside.infin)*(3.125^2); % - grid area within gate [km^2]
    vals(ii,9) = nanmean(SIP.winter.P); % - mean winter production [km^3]
    vals(ii,10) = nanmean(SIP.spring.P); % - mean spring produciton [km^3]
    vals(ii,11) = nanmean(SIP.summer.P); % - mean summer production [km^3]
    vals(ii,12) = nanmean(SIP.fall.P); % - mean fall production [km^3]
    
    clearvars -except vals secs
    
end



%% 

secs = ja_aagatedregions(3);

for ii = 1:length(secs)
    sector = secs{ii};
    load(['ICE/Production/data/SIP/sector',sector,'.mat']);
    
    % Climatological annual cycle peak monthly SIP 
    % get both SIP and DOY
    peak(ii,1) = max(SIP.RLmonthly.P);
    pmonth(ii,1) = find(SIP.RLmonthly.P==peak(ii));
    
    lowval(ii,1) = min(SIP.RLmonthly.P);
    t = find(SIP.RLmonthly.P==lowval(ii));
    lowmonth(ii,1) = t(1);
    
    clear SIP sector t
    
end
    
    
    
    
%% ice in and iceout

secs = ja_aagatedregions(3);

for ii = 1:length(secs)
    sector = secs{ii};
    load(['ICE/Production/data/SIP/sector',sector,'.mat']);
    
    in(ii,1) = nanmean(SIP.year.icein);
    out(ii,1) = nanmean(SIP.year.iceout);
    
    clear SIP sector 
end



%% sum and number of productive and counterproductive months in climatological annual cycle


secs = ja_aagatedregions(3);

for ii = 1:length(secs)
    sector = secs{ii};
    load(['ICE/Production/data/SIP/sector',sector,'.mat']);
    SIP.RLmonthly.P(end) = [];
    f = find(SIP.RLmonthly.P>0);
    promonths(ii,1) = length(f);
    pro(ii,1) = sum(SIP.RLmonthly.P(f));
    
    f2 = find(SIP.RLmonthly.P<0);
    sinmonths(ii,1) = length(f2);
    sink(ii,1) = sum(SIP.RLmonthly.P(f2));
    
    clear f f2 sector SIP
end






















