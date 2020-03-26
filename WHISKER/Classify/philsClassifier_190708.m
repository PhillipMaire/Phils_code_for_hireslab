%%
% philsClassifier
% cd('C:\Users\maire\Downloads')
%{


startDir = 'C:\testingClass';
 philsClassifier_190708(startDir)

%}
%% jus to save info, should always be the same
function [] = philsClassifier_190708(startDir)
%%

trackingINfoSaveDir =  'Y:\Whiskernas\Data\Video\PHILLIP\';
dateString1 = datestr(now,'yymmdd_HHMM');
%% get all the files from every dir
% startDir = 'Y:\Whiskernas\Data\Video\PHILLIP\AH0718\';
dirs = regexp(genpath(startDir),['[^;]*'],'match');
% % % dirs = {startDir} %################################################remove
Lthresh = 30; %length threshold. whisker must be larger than this
% threshMISSforceLargest = 1; % automatically classify the largest whiskeras %***********************
% centerOfMassJumpPrevention = 1%***********************
maxCenterOfMassChange = 15;% mean distance of x and y of previous whisker min distance to all points of testing whisker
% if the value is larger than this then it can not be classified as the correct whisker
wskrNUM = 0; %whisker class label in mease and whisker files
FramesInVid = 4000; % frames in video for me it will always be the same but for lily or jinho they can read video and get actual fram numbers and set this iteratively
forceReClass = 1; %classify everything using this method
Fnums = (0:FramesInVid-1)';% frmae numbers for the given total framses set above
allLessThan4000 = [];
allClassifierInfo = {};
%%

%%

%%

%%

%%

%%

%%

%%

%%

%%

%%

%%

%%

%%

%%

%%

%%

%%

%%

%%


end




