%% for now lets not pay attention to the protraction vs retraction touches
crush
plotRange = -20:80;
tmpColor = brewermap(100, 'RdPu');
t1c = tmpColor(100, :);
t2c = tmpColor(80, :);
t3c = tmpColor(60, :);
tmpColor = brewermap(100, 'Blues');
puc = tmpColor(80, :);
pdc = tmpColor(40, :);

plotType = 2;
smoothBy = 10;

figure
for k = 1:length(U)
    hold on
    C = U{k};
    
    poleOffset = C.meta.poleOffset;
    poleOffset(poleOffset>C.t) = nan;
    [poleUPextract, poleUP_makeTheseNans] = getTimeAroundTimePoints(C.meta.poleOnset+(0:C.t: (C.k-1).*C.t), plotRange, C.t);
    [poleDOWNextract, poleDOWN_makeTheseNans] = getTimeAroundTimePoints(poleOffset+(0:C.t: (length(poleOffset)-1).*C.t), plotRange, C.t);
    
    [allTouches, segments, protractionTouches, touchOrder, interTouchInterval] = GET_touches(C, 'onset', false);
    [touchExtract, touch_makeTheseNans] = getTimeAroundTimePoints(allTouches, plotRange, C.t);
    
    spikes = squeeze(C.R_ntk).*1000;
    
    PU = spikes(poleUPextract);
    PU(poleUP_makeTheseNans) = nan;
    PD = spikes(poleDOWNextract);
    PD(poleDOWN_makeTheseNans) = nan;
    
    T_tmp =  spikes(touchExtract);
    T_tmp(touch_makeTheseNans) = nan;
    
    T1 = T_tmp(:, touchOrder == 1);
    T2 = T_tmp(:, touchOrder == 2);
    T3 = T_tmp(:, touchOrder == 3);
    if plotType == 1
        plot(plotRange, smooth(nanmean(T1, 2), smoothBy), 'color', t1c, 'LineWidth', 2)
        plot(plotRange, smooth(nanmean(T2, 2), smoothBy), 'color', t2c, 'LineWidth', 2)
        plot(plotRange, smooth(nanmean(T3, 2), smoothBy), 'color', t3c, 'LineWidth', 2)
        
        plot(plotRange, smooth(nanmean(PU, 2), smoothBy), 'color', puc, 'LineWidth', 2)
        plot(plotRange, smooth(nanmean(PD, 2), smoothBy), 'color', pdc, 'LineWidth', 2)
    elseif plotType == 2
        rl = 1:length(plotRange);
        zs = find(plotRange==0);
        plot(rl+length(rl)*0, smooth(nanmean(PU, 2), smoothBy), 'color', puc, 'LineWidth', 2)
        plot(rl+length(rl)*1, smooth(nanmean(T1, 2), smoothBy), 'color', t1c, 'LineWidth', 2)
        plot(rl+length(rl)*2, smooth(nanmean(T2, 2), smoothBy), 'color', t2c, 'LineWidth', 2)
        plot(rl+length(rl)*3, smooth(nanmean(T3, 2), smoothBy), 'color', t3c, 'LineWidth', 2)
        plot(rl+length(rl)*4, smooth(nanmean(PD, 2), smoothBy), 'color', pdc, 'LineWidth', 2)
        
        % plot 0 lines
        plot(repmat(zs+length(rl)*0, 1, 2), ylim,  'color', puc, 'LineWidth', 1, 'LineStyle', '--')
        plot(repmat(zs+length(rl)*1, 1, 2), ylim,  'color', t1c, 'LineWidth', 1, 'LineStyle', '--')
        plot(repmat(zs+length(rl)*2, 1, 2), ylim,  'color', t2c, 'LineWidth', 1, 'LineStyle', '--')
        plot(repmat(zs+length(rl)*3, 1, 2), ylim,  'color', t3c, 'LineWidth', 1, 'LineStyle', '--')
        plot(repmat(zs+length(rl)*4, 1, 2), ylim,  'color', pdc, 'LineWidth', 1, 'LineStyle', '--')
        
        plot(repmat(1+length(rl)*0, 1, 2), ylim,  'color', puc, 'LineWidth', 1, 'LineStyle', '--')
        plot(repmat(1+length(rl)*1, 1, 2), ylim,  'color', t1c, 'LineWidth', 1, 'LineStyle', '--')
        plot(repmat(1+length(rl)*2, 1, 2), ylim,  'color', t2c, 'LineWidth', 1, 'LineStyle', '--')
        plot(repmat(1+length(rl)*3, 1, 2), ylim,  'color', t3c, 'LineWidth', 1, 'LineStyle', '--')
        plot(repmat(1+length(rl)*4, 1, 2), ylim,  'color', pdc, 'LineWidth', 1, 'LineStyle', '--')
        
        
    end
    keyboard
    clf
end