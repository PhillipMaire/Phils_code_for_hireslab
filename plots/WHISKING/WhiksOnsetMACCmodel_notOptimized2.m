%% findingWhiskingOnset
% % % % % % % % % % % % % % % %     'thetaAtBase',
% % % % % % % % % % % % % % % %     'velocity',
% % % % % % % % % % % % % % % %     'amplitude',
% % % % % % % % % % % % % % % %     'setpoint',
% % % % % % % % % % % % % % % %     'phase',
% % % % % % % % % % % % % % % %     'deltaKappa',
% % % % % % % % % % % % % % % %     'M0Adj',
% % % % % % % % % % % % % % % %     'FaxialAdj',
% % % % % % % % % % % % % % % %     'firstTouchOnset',
% % % % % % % % % % % % % % % %     'firstTouchOffset',
% % % % % % % % % % % % % % % %     'firstTouchAll',
% % % % % % % % % % % % % % % %     'lateTouchOnset',
% % % % % % % % % % % % % % % %     'lateTouchOffset',
% % % % % % % % % % % % % % % %     'lateTouchAll',
% % % % % % % % % % % % % % % %     'PoleAvailable',
% % % % % % % % % % % % % % % %     'beamBreakTimes'}
% % % % % % % % % % % % % % % %


% so say if the amplitude ever crosses 4 or maybe 3.5 before pole onset then disgard that trial for this measurement
% can then use those trials to see if anything is different



%%
close all
meanTraceFig = figure(2);
hold on 

allTracesFig = figure (1);
hold on 

SP1 = 5;
SP2 = 9;


% SP1 = 1;
% SP2 = 1;
%%%
variableToPlot = 1;
shiftToZero = true;
%%%
counter =0 ;
for cellStep = 1:45
    counter = counter +1;
    figure(1);
tmpSP = subplot(SP1, SP2, counter);
theta = squeeze(U{cellStep}.S_ctk(variableToPlot,:,:));
% theta = diff(diff(diff(theta)));
%4000 by trials
numTrials = size(theta, 2);
poleOnsets = U{cellStep}.meta.poleOnset;
% add time before pole onset
addTimeBefore = 39;
timeAfterPoleOnset = 99;
xaxisNUMS = (1:(addTimeBefore+ timeAfterPoleOnset+1))- (addTimeBefore+1);
poleOnsets  =poleOnsets - addTimeBefore;

% loop through and get traces from poleonset to certain time

% timeAfterPoleOnset = timeAfterPoleOnset-1; %to make it an even 30
thetaTrimmed = [];%initialize
for k = 1:numTrials
    thetaTrimmed(:, k) = theta(poleOnsets(k):poleOnsets(k)+timeAfterPoleOnset+addTimeBefore, k);
    %shift to zero
    if shiftToZero
        thetaTrimmed(:, k) = -mean(thetaTrimmed(1:addTimeBefore, k)) + thetaTrimmed(:, k);
    end
    
end
%%% 


% % % %%% STD 
% % % thetaTrimmed = movstd(thetaTrimmed(:,:), 5);
% % % for k = 1:numTrials
% % % thetaTrimmed(:,k) = thetaTrimmed(:,k) - mean(thetaTrimmed(1:60, k));
% % % end

% numberOfPlots = 100;
% test2 = datasample(1:numTrials, numberOfPlots,'replace',false);
test2 = 1:numTrials;
hold on
yLIMS = -2:2;
figure
Traj = thetaTrimmed;
Ts = 1;
Dim = [ 30 30];
MinJerk = 0;
clear OnsetDetected MovementIntialJerk BestModel
[OnsetDetected,MovementIntialJerk,BestModel]=MACCInitV4(Traj,Ts,Dim, MinJerk);
% OnsetDetected = round(OnsetDetected.*1000);
for test =1:numTrials
    test;
    hold off
    plot(OnsetDetected(test), thetaTrimmed(OnsetDetected(test), test), 'r*');
    hold on
     plot(xaxisNUMS, thetaTrimmed(:,test))
     keyboard
    
end

yLimSave = [-20 20];
xlim(tmpSP, [-20 100]);
ylim(tmpSP, yLimSave);
%%%





%%% plot meaned variable 

figure(2)
tmpSP = subplot(SP1, SP2, counter);
hold on 

% test3 = sum(thetaTrimmed(:,:), 2);
% test3 = test3./numTrials;
test3 = nanmean(thetaTrimmed, 2);
plot(xaxisNUMS, test3)
% yLimSave = tmpSP.YLim;
xlim(tmpSP, [-20 100]);
ylim(tmpSP, yLimSave);




keyboard
end

addOnName = '_20Ylims_';
%%%

    figure(1)
    set(gcf,'units','normalized','outerpos',[1 0 1 1 ]);
directoryString = 'C:\Users\maire\Documents\PLOTS\S2\WHIKSER\whisker movements';
cd(directoryString);
dateString = datestr(now,'yymmdd_HHMMSS');
saveName = [directoryString, filesep, 'allWhiskerTheta',addOnName, dateString];
tic
saveas(gcf, [saveName, '.png'])
saveas(gcf, saveName)
toc

    figure(2)
    set(gcf,'units','normalized','outerpos',[1 0 1 1 ]);
directoryString = 'C:\Users\maire\Documents\PLOTS\S2\WHIKSER\whisker movements';
cd(directoryString);
dateString = datestr(now,'yymmdd_HHMMSS');
saveName = [directoryString, filesep, 'meanWhiskerTheta',addOnName, dateString];
tic
saveas(gcf, [saveName, '.png'])
saveas(gcf, saveName)
toc

%%





