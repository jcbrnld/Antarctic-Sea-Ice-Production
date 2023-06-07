% Jacob Arnold

% 18-Jul-2022

% Create new "proper" sector 00 using only sectors that are valid
% Ignoring sectors 03B, 03C, 04A, 04B, 04C, 05, 08A, 18B, 18C



%% build new sector00

load ICE/Production/data/SIP/sector06.mat
f = fields(SIP);
for ii = 1:numel(f)  % Clear out an SIP structure from which to build 00
    if isstruct(SIP.(f{ii}))
        sf = fields(SIP.(f{ii}));
        for ss = 1:numel(sf)
            if strcmp(sf{ss}, 'comment') 
                SIP.(f{ii}).(sf{ss}) = [];
            else
                SIP.(f{ii}).(sf{ss}) = zeros(size(SIP.(f{ii}).(sf{ss})));
            end
        end
    else
        if strcmp(f{ii}, 'comment')
            SIP.(f{ii}) = [];
            continue
        end
        SIP.(f{ii}) = zeros(size(SIP.(f{ii})));
    end
end
nSIP = SIP; clear SIP
gsecs = {'01', '02', '03A', '06', '07', '08A', '08B', '09', '10', '11', '12A', '12B', '13', '14', '15', '16', '17', '18A'};

for ii = 1:length(gsecs)
    sector = gsecs{ii};
    
    load(['ICE/Production/data/SIP/sector',sector,'.mat']);
    
    for ff = 1:numel(f)
        if isstruct(SIP.(f{ff}))
            sf = fields(SIP.(f{ff}));
            for ss = 1:numel(sf)
                if strcmp(sf{ss}, 'comment') | strcmp(sf{ss}, 'dn') | strcmp(sf{ss}, 'dv')
                    nSIP.(f{ff}).(sf{ss}) = SIP.(f{ff}).(sf{ss});
                    continue
                end
                nSIP.(f{ff}).(sf{ss}) = nSIP.(f{ff}).(sf{ss}) + SIP.(f{ff}).(sf{ss}); % add
            end
            clear sf
        else
            if strcmp(f{ff}, 'comment') | strcmp(f{ff}, 'dn') | strcmp(f{ff}, 'dv') | strcmp(f{ff}, 'longdn') | strcmp(f{ff}, 'longdv')
                nSIP.(f{ff}) = SIP.(f{ff});
                continue
            end
            nSIP.(f{ff}) = nSIP.(f{ff}) + SIP.(f{ff}); % add
        end
    end
    clear SIP 
end


SIP = nSIP; clear nSIP
save('ICE/Production/data/SIP/sector00.mat', 'SIP')

%% plot old and new 00

load ICE/Production/data/SIP/sector00_ALL.mat
aSIP = SIP; clear SIP

load ICE/Production/data/SIP/sector00.mat;


p1 = polyfit(aSIP.year.dn, aSIP.year.P', 1);
p2 = polyfit(SIP.year.dn, SIP.year.P', 1);
y1 = polyval(p1, aSIP.year.dn); slope1 = (y1(2)-y1(1))*10;
y2 = polyval(p2, SIP.year.dn); slope2 = (y2(2)-y2(1))*10;

figure; plot_dim(900, 250);
l1 = plot(aSIP.year.dn, aSIP.year.P, 'color', [0.6, 0.2, 0.3], 'linewidth', 1.1);
hold on
l2 = plot(SIP.year.dn, SIP.year.P, 'color', [0.2, 0.4, 0.7], 'linewidth', 1.1);
plot(aSIP.year.dn, y1, '--', 'color', [0.6, 0.2, 0.3], 'linewidth', 1.1); % fit 1
plot(SIP.year.dn, y2, '--', 'color', [0.2, 0.4, 0.7], 'linewidth', 1.1); % fit 2

xticks(dnticker(1997,2021));
datetick('x', 'mm-yyyy', 'keepticks');
xtickangle(27);
xlim([min(SIP.dn)-50, max(SIP.dn)+50]);
grid on
legend([l1, l2], ['All sectors (slope: ',num2str(slope1),' km^3/dec)'], ['Without bad sectors (slope: ',num2str(slope2),' km^3/dec)'],...
    'location', 'north', 'orientation', 'horizontal');


print('ICE/Sectors/Investigate_thin/figures/sec00ALLvsonlygood.png', '-dpng', '-r400');

