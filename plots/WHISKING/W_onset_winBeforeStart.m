
%%





















































cellStep = 30;


%%
close all hidden
subplotMakerNumber = 1; subplotMaker
xPlotRange = -50:50;
transparentVal = .05;
for cellStep = 1: length(U)
    
    
    ampVar = squeeze(U{cellStep}.S_ctk(3, :, :));% blue
    velVar =squeeze(U{cellStep}.S_ctk(2, :, :))./100;%red
    thetaVar =      squeeze(U{cellStep}.S_ctk(1, :, :));%green
    poleOnsetsTMP = U{cellStep}.meta.poleOnset;
    
    
    
    % % % % % %     figure(10)
    
    % ampTheshOVERRIDE = 5; %can make so that all above this amp is considered whisking regardless
    ampThesh = 2.5;
    thetaThresh = 4;
    velThresh = 5;
    BLperiod = [-150:-50];
    lengthOfSignal = 250; %actual size
    signalStartAfterBLend = 0;%if BL end is -50 from pole onset and this is 0, then signal will start at -51 from pole
    stdThresh = 5;
    countTrialsWithNoOnset = 0;
    onsetShiftedTheta = [];
    actualOnsetALL = [];
    onsetDetectedTrials = ones([1, size( thetaVar,2)]);
    tmp = [];
    for trialNumber = 109:size( thetaVar,2)
        actualOnset = [];
        signalIndex = [];
        signalSTD = [];
        poleOnset = poleOnsetsTMP(trialNumber);
        xTOplot =(1:length(ampVar(:,trialNumber))) - poleOnset;
        % leave room for early onset whisking to not be bias
        baslineIND =BLperiod+poleOnset;
        
        velTOplot= velVar(:,trialNumber);
        thetaTOplot = thetaVar(:,trialNumber) - mean(thetaVar(baslineIND, trialNumber));
        ampTOplot= ampVar(:,trialNumber);
        
        % % % % % % % % % % % % % % % % % % % % % %         %     ampOnsetVals = ampTOplot(baslineIND(end)+signalStartAfterBLend+1:  ...
        % % % % % % % % % % % % % % % % % % % % % %         %                              baslineIND(end)+signalStartAfterBLend+lengthOfSignal);
        % % % % % % % % % % % % % % % % % % % % % %         %     ampOnsetVals2 = find(ampOnsetVals>=ampThesh);
        % % % % % % % % % % % % % % % % % % % % % %         %
        % % % % % % % % % % % % % % % % % % % % % %         %
        % % % % % % % % % % % % % % % % % % % % % %         %     thetaOnsetVals = thetaTOplot(baslineIND(end)+signalStartAfterBLend+1:  ...
        % % % % % % % % % % % % % % % % % % % % % %         %                                  baslineIND(end)+signalStartAfterBLend+lengthOfSignal);
        % % % % % % % % % % % % % % % % % % % % % %         %     thetaOnsetVals2 = find(thetaOnsetVals>=thetaThresh);
        close all
        figure; 
        plot(1:4000, velTOplot, 'b-')
        hold on 
        plot(1:4000, ampTOplot, 'r-')
        plot(1:4000, thetaTOplot, 'g-')
        
        
        ampOnsetVals2 = find(ampTOplot>=ampThesh);
        thetaOnsetVals2 = find(abs(thetaTOplot)>=thetaThresh);
        velOnsetVals2 = find(abs(velTOplot)>=velThresh);
        
        
        
        
        
        onsetIND = intersect(thetaOnsetVals2, ampOnsetVals2);
        onsetIND = onsetIND-poleOnset;% shift to pole onset time
        %     onsetIND = onsetIND +BLperiod(end)+1;
        
        startSignalInd = BLperiod(end)+signalStartAfterBLend +1;
        onsetINDinRange = intersect(onsetIND, (startSignalInd: ...
            BLperiod(end)+signalStartAfterBLend+lengthOfSignal));
        
        BL_STD = std(thetaTOplot(baslineIND));
        
        ampTOplot = smooth(ampTOplot, 100);
        ampThesh = 0.8
        test =  smooth(abs(velTOplot), 100);
        test2 = find(test> 0.85);
        test4 = find(ampTOplot<ampThesh);
        close all
        figure; 
        plot(1:4000, test, 'b-')
        hold on 
        plot(1:4000, ampTOplot, 'k-')
        plot(1:4000, thetaTOplot, 'g-')
        test3 = setdiff(1:4000, test2);
        plot(test3, thetaTOplot(test3)+2, 'r.')
         plot(test4, thetaTOplot(test4)-2, 'b.')
         test5 = unique([test4(:); test3(:)]);
         plot(test5, thetaTOplot(test5), 'k.');
         
