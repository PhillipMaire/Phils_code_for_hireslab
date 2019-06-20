%% ########## isi template for making drill location 
% cd('F:\AH0927\try2')
clc
frameRate = 7;
%  directory = 'Z:\Data\HLab_ISI\ISI\';
%  dirADD = '';
fileNameTMP = 'sig2';


isi_video(fileNameTMP, frameRate);
%               cd('C:\Users\maire\Desktop\StimTrialMats')

%% then choose the frame you want to draw over by opening the file in quicktime 
%% then changing the time to frames to choose one frame.
frameToDrawOver = 7;
fileNameTMP = 'f_sig3';
% fileNameTMP = 'Thresholded_sig1a.avi'
if ~isempty(strfind(fileNameTMP, '.'))
fileNameTMP = fileNameTMP(1:strfind(fileNameTMP, '.')-1);
end
isi_getImageFromVid([fileNameTMP, '.avi'], frameToDrawOver);


isi_easy
%% then open the mat file named with ending 'fromVid'
% then click on vas .qcamraw file 
% then draw away
 

isi_easy
%% adaptthreshVID

 sensitivity1 = .6;
 winChunckSize = [31, 31];
%  winChunckSize = winChunckSize +8
 vidName= 'sig3.avi'
 adaptthreshVID(vidName, sensitivity1, winChunckSize)


%% subtract2videos videos

vid1 = 'sig33.avi';
vid2 = 'sig4FAKE.avi';
subtract2videos(vid1, vid2)
%% subtract2videos images
im1 = 'sig1a.png';
im2 = 'sig1aFAKE.png';
subtract2videos(im1, im2)

%% sibtract2Videos for already adaptive thresholded videos 
%% this turns out to be very dark 
vid1 = 'Thresholded_sig33.avi';
vid2 = 'Thresholded_sig4FAKE.avi';
subtract2videos(vid1, vid2)
%% ########## isi template for making drill location 
numFramesPerTrial = 50; %after temporal averaging
numTrials = 40; % 20 trials
baselineFrames = 30; % whisker deflection starts after 5 sec %%###
numFramesInSignal = 30;%captured signal to subtract from BL
frameRate = 10;
%  directory = 'Z:\Data\HLab_ISI\ISI\';
%  dirADD = '';
fileNameTMP = 'sig3real';


[imageVar] = isi_videoSetYourOwnSettings(fileNameTMP,frameRate, numFramesPerTrial, numTrials,baselineFrames, numFramesInSignal);
%% ########## isi template for making drill location 
numFramesPerTrial = 10; %after temporal averaging
numTrials = 20; % 20 trials
baselineFrames = 3; % whisker deflection starts after 5 sec %%###
numFramesInSignal = 3;%captured signal to subtract from BL
frameRate = 10;
%  directory = 'Z:\Data\HLab_ISI\ISI\';
%  dirADD = '';
fileNameTMP = 'sig2aFAKE';


[imageVar] = isi_videoSetYourOwnSettings(fileNameTMP,frameRate, numFramesPerTrial, numTrials,baselineFrames, numFramesInSignal);
%% ########## isi template for making drill location 
numFramesPerTrial = 20; %after temporal averaging
numTrials = 20; % 20 trials
baselineFrames = 3; % whisker deflection starts after 5 sec %%###
numFramesInSignal = 3;%captured signal to subtract from BL
frameRate = 10;
%  directory = 'Z:\Data\HLab_ISI\ISI\';
%  dirADD = '';
fileNameTMP = 'sig33';
makeNewVidForEachTtrial =0

[imageVar] = isi_videoSetYourOwnSettings(fileNameTMP,frameRate, numFramesPerTrial, numTrials,baselineFrames, numFramesInSignal);


