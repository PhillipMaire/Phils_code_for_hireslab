
%{

behavFILE = 'Z:\Users\Phil\Data\Behavior\AH1017\data_@pole_contdiscrim_obj_AH1017_190505a.mat';
videoLOCATION = 'X:\Video\PHILLIP\AH1017\190505\Camera 1';
tic
[behavTrialsInVidINDS] = alignVidUsingPoleAndAVILastModifiedTime2(behavFILE, videoLOCATION)
toc

%}
%%
function [timeOffset, behavTrialsInVidINDSALL, allCamTrigTimes, numsFromVidALL, vidTimes] = alignVidUsingPoleAndAVILastModifiedTime(behavFILE, videoLOCATION,  modRefInd, cutvideoFromIndX)
% HARD CODED FOR MY TRIALS THAT ARE AT MIN 4 SECONDS LONG .
numsFromVidALL = {};
if nargin == 3 
    cutvideoFromIndX = -9999999; 
end
minTrialLength = 4;
addDueToRounding = .6;
minTrialLength = minTrialLength + addDueToRounding;
behavTrialsInVidINDSALL = {nan, nan};
%% get varibles set up
FTname = {'seq', 'AVI'};
for FT = 1:2
    cd(videoLOCATION)
    
    
    vidList = struct2cell(dir(['*ListAndInfoForAligning.mat']));
    tmp2 = {};
    for findType = 1:size(vidList,2)
        tmpFN = vidList{:, findType};
        if contains(lower(tmpFN) , lower(FTname{FT}))
            tmp2(1:size(vidList(:, findType),1), end+1) = vidList(:, findType);
        end
    end
    tmp1 = tmp2;
    if ~isempty(tmp1)
        [~, indToMostRecent]= max(cell2mat(tmp1(6, :)));
        tmp2  = load( tmp1{1, indToMostRecent});
        
        if FT == 2
            avi_list = struct2cell(tmp2.AVIlist);
            bytesLOC = find(~cellfun(@isempty, strfind(fieldnames(tmp2.AVIlist), 'bytes')) ==1);
            
        elseif FT ==1
            avi_list = struct2cell(tmp2.seqList);
            bytesLOC = find(~cellfun(@isempty, strfind(fieldnames(tmp2.seqList), 'bytes')) ==1);
            
        end
        not4000 = find(cell2mat(avi_list(bytesLOC, :)) ~= mode(cell2mat(avi_list(bytesLOC,:))));
        if ~isempty(avi_list)
            %         avi_list = avi_list(:, modeBytes);
            
            startInd = cell2mat(strfind(avi_list(1, :), '-')) +1;
            for k =1 :size(avi_list, 2)
                numsFromVid(k) = str2num(avi_list{1, k}(startInd(k):end-4));
            end
            [date1, date1ind] = sort(cell2mat(avi_list(end, :)));
            
            
            numsFromVid = numsFromVid(date1ind);
            [numsFromVid, indToKeep]  = setdiff(numsFromVid, 1:cutvideoFromIndX, 'stable');
            date1 = date1(indToKeep);
            timeBetTrials4vids = round(diff(date1)*60*60*24);
            %%  load beahvior data and set up stuff from there
            behav = load(behavFILE);
            polePos = behav.saved.MotorsSection_previous_pole_positions;
            SM = behav.saved_history.RewardsSection_LastTrialEvents;
%             numBehavTrials = cell2mat(behav.saved_history.AnalysisSection_NumTrials);
            %% get the cam trigger times for each trial
            allCamTrigTimes = [];
            triggered = 0;
            for k = 1:length(SM)
                tmp1 = SM{k};
                FirstSpot = find(tmp1(:,1) == 101);
                if ~isempty(FirstSpot)
                    allCamTrigTimes(k) = tmp1(FirstSpot(1), 3);
                    if triggered~=1
                        triggered = 1;
                        firstInd =k;
                    end
                else
                    allCamTrigTimes(k) = nan;
                end
            end
            numBehavTrials = 1:length(allCamTrigTimes);
            %%
            vidTimes = [0; cumsum(timeBetTrials4vids(:))];% cumlative video time starting at 0
            vidTimes(not4000) = nan;
            refTime = allCamTrigTimes(firstInd+modRefInd); % 0 point corresponidng to the trigger of the first video
            % this could be wrong if you didnt trigger the video from the first time I think that if it is this
            % program will still work but will be with a lagshift of some x number of trials. can use pole
            % position to determine this lagshift jsut want to make array same size as pole and use nan where
            % ther is a pole and there is no video trial number( shoud be none though )
            allCamTrigTimes =allCamTrigTimes- refTime; %pulled from SM form behavior these correspond to all the
            %101 states which is when the camer is triggered. this is the sate that the vidoe file get in their
            %'last modified' section despite that this make no sense I tested it. so these are the dates I have
            %in the mat called AVIListAndInfoForAligning above.
            diffMat = vidTimes(:)' - allCamTrigTimes(:);
            timeOffset = (diffMat);
            timeOffset(timeOffset>=minTrialLength ) = nan;
            timeOffset(timeOffset<=-minTrialLength ) = nan;
            %             timeOffset(timeOffset>
            [allMin, allInds] = nanmin(timeOffset, [], 2);% these are all the min times for eaach trial and their
            % inds, note that there will be doubles here if there are more behavior files than vidoe files, thats normal.
            
            %*** allInds is the ind of the best video that matches the trial in that position so
            % numsFromVid((allInds(20))) is the video number for trial 20
            
            videoNumsActual = numsFromVid(allInds);
            % so that means videoNumsActual INDS ARE 
            
            videoNumsActual(isnan(allMin)) = nan; %
            %
            %             [tmp4, minSortedInds] = sort(allMin); %these are the inds to the min subtracted times but sorted.
            %             % we only want to best matching ones for each trial (to get rid of the doubles mentioned above)
            %             indsToBehavWithMatchingVid = minSortedInds(1:sum(~isnan(vidTimes))); %take 1 thorugh the length of all
            %             %vide length to get the true inds
            %             %             numsFromVid2 = numsFromVid(behavTrialsInVidINDS);
            %              [behavTRIALS, inds1] = unique(minSortedInds, 'first');
            %
            %
            %
            %             behavTRIALS = allInds(indsToBehavWithMatchingVid);
            %
            %             [behavTRIALS, inds1] = unique(behavTRIALS, 'first');
            %
            %
            %
            %
            %             vidTRIALS = setdiff( numsFromVid, not4000);
            %             vidTRIALS = vidTRIALS(inds1);
            %
            %
            %             behavAndVids = [behavTRIALS(:) , vidTRIALS(:)]
            % %             tmp5 = sort(behavAndVids);
            %
            behavTrialsInVidINDSALL{FT} = videoNumsActual;% the inds are the trial number and the values
            % are hte video name number
            numsFromVidALL{FT} = numsFromVid;
            
        end
        
        
    end
end


