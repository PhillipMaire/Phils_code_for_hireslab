%%
%
Lans =   V.lick_answerlickVARS.allLicksCell;
L1 =     V.lick_firstlickVARS.allLicksCell;
L1and2 = V.lick_first2licksVARS.allLicksCell;
Lall =   V.lick_alllicksVARS.allLicksCell;

Tpro = V.redretblueproaxistightVAR.allTouchPro;
Tret = V.redretblueproaxistightVAR.allTouchRet;

Pup = V.poleUPVARS.allpolesCell;
Pdown = V.poleDownVARS.allpolesCell;

sigVal = 0.1;

smoothOrigSig = 0; % this doesnt work cause edge effects make things look weird
saveONFig = 1 ;
saveONVar = 0;
saveLoc = ['C:\Users\maire\Documents\PLOTS\sigTest6_color\'];

indexTime = -100:200;
eventTime = find(indexTime == 0);
beforeEventBL =30;
subtractBaslineToSig = 50;

winSize = 5;
%%
varNameCell = {'Tpro' 'Tret' 'Pup' 'Pdown' 'Lall' 'Lans'};
colorCell = {'Blues' 'Reds' 'Purples' 'Oranges' 'Greens' 'Greens' };
for NumVars =1:6
    % close all
    varNameSingle = varNameCell{NumVars};
    varToUse = eval(varNameSingle);
    
    subplotMakerNumber = 1;  subplotMaker;
    cellsToPlot = 1:length(varToUse);
    %     cellsToPlot = [4 12 1 8 24 10];
    
    %     cellsToPlot = [10];
    for cellStep = cellsToPlot
      
        disp(num2str(cellStep))
        
        
        smoothBy = 5;
        tmp2 = varToUse{cellStep};
        if smoothOrigSig ==1
            for SGiter = 1:size(tmp2,1)
                tmp2(SGiter, :) = smooth(tmp2(SGiter, :) , smoothBy );
            end
        end
        
        
        
        BLindex = 1:eventTime-beforeEventBL;
        signalIndex = eventTime- subtractBaslineToSig:length(indexTime);
        baseline = tmp2(:, BLindex);
        signal = tmp2(:,  signalIndex);
        baseline2 = nanmean(baseline, 2);
        signal2 = nanmean(signal,2);
        
        %%
        removeNans = find(~isnan(baseline2.*signal2));
        baseline = baseline(removeNans, :);
        signal = signal(removeNans, :);
        signalChunck = [];
        baselineChunk = [];
        %% other way so you are comparing average time chuncks
        %         for ksmooth = 1:size(signal, 2)-winSize
        %             signalChunck(1:winSize,ksmooth) = nanmean(signal(:,ksmooth:ksmooth+winSize -1),1);
        %         end
        %
        %         for ksmooth = 1:size(baseline, 2)-winSize
        %             baselineChunk(1:winSize,ksmooth) = nanmean(baseline(:,ksmooth:ksmooth+winSize -1),1);
        %         end
        %% noraml way averaging so we have same number of trials
        for ksmooth = 1:size(signal, 2)-winSize
            signalChunck(1:size(signal, 1),ksmooth) = nanmean(signal(:,ksmooth:ksmooth+winSize -1),2);
        end
        
        for ksmooth = 1:size(baseline, 2)-winSize
            baselineChunk(1:size(baseline, 1),ksmooth) = nanmean(baseline(:,ksmooth:ksmooth+winSize -1),2);
        end
        %%
        
        TtestMat = nan(size(baselineChunk, 2), size(signalChunck,2));
        for k = 1:size(signalChunck, 2)
            for kk = 1:size(baselineChunk,2)
                [~, tmpP ]= ttest(signalChunck(:,k), baselineChunk(:,kk));
                TtestMat(kk,k) = tmpP;
            end
        end
        
        %%%
        % figure;
        % hist(reshape(TtestMat, [numel(TtestMat), 1]))
        PsigTime = nanmedian(TtestMat, 1);
        %         Ptime = nanmean(TtestMat, 1);
        %         Ptime(1:winSize-1) = 1 ;
        %         Ptime(end-winSize+1:end) = 1 ;
        
        %     hist(Ptime, 1000)
        timeSig = find(PsigTime<sigVal);
        
        %%%
        
        %     figure
        subplotMakerNumber = 2;  subplotMaker;
        
        % BLindex
        % signalIndex
        % beforeEventBL
        
        traceToPlot = nanmean(tmp2);
        traceToPlot = smooth(traceToPlot, 1);
        
        tracePlot = plot(indexTime,traceToPlot, 'k');
        
        colorMapThing = nan(size(indexTime));
        colorMapThing(BLindex) = .3; %make the basline black or pure one color
        BLindex2 = BLindex(end) +1 : BLindex(end) +beforeEventBL -1;
        colorMapThing(BLindex2) = 0.1; %make extra part of baseline not used another color
        signalDefaultVal = 0.1;
        colorMapThing(signalIndex) = signalDefaultVal; %make all of signal this color unles changed later
        foundSig = repmat(timeSig, [winSize, 1]);
        timFoundSigAdd = repmat((0:winSize -1)', [1, length(timeSig)]);
        sigSegmentTmp = foundSig + timFoundSigAdd;
        sigSegmentTmp = signalIndex(sigSegmentTmp);%this is based on the signal portion
        sigSegmentTmp = reshape(sigSegmentTmp, [winSize , length(timeSig)]); % make sure it is vertical
        addValue = (1 - signalDefaultVal)./winSize;
        if ~isempty(sigSegmentTmp)
            for k = 1:winSize
                colorMapThing(sigSegmentTmp(k,:)) =  colorMapThing(sigSegmentTmp(k,:))  +addValue;
            end
        end
        %%
        x = indexTime;
        y = traceToPlot';
        z = zeros(size(x));
        colorMapThing(1) = 1;
        colorMapThing(2) = 0;%so that the scale is correct
        col = colorMapThing;  % This is the color, vary with x in this case.
        %         figure
       
         surface([x;x],[y;y],[z;z],[col;col],...
            'facecol','no',...
            'edgecol','interp',...
            'linew',1, 'FaceAlpha',0.5);
        brewCol =   brewermap(100, colorCell{NumVars});
        brewCol2 = brewCol(10:75, :);
        colormap(brewCol2)
        xlim([indexTime(1),  indexTime(end)]);
        %         ylim =
        allTraces{cellStep} = [x;y;z;col];
        colorMapCell{cellStep, 1} = brewCol;
        colorMapCell{cellStep, 2} = brewCol2;
        PsigTimeAll{cellStep} = PsigTime;
%         signalIndex
    end
    
    %%
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [1, 0, 1, 1]);
    if saveONFig
        
        
        generalName = ['medianPval_' varNameSingle] ;
        mkdir(saveLoc)
        save([saveLoc, generalName, '_plotVars'], 'allTraces', 'colorMapCell', 'PsigTimeAll', 'signalIndex')
        % see C:\Users\maire\Documents\GitHub\Phils_code_for_hireslab\plots\SPIKES\all_L_T_P\
        % to use these saved variables 
        % varNameSingle
        %%
        % save([saveLoc, generalName, 'VAR'], 'allTouchRet', 'allTouchPro', 'toPlotRet', 'toPlotPro')
        if  saveONVar
            save([saveLoc, generalName, '_VAR'], '-regexp', '^(?!(V|U|cellTMP)$).')
        end
        %         set(gcf, 'Units', 'Normalized', 'OuterPosition', [1, 0, 1, 1]);
        
        filename =  [saveLoc, generalName];
        saveas(gcf,filename,'png')
        savefig(filename)
    end
    
end


