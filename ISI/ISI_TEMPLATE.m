%% ########## isi template for making drill location 
frameRate = 10;
%  directory = 'Z:\Data\HLab_ISI\ISI\';
%  dirADD = '';
fileNameTMP = 'c2_3';

isi_video4(fileNameTMP, frameRate);

%% then choose the frame you want to draw over by opening the file in quicktime 
%% then changing the time to frames to choose one frame.
fraemToDrawOver = 9;
if ~isempty(strfind(fileNameTMP, '.'))
fileNameTMP = fileNameTMP(1:strfind(fileNameTMP, '.')-1);
end
isi_getImageFromVid([fileNameTMP, '.avi'], fraemToDrawOver);


%% then open the mat file named with ending 'fromVid'
%% then click on vas .qcamraw file 
%% then draw away

isi_easy





