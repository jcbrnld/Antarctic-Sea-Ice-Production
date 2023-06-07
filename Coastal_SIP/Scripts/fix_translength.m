% jacob Arnold

% 05-May-2022

% Fix transport length
% the last year (2021) is just 0 because there were no data then. Need to
% remove these from transport. Production has already had this operation so
% it is ok. 


for mm = 1:21
    if mm < 10
        sector = ['0', num2str(mm)];
        s = sector;
    elseif mm < 19 & mm > 9
        sector = num2str(mm);
        s = sector;
    elseif mm == 19
        sector = '03b';
        s = '03';
    elseif mm == 20
        sector = '04b';
        s = '04';
    elseif mm == 21
        sector = '07b';
        s = '07';
    end
    
    load(['ICE/Production/data/SIP/sector',sector,'.mat']);
    
    SIP.transport = SIP.transport(1:1210)';
    
    save(['ICE/Production/data/SIP/sector',sector,'.mat'], 'SIP', '-v7.3')
    
end