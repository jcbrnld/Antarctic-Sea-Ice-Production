% Jacob Arnold

% 21-Nov-2022

% calculate SIP Correlations 
%


% Variables to correlate SIP with: 
% - Sea Ice Area
% - Interior sea ice divergence
% - Interior sea ice speed ALSO u and v velocities
% - Sea Ice Export
% - Interior SIV change
% - El Nino Index
% - SAM Index
% - SIT along gate
% - Wind speed
% - Air temperature

% We will need to use inpolygon to match spatial scales 
% * Remember SIP pertains to the 16 sectors referred to in my thesis and some
%   of these differ from the original 18


% test variables
sector = '14';
load(['ICE/Production/data/SIP/sector',sector,'.mat']);
load(['ICE/Sectors/Gates/mat_files/sector_gates/sector',sector,'_gb15s_shelf.mat']); clear gate2
[px, py] = ll2ps(gate.whole.lat, gate.whole.lon);

%% SIA
% Need to match both spatial and temporal scales
load(['ICE/Concentration/ant-sectors/sector',sector,'.mat'])
SIClon = SIC.lon; SIClat = SIC.lat; clear SIC
load(['ICE/Concentration/ant-sectors/SIP_timescale/sector',sector,'.mat']);

count = 1;
for ii = 1:length(SIP.dn)
    dmatch = find(SIC.day.dn==SIP.dn(ii));
    if isempty(dmatch)
        nomatch(count) = SIP.dn(ii);
        count = count+1;
        indc(ii) = nan;
        C(ii) = nan;
        continue
    else
        indc(ii) = dmatch;
        C(:,ii) = nanmean(SIC.day.sic(:,indc(ii)-3:indc(ii)+3), 2);
    end
    clear dmatch 
end
disp([num2str(count-1),' unmatched dates'])

[cx, cy] = ll2ps(SIClat, SIClon);
in = inpolygon(cx, cy, px, py);

SICc = C(in, :); 

m_basemap('m', londom, latdom);
m_scatter(SIClon, SIClat, 'filled');
m_scatter(SIClon(in), SIClat(in), 'filled');

[R,P] = corrcoef(SIP.P, nanmean(SICc), 'rows', 'pairwise')
% R = 0.4568

SIA = sum(SICc.*3.125, 'omitnan');
[R,P] = corrcoef(SIP.P, SIA, 'rows', 'pairwise')
% R = 0.4555

% clear in C SICc SIClon SIClat SIC

%% SID SIS SIu SIv
load ICE/Motion/Data/NSIDC/sector14.mat;
[mx, my] = ll2ps(SIM.lat, SIM.lon);


in = inpolygon(mx, my, px, py);
inlon = SIM.lon(in);
inlat = SIM.lat(in);



% Match dates
for ii = 1:length(SIP.dn)
    ind(ii) = find(SIM.dnh==SIP.dn(ii));
    
    if isempty(ind(ii))
        disp(['No match for dn ',num2str(SIP.dn(ii))])
    end
end

SID = SIM.SID(in,ind);
SIDc = nanmean(SID);
[R,P] = corrcoef(SIDc, SIP.P, 'rows','pairwise')
% R = 0.3219; P = 0

SIS = sqrt(SIM.uh(in,ind).^2 + SIM.vh(in,ind).^2);
SISc = nanmean(SIS);
[R,P] = corrcoef(SISc, SIP.P, 'rows','pairwise')
% R =  0.3390; P = 0

uc = nanmean(SIM.uh(in,ind));
vc = nanmean(SIM.vh(in,ind));
[R,P] = corrcoef(uc, SIP.P, 'rows','pairwise')
% R = 0.2576; P = 0
[R,P] = corrcoef(vc, SIP.P, 'rows','pairwise')
% R = 0.4184; P = 0

% what about normal SIM along gate? 
load(['ICE/Sectors/Gates/mat_files/sector_gates/sector',sector,'_gb15s_shelf.mat']); clear gate2
nSIM = nanmean(gate.midn(:,2:end),1);
[R,P] = corrcoef(nSIM, SIP.P, 'rows','pairwise')
% R = 0.4744; P = 0


%% Wind speed and air temperature
% Expect temp to correlate better since reanalysis wind speed misses
% katabatic events. 

% Prepared using ICE/gated_ecmwf/scripts/prepare_ecmwf.m

sector = '14';
load(['ICE/gated_ecmwf/matfiles/sector',sector,'.mat']);

spd = sqrt(gated_ecmwf.u.^2 + gated_ecmwf.v.^2);
mspd = nanmean(spd);

[R,P] = corrcoef(mspd, SIP.P, 'rows','pairwise')


mu = nanmean(gated_ecmwf.u);
[R,P] = corrcoef(mu, SIP.P, 'rows','pairwise')

mv = nanmean(gated_ecmwf.v);
[R,P] = corrcoef(mv, SIP.P, 'rows','pairwise')

























