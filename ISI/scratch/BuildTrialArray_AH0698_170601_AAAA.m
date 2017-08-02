mouseName   = 'AH0698';
sessionName = '170601';
videoloc = 'AHHD_009';

whiskerTrialTimeOffset = .02; % in seconds to account for frametrig lag
depth = 1620;  % in um from pia
recordingLocation = [0 0 0];  % % in mm

cellnum = 'PM0121'; 
code = 'AAAA'; 
%from sweep 2 is good but messied with larger spikes so just looking at
%these properties to get an idea of the cell and if we need more
%statistical significance I can go through each trace
sweepnums =  [1:170];
% s.sweeps{15}.trialNum
% 
% ans =
% 
%      0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%I set s.sweeps{15}.trialNum=16; so that iit would run the program this is
%in line with the others s.sweeps{14}.trialNum == 15 and 
%s.sweeps{16}.trialNum ==17;
%% Build Behavior
fn =['Z:\Users\Phil\Data\Behavior\' mouseName filesep 'data_@pole_contdiscrim_obj_' mouseName '_' sessionName 'a.mat'];
b = Solo.BehavTrialArray(fn, sessionName); 
b.trim = [1 0];  
b.performanceRegion = [1 170]; 
figure; 
b.plot_scored_trials
pc = performance(b)
save(['Z:\Users\Phil\Data\BehaviorArrays\solo_' mouseName '_' sessionName '.mat'],'b')

%% Build Spike Array

cd(['Z:\Users\Phil\Data\EPHUS\' mouseName]);
s = LCA.SweepArray(cellnum, code, sweepnums);
s = s.set_primary_threshold_all(1); % in mV

%  s = s.set_primary_threshold([17:100 ],repmat(1,size([17:100]))); % trials and mV
%  s = s.set_primary_threshold(151:170,repmat(1.5,size(151:170)));
% s = s.set_artifact_threshold_all(-1);
%  s = s.set_artifact_threshold(78:150,repmat(-.8,size(78:150)));
%s.sweeps{15}.trialNum=231 %% used for when there is a glitch and one of the
%trial numbers are not assigned for the sweep
s.viewer
%% optional section if we have a bad licking artifact that cannot be removed
% by filtering

sweepTrialNums = cellfun(@(x)x.trialNum,s.sweeps);
%
sweepTrialNums(find(sweepTrialNums==0))= sweepTrialNums(find(sweepTrialNums==0)+1)-1;
%

[c, ia, ib] = intersect(b.trialNums,sweepTrialNums);
sweepBeamBreakTimes = cellfun(@(x)x.beamBreakTimes,b.trials(ia),'uniformoutput',0);

for i = 1:length(s.sweeps)
        [indx,indy] = find(abs(repmat(sweepBeamBreakTimes{i}*10000,1,length(s.sweeps{i}.spikeTimes))...
            -repmat(s.sweeps{i}.spikeTimes',length(sweepBeamBreakTimes{i}),1))<100);
    badSpikes{i} = indy;
    goodSpikes{i} = setdiff(find(s.sweeps{i}.spikeTimes),badSpikes{i});
    %   s.sweeps{i}.spikeTimes = s.sweeps{i}.spikeTimes(goodSpikes{i})
    %     s.sweeps{i}.spikeWaveforms{1} = s.sweeps{i}.spikeWaveforms{1}(goodSpikes{i});
    %     s.sweeps{i}.spikesWaveforms{2} = s.sweeps{i}.spikeWaveforms{2}(goodSpikes{i});
end


%% section for EVEN WORSE licking artifact where you will need to specify
%% values for defining what licks are

sw = s.get_spike_waveforms_all;
swall = cellfun(@(x)x.spikeWaveforms{2},sw,'uniformoutput',0);
bad = cell(size(swall));
good = cell(size(swall));
rise=10; %AP rise time in ms
%%
%use this to plot BEFORE
swall = cellfun(@(x)x.spikeWaveforms{2},sw,'uniformoutput',0);
swcat = [swall{:}];
swscale = (swcat - repmat(mean(swcat(1:rise,:)),30,1))./repmat(max(swcat)-mean(swcat(1:rise,:)),30,1);
% swaligned = swcatall - repmat(sum(swcatall(1:10,:))/10,30,1);
swaligned = swcat - repmat(sum(swcat(1:10,:))/10,30,1);
%normalized to min of trial swscale = (swcat - repmat(min(swcat),30,1))./repmat( max(swcat)-min(swcat),30,1);
figure;plot(swscale)
title('unfiltered scale (normalized)')
figure;plot(swaligned)
title('unfiltered aligned (not normalized)')
%%
for i=1:length(swall) %built to filter out each trial individually so can cross validate w/ licks 
    swcat = swall{i};
    if ~isempty(swall{i});
        swscale = (swcat - repmat(mean(swcat(1:rise,:)),30,1))./repmat(max(swcat)-mean(swcat(1:rise,:)),30,1);
        swaligned = swcat - repmat(sum(swcat(1:10,:))/10,30,1);
         %%%%use this to filter your spikes!!!>_<
       badScale{i} = find(swscale(1,:)<-.2|swscale(22,:)<-.8|swscale(18,:)>-.2); %this is what you change to filter out bad spikes
       badAligned{i} = find(swaligned(15,:)>9);%|swaligned(22,:)<-.8|swaligned(19,:)>.25);
          %%%%
       
       goodScale{i} = setdiff(1:size(swscale,2),badScale{i});
       goodAligned{i} = setdiff(1:size(swaligned,2),badAligned{i});
       bad{i} = unique([badAligned{i}, badScale{i}]);
       good{i} = setdiff(1:size(swscale,2),bad{i});
       
       newswScaleFilter{i} = swcat(:,goodScale{i});
       newswAlignedFilter{i} = swcat(:,goodAligned{i});
       newswall{i} = swcat(:,good{i}); %rewrites swall to keep only good spike columns
       
       spksToPlotGood{i} = swcat(:,good{i});%all good spikes
       spksToPlotBad{i} = swcat(:,bad{i});%all bad spikes
       spksToPlotScale{i} = swcat(:,goodScale{i});%all good spikes identified by the scaled display ( may contian bad spikes identified from the other display)
       spksToPlotAligned{i} = swcat(:,goodAligned{i});%all good spikes identified by the aligned display display( may contian bad spikes identified from the other display)
       spksToPlotBadScale{i} = swcat(:,badScale{i});%the bad spikes from the scale display
       spksToPlotBadAligned{i} = swcat(:,badAligned{i});%the bad spikes from the aligned display
    end
end
%% use this graph to compare to your swscale and see if these are the spike
%you want. If not, change the filter settings through "bad" 
swcatall = [newswall{:}];
scatscale = (swcatall - repmat(mean(swcatall(1:rise,:)),30,1))./repmat(max(swcatall)-mean(swcatall(1:rise,:)),30,1);
scatAligned = swcatall - repmat(sum(swcatall(1:10,:))/10,30,1);
figure; plot(scatscale)
title('Test Filter')
figure; plot(scatAligned)
title('Test Filter Aligned')
%% for plotting spikes not normalized to height
shiftMat = repmat(sum(swcatall(1:10,:))/10,30,1);
swcatall2 = swcatall-shiftMat;
figure; 
plot(swcatall2)
%% run one line to look at what you want (see aboove for descriptions)
spksToPlot = [spksToPlotGood{:}];
spksToPlot = [spksToPlotBad{:}];

spksToPlot = [spksToPlotScale{:}];
spksToPlot = [spksToPlotAligned{:}];

spksToPlot = [spksToPlotBadScale{:}];
spksToPlot = [spksToPlotBadAligned{:}];

%% Run this section to see normalized and aligned plots for the chosen spikes
scatscale = (spksToPlot - repmat(mean(spksToPlot(1:rise,:)),30,1))./repmat(max(spksToPlot)-mean(spksToPlot(1:rise,:)),30,1);
scatAligned = spksToPlot - repmat(sum(spksToPlot(1:10,:))/10,30,1);

figure; plot(scatscale)
title('Test Filter scale')
figure; plot(scatAligned)
title('Test Filter Aligned')
%%

allgood = cell(size(swall)); %integrate both good(removed artifact from waveform) and goodSpikes (removed artifact based on beambreaktimes) 
for i=1:length(s.sweeps)
    allgood{i} = intersect(goodSpikes{i},good{i}');
end

spikes_trials = s.get_spike_times; % takes into account allgood to replace spikes
for i = 1:length(spikes_trials.spikesTrials)
    spikes_trials.spikesTrials{i}.spikeTimes = spikes_trials.spikesTrials{i}.spikeTimes(allgood{i});
    viewsp{i}=sw{i}.spikeWaveforms{2}(:,[allgood{i}]);
end

%view all good waveforms
spcat=[viewsp{:}];
finalsw=(spcat - repmat(mean(spcat(1:rise,:)),30,1))./repmat(max(spcat)-mean(spcat(1:rise,:)),30,1);
figure;plot(finalsw)
title('Filtered')

%% Load whisker data for session:
load(['Z:\Data\Video\' videoloc filesep mouseName filesep sessionName filesep mouseName sessionName '-WTLIA.mat'],'wl')

%% Save everything
spikes_trials = s.get_spike_times; % takes into account allgood to replace spikes
for i = 1:length(spikes_trials.spikesTrials)
    spikes_trials.spikesTrials{i}.spikeTimes = spikes_trials.spikesTrials{i}.spikeTimes(allgood{i});
end

save(['Z:\Users\Phil\Data\SpikesData\SweepArrays\sweepArray_' mouseName '_' sessionName '_' cellnum '_' code '.mat'],'s')

save(['Z:\Users\Phil\Data\SpikesData\SpikeArrays\spikes_trials_'  mouseName '_' sessionName '_' cellnum '_' code '.mat'],'spikes_trials')

T = LCA.TrialArray(b,spikes_trials,wl);
T.whiskerTrialTimeOffset = whiskerTrialTimeOffset;
T.depth = depth;
T.recordingLocation = recordingLocation;

for i = 1:length(T.trials)
    T.trials{i}.spikesTrial.spikeTimes = T.trials{i}.spikesTrial.spikeTimes(:);
end

save(['Z:\Users\Phil\Data\TrialArrayBuilders\trial_array_'  mouseName '_' sessionName '_' cellnum '_' code '.mat'],'T')
cd('Z:\Users\Phil\Data\TrialArrayBuilders\');

figure;T.plot_spike_raster(0,'BehavTrialNum')
T
