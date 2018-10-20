%%  OUTPUTS
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
%% INPUTS
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
%% begin program
function [swallForSmallSpikesInWindow, allGoodMatchForSet1, allBadMatchForSet1, allMatch, spikesThatNeedSorting, spikesFromLastSort] = ...
    matching_two_swall_for_catching_small_burst_spikes(set1, set2, timeAfterBigSpike, lengthSpikeTime)
timeAfterBigSpike =timeAfterBigSpike*10;
swallForSmallSpikesInWindow = set2.swall;
[~, numTraces] = size(set2.swall);
PadFakeSpike = zeros(lengthSpikeTime,1);
PadFakeSpike(floor(lengthSpikeTime/2)) = -4;


for traces = 1:numTraces
    clear testMatch
    [~, set1NumSpikes] = size(set1.swall{traces});
    [~, set2NumSpikes] = size(set2.swall{traces});
    testMatch = zeros(set1NumSpikes, 1);
    for spikes = 1:set1NumSpikes %all spikes in small set
        %compare each spike to all the spikes in the large set to find all the matches and index them
        testMatch(spikes) = find(sum(set1.swall{traces}(:,spikes) == set2.swall{traces}(:,:))==lengthSpikeTime);
        testMatch(spikes) = find(sum(set1.swall{traces}(:,spikes) == set2.swall{traces}(:,:))==lengthSpikeTime);
    end
    try
        allMatch{1, traces} =testMatch';
    catch
        if isempty(spikes)
            allMatch{1, traces} =[];
            % allMatch is a variable that contains all the spike index of the smaller set1 in reference to the bigger set2.
        end
    end
    allGoodMatchForSet1{traces} = allMatch{traces}(set1.good{traces});
    allBadMatchForSet1{traces} = allMatch{traces}(set1.bad{traces});
    %% need to create an indexing mat for all of the spikes for the large set
    allIndexLargeSet{1, traces} = 1:set2NumSpikes;
    %%   find all different using setdiff to remove sorted spikes from larger set test1
    %%%% now setDiffSpikesLeft contains all the spikes in the larger set that arent in the smaller set so we can look through the times of these and
    %%%%% figure out which ones are in a time region after the good spikes (smaller set)
    setDiffSpikesLeft{traces} = setdiff(allIndexLargeSet{traces}, allMatch{traces})';
    %% then use spike times of a smaller set1 to make an extended matrix of 5 ms or whatever defined above
    %     set1SpikeTimes = set1.s.sweeps{traces}.spikeTimes; % this way is bad because edge spikes are still in this array
    set1SpikeTimes = set1.sw{traces}.spikeWaveforms{1, 1}*10000 ; %spike times after
    set1GoodSpikeTime{traces} = set1SpikeTimes(set1.good{traces});
    clear smallSpikeWindowTimesMat
    if timeAfterBigSpike>20000
        smallSpikeWindowTimesMat = 1:5000;
    else
        if isempty(set1GoodSpikeTime{traces})
            smallSpikeWindowTimesMat = [];
        else
            for kk = 1:timeAfterBigSpike
                
                smallSpikeWindowTimesMat(:,kk) = set1GoodSpikeTime{traces}+kk;
            end
        end
    end
    smallSpikeWindowTimes{traces}=smallSpikeWindowTimesMat;
    %% %% then cross reference test2 with spike times of test2 to look at only the spikes that are a certain time after the small set test3
    
    %     spikeTimesSpikesLeft{traces} = set2.s.sweeps{traces}.spikeTimes(setDiffSpikesLeft{traces}); %% bad way
    spikeTimesSpikesLeft{traces} = set2.sw{traces}.spikeWaveforms{1, 1}(setDiffSpikesLeft{traces})*10000
    %%
    spikesToLookAt{traces} = intersect(spikeTimesSpikesLeft{traces},smallSpikeWindowTimes{traces} );
    %%
    [spikesLeft,~ ] = size(spikesToLookAt{traces});
    
    if spikesLeft == 0
        spikesThatNeedSorting{traces} = [];
    else
        
        test8 = zeros(spikesLeft,1);
        for kk = 1:spikesLeft
            test8(kk, 1) = find(spikesToLookAt{traces}(kk) == set2.sw{traces}.spikeWaveforms{1, 1}*10000);
        end
        spikesThatNeedSorting{traces} = test8;
    end
    %% finally get all the other spikes that arent of interest
    
    spikesFromLastSort{traces} = setdiff(allIndexLargeSet{traces}, spikesThatNeedSorting{traces})';
    
    %% finally edit swall
    [lengthReplace, ~] = size(spikesFromLastSort{traces});
    for k = 1:lengthReplace
        swallForSmallSpikesInWindow{traces}(:,spikesFromLastSort{traces}(k)) = PadFakeSpike;
    end
    
    
    
    
    
    
    
    
    
    
end
end



