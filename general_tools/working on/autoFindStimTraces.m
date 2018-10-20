%%load it up
function [stimAmplitude, stimNames, allXSGfileNames] = autoFindStimTraces(dirOfEphusFiles)
% dirOfEphusFiles = 'C:\Users\maire\Desktop';
cd(dirOfEphusFiles) 
[xsgFileList] = dir('*.xsg');
%% LOOK FOR THIS VARIABLE 
matchThisName = 'LaserShutter';
%%
for k = 1: length(xsgFileList)
    fileName = [xsgFileList(k).folder, filesep, xsgFileList(k).name];
xsgFile = load(fileName,'-mat');

%% get channels find the name you are interested in to get that index

channels  = xsgFile.header.stimulator.stimulator.channels;

for kk = 1:length(channels)
    
    if strcmp(matchThisName, channels(kk).channelName)
        matchIndex = kk;
        
    end
end

%% get the names of the files so user can extract determine the stim and no stimtrials


stimAmplitude(k) = xsgFile.header.stimulator.stimulator.pulseParameters{1,matchIndex}.amplitude;
stimNames{k} = xsgFile.header.stimulator.stimulator.pulseParameters{1,matchIndex}.name;
allXSGfileNames{k} = fileName;
end