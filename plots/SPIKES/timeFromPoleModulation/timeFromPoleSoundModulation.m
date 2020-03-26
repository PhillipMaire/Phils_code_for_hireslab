%% look at touch time from sound







crush
rangeOfSig = -100:200;
plotAllTouches = 1
for cellStep = 1:length(U)
    disp(cellStep)
    
    %     cellStep = 17
    cellTMP = U{cellStep}
    poleOn = cellTMP.meta.poleOnset(:);
    spikes = squeeze(cellTMP.R_ntk) .* 1000;
    touchFirst = find(squeeze(cellTMP.S_ctk(14,:,:))==1);
    allOtherTouches = find(squeeze(cellTMP.S_ctk(15,:,:))==1);
    allTouches = unique([touchFirst(:);allOtherTouches(:) ]);
    
    if plotAllTouches == 1
        [segmentsTMP] = findInARow(allTouches)
        allTouches = segmentsTMP(:,1);
        touchTimes = mod(allTouches, 4000);
        trialNums = ceil(allTouches./cellTMP.t);
        
        firstTouchTime = touchTimes - poleOn(trialNums)
    else
        touchTimes = mod(touchFirst, 4000);
        trialNums = ceil(touchFirst./cellTMP.t);
        
        [uniqTrials, uniqInds] = unique(trialNums);
        %
        % firstTouchTime = touchTimes(uniqInds)
        % firstTouchTime = firstTouchTime- poleOn(uniqTrials)
        
        
        firstTouchTime = nan(cellTMP.k, 1);
        firstTouchTime(uniqTrials) =touchTimes(uniqInds);
        
        firstTouchTime = firstTouchTime - poleOn;
    end
    % %%
    %
    % rangeOfSig = -50:200;
    % alltoGet = firstTouchTime(:) + rangeOfSig(:)';
    % trialToGet = repmat((1:length(poleOn))', [1, size(alltoGet, 2)]);
    % alltoGet = alltoGet(~isnan(alltoGet));
    % trialToGet = trialToGet(~isnan(alltoGet));
    % spikesAligned = spikes(alltoGet(:), trialToGet(:));
    %
    
    % hist(firstTouchTime, 50)
    stepBy = 20;
    edges1 = [0:stepBy:600 ]
    
    edges1(1) = -inf;
    edges1(end) = inf;
    
    inds1 = {};
    counts1 = [];
    for k = 1:length(edges1)-1
        inds1{k} = find((firstTouchTime>edges1(k)) .* (firstTouchTime<=edges1(k+1)));
        counts1(k) = length(inds1{k} );
    end
    
    %
    % figure;
    hold on
    allSpikesCell  = {};
    meanSpikes = [];
    for k = 1 :length(inds1)
        tmpAllSpikes = [];
        if ~isempty(inds1{k})
            for kk = 1:length(inds1{k})
                tmpSpikes = spikes(:,inds1{k}(kk) );
                win1 = firstTouchTime(inds1{k}(kk))+ poleOn(inds1{k}(kk))+rangeOfSig;
                win1(win1>4000) = 1;
                tmp1 = tmpSpikes(win1);
                tmp1(win1>4000) = nan;
                tmpAllSpikes(1:length(rangeOfSig), kk) = tmp1 ;
            end
            
            allSpikesCell{k} = tmpAllSpikes;
            
            toPlot = smooth(nanmean(tmpAllSpikes, 2), 20);
            meanSpikes(1:length(rangeOfSig), k)   = toPlot;
            %     plot(rangeOfSig, toPlot)
            %     waitForEnterPress
        end
    end
    
    %%
    normOG = (meanSpikes - nanmean(meanSpikes(:)))/(std(meanSpikes(:)))
    
    normOG = reshape(normOG, size(meanSpikes));
    
    %     CB = meanNorm(meanSpikes);
    %     tpPLot = meanSpikes./CB;
    toPLot =normOG;
    %     toPLot(toPLot>3) = 3;
    h = figure('units','normalized','outerposition',[0 0 1 1])
    
    imagesc(toPLot);
    tmp1 = colorbar;
    for P = 1:length(counts1)
        text(P, 10, num2str(counts1(P)))
    end
    
    %     tmp1.Limits = [0, CB*3];
    
    %%
    ylabel('time from touch (ms)')
    xlabel('binned time From pole up touch occured (ms)')
    ylabel(tmp1, 'Z-scored spikes/sec')
    %%
    yticks = h.CurrentAxes.YTick;
    yticklabels = h.CurrentAxes.YTick +rangeOfSig(1)
    set(gca, 'YTick', yticks, 'YTickLabel', yticklabels)
    %%
    xticks = 1:2:max(h.CurrentAxes.XTick);
    xticklabels = edges1(xticks);
    set(gca, 'XTick', xticks, 'XTickLabel', xticklabels)
    
    %%
    a1 = normalizeMe(nanmean(toPLot ,1));
    a1 = a1*yticks(2);
    a2 = normalizeMe(nanmean(toPLot ,2));
    a2 = a2*xticks(3);
    %
    hold on ;plot(1:length(a1), a1, 'r')
    hold on ;plot(a2, 1:length(a2), 'g')
    %%
    rangeToGrab = -25:75;
    addNum = rangeToGrab(1) - rangeOfSig(1);
    rangeToGrab = rangeToGrab+find(rangeOfSig == 0);
    toPLot2 = toPLot(rangeToGrab, :)
    CS1 = (cumsum(toPLot2, 1));
    CS2 = [];
    for tmp1 = 1:size(CS1, 2)
        CS2(:, tmp1) = normalizeMe(CS1(:, tmp1));
    end
    [~, inds1] = min(abs(CS2-.5));
    inds1 = inds1+ addNum;
    plot(1:length(inds1), inds1, 'oy')
    %%
    keyboard
    
    sdf(gcf, 'default18')
    cd('C:\Users\maire\Dropbox\HIRES_LAB\PHIL\Data\plots\timeFromPoleOnsetToTouchModulation')
    saveas(h, [num2str(cellStep), ' timeFromSoundTouchModulation_allTouches.png'])
    
    crush
    
    
end
%%

%%









