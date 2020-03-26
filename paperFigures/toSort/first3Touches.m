%% for now lets not pay attention to the protraction vs retraction touches
function first3Touches(U, theseCells)

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


for k = theseCells
    figure
    hold on
    C = U{k};
   
    [allTouches, segments, protractionTouches, touchOrder, interTouchInterval] = GET_touches(C, 'onset', false);
    [touchExtract, touch_makeTheseNans] = getTimeAroundTimePoints(allTouches, plotRange, C.t);
    
    spikes = squeeze(C.R_ntk).*1000;
    
   
    T_tmp =  spikes(touchExtract);
    T_tmp(touch_makeTheseNans) = nan;
    tmpTime = segments(:, 5);
    
    T1 = T_tmp(:, touchOrder == 1);
    t1time = round(nanmedian(tmpTime(touchOrder == 1)));
    T2 = T_tmp(:, touchOrder == 2);
    t2time = round(nanmedian(tmpTime(touchOrder == 2)));
    T3 = T_tmp(:, touchOrder == 3);
    t3time = round(nanmedian(tmpTime(touchOrder == 3)));
    
    if plotType == 1% plot all 0 points at 0 
        plot(plotRange, smoothTrimEdges(nanmean(T1, 2), smoothBy), 'color', t1c, 'LineWidth', 2)
        plot(plotRange, smoothTrimEdges(nanmean(T2, 2), smoothBy), 'color', t2c, 'LineWidth', 2)
        plot(plotRange, smoothTrimEdges(nanmean(T3, 2), smoothBy), 'color', t3c, 'LineWidth', 2)
        
    elseif plotType == 2% plot 0 point  shifted by the length of each trace
        rl = 1:length(plotRange);
        zs = find(plotRange==0);
        plot(rl+length(rl)*1, smoothTrimEdges(nanmean(T1, 2), smoothBy), 'color', t1c, 'LineWidth', 2)
        plot(rl+length(rl)*2, smoothTrimEdges(nanmean(T2, 2), smoothBy), 'color', t2c, 'LineWidth', 2)
        plot(rl+length(rl)*3, smoothTrimEdges(nanmean(T3, 2), smoothBy), 'color', t3c, 'LineWidth', 2)
        
        % plot 0 lines
        plot(repmat(zs+length(rl)*1, 1, 2), ylim,  'color', t1c, 'LineWidth', 1, 'LineStyle', '--')
        plot(repmat(zs+length(rl)*2, 1, 2), ylim,  'color', t2c, 'LineWidth', 1, 'LineStyle', '--')
        plot(repmat(zs+length(rl)*3, 1, 2), ylim,  'color', t3c, 'LineWidth', 1, 'LineStyle', '--')
        
        plot(repmat(1+length(rl)*1, 1, 2), ylim,  'color', t1c, 'LineWidth', 1, 'LineStyle', '--')
        plot(repmat(1+length(rl)*2, 1, 2), ylim,  'color', t2c, 'LineWidth', 1, 'LineStyle', '--')
        plot(repmat(1+length(rl)*3, 1, 2), ylim,  'color', t3c, 'LineWidth', 1, 'LineStyle', '--')
        
    elseif plotType == 3 % 0 point based on average time of the event 
        rl = 1:length(plotRange);
        zs = find(plotRange==0);
        plot(plotRange+t1time, smoothTrimEdges(nanmean(T1, 2), smoothBy), 'color', t1c, 'LineWidth', 2)
        plot(plotRange+t2time, smoothTrimEdges(nanmean(T2, 2), smoothBy), 'color', t2c, 'LineWidth', 2)
        plot(plotRange+t3time, smoothTrimEdges(nanmean(T3, 2), smoothBy), 'color', t3c, 'LineWidth', 2)
        
        % plot 0 lines
        plot(repmat(t1time, 1, 2), ylim,  'color', t1c, 'LineWidth', 1, 'LineStyle', '--')
        plot(repmat(t2time, 1, 2), ylim,  'color', t2c, 'LineWidth', 1, 'LineStyle', '--')
        plot(repmat(t3time, 1, 2), ylim,  'color', t3c, 'LineWidth', 1, 'LineStyle', '--')
        
        plot(repmat(t1time, 1, 2), ylim,  'color', t1c, 'LineWidth', 1, 'LineStyle', '--')
        plot(repmat(t2time, 1, 2), ylim,  'color', t2c, 'LineWidth', 1, 'LineStyle', '--')
        plot(repmat(t3time, 1, 2), ylim,  'color', t3c, 'LineWidth', 1, 'LineStyle', '--')
        
    end
   
end