%     %%  Plot raster
%
%
%     for cellNum =[1]
%         figure(10+cellNum);clf;hold on
%      go = find(U{cellNum}.meta.trialType==1);%all trials that are go
%      nogo = find(U{cellNum}.meta.trialType==0);%all trials that are nogo
%
%
%
%      for i = 1:length(go) % i through all the go's
%         if sum(U{cellNum}.R_ntk(1,:,go(i)))>0%if there are spikes in this trial...
%
%             plot(find(U{cellNum}.R_ntk(1,:,go(i))==1),i,'k.')
%         end
%
%      end
%
%
%
%
%      for i = 1:length(nogo)
%           if sum(U{cellNum}.R_ntk(1,:,nogo(i)))>0%if there are spikes in this trial...
%           plot(find(U{cellNum}.R_ntk(1,:,nogo(i))==1),i+length(go),'k.')
%           end
%     end
%     end
%     set(gca,'ylim',[0 U{cellNum}.k]+1)
%%
for cellNum =[1:6]
    clearvars -except U cellNum U2 Uall
    h = figure(100+cellNum);
    
    clf;
    
    
    mouseName = U{cellNum}.details.mouseName;
    sessionName = U{cellNum}.details.sessionName;
    cellNumString = U{cellNum}.details.cellNum;
    cellCode = U{cellNum}.details.cellCode;
    projectCellNum = num2str(U{cellNum}.cellNum);
    depth = num2str(U{cellNum}.details.depth);
    title1 = [' cell-', projectCellNum, ' depth-',    depth, '     ' ,mouseName, ' ' ,sessionName, ' ', cellNumString, ' ' cellCode];
    
    hsub1 = subplot('position', [0.08,0.33,.87,.62]);
    title(title1);
    hsub2 = subplot('position', [0.08,0.08,.87,.17]);
    hold on
    
    
    set(gca,'ylim',[0 U{cellNum}.k]+1)
    
    
    smoothFactor = 30;
    smoothType = 'moving';
    % % %     normalizeSpikes = 1 ; %1 is yes 0 is no
    colorAtEndNumber = 9000:.2:9020;%add the colored part at the end to indicate trial type
    colorSet = {'b', 'g', 'g', 'k'};%for tghe trial type
    
    
    go = U{cellNum}.meta.trialType==1;%all trials that are go
    nogo = U{cellNum}.meta.trialType==0;%all trials that are nogo
    correct = U{cellNum}.meta.trialCorrect==1;
    incorrect = U{cellNum}.meta.trialCorrect==0;
    lick = (go.*correct)+(nogo.*incorrect);
    nolick =lick==0;
    hit = (go.*correct);
    corrRej=(nogo.*correct);
    falseAlarm = nogo.*incorrect;
    miss = go.*incorrect;
    
    poleAvailableTime =500;
    [licksLinInds, allLicksCell, firstLicks, trialStart, trialEnd, licksPostPole, licksPrePole] ...
        = lickExtractor(U, cellNum,poleAvailableTime);
    
    answerLickTimes = U{cellNum}.meta.answerLickTime*1000;
    %replace nans with average lick time
    licksPostPoleFinal = licksPostPole(:,1) -150;
    answerLickTimes(isnan(answerLickTimes)) =nanmean (answerLickTimes);
    firstLicksFinal = firstLicks-150;%note shifted these because lick finder doesnt remove the delay ...
    %%%%####set thing for rast to be shifted by
    shiftRastBy = answerLickTimes;
    
    
    numVars = 2;
    for iter1 = 1:numVars
        clear var1 var1LinInds var1Inds var1SummedSpikes allVar1LinInds var1AllShiftedSpikes lickShiftAll allVar1Inds
        hold on
        subplot(hsub1)
        text(1000,50, ['cell ', num2str(U{cellNum}.cellNum)])%plot cell number
        if iter1 == 1
            var1 = find(hit) ;
            addLength = 0;
            length1 = length(var1);
        elseif iter1 == 2
            var1 = find(falseAlarm);
            addLength = length1;
            length2 = length(var1);
        elseif iter1 == 3
            var1 = find(falseAlarm);
            addLength = addLength + length2;
            length3 = length(var1);
        elseif iter1 == 4
            var1 = find(miss);
            addLength = addLength +length3;
            
        end
        
        
        var1AllShiftedSpikes = nan(length(var1),10000);
        hold on
        for i = 1:length(var1) % i through all the go's
            %             if sum(U{cellNum}.R_ntk(1,:,var1(i)))>0%if there are spikes in this trial...
            var1LinInds = U{cellNum}.R_ntk(1,:,var1(i))==1;
            %                 var1LinInds = circshift(var1LinInds, [0, -shiftRastBy(var1(i))]);%shift the value
            lickShift = 0;%round(shiftRastBy(var1(i)));%trials numbers for trial type selected above is --> var1(i)
            
            var1AllShiftedSpikes(i,5000-lickShift:5000-lickShift+4000-1)= var1LinInds;
            var1LinInds = var1AllShiftedSpikes(i,:);
            
            lickShiftAll(i) = lickShift;
            allVar1LinInds(i,:) = var1LinInds;
            var1Inds = find(var1LinInds);
            var1IndsLickShifted = find(var1LinInds)-shiftRastBy(var1(i));
            %%%%
            
            allVar1Inds{i+addLength} = var1Inds;
            Var1Inds{i+addLength} = var1Inds;
            %%%%
            % % % % %                 plot(var1Inds,i+addLength,'k.')
            %             end
        end
        linIndTrialStart = ~isnan(allVar1LinInds);
        IndicesTrialStart = arrayfun(@(x) find(linIndTrialStart(x,:), 1, 'first'), 1:size(allVar1LinInds, 1));
        IndicesTrialEnd = arrayfun(@(x) find(linIndTrialStart(x,:), 1, 'last'), 1:size(allVar1LinInds, 1));
        percentToCut=.2;
        [startScale, endScale] = scalePlot(IndicesTrialStart, IndicesTrialEnd, percentToCut)
        otherLicksToPlot = firstLicksFinal(var1)';%%%to plot in red to see
        %%% how the other licks align with the 'aligned licks' aligned at
        %%% 5000
        
        %sort the trials based on where the fost lick lines up in the
        %raster, that is to sa the trial start plus the 'other licks to
        %plot' which in most cases will be the first lick (regarless of
        %answer period)
        [firstlickSorted, firstLickSortInd] = sort(IndicesTrialStart +otherLicksToPlot);
  
        sortON =1;
        if sortON ==1
            otherLicksToPlot = otherLicksToPlot(:,firstLickSortInd);
            IndicesTrialStart = IndicesTrialStart(:,firstLickSortInd);
            allVar1LinInds = allVar1LinInds(firstLickSortInd,:);
        end

        hold on
        %starting point of the trial so you can see when the trial starts
        %even when the raster is shifted 
        plot(IndicesTrialStart, addLength+1:numel(IndicesTrialStart)+addLength, strcat(colorSet{iter1}, '>'))
        %ending point of the trial...
        plot(IndicesTrialEnd, addLength+1:numel(IndicesTrialEnd)+addLength, strcat(colorSet{iter1}, '<'))
        
        
        %get the y axis points to plot for below (just trial numbers)
        trialsToPlot = (addLength+1:length(var1)+addLength);
        
        %plot 'secondary' licks, for example align to answer period lick
        %above and use this to plot first lick, where some licks happen
        %before the answer period for example.
        plot(otherLicksToPlot+IndicesTrialStart, trialsToPlot,'r.')
        
        %find and plot spikes
        [I, J] = find(allVar1LinInds>0);
        plot(J,I+addLength,'k.')
        hold on;
        
        %get the values for histogram below... use nanmean to correctly
        %normalize for each trial that is present in a column 
        var1SummedSpikes = nanmean(allVar1LinInds, 1);
        subplot(hsub2)
        if iter1 ==1
            hold off
        else
            hold on
        end
        smoothedSpikes = smooth(var1SummedSpikes,smoothFactor,smoothType);
        plot(smoothedSpikes,colorSet{iter1})
        
        %getting and setting correct y max value for below histogram
        %(separating out the end parts that have few trials that make the
        %spides of the graph jump up really far)
        yMaxAllVars(iter1) = max(smoothedSpikes(startScale:endScale));
        yMAX = max(yMaxAllVars);
        ylim([0 1.1*yMAX])
        
        hold on
        linkaxes([hsub1, hsub2], 'x');
        
    end
