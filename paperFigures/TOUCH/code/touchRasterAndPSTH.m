%% for now lets not pay attention to the protraction vs retraction touches
function touchRasterAndPSTH(U, theseCells)
plotRange = -20:60;
zeroPoint = find(plotRange==0);
tmpColor = brewermap(100, 'RdPu');
t1c = tmpColor(100, :);
t2c = tmpColor(80, :);
t3c = tmpColor(60, :);
tmpColor = brewermap(100, 'Blues');
puc = tmpColor(80, :);
pdc = tmpColor(40, :);

plotType = 3;
smoothBy = 1;

s = SPmaker(2, 3, 1);
for k = theseCells
    
    C = U{k};
    
    [allTouches, segments, protractionTouches, touchOrder, interTouchInterval] = GET_touches(C, 'onset', false);
    [touchExtract, touch_makeTheseNans] = getTimeAroundTimePoints(allTouches, plotRange, C.t);
    
    spikes = squeeze(C.R_ntk).*1000;
    
    T_tmp = spikes(touchExtract);
    T_tmp(touch_makeTheseNans) = nan;
    t_p =  T_tmp(:, find(segments(:, 7)==1));
    t_r =  T_tmp(:, find(segments(:, 7)==0));
    [px, py] = find(t_p);
    [rx, ry] = find(t_r);
    
    s = SPmaker(s);
    newPlotTrigger = s.newPlotTrigger;
    s.newPlotTrigger
    hold on
    plot(px-zeroPoint, py, 'k.')
    plot(rx-zeroPoint, ry+max(py), '.r')
    if newPlotTrigger == 1
        ylabel('Touch number')
    end
    axis tight
    s = SPmaker(s);
    hold on
    plot(plotRange, smoothTrimEdges(nanmean(t_p, 2), smoothBy), '-k');
    plot(plotRange, smoothTrimEdges(nanmean(t_r, 2), smoothBy), '-r');
    if newPlotTrigger == 1
        ylabel('Spikes/Sec')
    end
    axis tight
    linkaxes(s.mainFig.Children(:), 'x')
    xlim([plotRange(1)+smoothBy-1, plotRange(end)-smoothBy+1])
    ylim([0, max(ylim)])
    %     keyboard
    
end
% keyboard

supLabel_ALL('Protraction and Retraction touch responses','Time from touch onset (ms)', [], [], s.allFigs)