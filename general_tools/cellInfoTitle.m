%% title name general info


%% cellInfoTitle
mouseName = U{cellStep}.details.mouseName;
sessionName = U{cellStep}.details.sessionName;
cellNumString = U{cellStep}.details.cellNum;
cellCode = U{cellStep}.details.cellCode;
projectCellNum = num2str(U{cellStep}.cellNum);
depth = num2str(U{cellStep}.details.depth);
trialsCorrect = U{cellStep}.meta.trialCorrect;
% fractionCorrect = num2str(U{cellStep}.details.fractionCorrect*100); THIS WAY INCLUDES TRIALS THAT WE DONT HAVE IN T/U ARRAY CAUSE IT
% IS FROM BEHAVIOR PROGRAM
fractionCorrect = num2str((mean(trialsCorrect).*100) +0.00000000000001);
trialType = U{cellStep}.meta.trialType;
if numel(fractionCorrect)<4
    sizePerfReg = numel(fractionCorrect);
else
    sizePerfReg =4;
end
fractionCorrectstr = ['1-',num2str(numel(trialsCorrect)),' ',fractionCorrect(1:sizePerfReg), '%'];




numHitTrialsInRowCorrect = 1:4; 
for numHitTrialsInRowCorrectIter  = numHitTrialsInRowCorrect
allHitTrials = trialsCorrect.* trialType; %hit
counterForHitsInARow = 0;
IndForHitsInARow = [];
for allGoTrialsIter2 = find(trialType)
    if  allHitTrials(allGoTrialsIter2)
        counterForHitsInARow = counterForHitsInARow+1;
        if counterForHitsInARow >= numHitTrialsInRowCorrectIter
        IndForHitsInARow(end+1) = allGoTrialsIter2;
        end
    else
        counterForHitsInARow = 0;
    end
end
allHitsInARow{numHitTrialsInRowCorrectIter} = IndForHitsInARow;
end
numHitsInRowUsed = [];
% find the one with more than 2 so you can show between trial A and trial B
for numHitsInRowUsedITER = 1:length(allHitsInARow)
    if length(allHitsInARow{numHitsInRowUsedITER}) >= 2 
    numHitsInRowUsed = numHitsInRowUsedITER;
    end   
end
IndForHitsInARow = allHitsInARow{numHitsInRowUsed};



useTrials = U{cellStep}.details.useTrials;
%look at good perfomrance region
% numTrialsInRowCorrect = 4; %number of correct trials ina row to
%find the last instance of so that you can give a good performance measure
% correctTrialsInRow = ones(1,numTrialsInRowCorrect);
% new = strfind(trialsCorrect, correctTrialsInRow);
perormanceRegion= IndForHitsInARow(1):IndForHitsInARow(end);
meanPerformanceRegion = num2str(mean(trialsCorrect(perormanceRegion))*100);
if numel(meanPerformanceRegion)<4
    sizePerfReg = numel(meanPerformanceRegion);
else
    sizePerfReg =4;
end
% make subscript
tmpSubscriptName = [num2str(numHitsInRowUsed), ' cont hits'];
tmpSubscriptName2 ='';
for stupidShit = 1: length(tmpSubscriptName)
    tmpSubscriptName2(end+1) = '_';
    tmpSubscriptName2(end+1) = tmpSubscriptName(stupidShit);
end

perormanceRegionStr = [num2str(perormanceRegion(1)),'-',num2str(perormanceRegion(end))...
    ,' ', meanPerformanceRegion(1:sizePerfReg),'%', tmpSubscriptName2];

cellTitleName = {[' cell-', projectCellNum, ' depth-',    depth, ' ' ,mouseName, ' ',...
    sessionName, ' ', cellNumString, ' ', cellCode];[ fractionCorrectstr,'   ',perormanceRegionStr]};
%%



