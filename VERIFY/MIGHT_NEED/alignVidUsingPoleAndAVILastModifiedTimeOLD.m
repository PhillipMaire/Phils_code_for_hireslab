
%{

behavFILE = 'Z:\Users\Phil\Data\Behavior\AH1017\data_@pole_contdiscrim_obj_AH1017_190505a.mat';
videoLOCATION = 'X:\Video\PHILLIP\AH1017\190505\Camera 1';
tic
[behavTrialsInVidINDS] = alignVidUsingPoleAndAVILastModifiedTime(behavFILE, videoLOCATION)
toc

%}
%%
function [behavTrialsInVidINDSALL] = alignVidUsingPoleAndAVILastModifiedTime(behavFILE, videoLOCATION)
behavTrialsInVidINDSALL = {nan, nan};
%% get varibles set up
FTname = {'seq', 'AVI_'};
for FT = 1:2
    cd(videoLOCATION)
    %     try
    tmp1 = struct2cell(dir(['*',FTname{FT} ,'ListAndInfoForAligning.mat']));
    %     catch
    %     end
    if ~isempty(tmp1)
        [~, indToMostRecent]= max(cell2mat(tmp1(6, :)));
        tmp2  = load( tmp1{1, indToMostRecent});
        if FT == 2
            avi_list = struct2cell(tmp2.AVIlist);
        elseif FT ==1
            avi_list = struct2cell(tmp2.seqList);
        end
        startInd = cell2mat(strfind(avi_list(1, :), '-')) +1;
        for k =1 :size(avi_list, 2)
            numsFromVid(k) = str2num(avi_list{1, k}(startInd(k):end-4));
        end
        [date1, date1ind] = sort(cell2mat(avi_list(end, :)));
        if ~isempty(date1)
            numsFromVid = numsFromVid(date1ind);
            timeBetTrials = round(diff(date1)*60*60*24);
            %%  load beahvior data and set up stuff from there
            behav = load(behavFILE);
            polePos = behav.saved.MotorsSection_previous_pole_positions;
            SM = behav.saved_history.RewardsSection_LastTrialEvents;
            %% get the cam trigger times for each trial
            allCamTrigTimes = [];
            triggered = 0;
            for k = 1:length(SM)
                tmp1 = SM{k};
                FirstSpot = find(tmp1(:,1) == 101);?
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
            %%
            vidTimes = [0, cumsum(timeBetTrials)];% cumlative video time starting at 0
            refTime = allCamTrigTimes(firstInd); % 0 point corresponidng to the trigger of the first video
            % this could be wrong if you didnt trigger the video from the first time I think that if it is this
            % program will still work but will be with a lagshift of some x number of trials. can use pole
            % position to determine this lagshift jsut want to make array same size as pole and use nan where
            % ther is a pole and there is no video trial number( shoud be none though )
            allCamTrigTimes =allCamTrigTimes- refTime; %pulled from SM form behavior these correspond to all the
            %101 states which is when the camer is triggered. this is the sate that the vidoe file get in their
            %'last modified' section despite that this make no sense I tested it. so these are the dates I have
            %in the mat called AVIListAndInfoForAligning above.
            diffMat = vidTimes(:)' - allCamTrigTimes(:);
            [allMin, allInds] = min(abs(diffMat), [], 2);% these are all the min times for eaach trial and their
            % inds, note that there will be doubles here if there are more behavior files than vidoe files, thats normal.
            [~, sortedInds] = sort(allMin); %these are the inds to the min subtracted times but sorted.
            % we only want to bet matching ones for each trial (to get rid of the doubles mentioned above)
            behavTrialsInVidINDS = sortedInds(1:length(unique(allInds))); %take 1 thorugh the length of all
            %vide length to get the true inds
            behavTrialsInVidINDSALL{FT} = sort(behavTrialsInVidINDS);% sort them so they're not all jumbled up. <3
            
            
            
            
        end
        
        
    end
end










