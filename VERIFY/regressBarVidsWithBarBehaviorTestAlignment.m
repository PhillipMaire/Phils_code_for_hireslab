%{
directory1 = 'X:\Video\PHILLIP\AH1017\190505\Camera 1';
% % % % % % % % % behavTrialNum = 1:length(behavTrialsInVidINDS{2});
vidFileNum = behavTrialsInVidINDS{2}
behavFullFileName = 'Z:\Users\Phil\Data\Behavior\AH1017\data_@pole_contdiscrim_obj_AH1017_190505a.mat';
 [alignStruct, isAlignedLogical] = regressBarVidsWithBarBehaviorTestAlignment(...
    directory1, vidFileNum, behavFullFileName)
%}


function [alignStruct, isAlignedLogical] = regressBarVidsWithBarBehaviorTestAlignment(...
    vidDir, vidFileNums, behavFullFileName, varargin)


thresholdResids = 0.04; %if residuas of prediction are too latge consider this a flawed alignment.
if nargin >3
    thresholdResids=  varargin{1};
end
cd(vidDir)

allBars = nan(size(vidFileNums(:), 1), 2);
% barFileNum = nan(size(vidFileNum(:), 1), 1);

for k = 1:length(vidFileNums)
    tmp1 = dir([vidDir filesep,'*-', num2str(vidFileNums(k)) '.bar']);
    if~isnan(vidFileNums(k)) && ~isempty(tmp1)
        
        %         barFileNum(k, 1) = str2num(tmp1.name(strfind(tmp1.name, '-')+1 : end-4));
        tmp1 = load(tmp1.name);
        allBars(k, :) = tmp1(1, 2:3);
        
        
    end
    
end
if sum(~isnan(allBars))<1
    
    error('no bar files')
end
%% get a good ref value
[~, ind1] = sort(allBars(:,1));
allBarsSorted = allBars(ind1, :);
allBarsSorted = allBarsSorted(~isnan(allBarsSorted));
allBarsSorted  =reshape(allBarsSorted, length(allBarsSorted)./2, 2);
refVals = nanmedian(allBarsSorted);
% get the distance from that reap values
refVals = repmat(refVals, size(allBars, 1), 1);
allDIsts = sqrt(abs((allBars(:,1) - refVals(:,1)).^2 + (allBars(:,2) - refVals(:,2).^2)));

% % % % % [~, indToRef] = nanmin(allDIsts);
% % % % % refVals = allBarsSorted(indToRef, :);
% % % % % % get the distance from that reap values
% % % % % refVals = repmat(refVals, size(allBars, 1), 1);
% % % % % allDIsts = sqrt(abs((allBars(:,1) - refVals(:,1)).^2 + (allBars(:,2) - refVals(:,2).^2)));
% % % %
% % % % % tmp5 = ((allBars(:,1) - refVals(:,1)) + (allBars(:,2) - refVals(:,2)));
% % % % % tmp5 = tmp5./abs(tmp5);
% % % % % allDIsts = allDIsts.*tmp5;
% % % %
% % % % % allDIsts = abs(sqrt((allBars(:,1) - refVals(:,1)).^2 + (allBars(:,2) - refVals(:,2).^2)));

% % get the fit of the line for the rea positions withought the nans as they casue errors
% allBars2 = allBars(~isnan(allBars));
% allBars2 = reshape(allBars2, length(allBars2)/2, 2);
% fit1 = polyfit(allBars2(:,1), allBars2(:,2), 1);
%

% allBarsVID = normalize(allDIsts, 'zscore', 'robust');
allBarsVID = allDIsts(:);

%get behav pole pos
behav = load(behavFullFileName);
polePos = behav.saved.MotorsSection_previous_pole_positions;
polePos(1) = nan;
% polePosLat = behav.saved.MotorsSection_previous_pole_positions_lat;
% polePosLat(1) = nan;

