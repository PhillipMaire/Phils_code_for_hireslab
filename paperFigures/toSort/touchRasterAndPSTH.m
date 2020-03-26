%% for now lets not pay attention to the protraction vs retraction touches
function touchRasterAndPSTH(U, theseCells)
plotRange = -20:80;
tmpColor = brewermap(100, 'RdPu');
t1c = tmpColor(100, :);
t2c = tmpColor(80, :);
t3c = tmpColor(60, :);
tmpColor = brewermap(100, 'Blues');
puc = tmpColor(80, :);
pdc = tmpColor(40, :);

plotType = 3;
smoothBy = 10;

s = SPmaker(2, 3, 1);
for k = theseCells
    
    C = U{k};
    
    [allTouches, segments, protractionTouches, touchOrder, interTouchInterval] = GET_touches(C, 'onset', false);
    [touchExtract, touch_makeTheseNans] = getTimeAroundTimePoints(allTouches, plotRange, C.t);
    
    spikes = squeeze(C.R_ntk).*1000;
    
    T_tmp = spikes(touchExtract);
    T_tmp(touch_makeTheseNans) = nan;
    t_p =  T_tmp(:, find(segments(:, 7)));
    t_r =  T_tmp(:, find(~segments(:, 7)));
    [px, py] = find(t_p);
    [rx, ry] = find(t_r);
    
    s = SPmaker(s);
    hold on
    plot(px, py, 'k.')
    plot(rx, ry+max(py), '.r')
    
    
    
    s = SPmaker(s);
    hold on
    plot(smoothTrimEdges(nanmean(t_p, 2), smoothBy), '-k');
    plot(smoothTrimEdges(nanmean(t_r, 2), smoothBy), '-r');
    
    
    linkaxes(s.mainFig.Children(:), 'x')
    
    %     keyboard
    
end