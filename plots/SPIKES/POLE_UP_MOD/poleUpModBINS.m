%% whisking modulation before and after pole up
% % % tic
% % % [touchBLock2]  =  superEventMakerINDEXover4000dontELIMINATE(U, '.S_ctk(9,:,:)', 100, -50);
% % % toc
%%
set(0,'defaultAxesFontSize',20)
% for varNumber = [1 2 3 4 5 6]
xlimSET = [-40 60];
binWidth = 5;
for varNumber = 3 %[1]
    % varNumber = 5;
    varName = U{1}.varNames{varNumber}
    %%
    for cellStep = 17%1:length(U)
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
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         %% now block out all the periods where the mouse isnt whisking enough to qualify
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         %% as whisking, amp below 2.5 or 3 should be good for now. might have to go into velocity
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         %% for later or something
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         lowAmpMaskInd =  find(cellTMP.S_ctk(3,:,:) < 3);
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         lowAmpMask = ones(size(theta));
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         lowAmpMask(lowAmpMaskInd) = 0;
        %% create a mask for before pole up, after pole up and response region right after pole up
        poleUp = cellTMP.meta.poleOnset;
        beforePoleUpMask = zeros(size(theta));
        TimAfterPoleUpMask = 200;% ms after pole up to remove for all trials
        poleUpResponseMask = ones(size(theta));
        for k = 1:length(poleUp)
            indexTMP = poleUp(k):4000;
            beforePoleUpMask(indexTMP, k) = 1;
            indexTMP = poleUp(k):TimAfterPoleUpMask;
            poleUpResponseMask(indexTMP, k) = 0;
        end
        afterPoleUpMask = ~beforePoleUpMask;
        
        %% get indexs and length of each snipit (mat not need this for the histogram thing)
        
        % % %
        % % %
        % % %         inALine = PREindex - (1:length(PREindex))';
        % % %         [indexToLine indexToAllInds allIndsToLine] = unique(inALine);
        % % %
        % % %         indexToAllInds = [indexToAllInds; length(allIndsToLine)+1];
        % % %         lengthEach = indexToAllInds - (circshift(indexToAllInds, 1));
        % % %         lengthEach = lengthEach(2:end) - 1;
        % % %         indexToAllInds =indexToAllInds(1:end-1);
        % % %         indexMatPRE = [indexToLine , lengthEach+indexToLine];
        % % %
        % % %         inALine = POSTindex - (1:length(POSTindex))';
        % % %         [indexToLine indexToAllInds allIndsToLine] = unique(inALine);
        % % %
        % % %         indexToAllInds = [indexToAllInds; length(allIndsToLine)+1];
        % % %         lengthEach = indexToAllInds - (circshift(indexToAllInds, 1));
        % % %         lengthEach = lengthEach(2:end) - 1;
        % % %         indexToAllInds =indexToAllInds(1:end-1);
        % % %         indexMatPOST = [indexToLine , lengthEach+indexToLine];
        % % %
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
        
        %% seperate the data into before and after pole up
        finalMask = poleDownMask.*touchMask.*poleUpResponseMask;
        finalMaskPRE = finalMask.*afterPoleUpMask;
        finalMaskPOST = finalMask.*beforePoleUpMask;
        finalMaskPRE(find(finalMaskPRE ==0)) = nan;
        finalMaskPOST(find(finalMaskPOST ==0)) = nan;
        thetaPRE = theta.*finalMaskPRE;
        thetaPOST = theta.*finalMaskPOST;
        
        PREindex = find(~isnan(thetaPRE));
        POSTindex = find(~isnan(thetaPOST));
        
        linearPRE = thetaPRE(PREindex);
        linearPOST = thetaPOST(POSTindex);
        linearALL = [linearPRE;linearPOST];
        
        binsForVar = ( round(min(linearALL)-1) : binWidth :  round(max(linearALL)+1 ));
        SPKperBinPRE = nan(1, length(binsForVar) -1);
        SPKperBinPOST = SPKperBinPRE;
        normalizeByPRE = SPKperBinPRE;
        normalizeByPOST = SPKperBinPRE;
        for k = 1:length(binsForVar) - 1
            
            test = (thetaPRE >= binsForVar(k)).*(thetaPRE <binsForVar(k+1));
            normalizeByPRE(k) = sum(sum(test));
            test2 = test.*spikes;
            SPKperBinPRE(k) = length(find(test2==1));
            
            test = (thetaPOST >= binsForVar(k)).*(thetaPOST <binsForVar(k+1));
            normalizeByPOST(k) = sum(sum(test));
            test2 = test.*spikes;
            SPKperBinPOST(k) = length(find(test2==1));
            
        end
        
        %%
        
        figure
        subplot(2,1,1)
        hold on
        %          yyaxis left
        spaceBetween = (abs(binsForVar(2) - binsForVar(1)))./2;
        binsForVar2 = (binsForVar(2:end) - spaceBetween) - spaceBetween./5;
        normPREspks = SPKperBinPRE./normalizeByPRE;
        normPREspks = normPREspks.*1000;%spk per sec
        barTMP1 = bar(binsForVar2, normPREspks);
        barTMP1.FaceColor = [0 0 1];%blue
        barTMP1.EdgeColor = [0 0 0];
        barTMP1.FaceAlpha =.4;
        barTMP1.EdgeAlpha =0;
        projCellNum = cellTMP.details.projectDetails.cellNumberForProject;
        titleGeneral = [varName, ' tuning before (blue) and after (red) pole up      U ind ', num2str(cellStep), '   cellNum ',projCellNum];
        title(titleGeneral)
        ylabel('spikes per sec')
        
        %         yyaxis left
        binsForVar2 = (binsForVar(2:end) - spaceBetween) + spaceBetween./5;
        normPOSTspks = SPKperBinPOST./normalizeByPOST;
        normPOSTspks = normPOSTspks.*1000; % spks per sec
        barTMP2 = bar(binsForVar2, normPOSTspks);
        
        barTMP2.FaceColor = [1 0 0];%red
        barTMP2.EdgeColor = [0 0 0];
        barTMP2.FaceAlpha =.4;
        barTMP2.EdgeAlpha =0;
        
        combSpks = sort([normPREspks, normPOSTspks]);
        combSpks = combSpks(~isnan(combSpks));
        PercSpk = combSpks(round(0.8 .* length(combSpks)));
        
        yLimUp = PercSpk+ (PercSpk.* 2);
        if yLimUp< 0.01
            yLimUp = 0.01 .*1000;
        end
        
        ylim([0 yLimUp]);
        xlim(xlimSET)
        %% plot the sampling distribution
        
        subplot(2,1,2);
        hold on
        %          yyaxis left
        spaceBetween = (abs(binsForVar(2) - binsForVar(1)))./2;
        binsForVar2 = (binsForVar(2:end) - spaceBetween) - spaceBetween./5;
        barTMP1 = bar(binsForVar2, normalizeByPRE);
        barTMP1.FaceColor = [0 0 1];%blue
        barTMP1.EdgeColor = [0 0 0];
        barTMP1.FaceAlpha =.4;
        barTMP1.EdgeAlpha =0;
        
        %         yyaxis left
        binsForVar2 = (binsForVar(2:end) - spaceBetween) + spaceBetween./5;
        barTMP2 = bar(binsForVar2, normalizeByPOST);
        
        barTMP2.FaceColor = [1 0 0];%red
        barTMP2.EdgeColor = [0 0 0];
        barTMP2.FaceAlpha =.4;
        barTMP2.EdgeAlpha =0;
        set(gca, 'YScale', 'log')
        grid on
        xlim(xlimSET)
        %         grid minor
        %         grid ('YMinorGrid', 'on')
        %         test.YMinorGrid = 'on'
        %%
        
        %         xlabel(binsForVar)
        ylabel('num samples')
        xlabel(varName);
        
        
        keyboard
        
        saveLoc = ['C:\Users\maire\Documents\PLOTS\pole_up_ModulationBarGraphtmp\' varName '\'];
        mkdir(saveLoc)
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [1, 0, 1, 1]);
        generalName = ['Cell ', projCellNum,  ' Index ', num2str(cellStep) , varName] ;
        filename =  [saveLoc, generalName];
        saveas(gcf,filename,'png')
        savefig(filename)
        close all
        
        % % %         spkWin = -30:30;
        % % %         spikeINDS = find(spikes==1);
        % % %         spikeTrials =round(((spikeINDS./4000) - floor(spikeINDS./4000)).*4000);
        % % %         %% remove spikes that will grab window over limit
        % % %         test = spikeTrials + spkWin;
        % % %         test2 = find(test>4000);
        % % %         test3 = find(test<1);
        % % %
        % % %         OverUnderSpikeWindow = [test2; test3];
        % % %         %%
        % % %         grabTheseSpikes = spikeINDS+spkWin;
        % % %         grabTheseSpikes(OverUnderSpikeWindow) = 1; %this is temporary so
        % % %         %that indexing works I will replace these with nans below.
        % % %
        % % %
        % % %         allPreThetas = thetaPRE(grabTheseSpikes);
        % % %         allPreThetas(OverUnderSpikeWindow) = nan;
        % % %
        % % %         NsamplesPRE = nansum(~isnan(allPreThetas), 1);
        % % %         STA_PRE = nanmean(allPreThetas, 1);
        % % %         thetasSampledPRE = allPreSpikes(~isnan(allPreSpikes));
        % % %
        % % %         allPostT = thetaPOST(grabTheseSpikes);
        % % %         allPostSpikes(OverUnderSpikeWindow) = nan;
        % % %
        % % %         NsamplesPOST = nansum(~isnan(allPostSpikes), 1);
        % % %         STA_POST = nanmean(allPostSpikes, 1);
        % % %         thetasSampledPOST = allPostSpikes(~isnan(allPostSpikes));
        % % %         %%
        % % %         keyboard
        % % %         close all
        % % %
        % % %         mainFig = figure(100);
        % % %         left_color = [ .5 .5 .5];
        % % %         right_color = [0 0 0];
        % % %         set(mainFig,'defaultAxesColorOrder',[left_color; right_color]);
        % % %         hold on
        % % %
        % % %
        % % %         yyaxis left
        % % %         barTMP1 = bar(spkWin, NsamplesPRE);
        % % %         barTMP1.FaceColor = [0 0 1];%blue
        % % %         barTMP1.EdgeColor = [0 0 0];
        % % %         barTMP1.FaceAlpha =.4;
        % % %         barTMP1.EdgeAlpha =0;
        % % %
        % % %         yyaxis left
        % % %         barTMP2 = bar(spkWin, NsamplesPOST);
        % % %
        % % %         barTMP2.FaceColor = [1 0 0];%red
        % % %         barTMP2.EdgeColor = [0 0 0];
        % % %         barTMP2.FaceAlpha =.1;
        % % %         barTMP2.EdgeAlpha =0;
        % % %
        % % %         % % %     maxYsamples = max([NsamplesPOST, NsamplesPRE]);
        % % %         % % % % % %     % change y scale to log and change the limits of y axis
        % % %         % % %     if  maxYsamples>=10 && maxYsamples<=500
        % % %         % % %         ylim([0 maxYsamples.*1]);
        % % %         % % %     elseif  maxYsamples>500
        % % %         % % %         ylim([0 500]);
        % % %         % % %     else
        % % %         % % %         ylim([0 10]);
        % % %         % % %     end
        % % %
        % % %         maxSmallYsamples =  max([NsamplesPRE]);
        % % %         if maxSmallYsamples>500
        % % %             ylim([0 maxSmallYsamples.*3]);
        % % %         elseif maxSmallYsamples<500 &&maxSmallYsamples>200
        % % %             ylim([0 1000]);
        % % %         else
        % % %             ylim([0 500]);
        % % %         end
        % % %
        % % %         %     set(gca, 'YScale', 'log')
        % % %         ylabel('samples per bin');
        % % %
        % % %         yyaxis right
        % % %         temp1 = plot(spkWin, STA_POST, 'r');
        % % %         % uistack(temp1,'top');
        % % %
        % % %         % yyaxis left
        % % %         temp2 = plot(spkWin, STA_PRE, 'b-');
        % % %         % uistack(temp2,'top');
        % % %         xlim([spkWin(1), spkWin(end)]);
        % % %         ylabel([varName, '  before (blue) and after (red) pole up'])
        % % %         xlabel('STA spike at 0 (ms)')
        % % %         title(['whisking ' varName ' pole up modulation']);
        % % %
        % % %         set(gcf, 'Units', 'Normalized', 'OuterPosition', [1, 0, 1, 1]);
        % % %         saveLoc = ['C:\Users\maire\Documents\PLOTS\pole_up_Modulation\' varName '\'];
        % % %         mkdir(saveLoc)
        % % %         generalName = ['pole up mod ' varName] ;
        % % %         tmpName = ['U_IND_' num2str(cellStep)];
        % % %         filename =  [saveLoc, generalName, tmpName];
        % % %         saveas(gcf,filename,'png')
        % % %         savefig(filename)
        % % %
        
        
        
    end
    
    
    
end