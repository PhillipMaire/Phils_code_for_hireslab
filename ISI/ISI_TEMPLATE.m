%% automatically make MP4 vidoes in a while loops

% dirSet = 'X:\ISI\Phil\NewMice200309\AH1133 red\try2';
dirSet = pwd
while true
    ISIsigFiles = struct2cell(dirALL(dirSet, '*.qcamraw'));
    ISIsigFiles = ISIsigFiles(:, cell2mat(ISIsigFiles(4, :))>70000000);
    for k = 1:size(ISIsigFiles, 2)%%
        qcamFile = [ISIsigFiles{2, k}, filesep, ISIsigFiles{1, k}];
        aviFile = [qcamFile(1:end-7), 'avi'];
        if ~isfile(aviFile)
            try
                fclose('all')
                cd(ISIsigFiles{2, k})
                isi_video(qcamFile, 7);
            catch
            end
        end
    end
    pause(5)
end

%% ########## isi template for making drill location
% cd('F:\AH0927\try2')
clc
frameRate = 7;
%  directory = 'Z:\Data\HLab_ISI\ISI\';
%  dirADD = '';
fileNameTMP = 'sig3';


isi_video(fileNameTMP, frameRate);
%%

TESTING_isi_video(fileNameTMP, frameRate);
%               cd('C:\Users\maire\Desktop\StimTrialMats')
%%
% h = figure;
% fullscreen(h, 2)
playXtimes = 200
secondsPerFrame = .001;
isi_showRawVideo(fileNameTMP,secondsPerFrame,playXtimes,  2)
% ass a if fig closes then stop looping 

%%




isi_showRawVideo(fileNameTMP,secondsPerFrame,playXtimes,  2)


%% then choose the frame you want to draw over by opening the file in quicktime
%% then changing the time to frames to choose one frame.
fileNameTMP = 'f_sig3';
frameToDrawOver = 6;
% fileNameTMP = 'sig10_2';
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

sensitivity1 = .1;
winChunckSize = [17, 17];
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
numTrials = 40; % trials
baselineFrames = 30; % whisker deflection starts after 5 sec %%###
numFramesInSignal = 30;%captured signal to subtract from BL
frameRate = 10;
%  directory = 'Z:\Data\HLab_ISI\ISI\';
%  dirADD = '';
fileNameTMP = 'sig3real';


[imageVar] = isi_videoSetYourOwnSettings(fileNameTMP,frameRate, numFramesPerTrial, numTrials,baselineFrames, numFramesInSignal);
%% ########## isi template for making drill location
numFramesPerTrial = 20; %after temporal averaging
numTrials = 20; % 20 trials
baselineFrames = 3; % whisker deflection starts after 5 sec %%###
numFramesInSignal = 4;%captured signal to subtract from BL
frameRate = 7;
%  directory = 'Z:\Data\HLab_ISI\ISI\';
%  dirADD = '';
fileNameTMP = 'sig2';


[imageVar] = isi_videoSetYourOwnSettings(fileNameTMP,frameRate, numFramesPerTrial, numTrials,baselineFrames, numFramesInSignal);
%% ########## isi template for making drill location
numFramesPerTrial = 20; %after temporal averaging
numTrials = 20; % 20 trials
baselineFrames = 3; % whisker deflection starts after 5 sec %%###
numFramesInSignal = 3;%captured signal to subtract from BL
frameRate = 10;
%  directory = 'Z:\Data\HLab_ISI\ISI\';
%  dirADD = '';
fileNameTMP = 'sig2';

[imageVar] = isi_videoSetYourOwnSettings(fileNameTMP,frameRate, numFramesPerTrial, numTrials,baselineFrames, numFramesInSignal);

%% ########## isi template for making drill location
numFramesPerTrial = 10; %after temporal averaging
numTrials = 40; % 20 trials
baselineFrames = 2; % whisker deflection starts after 5 sec %%###
numFramesInSignal = 2;%captured signal to subtract from BL
frameRate = 7;
%  directory = 'Z:\Data\HLab_ISI\ISI\';
%  dirADD = '';
fileNameTMP = 'sig33';

[imageVar] = isi_videoSetYourOwnSettings(fileNameTMP,frameRate, numFramesPerTrial, numTrials,baselineFrames, numFramesInSignal);


