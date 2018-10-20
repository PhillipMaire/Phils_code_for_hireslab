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
figure
hold on
%%
close all
variableToPlot = 1;
shiftToZero = true;
%
cellStep = 1;
theta = squeeze(U{cellStep}.S_ctk(variableToPlot,:,:));
% theta = diff(diff(diff(theta)));
%4000 by trials
numTrials = size(theta, 2);
poleOnsets = U{cellStep}.meta.poleOnset;
% add time before pole onset
addTimeBefore = 49;
poleOnsets  =poleOnsets - addTimeBefore;

% loop through and get traces from poleonset to certain time
timeAfterPoleOnset = 99;
% timeAfterPoleOnset = timeAfterPoleOnset-1; %to make it an even 30
thetaTrimmed = [];%initialize
for k = 1:numTrials
    thetaTrimmed(:, k) = theta(poleOnsets(k):poleOnsets(k)+timeAfterPoleOnset+addTimeBefore, k);
    %shift to zero
    if shiftToZero
        thetaTrimmed(:, k) = -mean(thetaTrimmed(1:addTimeBefore, k)) +thetaTrimmed(:, k);
    end
end
%%%


thetaTrimmed = thetaTrimmed(:, :);
% thetaTrimmed = movstd(thetaTrimmed(:,:), 5);
%%%
figure
numberOfPlots = 100;
test2 = datasample(1:numTrials, numberOfPlots,'replace',false);
test2 = 80:85;
hold on
yLIMS = -30:30;
plot(repmat(addTimeBefore+1,length(yLIMS),1),yLIMS );



%%%



Traj = thetaTrimmed;
Ts = 1;
Dim = [ 30 30];
MinJerk = 0;
clear OnsetDetected MovementIntialJerk BestModel
[OnsetDetected,MovementIntialJerk,BestModel] = MACCInitV4(Traj,Ts,Dim, MinJerk);
%%%
% OnsetDetected = OnsetDetected.*1000;

% % % for test =test2
% % %     test;
% % %     hold on
% % %     plot(OnsetDetected(test), thetaTrimmed(OnsetDetected(test), test), 'r*');
% % %     keyboard
% % % end


% plot some whisker traces
for test =test2
    test;
    hold on
    plot(thetaTrimmed(:,test));
    plot(OnsetDetected(test), thetaTrimmed(OnsetDetected(test), test), 'r*');
    keyboard
end

% plot the detected onsets based on MACC model
for test =1:numTrials
    test;
    hold on
    plot(OnsetDetected(test), thetaTrimmed(OnsetDetected(test), test), 'r*');
end





