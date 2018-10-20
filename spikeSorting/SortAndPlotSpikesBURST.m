%% SortAndPlotSpikesBURST
%% SortAndPlotSpikesBURST
%% SortAndPlotSpikesBURST
%% SortAndPlotSpikesBURST
%% SortAndPlotSpikesBURST
%% SortAndPlotSpikesBURST


cd('C:\Users\maire\Desktop\BurstSortingSaves')





%% sorting and plotting spike general template
%% for larger set threshold  set1
dateString = datestr(now,'yymmdd_HHMM'); %for saving unique variables later but with the same extension
set1saveString = [dateString '_set1_' num2str(threshVars) '_' mouseName '_' sessionName '_' cellnum '_' code '_' '.mat'];
save(set1saveString, 'swall', 'good', 'bad', 's', 'threshVars', 'sw')


%% *****************************
%% *****************************
%% *****************************
%% *****************************
%% OK NOW GO THROUGH AND CREATE A NEW SWALL USING A NEW THRESHOLD USING THE SAME BUILDER FILE
%% THEN COME BACK HERE WHEN IT'S BUILT
%% *****************************
%% *****************************
%% *****************************
%% *****************************


%% for lower threshold  set2

dateString = datestr(now,'yymmdd_HHMM'); %for saving unique variables later but with the same extension
set2saveString = [dateString '_set2_' num2str(threshVars) '_' mouseName '_' sessionName '_' cellnum '_' code '_'  '.mat'];
try
    save(set2saveString, 'swall', 'good', 'bad', 's', 'threshVars', 'sw')
catch
    save(set2saveString, 'swall', 's', 'threshVars', 'sw')
    display('catch triggered');
end
%% ####### be carful not to overwrite, also this step takes some time

set1 = load(set1saveString);
set2 = load(set2saveString);

%% SET UP NEW SWALL WITH PREVIOUSLY SORTED SPIKES REPLACED WITH FAKE SPIKE AND GENERATE NEW INDEXES FOR CURRENT SWALL
%%%  OUTPUTS
%  swallForSmallSpikesInWindow
%     swall variable from set 2 (the threshold set lower than set1) with all the spike sorted (determined as good or bad)
%     replaces with 0's and a -4 at the 15 time point mark, this is used for sorting through jsut the spikes that
%     were captured by set2 that WERE NOT captured by set1. --- insert this into the spike_sorting_PSM
%     above in the swall location
%
%  allGoodMatchForSet1
%      as name implies, these are the index for all the good spikes determined in set 1 BUT for the new swall
%      from set 2 (which will have more spikes becasue of the lower threhsold) --- after you are done sorting the
%      set2 spikes which will generate 'good' variable combine this variable with good to make a final good.
%  allBadMatchForSet1
%      same as allGoodMatchForSet1 but for bad spikes. from set1 inexed in reference to set2 swall
%  allMatch
%      all the spike indexes of the smaller set1 in reference to the bigger set2. so for example it can be used for
%      removing all the spikes sorted by the first pass with set1 in reference to the good array from set 2 for
%      example using setdiff like this 'allGoodMatchForSet1{traces} = allMatch{traces}(set1.good{traces});'
%      where the traces are a for loop running through the length of the arrays.
%  spikesThatNeedSorting
%      just the index of the new spikes that are in in set2 swall that aren't in set1 swall. this isnt used
%      as of now but could be useful for some reason...
%  spikesFromLastSort
%      this is the reverse of spikesThatNeedSorting, in that it is the index of the spikes that were sorted already
%      from the set1, in reference to the set2 swall (these include good and bad sorted neurons)
%______________________________________________________________________________
%______________________________________________________________________________
%%% INPUTS
%  set1
%      all the variables saved from builder for the first pass with a higher threshold.Including the following
%           - swall, s, good, bad
%  set2
%      all the variables saved from builder for the second pass with a lower threshold.Including the following
%           - swall, s
%  timeAfterBigSpike
%      window of time to look at spikes to sort for the second pass sorting in ms. so if 20 ms then it will
%      generate swallForSmallSpikesInWindow so that it only looks at spike caught by the lower threshold that are
%      1) not caught in the first set with higher threshold and 2) exist within 20 ms after the good spikes sorted in
%      set 1.
%      IF timeAfterBigSpike IS SET TO GREATER THAN 20000 THEN IT WILL LOOK AT ALL TIME POINTS. SO THE SPECIFIC TIME 
%      AFTER WINDOW WILL NOT BE CONSIDERED AND ESSENTIALLY THE PROGRAM WILL JUST ALLOW YOU TO SORT AT TWO DIFFERENT 
%      THRESHOLDS
%  lengthSpikeTime
%      length of the spikes extracted from the files in swall, so swall is 30 in time so this should
%      be 30 unless someone changes swall for some reason.

