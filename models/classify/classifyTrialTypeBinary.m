%% C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\models\classify\classifyTrialTypeBinary

%% classifyTrialTypeBinary
U2 = U;
%% get the data
theseCells = 1:length(U2);
GLMdata = {};
for cellStep = theseCells
    cellTMP =  U2{cellStep};
    
    spks = squeeze(cellTMP.R_ntk);
    poleUP = cellTMP.meta.poleOnset;
    
    T_bl= -200:0;
    T_pole = 0:50;
    T_touch = 50:200;
    T_AftTouch = 300:600;
    T_lick = 800:1200;
    predMean = [];
    predCV = [];
    predSTD = [];
    timePoints ={T_bl, T_pole,T_touch ,T_AftTouch ,T_lick };
    for k = 1:length(timePoints)
        inds = timePoints{k}(:) + poleUP(:)';
        trials = (0:size(inds,2)-1)*4000;
        inds = inds+trials;
        spkTMP =spks(inds);
        resp = nanmean(spkTMP, 1);
        predMean(1:length(resp), k) = resp(:);
        CVtmp = std(spkTMP)./resp;
        CVtmp(isnan(CVtmp)) = 0;
        predCV(1:length(resp), k) = CVtmp;
        predSTD(1:length(resp), k) = std(spkTMP);
    end
    
    go = U2{cellStep}.meta.trialType==1;%all trials that are go
    nogo = U2{cellStep}.meta.trialType==0;%all trials that are nogo
    correct = U2{cellStep}.meta.trialCorrect==1;
    incorrect = U2{cellStep}.meta.trialCorrect==0;
    lick = (go.*correct)+(nogo.*incorrect);
    nolick =lick==0;
    hit = (go.*correct);
    corrRej=(nogo.*correct);
    falseAlarm = nogo.*incorrect;
    miss = go.*incorrect;
    
    trialTypes = [];
    trialTypes(1:length(resp), 1) =go(:);%1
    trialTypes(1:length(resp), end+1) = nogo(:);%2
    trialTypes(1:length(resp), end+1) = correct(:);%3
    trialTypes(1:length(resp), end+1) = incorrect(:);%4
    trialTypes(1:length(resp), end+1)= lick(:);%5
    trialTypes(1:length(resp), end+1)=nolick(:);%6
    trialTypes(1:length(resp), end+1) = hit(:);%7
    trialTypes(1:length(resp), end+1)=corrRej(:);%8
    trialTypes(1:length(resp), end+1)= falseAlarm(:);%9
    trialTypes(1:length(resp), end+1)=miss(:);%10
    
    GLMdata{cellStep}.trialTypes = trialTypes;
    GLMdata{cellStep}.predMean = predMean;
    GLMdata{cellStep}.predCV = predCV;
    GLMdata{cellStep}.predSTD = predSTD;
end
%%
close all
clc
%% get the models
binCLASS = 5;
theseXs = [ 4 5];
AOCthresh = 0.7; %aoc must be greater than this to number
% cellStep = 18% % % % % % % % for cellStep = 1:length(U)
allVars = {};
allAUC = [];
for cellStep = 1:length(U2)
    % CHOOSE X VARS TO USE
    Xs = GLMdata{cellStep}.predMean;
    Xs = Xs(:,theseXs);
    % CHOOSE Y VAR TO USE
    Yvar = GLMdata{cellStep}.trialTypes(:,binCLASS);
    % Yvar2 = [GLMdata{cellStep}.trialTypes(:,7),...
    %     GLMdata{cellStep}.trialTypes(:,8),...
    %     GLMdata{cellStep}.trialTypes(:,9),...
    %     GLMdata{cellStep}.trialTypes(:,10)];
    % [sortedT , indT ] = find(Yvar2);
    % [~, ind] = sort(sortedT);
    % Yvar2 = indT(ind);
    thisOne = Yvar;
    
    
    logitMods{cellStep} = fitglm(Xs,logical(thisOne),'Distribution','binomial','Link','logit');
    
    scores = logitMods{cellStep}.Fitted.Probability;
    [X,Y,T,AUC] = perfcurve(categorical(thisOne),scores,'1');
    allVars{cellStep}.X = X;
    allVars{cellStep}.Y = Y;
    allVars{cellStep}.T = T;
    allAUC(cellStep) = AUC;
    allVars{cellStep}.thisOne = thisOne;
    allVars{cellStep}.scores = scores;
    allVars{cellStep}.Xs = Xs;
    allVars{cellStep}.Yvar = Yvar;
    
    
end
%%%
 allAOC = allAUC;
figure, hist(allAOC, 20)


%%%
%% plot the models above threshold
[sorted inds] = sort(allAOC);
theseOnes = inds(sorted>AOCthresh);
% theseOnes = inds(end-2:end);
% close all
clc
allMCCvars = []
figure
iterationsForMCC = 1;
setThresh = linspace(0, 1, iterationsForMCC);
allAUC(theseOnes)
for kk = 1:iterationsForMCC
    %     disp(kk)
    counter = 0 ;
    for cellStep = theseOnes(:)'
%         tic
        counter = counter +1;
        %% MCC
        tmp = logitMods{cellStep};
        scores = tmp.Fitted.Probability;
        actual = tmp.Variables.y;
 
        predicted = scores>setThresh(kk);
        %
        C = confusionmat(double(actual(:)),double(predicted));
        TN = C(1, 1); % CR
        FP = C(1, 2) ; %FA
        FN = C(2, 1) ;% miss
        TP = C(2, 2);%% hit
        % %% MCC
        numerator = ((TP*TN) - (FP*FN));
        denom = sqrt((TP+FP)*(TP+FN)*(TN+FP)*(TN+FN));
        
        MCC = numerator./denom;
        
        allVars{cellStep}.MCC = MCC;
        allVars{cellStep}.Rsquared = tmp.Rsquared;
       
        allMCCvars(kk, counter) = MCC;
        tmp
        if kk==1
%             tmp
            mean(actual)
             tmp.Rsquared
            %     keyboard
            
            plot(allVars{cellStep}.X,allVars{cellStep}.Y)
            %             keyboard
            hold on
            xlabel('False positive rate')
            ylabel('True positive rate')
            title('ROC for Classification by Logistic Regression')
            
        end
%         toc
    end
    
end
%
figure, plot(repmat(setThresh(:), [1, size(allMCCvars, 2)]), allMCCvars)