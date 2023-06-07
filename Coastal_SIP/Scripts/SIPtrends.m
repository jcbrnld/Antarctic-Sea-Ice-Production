% Jacob Arnold

% 15-Aug-2022

% Plot SIP with trend lines for both 1998-2020 and 1998-2013
% also report trends for table


secs = ja_aagatedregions(3);
for ii = 1:length(secs)
    sector = secs{ii};
    load(['ICE/Production/data/SIP/sector',sector,'.mat']);
    
    sdn = SIP.month.dn(1:192);
    p1 = polyfit(SIP.month.dn, SIP.month.P', 1);
    p2 = polyfit(sdn, SIP.month.P(1:192)', 1);
    y1 = polyval(p1, SIP.month.dn);
    y2 = polyval(p2, sdn);
    
    
    figure;plot_dim(1000,250);
    plot(SIP.month.dn, SIP.month.P, 'linewidth', 1.1, 'color', [.01,.01,.01]);
    hold on
    plot(SIP.month.dn, y1, '--', 'linewidth', 1);
    plot(sdn, y2, '-.', 'linewidth', 1);
    