lengthSpikeTime = 30 ; % dont change this this is the size of the spike that is extracted from ephus trace



timeAfterBigSpike = 50; %in ms

% timeAfterBigSpike = 99999999999; %THIS WILL LOOK AT ALL TIME POINTS AT THIS THRESHOLD 
[swallForSmallSpikesInWindow, allGoodMatchForSet1, allBadMatchForSet1, allMatch, spikesThatNeedSorting, spikesFromLastSort]=...
    matching_two_swall_for_catching_small_burst_spikes(set1, set2, timeAfterBigSpike, lengthSpikeTime);
%% useed to go through swall multiple times with previous bas spikes forced to this shape (flat with -4 at time = 15)
lengthSpikeTime = 30
PadFakeSpike = zeros(lengthSpikeTime,1);
PadFakeSpike(floor(lengthSpikeTime/2)) = -4;

swallForSmallSpikesInWindow2 = swallForSmallSpikesInWindow;
for k = 1:length(swallForSmallSpikesInWindow)
    for kk = 1:length(bad{k})
        swallForSmallSpikesInWindow2{k}(:,(bad{k}(kk))) = PadFakeSpike;
    end
end
%% have to sort files first using below program then come back here if you want 
%%
preSpikeBaselineTime = [21:25]; % set to align the spikes from mean of ms X1 to ms X2
trialsPerPlot = 50;
%%% DONT CHANGE THIS VVVVVV THE PROGRAM WILL AUTO DETECT END OF SPIKES
TrialIndCount =(1:trialsPerPlot:20000);
%% THIS IS FOR NEW SETS
%note that once you sort all spikes you can use them for all cells (if you
%sort pm0170 for cells AAAA AAAB and AAAC you only sort the first one and
%use it for all three
selectedSwallArray = swallForSmallSpikesInWindow2; %either swall or swallForSmallSpikesInWindow noramlly
setToScaleOrAligned = 'aligned';
[indexingMat,spksToPlotGood,spksToPlotBad, good, bad]= ...
    spike_sorting_PSM(TrialIndCount,selectedSwallArray,setToScaleOrAligned, preSpikeBaselineTime);

%% ORRRRRRRRRRRRRRRRRRRRRR
%% THIS IS FOR IF YOU HAVE AN 'indexingMat' ALSO LOADS TrialIndCount

selectedSwallArray = swallForSmallSpikesInWindow; %either swall or swallForSmallSpikesInWindow noramlly
startOnPlotNum = 3;
setToScaleOrAligned = 'aligned';
[indexingMat,spksToPlotGood,spksToPlotBad, good, bad]= ...
    spike_sorting_PSM(TrialIndCount,selectedSwallArray,setToScaleOrAligned, preSpikeBaselineTime,indexingMat,startOnPlotNum);
%%%%NOTE THIS WILL LOAD ALL THE POINTS FROM THE INDEXINGMAT SO IF FOR
%%%%EXAMPLE YOU HAVE 4 POINTS ON PLOT NUMBER 10, AND YOU WANT TO DO PLOT 10
%%%%OVER, YOU HAVE TO CLICK 4 TIMES TO OVERWRITE ALL THE PREVIOUS POINTS.
%%%%JUST USE 'DUMMY POINTS' IF NEEDED (POINTS OUTSIDE OF SPIKES THAT DONT
%%%%REMOVE ANY SPIKES) (ALSO NOTE ALL THE POINTS WILL BE VISABLE SO YOU
%%%%SHOULDNT ACCIDNETALLY MISS THIS IF YOU PAY ATTENTION TO THE PLOTS)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% COMBINE THE GOOD AND BAD INDEXES IN REFERENCE TO THE CURRENT SWALL

[~, numTraces] = size(good);
for k = 1:numTraces
    goodCombined{k} = [good{k}, allGoodMatchForSet1{k}];
    
    badActual{k} = setdiff(bad{k}, allMatch{k});
    badCombined{k} = [badActual{k}, allBadMatchForSet1{k}];
end


%% *****************************
%% *****************************
%% *****************************
%% *****************************
%% ONCE DONE WE CAN LOOK AT THIS IN S.VIEW OR JUST USING THE PLOT TRACES PROGRAM
%% WHEN WE ARE SATISFIED THEN WE CAN TURN SET good = goodCombined;
%% THE PROGRAM CAN BE DONE MULTIPLE TIMES IF NEEDED, SO COMBINE AND
%% THEN RUN THIS PART AGAIN TO FIND SPIKES EXTENDED A CERTAIN TIME THAT EXIST
%% AFTER THESE GOOD SPIKES. JUST MAKE SURE TO MADE THE good AND bad VARIABLES
%% ARE MADE FROM THE COMBINED VARIABLES. THEN MAKE SURE TO SAVE SET 1 AGAIN
%% *****************************
%% *****************************
%% *****************************
%% *****************************

%% FIRST OPEN S.VIEWER AND AND GO TO THE TRIAL OF INTEREST
%% THIS IS FOR PLOTING THE DIFFERENT REJECTED AND ACCEPTED SPIKES
%% RED IS FOR SET1 AND BLUE SET2 O'S ARE ACCEPTED AND X'S ARE REJECTED

%               s.viewer

for trial = 550:627
    %%%%%
    plotSortedSpikesSingle(trial, good, swall, s, 'ob')
    hold on
    
    %%%%%
    % using swallForSmallSpikesInWindow so that it plots the 'bad' spikes from the already sorted set down below
    % note that these are all the spikes sorted good or bad from set1. they do not determine final spikes because
    % only the good spikes determine final
    plotSortedSpikesSingle(trial, bad, swallForSmallSpikesInWindow, s, 'xb')
    
    
    %%%%%
    plotSortedSpikesSingle(trial, allGoodMatchForSet1, swall, s, 'or')
    
    %%%%%
    plotSortedSpikesSingle(trial, allBadMatchForSet1, swall, s, 'xr')
    
    
    %%%%%
    % plots the secondary waveforms not need just thought i might be able to use this later.
    plot(sw{trial}.spikeWaveformsSecondary{1,1}, sw{trial}.spikeWaveformsSecondary{1,2}(15,:), '+g')
    
    
    
    waitForEnterPress
end

%% PLOT ALL THE GOOD OR BAD SPIKES
%% set values to plot with this
selectedArray = goodCombined;
preSpikeBaselineTime = 8:12;%align at this part of spike
numSpikesPerPlot = 1000;
selectedArraySize = sum(cell2mat(cellfun(@numel,selectedArray, 'UniformOutput',false)));

%% plot with this

plotSpikeNumbers(selectedArray, preSpikeBaselineTime, swall, numSpikesPerPlot)
%% OR
%% plot single trials

trial = 137;
% % for trial = 2:600
plotSpikeNumbers(selectedArray, preSpikeBaselineTime, swall, numSpikesPerPlot, trial)
% % end

%% FINAL CUT -- CREATE THE GOOD AND BAD ARRAY AND MOVE ON BACK TO BUILDER

good = goodCombined;
bad = badCombined;
cd(['Z:\Users\Phil\Data\EPHUS\' mouseName]); 
display('GO BACK TO BUILDER');









