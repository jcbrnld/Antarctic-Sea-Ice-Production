% Jacob Arnold
% 29-Mar-2023
% SIP +- 95% confidence 

% ±1.96*standard error

% Standard error is std/(sqrt(length(data))



% test
load ICE/Production/data/SIP/sector14.mat;

%%


% year
stdery = std(SIP.year.P)./sqrt(length(SIP.year.P));
er95y = stdery*1.96;


figure;plot(SIP.year.P)
hold on
plot(SIP.year.P-er95y)
plot(SIP.year.P+er95y)




%%  calculate for all sectors

secs = ja_aagatedregions(3); % for the 16 good sectors 


for ii = 1:length(secs)
    sector = secs{ii};
    disp(['Starting sector ',sector,'...'])
    load(['ICE/Production/data/SIP/sector',sector,'.mat']);
    stder = std(SIP.year.P)./sqrt(length(SIP.year.P));
    er95 = stder*1.96;
    
    allerror(ii) = er95;
    
    clear stder er95 SIP
end



