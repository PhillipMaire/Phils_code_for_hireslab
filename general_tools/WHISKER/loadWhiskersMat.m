

%% just an easy way to make a mat from measurments file

function [whiskerstruct, whiskerMat,IDandTIME, fieldNames] = loadWhiskersMat(input)
% simple function to output... 1) the struct for general purpose 2) the whisker MAT... padded with nans Y.X.Z where 1,1 is the whisker
% ID, 1,2 is the frame number (time) starting at 0 then :,3    :,4     :,5     :,6 are the variables  'x'    'y'    'thick'  'scores'
% respectively , 3)IDandTIME is just the ID anf Time (frame) in a mat that is length(whiskers) by 2 4) just field names
%%
% % % % % % % % tic1 = tic;
whiskerstruct = LoadWhiskers(input);
% % % % % % % % loadWhiskTime = toc(tic1)

%%
% % % % % % % % tic2 = tic;
fieldNames = fieldnames(whiskerstruct)';
whiskerCell = struct2cell(whiskerstruct)';

lengthW = length(whiskerCell);
IDandTIME = double(cell2mat(whiskerCell(:,1:2)));

for k = 1: lengthW
    allLengths(k) = length(whiskerCell{k,end});
end
maxLength = max(allLengths);

whiskerMat = nan(maxLength+500,6,lengthW);
% % % % % % % % otherTime = toc(tic2)
% % % % % % % % tic3 = tic;
for k = 1:lengthW
    whiskerMat(1:allLengths(k),3,k) = whiskerCell{k,3};
    whiskerMat(1:allLengths(k),4,k) = whiskerCell{k,4};
    whiskerMat(1:allLengths(k),5,k) = whiskerCell{k,5};
    whiskerMat(1:allLengths(k),6,k) = whiskerCell{k,6};
    whiskerMat(1,1:2,k) = IDandTIME(k,1:2);
end
% % % % % % % % otherTime2 = toc(tic3)

% % % % [saveName] = saveDatShit
% % % % function [saveName] = saveDatShit
% % % % directoryString = 'C:\Users\Public\Documents';
% % % % cd(directoryString);
% % % % dateString = datestr(now,'yymmdd_HHMMSS');
% % % % saveName = [directoryString, filesep, 'saveDatShit_', dateString];
% % % % save(saveName)
% % % % end
end









