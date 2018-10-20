%% whisking modulation before and after pole up
% % % tic
% % % [touchBLock2]  =  superEventMakerINDEXover4000dontELIMINATE(U, '.S_ctk(9,:,:)', 100, -50);
% % % toc
%%
set(0,'defaultAxesFontSize',20)
% for varNumber = [1 2 3 4 5 6]

binslinSWITCH = true;
% userSetBinsWhenSWITCHisOff = logspace(0, log10(20), 50);% for amp
% userSetBinsWhenSWITCHisOff = logspace(log10(-50), log10(50), 80);% for theta
userSetBinsWhenSWITCHisOff = linspace(-50, 50, 20);% for theta

for varNumber = [3 1 2 4 5 6]
    % varNumber = 5;
    varName = U{1}.varNames{varNumber}
    saveLoc = ['C:\Users\maire\Documents\PLOTS\pole_up_ModulationHEAT_BINSLIN_correctTouch\' varName '\'];
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

        %% create a mask for before pole up, after pole up and response region right after pole up
        poleUp = cellTMP.meta.poleOnset;
        beforePoleUpMask = zeros(size(theta));
        TimAfterPoleUpMask = 400;% ms after pole up to remove for all trials
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
        
        timeWindow = -50:50;
        userSetNumberBins = 40;
        SPKperBinSELECTED = nan(length(timeWindow), userSetNumberBins);
        normalizeBySELECT =SPKperBinSELECTED;
        
        for numberOfSubSelected = 1:2 % post and pre
            if numberOfSubSelected == 1
                %put the bin selection here so that the bins would be the same for each otherwise you
                % can't compare teh two so only the first one has the equal bins (the post poleup)
                thetaSELECT = thetaPOST;
                thetaSELECTEDlinear = reshape(thetaSELECT, [numel(thetaSELECT) 1]);
                thetaSELECTEDlinear = thetaSELECTEDlinear(~isnan(thetaSELECTEDlinear));
                [jjjjjjj kkkkkkkk] = binslin(thetaSELECTEDlinear, thetaSELECTEDlinear, 'equalN', userSetNumberBins);
                for binsK = 1:length(jjjjjjj)
                    test50(binsK, 1:2) = [min(jjjjjjj{binsK}) max(jjjjjjj{binsK}(end))]  ;
                end
                binsForVar = test50(:,1);
                binsForVar(end+1) = test50(end);
                if binslinSWITCH == false
                    binsForVar = userSetBinsWhenSWITCHisOff;
                end
            elseif numberOfSubSelected == 2
                thetaSELECT = thetaPRE ;
            else
                error('error')
            end
            
            
            
            for k = 1:length(binsForVar) - 1
                % make mask for just certain range of variable
                inThisRange = (thetaSELECT >= binsForVar(k)).*(thetaSELECT <binsForVar(k+1));
                % find number of variables that exist in that array to normalize
                % this will be the same for all time grabed becasue the same number
                % of that variabel in that range still exists we are jsut looking
                % for spike around that are
                normalizeBySELECT(1:length(timeWindow), k) = repmat(sum(sum(inThisRange)), [length(timeWindow) , 1]);
                % find the time points of the variables in the selected range
                % and add timepoints for periods before and after
                allTimeIndexForThisBin = find(inThisRange)+timeWindow;
                for timeWinK = 1:length(timeWindow)
                    grabSpikeIndex = allTimeIndexForThisBin(:,timeWinK);
                    % get the spikes from those time points that match the range
                    if ~isempty(grabSpikeIndex )
                        removeFromTest20index = [find(grabSpikeIndex<1), find(isnan(grabSpikeIndex)), find(grabSpikeIndex>numel(spikes))];
                        if ~isempty(removeFromTest20index )
                            keepMat = ones(size(grabSpikeIndex));
                            keepMat(removeFromTest20index) = 0;
                            grabSpikeIndex = grabSpikeIndex(logical(keepMat));
                        end
                        resultingSpikes = spikes(grabSpikeIndex);
                    else
                        resultingSpikes = nan;
                    end
                    SPKperBinSELECTED(timeWinK, k) = length(find(resultingSpikes==1));
                end
            end
            
            
            %             figure(numberOfSubSelected)
            trimmedImage = SPKperBinSELECTED./normalizeBySELECT;
            trimmedImage = trimmedImage.*1000;%spk per sec
            %             trimmedImage2 = trimmedImage(:,1:25);
            if numberOfSubSelected == 1
                % make the array
                bothNormSpikesMat = trimmedImage;
            else
                bothNormSpikesMat(:,:,end+1) = trimmedImage;
            end
            %             imagesc(trimmedImage')
            %             colorbar
        end
        
        % a 1 on the third dimention cause the first one
        % is post pole up and that has a lot of samples
        % so it will have a readable max
        scaleMax = max(max(max(  bothNormSpikesMat(:, 1:end-1, 1)  )));
        scaleMin = min(min(min(  bothNormSpikesMat(:, 1:end-1, :)  )));
        scaleMin = 0; %spike so min should be 0
        bothNormSpikesMat(bothNormSpikesMat>scaleMax) = scaleMax;
        %                 test99(test99<scaleMin) = scaleMin;
        bothNormSpikesMat (1, 1, :) = scaleMin;
        bothNormSpikesMat (1, 2, :) = scaleMax;
        
        projCellNum = cellTMP.details.projectDetails.cellNumberForProject;
        titleGeneral = [varName, ' tuning       U ind ', num2str(cellStep), '   cellNum ',projCellNum];
        xLabelGeneral = ['time from binned ', varName , ' (ms)'];
       
        mkdir(saveLoc)
        
        
        close all
        figure(1)
        imagesc(bothNormSpikesMat(:,:,1)')
        tmpBar = colorbar;
        ylabel(tmpBar, 'spk/sec')
        axisTMP = gca;
        binsForVar2 = round(binsForVar,2);
        axisTMP.YTickLabel = binsForVar2;
        axisTMP.YTick = 1:length(binsForVar2);
        
        
        axisTMP.XTick = (1:10:length(timeWindow));
        axisTMP.XTickLabel =  axisTMP.XTick - ceil(length(timeWindow)./2) ;
        ylabel(varName);
        xlabel(xLabelGeneral);
        title(['After Pole Up ', titleGeneral]);
        
        
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [1, 0, 1, 1]);
        generalName = ['Cell ', projCellNum,  ' Index ', num2str(cellStep) ,' After pole up mod ', varName] ;
        filename =  [saveLoc, generalName];
        saveas(gcf,filename,'png')
        savefig(filename)
        
        close all
        
        
        figure(2)
        imagesc(bothNormSpikesMat(:,:,2)')
        tmpBar = colorbar;
        ylabel(tmpBar, 'spk/sec')
        axisTMP = gca;
        binsForVar2 = round(binsForVar,2);
        axisTMP.YTickLabel = binsForVar2;
        axisTMP.YTick = 1:length(binsForVar2);
        
        axisTMP.XTick = (1:10:length(timeWindow));
        axisTMP.XTickLabel =  axisTMP.XTick - ceil(length(timeWindow)./2) ;
        ylabel(varName);
        xlabel(xLabelGeneral);
        title(['Before Pole Up ', titleGeneral]);
        
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [1, 0, 1, 1]);
        generalName = ['Cell ', projCellNum,  ' Index ', num2str(cellStep) ,' Before pole up mod ', varName] ;
        filename =  [saveLoc, generalName];
        saveas(gcf,filename,'png')
        savefig(filename)
        
        
        close all
        
        
        
    end
    
    
    
end