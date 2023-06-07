% Jacob Arnold

% 7-June-2022

% Create growing and decaying ice seasons in SIP data by combining fall/winter and
% spring/summer



clear all
lists = {'all', 'only valid', 'special', '-99 sectors'};
selection = listdlg('liststring', lists, 'promptstring', 'Which sector category?', 'selectionmode', 'single');
if selection == 1
    secs = ja_aagatedregions(0); 
elseif selection == 2
    secs = ja_aagatedregions(3);
elseif selection == 3
    secs = ja_aagatedregions(4);
elseif selection == 4
    secs = ja_aagatedregions(-99);    
end
for mm = 1:length(secs)
    sector = secs{mm};
    disp(['Adding growth decay to sector ',sector,'...']);
    load(['ICE/Production/data/SIP/noGrowDecay/sector',sector,'.mat']);

    growP = SIP.winter.P+SIP.fall.P;
    growE = SIP.winter.E+SIP.fall.E;
    growdSIV = SIP.winter.dSIV+SIP.fall.dSIV;
    growIN = SIP.winter.icein+SIP.fall.icein;
    growOUT = SIP.winter.iceout+SIP.fall.iceout;
    
    decayP = SIP.spring.P+SIP.summer.P;
    decayE = SIP.spring.E+SIP.summer.E;
    decaydSIV = SIP.spring.dSIV+SIP.summer.dSIV;
    decayIN = SIP.spring.icein+SIP.summer.icein;
    decayOUT = SIP.spring.iceout+SIP.summer.iceout;
    
    counter = 1; years = 1998:2020;
    for yy = 1:length(SIP.winter.P)
        twoP(counter) = growP(yy);
        twoE(counter) = growE(yy);
        twodSIV(counter) = growdSIV(yy);
        twoIN(counter) = growIN(yy);
        twoOUT(counter) = growOUT(yy);
        dn(counter) = datenum(years(yy), 06, 15);
        
        counter = counter+1;
        
        twoP(counter) = decayP(yy);
        twoE(counter) = decayE(yy);
        twodSIV(counter) = decaydSIV(yy);
        twoIN(counter) = decayIN(yy);
        twoOUT(counter) = decayOUT(yy);
        dn(counter) = datenum(years(yy), 12, 15);
        
        counter = counter+1;
        
        growdn(yy) = datenum(years(yy), 06, 15);
        decaydn(yy) = datenum(years(yy), 12, 15);
    end
    
    
    SIP.grow.P = growP;
    SIP.grow.E = growE;
    SIP.grow.dSIV = growdSIV;
    SIP.grow.icein = growIN;
    SIP.grow.iceout = growOUT;
    SIP.grow.dn = growdn;
    SIP.grow.comment = {'SIP elements during growth seasons (fall and winter)'};
    
    SIP.decay.P = decayP;
    SIP.decay.E = decayE;
    SIP.decay.dSIV = decaydSIV;
    SIP.decay.icein = decayIN;
    SIP.decay.iceout = decayOUT;
    SIP.decay.dn = decaydn;
    SIP.decay.comment = {'SIP elements during decay seasons (spring and summer)'};
    
    SIP.twoseason.P = twoP;
    SIP.twoseason.E = twoE;
    SIP.twoseason.dSIV = twodSIV;
    SIP.twoseason.icein = twoIN;
    SIP.twoseason.iceout = twoOUT;
    SIP.twoseason.dn = dn;
    SIP.twoseason.comment = {'Yearly growth and decay seasons combined in a single variable'};
    
    save(['ICE/Production/data/SIP/sector',sector,'.mat'], 'SIP', '-v7.3');
    
    figure; plot_dim(900,270);
    plot(SIP.grow.dn, SIP.grow.P)
    hold on;
    plot(SIP.twoseason.dn, SIP.twoseason.P)
    plot(SIP.decay.dn, SIP.decay.P)
    xticks(dnticker(1997,2021)); datetick('x', 'mm-yyyy', 'keepticks'); xtickangle(27); 
    xlim([min(SIP.grow.dn)-50, max(SIP.decay.dn)+50]);
    title(['Setor ',sector, ' Growth, decay, and two season SIP']);
    print(['ICE/Production/figures/SIP/twoseason/sector',sector,'growAndDecaySIP.png'], '-dpng', '-r300');
    
    
    clearvars -except secs
    
end
    
    
    
    