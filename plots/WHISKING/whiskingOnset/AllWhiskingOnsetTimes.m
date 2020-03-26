%{


runTheseCells =1:length(U);
[OnsetsALL_CELLS] = AllWhiskingOnsetTimes(U, runTheseCells)


%}
function [OnsetsALL_CELLS] = AllWhiskingOnsetTimes(U, runTheseCells)



%% 181025 this is mostly wrking just have to do 2 things
%% 1) find a way to not get the random not really whisking onset things in here
%% 2) remove tracs that never make it above a certain amp or sd or something
%% think these are both taken care of
totalCount = [];
badCells = {};
%%
OnsetsALL_CELLS = {};
% close all hidden
subplotMakerNumber = 1; subplotMaker
set(gcf, 'Units', 'Normalized', 'OuterPosition', [1, 0, 1, 1]);
% xPlotRange = -50:50;
% transparentVal = .05;

PLOT_TRACES_SWITCH = true;
preWindowMin = 200; % min time of whisker being still using the user setting that is considered
% when looking through the whisking for still periods.
postWindowMin = 300;
smoothBy = 1; % for the amp not moving whisker point ( leave at 10)
ampThreshSmall = 2.5;% find values smaller than this. these are valid
ampThreshLarge = 15; %have to have a whisk at least this big in the 'signal' time (after still period) 
for cellStep = runTheseCells
    %     try
    cellTMP = U{cellStep};
    disp(num2str(cellStep))
    ampVar = squeeze(U{cellStep}.S_ctk(3, :, :));
    velVar =squeeze(U{cellStep}.S_ctk(2, :, :));
    thetaVar =      squeeze(U{cellStep}.S_ctk(1, :, :));
    
    ampVar(end, :) = nan;
    ampVarSmoothed = smooth(ampVar, smoothBy, 'moving');
    ampVarSmoothed = reshape(ampVarSmoothed, size(ampVar));
    ampVarSmoothed(end, :) = nan;
    
    %     thetaVar(end, :) = nan;
    thetaVarMeanBL = mean(thetaVar(1:300, :), 1);
    thetaVarSubtractBL = thetaVar-thetaVarMeanBL;
    thetaVarSubtractBL = smooth(thetaVarSubtractBL, smoothBy, 'moving');
    thetaVarSubtractBL = reshape(thetaVarSubtractBL, size(thetaVar));
    %     thetaVarSubtractBL(end, :) = nan;
    
    %     ampVarSmoothed(find(isnan(ampVarSmoothed))) = 9999999999;
    ampStillWhisker = find(ampVarSmoothed<=ampThreshSmall);
    test = ampVarSmoothed(ampStillWhisker);
    %     ampStillWhisker2 = find(~isnan(ampVarSmoothed));
    ampStillWhisker2 = ampStillWhisker;
    ampStillWhisker2(end, :) = nan;
    % find all the segments and trial numbers
    [segmentsTMP] = findInRow(ampStillWhisker2, cellTMP.t);%custom program by phil
    % now remove the segments that dont meet our length criteria
    segmentsFinal = segmentsTMP(find(segmentsTMP(:,3)>preWindowMin), :);
    % below corresponds to segmentsFinal
    % start    end     length   trialNumber  start    end  (where the last ones or NOT lin inds but for each trial)
    
    
    %% now remove trials where the still period is too late in the trial
    removeTooLarge = find(segmentsFinal(:, 6)+postWindowMin < cellTMP.t);
    segmentsFinal = segmentsFinal(removeTooLarge, :);
    %% ampMov and thetaMov = packaged
    ampMov = [];
    thetaMov = [];
    removeTrialsWithNans = ones(size(segmentsFinal, 1),1);
    
    lengthAmmpArray = postWindowMin+preWindowMin+1;
    segmentsFinal(:,7) = preWindowMin;
    segmentsFinal(:,8) = lengthAmmpArray - preWindowMin;
    segmentsFinal(:,9) = lengthAmmpArray;
    for k = 1:size(segmentsFinal, 1)
        
        lengthArray = segmentsFinal(k, 3);
        trialTMP = segmentsFinal(k, 4);
        ampTMP = ampVar(:, trialTMP);
        thetaTMP = thetaVar(:, trialTMP);
        
        indsToWhisk = segmentsFinal(k, 5) :  segmentsFinal(k, 6)+postWindowMin;
        ampTMP =  ampTMP(indsToWhisk);
        thetaTMP =  thetaTMP(indsToWhisk);
        cutItDownInds = lengthArray-preWindowMin: lengthArray+postWindowMin;
        
        ampMov(1:lengthAmmpArray, k) = ampTMP(cutItDownInds);
        thetaMov(1:lengthAmmpArray, k) = thetaTMP(cutItDownInds);
        % % % % % % % % % % % % % % % %         %                 plot(((1:length(ampTMP)) - segmentsFinal(k, 3)), ampTMP)
        % % % % % % % % % % % % % % % %         %                 hold on
        % % % % % % % % % % % % % % % %         %                 tmp = ylim;
        % % % % % % % % % % % % % % % %         %                 plot([0 0], tmp, '-r')
        % % % % % % % % % % % % % % % %         %                 hold off
        % % % % % % % % % % % % % % % %         %
        if isnan(mean(ampTMP)*mean(thetaTMP))
            removeTrialsWithNans(k) = 0;
        end
    end
    %% remove bad traces
    segmentsFinal= segmentsFinal(find(removeTrialsWithNans), :);
    ampMov = ampMov(:, find(removeTrialsWithNans));
    thetaMov = thetaMov(:, find(removeTrialsWithNans));
    %% get the whisks with a big whisk after small whisk
    
    
    tmp = size(ampMov,1);
    maxAmpSignal = max(ampMov(tmp-postWindowMin:tmp, :));
    indsForWhiskInSignal = find(maxAmpSignal>=ampThreshLarge);
    ampMov = ampMov(:, indsForWhiskInSignal);
    thetaMov = thetaMov(:, indsForWhiskInSignal);
    segmentsFinal=  segmentsFinal(indsForWhiskInSignal, :);
    ampMovAll{cellStep} = ampMov;
    thetaMovAll{cellStep} = thetaMov;
    segmentsFinalALL{cellStep} = segmentsFinal;
    
    
    %% ok so basically done
    % now w havt the traces and we just need to take the STD of the basline
    % period
    %     ampThresh3 =0;% 0 means not on
    thetaThresh2 = -999999;
    % % % % % %     SD_thresh = 15; % based on the BL SD if the trace have points beyond this
    % % % % % %     % times the BL SD then we will say whisking onset exists somewhere in the trace
    % % % % % %     % if not then it must not.
    % % % % %     maxBL_SDthresh = 1.5; %if BL has a thresh of more than this we will not look for onset. \
    % % % % %     % large number means this is disabled
    smoothSDtheta  = 25 ; % leave this at
    onsetThresh = 2; % leave this at 0.8 threshhold for
    %%
    
    
    %%
    whiskingONSETall = [];
    for k = 1:size(segmentsFinal, 1)
        
        ampTMP = ampMov(:, k);%using amp now
        thetaTMP = thetaMov(:, k);
        
        
        ampBL_tmp = ampTMP(1:preWindowMin-100);%## basline period from
        % start to the 100 ms before the end of the still whisker
        mean_BLamp = nanmean(ampBL_tmp);
        ampTMP = ampTMP-mean_BLamp;
        SD_BLamp = nanstd(ampBL_tmp);
        %         limsVar = SD_thresh.*SD_BL;
        ampZscoredToBL = (ampTMP./SD_BLamp);
        
        
        thetaBL_tmp = thetaTMP(1:preWindowMin);%## basline period from
        % start to the 100 ms before the end of the still whisker
        mean_BLtheta = nanmean(thetaBL_tmp);
        thetaTMP = thetaTMP-mean_BLtheta;
        SD_BLtheta = nanstd(thetaBL_tmp);
        %         limsVar = SD_thresh.*SD_BL;
        thetaZscoredToBL = abs(thetaTMP./SD_BLtheta);
        
        movThetaSD = movstd(thetaTMP, smoothSDtheta);
        
        
        
        %%
        % look 50 ms before
        lookTimeBefore = 50;
        whiskingONSETthetaSTD = find(movThetaSD(preWindowMin-lookTimeBefore:end)>=onsetThresh)+preWindowMin-lookTimeBefore;
        %         whiskingONSETtheta = find(abs(ampTMP(preWindowMin-lookTimeBefore:end))>=ampThresh3)+preWindowMin-lookTimeBefore;
        %         whiskingONSET = intersect(whiskingONSETthetaSTD, whiskingONSETtheta);
        %         whiskingONSET = whiskingONSET(1);
        if ~isempty(whiskingONSETthetaSTD)
            whiskingONSET = whiskingONSETthetaSTD(1);
        else
            whiskingONSET = nan;
        end
        
        whiskingONSETall(k) = whiskingONSET;
    end
    %%
    indTMP = ~isnan(whiskingONSETall);
    whiskingONSETall = whiskingONSETall(indTMP);
    segmentsFinal = segmentsFinal(indTMP, :);
    %%
    
    %     totalCount(end+1) = k;
    S = segmentsFinal;
    trialTimeIndexTRACE = (S(:,6)-S(:,7));
    trialTimeIndexTRACE = trialTimeIndexTRACE(:) + repmat((0:S(:,9)-1), [ length(whiskingONSETall),1]);
    
    linIndsTRACE = (S(:,2)-S(:,7));
    linIndsTRACE = linIndsTRACE(:) + repmat((0:S(:,9)-1), [ length(whiskingONSETall),1]);
    
    
    
    
    linIndsONSETS = [];
    trialTimeONSETS = [];
    for k = 1:length(whiskingONSETall)
        linIndsONSETS(k) = linIndsTRACE(k,whiskingONSETall(k));
        trialTimeONSETS(k)= trialTimeIndexTRACE(k,whiskingONSETall(k));
    end
    
    %%
    OnsetsALL_CELLS{cellStep}.linIndsONSETS = linIndsONSETS(:);
    OnsetsALL_CELLS{cellStep}.trialTimeONSETS = trialTimeONSETS(:);
    OnsetsALL_CELLS{cellStep}.trialNums = S(:,4);
    OnsetsALL_CELLS{cellStep}.segmentsFinal = segmentsFinal;
    U{cellStep}.WhiskerOnsetsALL = OnsetsALL_CELLS;
    %     keyboard
    % %%
    % tmp = 1:3
    % tmp = tmp'
    %
    % tmp2 = 1:
    % (1:2)'+ (4:5)
    %%
    %     figure
    %     plot(thetaSD_ALL)
    %%
    
    %     catch
    %        badCells{end+1} = cellStep;
    % %        keyboard
    % %        find(isnan(nanmean(thetaVar)))
    %     end