%         plot(1:4000, zscore(velTOplot), 'y-')
%                 plot(1:4000-1, diff(velTOplot), 'r-')
% 
%         
%         test = abs(diff(velTOplot)).*abs(velTOplot(1:3999))
%         plot(1:4000-1, test, 'k-');
        
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [1, 0, .8, .8]);
        actualOnset = [];
        try
            signalIndex = (startSignalInd:onsetINDinRange(1))+poleOnset;
            signalVar = thetaTOplot(signalIndex);
            signalSTD = signalVar./BL_STD;
            actualOnset = find(signalSTD<stdThresh);
        catch
        end
        
        if numel(onsetINDinRange)==0 || onsetINDinRange(1)<=startSignalInd || isempty(actualOnset)
            onsetDetectedTrials(trialNumber) = 0; %for indexing which trials I can't find an onset
            onsetShiftedTheta(:,trialNumber) = nan(101,1);
            signalIndex = (startSignalInd:lengthOfSignal+BLperiod(end))+poleOnset;
            signalVar = thetaTOplot(signalIndex);
            signalSTD = signalVar./BL_STD;
            actualOnset =signalIndex(end);%no onset found so just plot the end not actually used
            countTrialsWithNoOnset = countTrialsWithNoOnset+1;
            actualOnsetALL(trialNumber) = nan;
            
            
            
            
            
            
            
            % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         figure(50)
            % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         hold off
            % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         %%%plotting section
            % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         plot(xTOplot, ampTOplot, 'b-')
            % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         hold on
            % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         plot(xTOplot, velTOplot, '-r');
            % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         plot(xTOplot, thetaTOplot, 'g-');
            % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         plot(onsetIND, thetaTOplot(onsetIND+poleOnset), 'k.')
            % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         plotONSET = plot(actualOnset-poleOnset, thetaTOplot(actualOnset), 'b*');
            % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         plotONSET.MarkerSize = 10;
            % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         plotONSET.LineWidth = 2;
            % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         plot(signalIndex-poleOnset ,signalSTD, 'y-')
            % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
            % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         poleUpLineRange = -40:40;
            % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         plot(ones(length(poleUpLineRange)).*0, poleUpLineRange, '-k')
            % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
            % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         grid;
            % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         ylim([-10 30]);
            % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         xlim([-200, 200]);
            % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         xticks(-50:10:200);
            % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
            % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         %         pause(0.2)
            % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         hold off
            % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         keyboard
        else
            
            actualOnset = actualOnset(end);
            actualOnset = signalIndex(actualOnset);
            onsetShiftedTheta(:,trialNumber)  = thetaTOplot(actualOnset-50 : actualOnset+50);
            
            actualOnsetALL(trialNumber) = actualOnset;
            
        end
        
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         %     figure(50)
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         %     hold off
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         %     %%%plotting section
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         %     plot(xTOplot, ampTOplot, 'b-')
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         %     hold on
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         %     plot(xTOplot, velTOplot, '-r');
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         %     plot(xTOplot, thetaTOplot, 'g-');
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         %     plot(onsetIND, thetaTOplot(onsetIND+poleOnset), 'k.')
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         %     plotONSET = plot(actualOnset-poleOnset, thetaTOplot(actualOnset), 'b*');
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         %     plotONSET.MarkerSize = 10;
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         %     plotONSET.LineWidth = 2;
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         %     plot(signalIndex-poleOnset ,signalSTD, 'y-')
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         %
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         %     poleUpLineRange = -40:40;
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         %     plot(ones(length(poleUpLineRange)).*0, poleUpLineRange, '-k')
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         %
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         %     grid;
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         %     ylim([-10 30]);
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         %     xlim([-50, 200]);
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         %     xticks(-50:10:200);
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         %     keyboard
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         %     %         pause(0.2)
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         %     hold off
    end
    U{cellStep}.whiskerOnset = actualOnsetALL;
    %% datasample(1:trialNumber, 10)
    % % % % % % % % % % % % % % % % % % % % % % % % %     figure(cellStep+20);
    subplotMakerNumber = 2; subplotMaker
    tmp = plot(xPlotRange, onsetShiftedTheta);
    for ChangeTheColor = 1:length(tmp)
        tmp(ChangeTheColor).Color = [tmp(ChangeTheColor).Color, transparentVal];
    end
    
    ylim([-20 20]);
    xlim([-40 40]);
    grid on
    disp(cellStep)
    
    %     countTrialsWithNoOnset
    % % % % % % % % % % % % % % % % % % % % % % % % %     set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, .8, .8]);
    % % % % % % % % % % % % % % % % % % % % % % % % %     saveas(gcf, [num2str(cellStep), '_aligned_to_Whisk_onset' ],'png')
    % % % % % % % % % % % % % % % % % % % % % % % % %     close all hidden
    
