% Jacob Arnold

% 09-May-2022

% Create sector 00 SIP


P = zeros(1,1209);
dSIV = zeros(1,1209);
transport = P;
secs = ja_aagatedregions;
for ii = 1:length(secs)
    sector = secs{ii};

    load(['ICE/Production/data/SIP/without_daily_monthly_yearly/sector',sector,'.mat']);
    
    dn = SIP.longdn;
    dv = SIP.longdv;
    pdn = SIP.pdn;
    pdv = SIP.pdv;
    P = P+SIP.P;
    transport = transport+SIP.transport';
    dSIV = dSIV+SIP.dSIV;
    comment = SIP.comment;
    
   clear SIP
end


% build sector00
SIP.longdn = dn;
SIP.longdv = dv;
SIP.pdn = pdn;
SIP.pdv = pdv;
SIP.P = P;
SIP.transport = transport;
SIP.dSIV = dSIV;
SIP.comment = comment;

save('ICE/Production/data/SIP/without_daily_monthly_yearly/sector00.mat', 'SIP', '-v7.3');

disp('Done')


