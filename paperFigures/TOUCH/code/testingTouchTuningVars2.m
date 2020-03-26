% for getting tuning curves for at touche variables
% crush
numBins = 10;
CIalpha = 0.05;
% theseCells = [1 17 18]
for k = theseCells(:)'
    C = U{k};
    T = V{3, k};
    T2 = getSignalRegionFromVarray(T, T.plotRange);
    segs = allCellsTouch{k}.segments;
    trigON = 0;
    if ~T.isSig
        %         [~, ~, T2.OGsigExtract] = intersect(8:20, T.plotRange);
        trigON = 1;
        T2.SIGinds = 8:20;
    end
    
    [allTouches, T_makeTheseNans] = getTimeAroundTimePoints(segs(:, 1), T2.SIGinds, C.t);
    [BLtouches, BL_makeTheseNans] = getTimeAroundTimePoints(segs(:, 1), T2.SIGinds-T2.SIGinds(end), C.t);
    % max touch featres (max change in kappa)
    [maxDeltaTrialTimeInd, maxDeltaKappa, Sind, absMaxKappaINDS, Tcell] = ...
        getMaxKappa(C, segs(:, 1), segs(:, 2));
    maxKap = nan(size(C.S_ctk(1, :, :)));
    maxKap(BLtouches) = repmat(maxDeltaKappa, size(allTouches, 1) , 1);
    % at touch featres (theta amp set point)
    var1={};spkSIG={};BL1={};spkBL={};edges={};spkCount={};TfromPole={};edges={};binINDs={};
    Tcurve={};TcurveCIs={};y2plot={};
    allVars = C.S_ctk(1:5, :, :);
    allVars(6, :, :) = maxKap;
    for kk = 1:size(allVars, 1)
        [var1{kk}, spkSIG{kk}] = getSpikesAndVar(C, allVars(kk, :, :) , allTouches, T_makeTheseNans);
        [BL1{kk}, spkBL{kk}] = getSpikesAndVar(C, allVars(kk, :, :), BLtouches, BL_makeTheseNans);
        % below just use at touch numbers can use another variable though --> BL1{kk}(end, :)'
        % because the baseline end is at the time of touch
        [spkCount{kk}, TfromPole{kk},edges{kk}, binINDs{kk}] = binslin(BL1{kk}(end, :)', 1000*nanmean(spkSIG{kk}, 1)', 'equalN', numBins);
        y2plot{kk} = cellfun(@(x) nanmedian(BL1{kk}(end, x)), binINDs{kk}); %@touch
        Tcurve{kk} = cellfun(@(x) nanmean(x), spkCount{kk});
        [~, tmp1] = cellfun(@(x) philsCIs(x , CIalpha, length(x)), spkCount{kk}, 'UniformOutput', false);
        TcurveCIs{kk} = cell2mat(tmp1);
    end
    
    
    
    
    
    % touch desribtive featres (touch time from pole onset, length of touch)
    sp = SPmaker(3, 3);
    varNames = {'Theta (degrees)' 'Velocity (degrees/sec)' 'amp (degrees)' 'setpoint (degrees)' 'Phase' 'maxDelta Kappa (degrees)' 'touch delay from pole onset (ms)' ...
        'first touch delay from pole onset (ms)' 'touch length (ms)' '' '' }
    
    
    ylimSET = [];
    roundTO = 5;
    
    yset = max(max(cell2mat(TcurveCIs)+cell2mat(Tcurve)));
    yset = ceil((1./roundTO)*yset)/(1./roundTO);
    
    for kk = 1:size(allVars, 1)
        sp = SPmaker(sp);
        %     var1{kk}(1, :)
        
        shadedErrorBar(y2plot{kk}', Tcurve{kk}, TcurveCIs{kk},'lineProps',  'k-')
        xlabel(varNames{kk}); ylabel('spikes/Sec');
        
        ylim([0 yset])
        
        
        %      [hl, hp] = boundedline(y2plot{kk}', Tcurve{kk}, cell2mat(TcurveCIs{kk}), ...
        %             'k-',  'orientation', 'horiz', 'transparency', 1);
        %         hl.Color = 'g'
        %         xlim([0, max(xlim)])
        %         xlabel('Spikes/Sec')
        %         %         ylabel('Max delta kappa at touch (degrees)')
        %         set(gca, 'TickLength',[0 0])
        %         set(gca, 'Color','none')
        %         set(gca,'YTickLabel',[]);
        %
        %
        %         xlim([0, max(xlim)])
        %         xlabel('Spikes/Sec')
        %         %         ylabel('Max delta kappa at touch (degrees)')
        %         set(gca, 'TickLength',[0 0])
        %         set(gca, 'Color','none')
        %         set(gca,'YTickLabel',[]);
        
    end
    
    
    
    
end