end
%%

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]);
% % % % % % % filename =  [num2str(cellStep), '_aligned_to_Whisk_onsetALLcolor2' ];
% % % % % % % saveas(gcf,filename,'png')
% % % % % % % savefig(filename)


%% plot the pole aligned whisk
close all hidden
subplotMakerNumber = 1; subplotMaker
shiftPlotForPoleUp = 50;% shift this cause whisking happens after pole up
for cellStep = 1:length(U)
    disp(cellStep)
    trialsToUse = ~isnan(U{cellStep}.whiskerOnset ); % to compare pole aligned and predicted whisking onset aligned
    % we need to use only the trials used in the whisking onset aligned set (cause some are disgarded
    thetaVar =      squeeze(U{cellStep}.S_ctk(1, :, :));%green
    poleOnsetsTMP = U{cellStep}.meta.poleOnset;
    poleOnsetsLinInds = poleOnsetsTMP +((1:length(poleOnsetsTMP))-1).* U{cellStep}.t;
    
    BLperiod = [-150:-50];
    signalPeriod = BLperiod(end) :lengthOfSignal +BLperiod(end);
    baselineLI = poleOnsetsLinInds+BLperiod';
    signalLI = poleOnsetsLinInds+signalPeriod';
    
    signalTheta = thetaVar(signalLI);
    BLTheta = nanmean(thetaVar(baselineLI),1);
    signalThetaZeroShifted = signalTheta-BLTheta;
    
    signalThetaZeroShifted = signalThetaZeroShifted(:, trialsToUse);
    subplotMakerNumber = 2; subplotMaker;
    numTrials = size(signalThetaZeroShifted, 2);
    tmp = plot(repmat(signalPeriod',[1, numTrials]), signalThetaZeroShifted);
    hold on 
    grid on
    ylim([-20 20]);
    xlim(([-40 40]+shiftPlotForPoleUp));
    for makeSeeThrough = 1:length(tmp)
   tmp(makeSeeThrough).Color = [tmp(makeSeeThrough).Color, transparentVal];
    end
end
%%
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]);
% % % filename =  [num2str(cellStep), '_aligned_to_pole_onsetALLcolor2' ];
% % % saveas(gcf,filename,'png')
% % % savefig(filename)