end








% % % % % % % % % % % % % %      %%
% % % % % % % % % % % % % %
% % % % % % % % % % % % % %      Q(isnan(Q))=0;
% % % % % % % % % % % % % %      poleAvailableTime = 500;
% % % % % % % % % % % % % %
% % % % % % % % % % % % % %      [test1,tes2,trials]=size(U{1}.S_ctk(:,:,:));
% % % % % % % % % % % % % %
% % % % % % % % % % % % % %      test4 = U{cellNum}.S_ctk(16,:,1:trials);
% % % % % % % % % % % % % %      test4(isnan(test4))=0;
% % % % % % % % % % % % % %      C = permute(test4,[1 3 2]);
% % % % % % % % % % % % % %      C = reshape(C,[],size(test4,2),1);
% % % % % % % % % % % % % %
% % % % % % % % % % % % % %
% % % % % % % % % % % % % %
% % % % % % % % % % % % % %
% % % % % % % % % % % % % %      find(test4)
% % % % % % % % % % % % % %      for trial = 1:trials
% % % % % % % % % % % % % %         test5{trial}=find(test4(1,:,trial));
% % % % % % % % % % % % % %      end
% % % % % % % % % % % % % %
% % % % % % % % % % % % % %
% % % % % % % % % % % % % %  [x]=cellNums2MatWithZeros(test5');
% % % % % % % % % % % % % %
% % % % % % % % % % % % % % test7 = x(:,1);
% % % % % % % % % % % % % % averageLickShift = round(sum(test7(test7>0))/length(test7(test7>0)));
% % % % % % % % % % % % % % test7(test7==0)= averageLickShift
% % % % % % % % % % % % % %
% % % % % % % % % % % % % %
% % % % % % % % % % % % % % %%
% % % % % % % % % % % % % %
% % % % % % % % % % % % % % r = rem(test7,10);
% % % % % % % % % % % % % % c = [cycle,cycle];
% % % % % % % % % % % % % % out = c(bsxfun(@plus,bsxfun(@plus,10 - r,0:9)*5,(1:5)'));








%      firstLickTime =
% %      allLickTimes
%     lick
%      sortedBarPos, sortedBarInd] = sort(U{1}.whisker.barPose
%yo bar position is an xy coordinates of the video will have to fit line to
%it and then i can get the actual
%
%      for i = 1:length(go) % i through all the go's
%         if sum(U{cellNum}.R_ntk(1,:,go(i)))>0%if there are spikes in this trial...
%
%             plot(find(U{cellNum}.R_ntk(1,:,go(i))==1),i,'k.')
%         end
%
%      end
%
%
%
%
%      for i = 1:length(nogo)
%           if sum(U{cellNum}.R_ntk(1,:,nogo(i)))>0%if there are spikes in this trial...
%           plot(find(U{cellNum}.R_ntk(1,:,nogo(i))==1),i+length(go),'k.')
%           end
%     end
%     end
%     set(gca,'ylim',[0 U{cellNum}.k]+1)
% %%
%     U{1}.meta.trialCorrect
%     U{1}.meta.trialType
%
%      motorPosition: [1×512 double]
%           goPosition: [1×512 double]
%         nogoPosition: [1×512 double]
%            trialType: [1×512 logical]
%         trialCorrect: [1×512 double]
%            poleOnset: [1×512 double]
%           poleOffset: [1×512 double]
%                layer: {'S2BadContacts'}
%               ranges: [45000 125000]
%       sweepArrayName: {}
%            harddrive: {}
%         manipulation: {}
%     performingTrials: []
%          performance: []
%           stimTrials: {}
%     U{1}.varNames
%   Columns 1 through 7
%     'thetaAtBase'    'velocity'    'amplitude'    'setpoint'    'phase'    'deltaKappa'    'M0Adj'
%   Columns 8 through 12
%     'FaxialAdj'    'firstTouchOnset'    'firstTouchOffset'    'firstTouchAll'    'lateTouchOnset'
%   Columns 13 through 16
%     'lateTouchOffset'    'lateTouchAll'    'PoleAvailable'    'beamBreakTimes'
% %%
%     U{cellNum}.S_ctk(variableNum,time,trial)