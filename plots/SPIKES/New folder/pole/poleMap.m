%%
% polePlotType = 2


for poleTypesIter = 1:2
    plotRange = -100:200;
    toPlotAllPoles = nan(length(U), length(plotRange));
    rangeRemoveTouch = -50:200;
    nameCell = { 'poleUP' 'poleDown'};
    
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
        
        
        if poleTypesIter == 1
            poleD = cellTMP.meta.poleOnset;
        elseif poleTypesIter ==2
            poleD = cellTMP.meta.poleOffset;
        else
            error('not valid input number')
        end
        
        poleD(poleD>cellTMP.t) = nan;
        if numel(poleD) ~= cellTMP.k
            error('for some reason the pole down doesnt match length of trials, this should never happen but this is here just incase')
        end
        poleD = poleD + ((0:cellTMP.k-1).*cellTMP.t);
        poleD = reshape(poleD, [numel(poleD), 1]);%make sure the array is vertical
        trials = ceil(allTouches./4000);
        
        poleInds = (poleD + (plotRange));
        poleInds(find(isnan(poleD)), :) =  nan;
        trialToMatch = find(plotRange==0);
        % get the trial numbers
        poleIndTrial = ceil(poleInds./cellTMP.t);
        % subtract the trial number from the trial numbers at the '0' point
        % represented as trialToMatch (where the trial the event happened in)
        poleIndTrial = poleIndTrial - poleIndTrial(:,trialToMatch);
        %find only the ones that are the same trial the touch was extracted from
        makeTheseNans = find(poleIndTrial~=0);
        %find any valid index (here just the first one we find that is valid)
        tempReplaceForIndexToNAN = find(poleIndTrial==0, 1);
        % thie is only temporary. because of edge problems which include going out of index range
        % and include running off into the next trial we are going to replace these all with nans later
        % for now make sure that they index without erroring out
        poleInds(makeTheseNans) = poleInds(tempReplaceForIndexToNAN);
        % keep only the ind that are in that same trial
        
        
        %%
        
        %     [~, removeIndex, ~] = intersect(poleInds, touchMaskInd);
        
        touchMask = touchMask(poleInds); % 0's are spikes
        allpoles = spikes(poleInds);
        allpoles(makeTheseNans) = nan; % block out go over trial or under trail
        allpoles(find(touchMask==0)) = nan;%block out touches
        allpolesCell{cellStep} = allpoles;
        toPlotpole2 = nanmean(allpoles);
        toPlotAllPoles(cellStep, 1:length(plotRange))  = toPlotpole2;
        
    end
    
    %%
    subplotMakerNumber = 1; subplotMaker
    set(0,'defaultAxesFontSize',10)
    smoothBy = 10;
    for cellStep = 1:length(U)
        toPlotpole = toPlotAllPoles(cellStep, :);
        subplotMakerNumber = 2; subplotMaker
        toPlotpole = smooth(toPlotpole, smoothBy);
        polePlot = plot(plotRange,toPlotpole, 'k');
        hold on
        polePlot.Color = [polePlot.Color, 0.7];
        
        axis tight
        xlim([plotRange(1) plotRange(end)])
        %     keyboard
        tmpAXIS = gca;
        %     tmpAXIS.YLim(1) = 0 ;
        
    end
    %%
%     keyboard
    saveLoc = ['C:\Users\maire\Documents\PLOTS\pole\'];
    generalName = ['', nameCell{poleTypesIter}] ;
    mkdir(saveLoc)
    
    saveName = [saveLoc, generalName];
    %%
    save([saveName, 'VARS'], 'allpolesCell', 'toPlotAllPoles')
    
    
    %%
    %     keyboard
    %     generalName = ['all pole aligned'] ;
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [1, 0, 1, 1]);
    filename =  saveName;
    saveas(gcf,filename,'png')
    savefig(filename)
    
end
