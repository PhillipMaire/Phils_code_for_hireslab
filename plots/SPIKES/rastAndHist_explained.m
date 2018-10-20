spk2 = cellfun(@(x)x.spikeTimes,spikes_trials.spikesTrials,'uniformoutput',0);

spk4 = cellfun(@(x)(x.spikeTimes)/10000,...
    spikes_trials.spikesTrials,...
    'uniformoutput',0);

%spk = cellfun(@(functionhandle)x.spikeTimes,function or whatever being called by 
%the function handle,'uniformoutput',0)

spk3= cellfun(@(x)x.spikeTimes/10000,s.sweeps,'uniformoutput',0);