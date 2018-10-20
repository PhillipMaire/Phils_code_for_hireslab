%%


cellStep = 1;
ampVar = squeeze(U{cellStep}.S_ctk(3, :, :));% blue
velVar =squeeze(U{cellStep}.S_ctk(2, :, :))./100;%red
thetaVar =      squeeze(U{cellStep}.S_ctk(1, :, :));%green





%%
% close all
figure(10)
startTrial = 1;
ampThesh = 2.5;
thetaThresh = 4;
BLperiod = [-150:-50];
lengthOfSignal = 250; %actual size
signalStartAfterBLend = 0;%if BL end is -50 from pole onset and this is 0, then signal will start at -51 from pole
stdThresh = 5;
testVar = [];
for trialNumber = startTrial:size( thetaVar,2)
    poleOnset = poleOnsetsTMP(trialNumber);
    xTOplot =(1:length(ampVar(:,trialNumber))) - poleOnset;
    % leave room for early onset whisking to not be bias
    baslineIND =BLperiod+poleOnset;
    
    
    velTOplot= velVar(:,trialNumber) - mean(velVar(baslineIND, trialNumber));
    thetaTOplot = thetaVar(:,trialNumber) - mean(thetaVar(baslineIND, trialNumber));
    ampTOplot= ampVar(:,trialNumber);
    
    
    %     ampOnsetVals = ampTOplot(baslineIND(end)+signalStartAfterBLend+1:  ...
    %                              baslineIND(end)+signalStartAfterBLend+lengthOfSignal);
    %     ampOnsetVals2 = find(ampOnsetVals>=ampThesh);
    %
    %
    %     thetaOnsetVals = thetaTOplot(baslineIND(end)+signalStartAfterBLend+1:  ...
    %                                  baslineIND(end)+signalStartAfterBLend+lengthOfSignal);
    %     thetaOnsetVals2 = find(thetaOnsetVals>=thetaThresh);
    
    ampOnsetVals2 = find(ampTOplot>=ampThesh);
    thetaOnsetVals2 = find(abs(thetaTOplot)>=thetaThresh);
    
    
    onsetIND = intersect(thetaOnsetVals2, ampOnsetVals2);
    onsetIND = onsetIND-poleOnset;% shift to pole onset time
    %     onsetIND = onsetIND +BLperiod(end)+1;
    
    
    onsetINDinRange = intersect(onsetIND, (BLperiod+signalStartAfterBLend +1: ...
        BLperiod+signalStartAfterBLend+lengthOfSignal));
    
    if numel(onsetINDinRange)==0 || onsetINDinRange(1)<=BLperiod(end)
        testVar(:,trialNumber) = nan(101,1);
    else
        BL_STD = std(thetaTOplot(baslineIND));
        signalIndex = (BLperiod(end)+1+signalStartAfterBLend:onsetINDinRange(1))+poleOnset;
        signalVar = thetaTOplot(signalIndex);
        %     sigFlipped = flip(signalVar);
        
        
        signalSTD = signalVar./BL_STD;
        actualOnset = find(signalSTD<stdThresh);
        
        
        actualOnset = actualOnset(end);
        actualOnset = signalIndex(actualOnset);
        
        testVar(:,trialNumber)  = thetaTOplot(actualOnset-50 : actualOnset+50);
    end
    
    
    
    
    
    
%     
%     
%         %%%plotting section
%         plot(xTOplot, ampTOplot, 'b-')
%         hold on
%         plot(xTOplot, velTOplot, '-r');
%         plot(xTOplot, thetaTOplot, 'g-');
%         plot(onsetIND, thetaTOplot(onsetIND+poleOnset), 'k.')
%         plot(actualOnset-poleOnset, thetaTOplot(actualOnset), 'r*')
%         plot(signalIndex-poleOnset ,signalSTD, 'y-')
%     
%     
%         poleUpLineRange = -40:40;
%         plot(ones(length(poleUpLineRange)).*0, poleUpLineRange, '-k')
%     
%     
%         ylim([-10 30]);
%         xlim([-50, 200]);
%         xticks(-50:10:200);
%         grid;
%         keyboard
%         %         pause(0.2)
%         hold off
end
%%
figure(20);plot(-50:50, testVar(:, datasample(1:trialNumber, 10)))

% for k = 1:size(testVar