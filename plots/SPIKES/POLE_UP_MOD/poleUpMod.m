%% whisking modulation before and after pole up
% % % tic
% % % [touchBLock2]  =  superEventMakerINDEXover4000dontELIMINATE(U, '.S_ctk(9,:,:)', 100, -50);
% % % toc
%%
set(0,'defaultAxesFontSize',20)
% for varNumber = [1 2 3 4 5 6]
for varNumber = [3]
    % varNumber = 5;
    varName = U{1}.varNames{varNumber}
    %%
    for cellStep = 1:length(U)
        cellTMP = U{cellStep};
        %%
        theta = squeeze(cellTMP.S_ctk(varNumber,:,:));
        
        
        
        %% first block out pole downtimes for now
        poleDown = cellTMP.meta.poleOffset;
        poleDown(poleDown>4000) = 4000;
        poleDownMask = zeros(size(theta));
        for k = 1:length(poleDown)
            indexTMP = 1:poleDown(k);
            poleDownMask(indexTMP,k) = 1;
        end
        %%
        
        %% next block out touches
        %% base this on the phase, if a touch occured, then remove the period 1/2 phase before and after the touch to
        %% remove the entire cycle surroudn this touch
        %% actually just going to do the easy way and block out like 50 ms before and after
        
       
        touchFirstAll = find(squeeze(cellTMP.S_ctk(14,:,:))==1);
        touchLateALL = find(squeeze(cellTMP.S_ctk(11,:,:))==1);
        allTouches = sort([touchFirstAll; touchLateALL]);
        % trials = ceil(allTouches./4000);
        rangeRemoveTouch = -50:200;
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
        
        

        touchMask = ones(size(theta));
        touchMask(touchMaskInd) = 0;
        %% now block out all the periods where the mouse isnt whisking enough to qualify
        %% as whisking, amp below 2.5 or 3 should be good for now. might have to go into velocity
        %% for later or something
        lowAmpMaskInd =  find(cellTMP.S_ctk(3,:,:) < 3);
        lowAmpMask = ones(size(theta));
        lowAmpMask(lowAmpMaskInd) = 0;
        %% create a mask for before pole up, after pole up and response region right after pole up
        poleUp = cellTMP.meta.poleOnset;
        poleUpMask = zeros(size(theta));
        TimAfterPoleUpMask = 200;
        poleUpResponseMask = ones(size(theta));
        for k = 1:length(poleUp)
            indexTMP = poleUp(k):4000;
            poleUpMask(indexTMP, k) = 1;
            indexTMP = poleUp(k):TimAfterPoleUpMask;
            poleUpResponseMask(indexTMP, k) = 0;
        end
        beforePoleUpMask = ~poleUpMask;
        %% seperate the data into before and after pole up
        finalMaskPRE = poleDownMask.*touchMask.*lowAmpMask.*beforePoleUpMask.*poleUpResponseMask;
        finalMaskPOST = poleDownMask.*touchMask.*lowAmpMask.*poleUpMask.*poleUpResponseMask;
        finalMaskPRE(find(finalMaskPRE ==0)) = nan;
        finalMaskPOST(find(finalMaskPOST ==0)) = nan;
        thetaPRE = theta.*finalMaskPRE;
        thetaPOST = theta.*finalMaskPOST;
        %% now block out whisking periods that are too short, if the preiod between touches is only like 50 ms
        %% then this is to small, lets set this value to be an entire phase
        PREindex = find(~isnan(thetaPRE));
        POSTindex = find(~isnan(thetaPOST));
        
        inALine = PREindex - (1:length(PREindex))';
        [indexToLine indexToAllInds allIndsToLine] = unique(inALine);
        
        indexToAllInds = [indexToAllInds; length(allIndsToLine)+1];
        lengthEach = indexToAllInds - (circshift(indexToAllInds, 1));
        lengthEach = lengthEach(2:end) - 1;
        indexToAllInds =indexToAllInds(1:end-1);
        indexMatPRE = [indexToLine , lengthEach+indexToLine];
        
        inALine = POSTindex - (1:length(POSTindex))';
        [indexToLine indexToAllInds allIndsToLine] = unique(inALine);
        
        indexToAllInds = [indexToAllInds; length(allIndsToLine)+1];
        lengthEach = indexToAllInds - (circshift(indexToAllInds, 1));
        lengthEach = lengthEach(2:end) - 1;
        indexToAllInds =indexToAllInds(1:end-1);
        indexMatPOST = [indexToLine , lengthEach+indexToLine];
        
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %%%%%%%%%%%%%% PRROF OF CONCEPT FRO ABOVE
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % indexToAllInds = [indexToAllInds; length(allIndsToLine)+1];
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % lengthEach = indexToAllInds - (circshift(indexToAllInds, 1));
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % lengthEach = lengthEach(2:end) - 1;
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % indexToAllInds =indexToAllInds(1:end-1);
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % indexMatPRE = [indexToAllInds , lengthEach+indexToAllInds];
        
        %% NOW WE HAVE THE INDEXS BUT NOW WHAT
        spikes = squeeze(cellTMP.R_ntk(:,:,:));
        % can adda thing to look before and after window for spikes cause of delay of motor signal or reafferent signal
        %     spikesPre = find(spikes(PREindex));
        %     spikesPOST = find(spikes(POSTindex));
        
        %%
        spkWin = -30:30;
        spikeINDS = find(spikes==1);
        spikeTrials =round(((spikeINDS./4000) - floor(spikeINDS./4000)).*4000);
        %% remove spikes that will grab window over limit
        test = spikeTrials + spkWin;
        test2 = find(test>4000);
        test3 = find(test<1);
        
        OverUnderSpikeWindow = [test2; test3];
        %%
        grabTheseSpikes = spikeINDS+spkWin;
        grabTheseSpikes(OverUnderSpikeWindow) = 1; %this is temporary so
        %that indexing works I will replace these with nans below.
        
        
        allPreThetas = thetaPRE(grabTheseSpikes);
        allPreThetas(OverUnderSpikeWindow) = nan;
        
        NsamplesPRE = nansum(~isnan(allPreThetas), 1);
        STA_PRE = nanmean(allPreThetas, 1);
        thetasSampledPRE = allPreSpikes(~isnan(allPreSpikes));
        
        allPostT = thetaPOST(grabTheseSpikes);
        allPostSpikes(OverUnderSpikeWindow) = nan;
        
        NsamplesPOST = nansum(~isnan(allPostSpikes), 1);
        STA_POST = nanmean(allPostSpikes, 1);
        thetasSampledPOST = allPostSpikes(~isnan(allPostSpikes));
        %%
        keyboard
        close all
        
        mainFig = figure(100);
        left_color = [ .5 .5 .5];
        right_color = [0 0 0];
        set(mainFig,'defaultAxesColorOrder',[left_color; right_color]);
        hold on
        
        
        yyaxis left
        barTMP1 = bar(spkWin, NsamplesPRE);
        barTMP1.FaceColor = [0 0 1];%blue
        barTMP1.EdgeColor = [0 0 0];
        barTMP1.FaceAlpha =.4;
        barTMP1.EdgeAlpha =0;
        
        yyaxis left
        barTMP2 = bar(spkWin, NsamplesPOST);
        
        barTMP2.FaceColor = [1 0 0];%red
        barTMP2.EdgeColor = [0 0 0];
        barTMP2.FaceAlpha =.1;
        barTMP2.EdgeAlpha =0;
        
        % % %     maxYsamples = max([NsamplesPOST, NsamplesPRE]);
        % % % % % %     % change y scale to log and change the limits of y axis
        % % %     if  maxYsamples>=10 && maxYsamples<=500
        % % %         ylim([0 maxYsamples.*1]);
        % % %     elseif  maxYsamples>500
        % % %         ylim([0 500]);
        % % %     else
        % % %         ylim([0 10]);
        % % %     end
        
        maxSmallYsamples =  max([NsamplesPRE]);
        if maxSmallYsamples>500
            ylim([0 maxSmallYsamples.*3]);
        elseif maxSmallYsamples<500 &&maxSmallYsamples>200
            ylim([0 1000]);
        else
            ylim([0 500]);
        end
        
        %     set(gca, 'YScale', 'log')
        ylabel('samples per bin');
        
        yyaxis right
        temp1 = plot(spkWin, STA_POST, 'r');
        % uistack(temp1,'top');
        
        % yyaxis left
        temp2 = plot(spkWin, STA_PRE, 'b-');
        % uistack(temp2,'top');
        xlim([spkWin(1), spkWin(end)]);
        ylabel([varName, '  before (blue) and after (red) pole up'])
        xlabel('STA spike at 0 (ms)')
        title(['whisking ' varName ' pole up modulation']);
        
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [1, 0, 1, 1]);
        saveLoc = ['C:\Users\maire\Documents\PLOTS\pole_up_Modulation\' varName '\'];
        mkdir(saveLoc)
        generalName = ['pole up mod ' varName] ;
        tmpName = ['U_IND_' num2str(cellStep)];
        filename =  [saveLoc, generalName, tmpName];
        saveas(gcf,filename,'png')
        savefig(filename)
        
        
        
        
    end
    
    
    
end