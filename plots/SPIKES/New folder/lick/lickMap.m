%%
% lickPlotType = 2
for lickPlotType = 1%:4
    plotRange = -100:200;
    toPlotAllLick = nan(length(U), length(plotRange));
    rangeRemoveTouch = -50:200;
    nameCell = {'answer lick' 'all licks' 'first lick' ' first 2 licks '}
    
    for cellStep = 1:length(U)
        clc
        disp(num2str(cellStep))
        %%
        cellTMP = U{cellStep};
        spikes = squeeze(cellTMP.R_ntk) .* 1000;
        %%
        %% next block out touches
        %% base this on the phase, if a touch occured, then remove the period 1/2 phase before and after the touch to
        %% remove the entire cycle surroudn this touch
        %% actually just going to do the easy way and block out like 50 ms before and after
        
        touchFirstAll = find(squeeze(cellTMP.S_ctk(14,:,:))==1);
        touchLateALL = find(squeeze(cellTMP.S_ctk(11,:,:))==1);
        allTouches = sort([touchFirstAll; touchLateALL]);
        % trials = ceil(allTouches./4000);
        
        touchMaskInd = (allTouches + (rangeRemoveTouch));
        trialToMatch = find(rangeRemoveTouch==0);
        % get the trial numbers
        touchMaskIndTrial = ceil(touchMaskInd./cellTMP.t);
        % subtract the trial number from the trial numbers at the '0' point
        % represented at trialToMatch (where the trial the touch happened in)
        touchMaskIndTrial = touchMaskIndTrial - touchMaskIndTrial(:,trialToMatch);
        %find only the ones that are the same trial the touch was extracted from
        touchMaskIndTrial = find(touchMaskIndTrial==0);
        % keep only the ind that are in that same trial
        touchMaskInd = touchMaskInd(touchMaskIndTrial);
        touchMask = ones(size(spikes));
        touchMask(touchMaskInd) = 0;
        
        %%
        if lickPlotType == 1 % only answerlick
            licks = (cellTMP.meta.answerLickTime);
            licks(licks>cellTMP.t) = nan;
            licks = licks+ (0:cellTMP.k -1).*cellTMP.t;
            licks = licks';
        elseif lickPlotType == 2 % all lick
            licks = (cellTMP.meta.beamBreakTimesMat);
            licks(licks>cellTMP.t) = nan;
            licks = licks + (0:cellTMP.k -1).*cellTMP.t;
            licks = licks(~isnan(licks));
        elseif lickPlotType == 3 % only second lick
            licks = (cellTMP.meta.beamBreakTimesMat);
            licks(licks>cellTMP.t) = nan;
            licks = licks + (0:cellTMP.k -1).*cellTMP.t;
            licks = licks(2, :);
            licks = licks(~isnan(licks));
        elseif lickPlotType == 4 % only first and second lick
            licks = (cellTMP.meta.beamBreakTimesMat);
            licks(licks>cellTMP.t) = nan;
            licks = licks + (0:cellTMP.k -1).*cellTMP.t;
            licks = licks(1:2, :);
            licks = licks(~isnan(licks));
        end
        licks = unique(licks);
        licks = reshape(licks, [numel(licks), 1]);%make sure the array is vertical
        trials = ceil(allTouches./4000);
        
        lickInds = (licks + (plotRange));
        lickInds(find(isnan(licks)), :) =  nan;
        trialToMatch = find(plotRange==0);
        % get the trial numbers
        lickIndTrial = ceil(lickInds./cellTMP.t);
        % subtract the trial number from the trial numbers at the '0' point
        % represented as trialToMatch (where the trial the event happened in)
        lickIndTrial = lickIndTrial - lickIndTrial(:,trialToMatch);
        %find only the ones that are the same trial the touch was extracted from
        makeTheseNans = find(lickIndTrial~=0);
        %find any valid index (here just the first one we find that is valid)
        tempReplaceForIndexToNAN = find(lickIndTrial==0, 1);
        % thie is only temporary. because of edge problems which include going out of index range
        % and include running off into the next trial we are going to replace these all with nans later
        % for now make sure that they index without erroring out
        lickInds(makeTheseNans) = lickInds(tempReplaceForIndexToNAN);
        % keep only the ind that are in that same trial
        
        
        %%
        
        %     [~, removeIndex, ~] = intersect(lickInds, touchMaskInd);
        
        touchMask = touchMask(lickInds); % 0's are spikes
        allLicks = spikes(lickInds);
        allLicks(makeTheseNans) = nan; % block out go over trial or under trail
        allLicks(find(touchMask==0)) = nan;%block out touches
        allLicksCell{cellStep} = allLicks;
        toPlotLick2 = nanmean(allLicks);
        toPlotAllLick(cellStep, 1:length(plotRange))  = toPlotLick2;
        
    end
    
    %%
    subplotMakerNumber = 1; subplotMaker
    set(0,'defaultAxesFontSize',10)
    smoothBy = 10;
    for cellStep = 1:length(U)
        toPlotLick = toPlotAllLick(cellStep, :);
        subplotMakerNumber = 2; subplotMaker
        toPlotLick = smooth(toPlotLick, smoothBy);
        lickPlot = plot(plotRange,toPlotLick, 'g');
        hold on
        lickPlot.Color = [lickPlot.Color, 0.7];
        
        axis tight
        xlim([plotRange(1) plotRange(end)])
        %     keyboard
        tmpAXIS = gca;
        %     tmpAXIS.YLim(1) = 0 ;
        
    end
    %%
    saveLoc = ['C:\Users\maire\Documents\PLOTS\lick\'];
    generalName = ['lick_'] ;
    mkdir(saveLoc)
    
    saveName = [saveLoc, generalName, nameCell{lickPlotType}];
    %%
    save([saveName, 'VARS'], 'allLicksCell', 'toPlotAllLick')
    
    
    %%
    %     keyboard
    %     generalName = ['all lick aligned'] ;
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [1, 0, 1, 1]);
    filename =  saveName;
    saveas(gcf,filename,'png')
    savefig(filename)
    
    
end
%%


