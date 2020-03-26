%%

function [trialTypeStruct, varargout] = getTrialTypes(cellTMP)
%% 2nd varible is the mat
%% 3rd variable is the name array
% input the single cell form the U array as cellTMP
trialTypeStruct.go = double(cellTMP.meta.trialType==1);%all trials that are go
trialTypeStruct.nogo = double(cellTMP.meta.trialType==0);%all trials that are nogo
trialTypeStruct.correct = double(cellTMP.meta.trialCorrect==1);
trialTypeStruct.incorrect = double(cellTMP.meta.trialCorrect==0);
trialTypeStruct.lick = double((trialTypeStruct.go.*trialTypeStruct.correct)+(trialTypeStruct.nogo.*trialTypeStruct.incorrect));
trialTypeStruct.nolick =double(trialTypeStruct.lick==0);
trialTypeStruct.hit = double((trialTypeStruct.go.*trialTypeStruct.correct));
trialTypeStruct.corrRej=double((trialTypeStruct.nogo.*trialTypeStruct.correct));
trialTypeStruct.falseAlarm = double(trialTypeStruct.nogo.*trialTypeStruct.incorrect);
trialTypeStruct.miss =double( trialTypeStruct.go.*trialTypeStruct.incorrect);



trialTypeMat = cell2mat(struct2cell(trialTypeStruct));
trialTypeMatNames = {'go' 'nogo' 'correct' 'incorrect' 'lick' 'nolick' 'hit' 'corrRej' 'falseAlarm' 'miss'};
if nargout ==2
    varargout{1} = trialTypeMat;
elseif nargout ==3
    varargout{1} = trialTypeMat;
    varargout{2} = trialTypeMatNames;
end

% trialTypestruct.