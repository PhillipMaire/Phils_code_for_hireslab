% % % % function [] = uber_histoANDrast_lick_aligned_2_FINAL(sortON, , , , , , , , , , )

%need to put a switch here so that i can plot differnt kinds of graphs on a
%single figure so like a use a number and command string like 'plotOn' and
%then number 2 so make it plot on a subplot 2 of the same figure so that
%UBER_MASTER_CONTROL can use it to plot what we want






%%
for cellNum =[2]
    clearvars -except U cellNum U2 Uall
    h = figure(400+cellNum);
    
    clf;
    
    
    percentToCut=.3;%for scaleing the plot so if .2 then will scale based on withing 80% of trials
    sortONprimary = 1;%based on  otherLicksToPlotSet
    sortONsecondary =1;%based on alignToThisVar
    alignON = 1;
    VariableNumToPlot = 9;%##setvar ie first touch ect,. {'thetaAtBase','velocity','amplitude','setpoint','phase','deltaKappa','M0Adj','FaxialAdj','firstTouchOnset','firstTouchOffset','firstTouchAll','lateTouchOnset','lateTouchOffset','lateTouchAll','PoleAvailable','beamBreakTimes'}
    %search for ##setvar to find variables you mostlikely want to
    %manipulate
    
    mouseName = U{cellNum}.details.mouseName;
    sessionName = U{cellNum}.details.sessionName;
    cellNumString = U{cellNum}.details.cellNum;
    cellCode = U{cellNum}.details.cellCode;
    projectCellNum = num2str(U{cellNum}.cellNum);
    depth = num2str(U{cellNum}.details.depth);
    fractionCorrect = num2str(U{cellNum}.details.fractionCorrect*100);
    trialsCorrect = U{cellNum}.meta.trialCorrect;
    fractionCorrectstr = ['1-',num2str(numel(trialsCorrect)),' ',fractionCorrect(1:4), '%'];
    
    useTrials = U{cellNum}.details.useTrials;
    %look at good perfomrance region
    numTrialsInRowCorrect = 4; %number of correct trials ina row to
    %find the last instance of so that you can give a good performance measure
    correctTrialsInRow = ones(1,numTrialsInRowCorrect);
    new = strfind(trialsCorrect, correctTrialsInRow);
    perormanceRegion= 1:new(end)+numTrialsInRowCorrect;
    meanPerformanceRegion = num2str(mean(trialsCorrect(perormanceRegion))*100);
    perormanceRegionStr = [num2str(useTrials(1)),'-',num2str(useTrials(perormanceRegion(end)))...
        ,' ', meanPerformanceRegion(1:4),'%'];
    
    title1 = [' cell-', projectCellNum, ' depth-',    depth, '     ' ,mouseName, ' ' ,sessionName, ' ', cellNumString, ' ', cellCode, '     ', fractionCorrectstr,'   ',perormanceRegionStr];
    
    hsub1 = subplot('position', [0.08,0.33,.87,.62]);
    title(title1);
    hsub2 = subplot('position', [0.08,0.08,.87,.17]);
    hold on
    
    
    set(gca,'ylim',[0 U{cellNum}.k]+1)
    
    
    smoothFactor = 30;%##setvar
    smoothType = 'moving';%##setvar
    % % %     normalizeSpikes = 1 ; %1 is yes 0 is no
    
    colorSet = {'b', 'g', 'g', 'k'};%for tghe trial type%##setvar
    
    
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
    poleOnsetTimes = U{cellNum}.meta.poleOnset*1000;
    offsetShift = U{cellNum}.details.whiskerTrialTimeOffset*1000;
    
    [licksLinInds, allLicksCell, firstLicks, trialStart, trialEnd, licksPostPole, licksPrePole, averageLickShift] ...
        = lickExtractor(U, cellNum,offsetShift,poleOnsetTimes);%##setvar ad shift value to make pole available time
    %uses shift value because these values arent shifted in the uber aray
    %but the other lick times are shifted in the uber array can use a plus
    %value to add to pole onset for pole available times
    
    
    %answer licks time from the U array (originally form the T array)
    answerLickTimes = U{cellNum}.meta.answerLickTime*1000;
    %replace nans with average lick time
    %get just the first licks after pole up
    licksPostPoleFinal = licksPostPole(:,1);
    %replace no licks with average lick time (to plot the no lick trials
    %together with the lick trials
    answerLickTimes(isnan(answerLickTimes)) =nanmean (answerLickTimes);
    firstLicksFinal = firstLicks;%note shifted these because lick finder doesnt remove the delay ...
    %%%%####set thing for rast to be shifted by
    alignToThisVar = answerLickTimes;%##setvar
    %to plot in red points to see how the other licks align with the
    %'aligned licks' aligned at 5000
    
    %     ############# this is the new part
    firstlickFinal = U{cellNum}.meta.beamBreakTimesMat(1,:);
    firstlickFinal(isnan(firstlickFinal)) = averageLickShift;
    otherLicksToPlotSet = firstLicksFinal';%##setvar  #firstLicksFinal' <-- dont forget to transpose only this one #answerLickTimes
    %     ############# this is the new part
    
    numVars = 2;
    for iter1 = 1:numVars
        clear var1 var1LinInds var1Inds var1SummedSpikes allVar1LinInds var1AllShiftedSpikes lickShiftAll allVar1Inds
        hold on
        subplot(hsub1)
        
        if iter1 == 1
            TrialIndexVar = find(hit) ;
            addLength = 0;
            length1 = length(TrialIndexVar);
        elseif iter1 == 2
            TrialIndexVar = find(falseAlarm);
            addLength = length1;
            length2 = length(TrialIndexVar);
        elseif iter1 == 3
            TrialIndexVar = find(falseAlarm);
            addLength = addLength + length2;
            length3 = length(TrialIndexVar);
        elseif iter1 == 4
            TrialIndexVar = find(miss);
            addLength = addLength +length3;
            
        end
        
        
        var1AllShiftedSpikes = nan(length(TrialIndexVar),10000);
        var2AllShiftedSpikes = nan(length(TrialIndexVar),10000);
        hold on
        %%
        for i = 1:length(TrialIndexVar) % i through all the go's
            %             if sum(U{cellNum}.R_ntk(1,:,var1(i)))>0%if there
            %             are spikes in this trial...\
            
            var1LinInds = U{cellNum}.R_ntk(1,:,TrialIndexVar(i))==1;
            var2LinInds = U{cellNum}.S_ctk(VariableNumToPlot,:,TrialIndexVar(i))==1;
            %                 var1LinInds = circshift(var1LinInds, [0, -shiftRastBy(var1(i))]);%shift the value
            if alignON ==1
                offsetShift = floor(alignToThisVar(TrialIndexVar(i)));%trials numbers for trial type selected above is --> var1(i)
            else
                offsetShift =0;
            end
            var1AllShiftedSpikes(i,5000-offsetShift:5000-offsetShift+4000-1)= var1LinInds;
            var2AllShiftedSpikes(i,5000-offsetShift:5000-offsetShift+4000-1)= var2LinInds;
            var1LinInds = var1AllShiftedSpikes(i,:);
            var2LinInds = var2AllShiftedSpikes(i,:);
            lickShiftAll(i) = offsetShift;
            allVar1LinInds(i,:) = var1LinInds;
            allVar2LinInds(i,:) = var2LinInds;
            var1Inds = find(var1LinInds);
            var2Inds = find(var2LinInds);
            var1IndsLickShifted = find(var1LinInds)-alignToThisVar(TrialIndexVar(i));
            var2IndsLickShifted = find(var2LinInds)-alignToThisVar(TrialIndexVar(i));
            %%%%
            
            allVar1Inds{i+addLength} = var1Inds;
            Var1Inds{i+addLength} = var1Inds;
            allVar2Inds{i+addLength} = var2Inds;
            Var2Inds{i+addLength} = var2Inds;
            %%%%
            % % % % %                 plot(var1Inds,i+addLength,'k.')
            %             end
        end
        
        shiftToZero = 5000;
        linIndTrialStart = ~isnan(allVar1LinInds);
        IndicesTrialStart = arrayfun(@(x) find(linIndTrialStart(x,:), 1, 'first'), 1:size(allVar1LinInds, 1))-shiftToZero;
        IndicesTrialEnd = arrayfun(@(x) find(linIndTrialStart(x,:), 1, 'last'), 1:size(allVar1LinInds, 1))-shiftToZero;
        %         IndicesTrialEnd =IndicesTrialEnd+200;%add on the extra 200 for 4.2 seconds for the spike arrays
        
        %function used to find the points between which the plot should be
        %scaled to
        %placed above percentToCut=.2;
        [startScale, endScale] = scalePlot(IndicesTrialStart, IndicesTrialEnd, percentToCut);
        
        otherLicksToPlot = otherLicksToPlotSet(TrialIndexVar) -shiftToZero;%this is set above;
        
        %sort the trials based on where the first lick lines up in the
        %raster, that is to say the trial start plus the 'other' licks to
        %plot' which in most cases will be the first lick (regarless of
        %answer period)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %##setvar %##setvar %##setvar %##setvar
        %need to remove or att the IndicesTrialStart depending on which
        %variables you are plotting fo rit to align correctly.
        %might have to change this code
        
        
        
        alignToThisVarVar1 = alignToThisVar(TrialIndexVar);%first lick final
        % % %         if mean(otherLicksToPlotSet == alignToThisVar)
        % % %             [~, firstLickSortInd2] = sort(alignToThisVarVar1);
        % % %         else
        [~, firstLickSortInd2] = sort(alignToThisVarVar1);
        % % %         end
        
        
        %sorting the rasters based on lick type 'other' licks
        %placed above    sortON =1 ;
        if sortONsecondary ==1
            otherLicksToPlot = otherLicksToPlot(:,firstLickSortInd2);
            IndicesTrialStart = IndicesTrialStart(:,firstLickSortInd2);
            IndicesTrialEnd = IndicesTrialEnd(:,firstLickSortInd2);
            allVar1LinInds = allVar1LinInds(firstLickSortInd2,:);
            allVar2LinInds = allVar2LinInds(firstLickSortInd2,:);
            poleOnsetTimes = poleOnsetTimes(firstLickSortInd2);
        end
        if mean(otherLicksToPlotSet == alignToThisVar)
            [~, firstLickSortInd] = sort(otherLicksToPlot);
        else
            [~, firstLickSortInd] = sort(IndicesTrialStart + otherLicksToPlot);
        end
        if sortONprimary == 1
            otherLicksToPlot = otherLicksToPlot(:,firstLickSortInd);
            IndicesTrialStart = IndicesTrialStart(:,firstLickSortInd);
            IndicesTrialEnd = IndicesTrialEnd(:,firstLickSortInd);
            allVar1LinInds = allVar1LinInds(firstLickSortInd,:);
            allVar2LinInds = allVar2LinInds(firstLickSortInd,:);
            poleOnsetTimes = poleOnsetTimes(firstLickSortInd);
        end
        
        hold on
        %starting point of the trial so you can see when the trial starts
        %even when the raster is shifted
        plot(IndicesTrialStart, addLength+1:numel(IndicesTrialStart)+addLength, strcat(colorSet{iter1}, '>'))
        %ending point of the trial...
        plot(IndicesTrialEnd, addLength+1:numel(IndicesTrialEnd)+addLength, strcat(colorSet{iter1}, '<'))
        
        
        %get the y axis points to plot for below (just trial numbers)
        trialsToPlot = (addLength+1:length(TrialIndexVar)+addLength);
        
        %plot 'other' licks, for example align to answer period lick
        %above and use this to plot first lick, where some licks happen
        %before the answer period for example.
        plot(otherLicksToPlot+IndicesTrialStart+shiftToZero, trialsToPlot,'r.')
        
        plot(poleOnsetTimes+IndicesTrialStart, trialsToPlot,'m+')
        
        %find and plot spikes
        [I, J] = find(allVar1LinInds>0);
        [I2, J2] = find(allVar2LinInds>0);
        
        plot(J2-shiftToZero,I2+addLength,'bx')
        hold on;
        plot(J-shiftToZero,I+addLength,'k.')
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
        plot((1:10000)-shiftToZero,smoothedSpikes,colorSet{iter1})
        hold on
        %getting and setting correct y max value for below histogram
        %(separating out the end parts that have few trials that make the
        %spides of the graph jump up really far)
        yMaxAllVars(iter1) = max(smoothedSpikes(startScale+shiftToZero:endScale+shiftToZero));
        yMAX = max(yMaxAllVars);
        ylim([0 1.1*yMAX])
        
        hold on
        linkaxes([hsub1, hsub2], 'x');
        
    end
end