allBarsBEHAV = polePos(:);
% allBarsBEHAV = normalize([polePos(:)], 'zscore', 'robust');
% now use teh provided info to see if there are na mis matches
%%
try
    allBarsVID = normalize(allBarsVID, 'range');
    allBarsBEHAV = normalize(allBarsBEHAV, 'range');
catch
    allBarsVID = (allBarsVID - nanmin(allBarsVID))./nanmax((allBarsVID - nanmin(allBarsVID)));
    allBarsBEHAV = (allBarsBEHAV - nanmin(allBarsBEHAV))./nanmax((allBarsBEHAV - nanmin(allBarsBEHAV)));
    
end

tmpL = [length(allBarsVID), length(allBarsBEHAV)];
if tmpL(1)>= tmpL(2)
    allBarsBEHAV(end+1:end+(tmpL(1) - tmpL(2))) = nan;
elseif tmpL(1)< tmpL(2)
    allBarsVID(end+1:end+(tmpL(2) - tmpL(1))) = nan;
end



[allBarsBEHAV, allBarsBEHAV_IND] = sort(allBarsBEHAV);
[allBarsVID] = allBarsVID(allBarsBEHAV_IND);
figure; plot( allBarsBEHAV,allBarsVID, '.')

indToFit = (~isnan(allBarsVID) + ~isnan(allBarsBEHAV)) == 2;
allBarsVID_MOD_IN = allBarsVID(indToFit);
allBarsBEHAV_MOD = allBarsBEHAV(indToFit);

p1 = polyfit(allBarsBEHAV_MOD, allBarsVID_MOD_IN, 4);
[allBarsVID_MOD] = polyval(p1, allBarsBEHAV_MOD, '.b');
hold on
plot( allBarsBEHAV_MOD,allBarsVID_MOD, 'Or');

%% replace the nans where they need to be so user can see the trials what are missing and so the numbers match
%% with behavior trials numbers.
nanLocs = find(indToFit ==0);
for k = 1:length(nanLocs)
    b = nan;
    i1 = nanLocs(k);
    allBarsVID_MOD_IN = [allBarsVID_MOD_IN(1:i1-1);b;allBarsVID_MOD_IN(i1:end)];
    allBarsVID_MOD = [allBarsVID_MOD(1:i1-1);b;allBarsVID_MOD(i1:end)];
    allBarsBEHAV_MOD = [allBarsBEHAV_MOD(1:i1-1);
        b;allBarsBEHAV_MOD(i1:end)];
    
    
end
%%
resids = allBarsVID_MOD - allBarsVID_MOD_IN;
figure;hist(resids, 100)
xlim([-.2 .2])

missalignedTrials = find(abs(resids)>thresholdResids);
alignStruct.bar_vid =allBarsVID_MOD_IN ;
% alignStruct.bar_vidALL = allBarsVID
alignStruct.bar_vid_predict = allBarsVID_MOD;
alignStruct.bar_behav = allBarsBEHAV_MOD;
% alignStruct.bar_behavALL = allBarsBEHAV;
alignStruct.indToFit = indToFit;
alignStruct.missalignedTrials = missalignedTrials;
alignStruct.resids = resids;

stop1 = 1;
if isempty(missalignedTrials)
    isAlignedLogical= true;
else
    isAlignedLogical = false;
end
% [   ,   ,   ]
%%
% % % % %
% % % % % %  directory1, behavTrialNum, vidFileNum, behavFullFileName
% % % % % if length(allBarsVID)>= length(allBarsBEHAV)
% % % % %     [allBarsBEHAV, allBarsBEHAV_IND] = sort(allBarsBEHAV);
% % % % %     [allBarsVID] = allBarsVID(allBarsBEHAV_IND);
% % % % %     figure; plot(allBarsVID, allBarsBEHAV, '.')
% % % % % else
% % % % %     %
% % % % %     %
% % % % %     %
% % % % %     %
% % % % % end
% % % % %
% % % % %
% % % % % % allBarsVID2 = allBarsVID(vidFileNum
% % % % %
% % % % % % barFileNum
% % % % %

%%