end
%%

% cd('C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\plots\SPIKES\MAIN_PLOTS\DATA_TO_LOAD')
%
% save('OnsetsALL_CELLS', 'OnsetsALL_CELLS')


%%
if PLOT_TRACES_SWITCH
    transparentVal = .1;
    plotRange = -200:200;
    sigStart = find(plotRange==0)
    BL = (-20:0)+sigStart;
    for cellStep = runTheseCells
        disp(num2str(cellStep))
        thetaVar = squeeze(U{cellStep}.S_ctk(1, :, :));
        cellTMP = U{cellStep};
        onsetTMP = OnsetsALL_CELLS{cellStep};
        lins = onsetTMP.linIndsONSETS;
        linTrace = (plotRange)' + lins(:)';
        linTrace(linTrace>numel(thetaVar)) =numel(thetaVar);
        thetaToPlot = thetaVar(linTrace);
        BLtheta = mean(thetaToPlot(BL, :), 1);
        thetaToPlot = thetaToPlot - BLtheta;
        subplotMakerNumber = 2; subplotMaker
        %     figure
        tmp = plot(plotRange, thetaToPlot, 'LineWidth', 1);
        xlim([-50 100])
        hold on
        axis tight
        %    tmp.LineWidth = 2
        
        for makeSeeThrough = 1:length(tmp)
            tmp(makeSeeThrough).Color = [tmp(makeSeeThrough).Color, transparentVal];
        end
        
        plot([0 0], ylim, 'r-')
        %    keyboard
        
    end
end
%               close all













