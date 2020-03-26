%% save the U array

% saveName = 'U_cells_180116'
% save(saveName,'U','-v7.3');
%
%
%
% %%stamp

% clear U

% %%%%set cvariable here to rename the U to a specific name that way we can
% %%%%have all the data here at onece
%
%%

% for k = 1: length(allCONTACTS)
%
%     newCell{k} = allCONTACTS(k).CellNumber;
%
% end
% cellNumsFromWrapper = newCell;


%%
clear U
close all hidden
% cellNumsFromWrapper = {'1' '2' '5' '6' '7' '8' '9' '10' '11' '12' '14' '15' '16A' '16B' '17' '18' ...
%     '21' '22' '23' '24' '25' '26' '27' '28' '29' '30' '33A' '33B' '35' '37' '39' '40' '41' '42'  ...
%     '43' '44' '45' '46'  '47' '48' '49' '50'  '51' '51B' '52'}

% cellNumsFromWrapper = {'2001' '2003' '2003' '2004' '2006' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' }



% cellNumsFromWrapper = {'1' '2' '5' '6' '7' '8' '9' '10' '11' '12' '14' '15' '16A' '17' '18' ...
%     '21' '22' '23' '24' '25' '26' '27' '28' '29' '33A' '33B' '35' '37' '39' '40' '41' '42'  ...
%     '43' '44' '45' '46'  '47' '48' '49' '50'  '51' '51B' '52'}



% cellNumsFromWrapper = { '2' '5' '6' '7' '8' '9' '10' '14' '15' '16A' '17' '18' ...
%     '21' '22' '23' '24' '25' '26' '27' '28' '29' '33A' '35' '37' '39' '40' '41' '42'  ...
%     '43' '45' '46'  '47' '48' '49' '50'  '51'}


% % cellNumsFromWrapper = {'26' '27' '28' '29' '30' '33A' '35' '37' '40' '41' '42'  ...
% %     '43' '45' '46'  '47' '48' '49' '50'  '51' '52'}%based on the auto curator contacts done now
% cellNumsFromWrapper = {'14' '21' '41'}


characterizationDir = 'C:\Users\maire\Dropbox\HIRES_LAB\PHIL\Data\Characterization\';
folderDir = 'S1ForJon2';
% %% based on the trial arrays
% cd([characterizationDir, filesep,folderDir, filesep  'TArrays'])
% tmp1 = struct2cell(dir('trial_array_*'));
% cellNumsFromWrapper = {}
% for k = 1:size(tmp1, 2)
%     tmp2 = tmp1{1, k};
%     ind1 = strfind(tmp2 , 'trial_array_') + length('trial_array_');
%     ind2 = strfind(tmp2, '.mat')- 1;
%
%     cellNumsFromWrapper{end+1} = tmp2(ind1:ind2);
% end
% trialCutoffs = repmat([1 1100],numel(cellNumsFromWrapper),1);
%% based on the contacts
cd([characterizationDir, filesep,folderDir, filesep  'Contacts'])
tmp1 = struct2cell(dir('ConTA_*'));
cellNumsFromWrapper = {};
for k = 1:size(tmp1, 2)
    tmp2 = tmp1{1, k};
    ind1 = strfind(tmp2 , 'ConTA_') + length('ConTA_');
    ind2 = strfind(tmp2, '.mat')- 1;
    
    cellNumsFromWrapper{end+1} = tmp2(ind1:ind2);
end
trialCutoffs = repmat([1 1100],numel(cellNumsFromWrapper),1);










StimTrialMatsLocation = 'C:\Users\maire\Desktop\StimTrialMats';
%LEAVE OFF SLASH AT END
%place to save the ehus analysis to check for stim trials
% % trialCutoffs = repmat([1 1024],numel(cellNum),1);
%%%%set cvariable here to rename the U to a specific name that way we can
%%%%have all the data here at onece
%%%%

% % % % % finalDir = [characterizationDir, folderDir, '\Tarrays'];
% % % % %
% % % % % dirlistTarrays = dir(finalDir);
% % % % % cellNumsFromWrapper = cell(0);
% % % % % for k = 1:length(dirlistTarrays)
% % % % %     if ~dirlistTarrays(k).isdir
% % % % %         dotIndex = strfind(dirlistTarrays(k).name, '.mat');
% % % % %         cellNumsFromWrapper{end+1} = dirlistTarrays(k).name(13:dotIndex-1);
% % % % %     end
% % % % % end
% % % % % cellNumsFromWrapper



allCellString = strjoin(cellNumsFromWrapper, '_');


dateString = datestr(now,'yymmdd_HHMM');
saveName = ['U_', dateString]
saveNameTryThisFirst = [saveName, allCellString];
%%
progressWin3 = waitbar(0, ['total of ', num2str(length(cellNumsFromWrapper)), ' cells to process']);
progressWin2 =  waitbar(0,'starting program ');
movegui(progressWin3,'north')
for cellStep = 1:length(cellNumsFromWrapper)
    
    clearvars -except   allCONTACTS   cellNumberForProject   catchcell k cellNumberForProjectString progressWin3  progressWin2 cellStep ...
        cellNumsFromWrapper characterizationDir folderDir StimTrialMatsLocation trialCutoffs saveName ...
        saveNameTryThisFirst dateString allCellString finalDir U
    waitbar(0,progressWin2, ['loading cell ', num2str(cellNumsFromWrapper{cellStep})])
    cd([characterizationDir filesep folderDir '\TArrays'])
    load(['trial_array_' num2str(cellNumsFromWrapper{cellStep}) '.mat'])
    cd([characterizationDir folderDir '\Contacts'])
    % % %     cd('Z:\Users\Phil\Data\Characterization\AUTOCURATED_CONTA\Most_Updated')
    load(['ConTA_' num2str(cellNumsFromWrapper{cellStep}) '.mat'])
    clear d %d is saved variable for directory need to remove it
    d.varNames = {'thetaAtBase', 'velocity', 'amplitude', 'setpoint', 'phase', ...
        'deltaKappa','M0Adj','FaxialAdj', 'firstTouchOnset', 'firstTouchOffset', ...
        'firstTouchAll', 'lateTouchOnset','lateTouchOffset','lateTouchAll','PoleAvailable','beamBreakTimes'};
    d.cellNum = cellNumsFromWrapper{cellStep};
    
    d.t = max(cellfun(@(x)round(x.whiskerTrial.time{1}(end)*1000)+1,T.trials(T.whiskerTrialInds)));
    
    
    %%%%THIS SECTION IS FOR FINDING AND REMOVING STIM TRIALS
    cd(StimTrialMatsLocation) %used to load (or create if this is the first time) list of stim trials
    stimTrialvar = ['stimTrials_EPHUS_', T.trials{1, 1}.cellNum];
    if exist([StimTrialMatsLocation,filesep, stimTrialvar, '.mat'], 'file') == 2
        load([StimTrialMatsLocation,filesep, stimTrialvar, '.mat']);
    else
        disp('looking for stim trials');
        %         cd(['C:\Users\maire\Dropbox\HIRES_LAB\PHIL\Data\EPHUS\', T.trials{1, 1}.mouseName, ...
        %             filesep, T.trials{1, 1}.cellNum, filesep])
        cd(['C:\Users\maire\Dropbox\HIRES_LAB\PHIL\Data\EPHUS\', ...
            filesep, T.trials{1, 1}.cellNum, filesep])
        
        allXSG =  struct2cell(dir ('*.xsg'));
        
        progressWin = waitbar(0,'loading XSG files... will save so only have to do this once');
        for k = 1:size(allXSG,2)
            waitbar(k./size(allXSG,2),progressWin)
            xsgName = allXSG{1,k};
            load(xsgName, '-mat');
            %%%%##### NOTE THAT THE NUMBER HERE --> header.stimulator.stimulator.pulseNameArray(4)
            %%%%##### IS THE ONY SECTION THAT IT LOOKS IN SO IF YOU HAVE STIM PARAMETERS FRO M
            %%%%##### OTHER AREAS PLEASE EDIT
            testIfStim(1,k) = header.stimulator.stimulator.pulseNameArray(4);
            testIfStim{2,k} = xsgName(end-7:end-4);%number
            testIfStim{4,k} = xsgName(end-11:end-8);% cell name ie AAAA or AAAB
            %%%%
            if ~isempty(strfind(testIfStim{1, k}, '10'))
                testIfStim{3, k} = 1;
            elseif ~isempty(strfind(testIfStim{1, k}, 'full'))%full power
                testIfStim{3, k} = 2;
            elseif ~isempty(strfind(testIfStim{1, k}, '2sec@T=1_5'))
                testIfStim{3, k} = 3;
            elseif ~isempty(strfind(testIfStim{1, k}, 'nothing'))
                testIfStim{3, k} = -1;
            else
                testIfStim{3, k} = 0;
                warning('somthing weird happened look at this')
                testIfStim{1, k}
                keyboard
            end
        end
        close(progressWin);
        for kk = 1:size(testIfStim, 2)
            actualEPHUSnumsREF(kk) = str2num(testIfStim{2,kk});
        end
        isStimStruct.actualEPHUSnumsREF = actualEPHUSnumsREF;
        isStimStruct.testIfStim = testIfStim;
        isStimStruct.stimON = find(cell2mat(testIfStim(3, :))>0);
        isStimStruct.stimOFF = find(cell2mat(testIfStim(3, :))<0);
        isStimStruct.stimUNKNOWN = find(cell2mat(testIfStim(3, :))==0);
        isStimStruct.stimONtrialRef = actualEPHUSnumsREF(isStimStruct.stimON);
        isStimStruct.stimOFFtrialRef = actualEPHUSnumsREF(isStimStruct.stimOFF);
        isStimStruct.stimUNKNOWNtrialRef = actualEPHUSnumsREF(isStimStruct.stimUNKNOWN);
        save([StimTrialMatsLocation,filesep, stimTrialvar], 'isStimStruct');
    end
    %%%%END ... SECTION IS FOR FINDING AND REMOVING STIM TRIALS
    
    
    %     d.t = max([cellfun(@(x)numel(x.whiskerTrial.theta{1}),T.trials(T.whiskerTrialInds)) ...
    %        cellfun(@(x)numel(x.whiskerTrial.time{1}),T.trials(T.whiskerTrialInds))] );
    %    [~,useTrials] = intersect(T.trialNums,UgoodtrialnumsCrop{cellStep});
    [useTrialsOriginal, indexUseTrials_A, indexUseTrials_B] = intersect(T.trialNums,T.whiskerTrialNums);
    %% THIS SECTION REMOVES TRIALS BASED ON THE USER
    %% this is a hack becasue T arrays dont allow adding without making new class
    %% chose my class project details cause it wont effect anyone else
    %% ALSO NOTE YOU WILL HAVE TO EDIT AND SAVE TARRAYS FOR THIS EFFECT TO TAKE PLACE
    %% reason for originally creating this is because some cells have bad pole positions for a few trials
    %% that I needed to edit out.
    
    %% WARNING
    %% below removes based on the index (useTrials is based on Tarray index not trials) if you want to remove
    %% based on actual trial number or actual ephus file number then you need to adjust.
    
    %% for trial number based on behavior see the intersect function used above to first create the useTrials variable
    %% the numbers it uses as inputs '[~,useTrials] = intersect(T.trialNums,T.whiskerTrialNums);' are actual behavior trial numbers
    %% so you can intercept the use of those numbers and then remove the trials that way
    
    %% for the ephus file number removal you will have to find the ephus file numbers of interest in the Tarray which contains
    %% the EPHUS file numbers here 'T.trials{1}.spikesTrial.xsgFileNum' then find the behavior trials that match the EPHUS numbers
    %% then intercept the creation of useTrials.
    userRemovedTrials = [];
    useTrials = indexUseTrials_A;
    try
        userRemovedTrials = T.projectDetails.trials;
        useTrials = setdiff(useTrials, userRemovedTrials);
    catch
    end
    
    
    % THIS WORKS BECASUE BOTH ARE THE INDICES OF THE EXISTING T ARRAY NOT THE TRIAL NUMBER
    
    %%
    
    
    %%
    useTrials = useTrials(useTrials >= trialCutoffs(cellStep,1) & useTrials <= trialCutoffs(cellStep,2));
    
    %%
    % get the ephus numbers from traay so we can figure out where they live
    % inside the t array so that we can match the Tarray with the ephus numbers
    for allTrialsIter = 1: size(isStimStruct.testIfStim, 2)
        if strcmp(isStimStruct.testIfStim(4, allTrialsIter) , T.trials{1}.cellCode) %test if cell code (ie AAAA) matches the current cell
            actualXSGnumbers(allTrialsIter) = str2num(isStimStruct.testIfStim{2, allTrialsIter});
        end
    end
    % get the XSG file numbers that are stored in the T array to be associated
    % with each trial
    for allCellTrialsIter = 1: length(T.trials)
        TarrayXSGnumber(allCellTrialsIter) = T.trials{allCellTrialsIter}.spikesTrial.xsgFileNum;
    end
    % indicates if stim or not. in the ephus index
    isStimMat = cell2mat( isStimStruct.testIfStim(3, :));
    % in ephus index but logical
    isStimInds = find(isStimMat>0);
    % remove the stim trials that aren't for this cell
    lessThanTheMax = find(isStimInds<=max(find(actualXSGnumbers)));
    moreThanTheMin = find(isStimInds>=min(find(actualXSGnumbers)));
    isStimInds = isStimInds(intersect(lessThanTheMax, moreThanTheMin));
    % get ephus actual numbers not index
    actualEphusStimNums = actualXSGnumbers(isStimInds);
    % % % % %     % remove the zeros that are from another cell
    % % % % %     actualEphusStimNums = actualEphusStimNums(actualEphusStimNums~=0);
    % find the indices of those EPHUS stim numbers based on the ehpus number in the Tarray
    % we dont care about the actual trial number just the index in the Tarray because that is what
    % use trials varibale uses
    [~, STIM_ON_TRIALS, ~] = intersect(TarrayXSGnumber, actualEphusStimNums);
    useTrials = setdiff(useTrials, STIM_ON_TRIALS);
    %% save the behavior trials and other trials
    
    % find out which trials were cut from the original
    
    [useTrialsOriginal, indexUseTrials_A, indexUseTrials_B] = intersect(T.trialNums,T.whiskerTrialNums);
    
    [~, indexNotInNew_UseTrials] = setdiff(indexUseTrials_A, useTrials);
    indexUseTrials_B = setdiff(indexUseTrials_B, indexUseTrials_B(indexNotInNew_UseTrials));
    
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %       indexNotInNew_UseTrials is the location index in terms of  useTrialsOriginal where
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %       the trials were removed. so because
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 1) the Originalindexes and original trial numes were generated together
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 2) they are the same length
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 3) all the numbers in the original (included the ones that were removed, obviously)
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %    how a corresponding index in indexUseTrials_A AND indexUseTrials_B (although they may be different)
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 4) the indexs of the original correspond to the original trial nums so that if we remove the
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %    indexes of the removed trials IN THE ORIGINAL INDEXES -- then we can preserve the original
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %    indexes with respect to the new trialNums
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % %       % modify this--> indexUseTrials_A -- index to match with modified useTrials
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % %       indexUseTrials_A =(setdiff( indexUseTrials_A, indexNotInNew_UseTrials));
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % %       % modify this--> indexUseTrials_B -- index to match with modified useTrials
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % %       indexUseTrials_B =(setdiff( indexUseTrials_B, indexNotInNew_UseTrials));
    
    
    trialNumsUseTrials = T.trialNums(useTrials);
    whiskerTrialNumsUseTrials = T.whiskerTrialNums(indexUseTrials_B);
    
    %%
    d.k = length(useTrials);
    d.u = 1;
    d.c = 16;
    d.S_ctk = nan(d.c, d.t, d.k);
    d.R_ntk = zeros(1, d.t, d.k);
    %%%%how do i shift just the video and measurements without shifitng
    %%%%everything else? and make it work well so that peopple dont have to
    %%%%worry about it.
    T.trials{1}.spikesTrial.xsgFileNum;
    
    
    useTrials = useTrials';
    traj = 1;
    
    
    timeStamps = zeros(1,length(useTrials));
    timeStampsContacts = zeros(1,length(useTrials));
    for i = 1:length(useTrials)
        timeStamps(i) = length(round(T.trials{useTrials(i)}.whiskerTrial.time{1}*1000)+1);
        if ~isempty(contacts{useTrials(i)})
        timeStampsContacts(i) = length(contacts{useTrials(i)}.M0combo{1});
        end
    end
    useTrials = useTrials(timeStamps == timeStampsContacts);
    
    waitbar(0, progressWin2, ['compiling cell ', num2str(cellNumsFromWrapper{cellStep})]);
    for i = 1:length(useTrials);
        waitbar(i/length(useTrials), progressWin2);
        timeIdx = round(T.trials{useTrials(i)}.whiskerTrial.time{traj}*1000)+1;
        
        
        theta = nan(1,d.t);
        theta(timeIdx) = T.trials{useTrials(i)}.whiskerTrial.thetaAtBase{traj};
        
        nanidx = find(isnan(theta));
        nanidx = nanidx(nanidx > 2 & nanidx < length(timeIdx)-2);
        for j = nanidx
            if j>=3999
                theta(j)=nanmean(theta(j+[-2:0]));
            else
                theta(j) = nanmean(theta(j+[-2:2]));
            end
        end
        
        firstTouchOn    = [];
        firstTouchOff   = [];
        firstTouchAll   = [];
        
        lateTouchOn     = [];
        lateTouchOff    = [];
        lateTouchAll    = [];
        
        if isfield(contacts{useTrials(i)},'segmentInds')
            if ~isempty(contacts{useTrials(i)}.segmentInds{traj})
                firstTouchOn  = round(1000*T.trials{useTrials(i)}.whiskerTrial.time{traj}(contacts{useTrials(i)}.segmentInds{traj}(1,1)));
                firstTouchOff = round(1000*T.trials{useTrials(i)}.whiskerTrial.time{traj}(contacts{useTrials(i)}.segmentInds{traj}(1,2)));
                firstTouchAll = round(1000*T.trials{useTrials(i)}.whiskerTrial.time{traj}(contacts{useTrials(i)}.segmentInds{traj}(1,1):contacts{useTrials(i)}.segmentInds{traj}(1,2)));
                
                if size(contacts{useTrials(i)}.segmentInds{traj},1)>1
                    lateTouchOn  = round(1000*T.trials{useTrials(i)}.whiskerTrial.time{traj}(contacts{useTrials(i)}.segmentInds{traj}(2:end,1)));
                    lateTouchOff = round(1000*T.trials{useTrials(i)}.whiskerTrial.time{traj}(contacts{useTrials(i)}.segmentInds{traj}(2:end,2)));
                    
                    for j = 2:size(contacts{useTrials(i)}.segmentInds{traj},1)
                        lateTouchAll = cat(2,lateTouchAll,round(1000*T.trials{useTrials(i)}.whiskerTrial.time{traj}(contacts{useTrials(i)}.segmentInds{traj}(j,1):contacts{useTrials(i)}.segmentInds{traj}(j,2))));
                    end
                    
                end
            end
        end
        
        [hh amplitude  filteredSignal setpoint amplitudeS setpointS phase phaseS] =  SAHWhiskerDecomposition(theta);
        
        % if you want to use the S_ctk 15 then make sure this is correct
        % remember though that it will be different for different animals
        % so maybe its best not to use this
        travelIn = 0;
        travelOut = 250;
        
        vel = diff([0 theta])/.001;
        
        pinIn = round(1000*T.trials{useTrials(i)}.pinDescentOnsetTime + travelIn);
        pinOut = min([d.t round(1000*T.trials{useTrials(i)}.pinAscentOnsetTime + travelOut)]);
        
        d.S_ctk(1,:,i) = theta;%feature from VIDEO
        d.S_ctk(2,:,i) = vel;%feature from VIDEO
        d.S_ctk(3,:,i) = amplitude;%feature from VIDEO
        d.S_ctk(4,:,i) = setpoint;%feature from VIDEO
        d.S_ctk(5,:,i) = phase;%feature from VIDEO
        d.S_ctk(6,timeIdx,i) = T.trials{useTrials(i)}.whiskerTrial.deltaKappa{traj};%feature from VIDEO
        d.S_ctk(7,timeIdx,i) = contacts{useTrials(i)}.M0comboAdj{traj};%???????
        d.S_ctk(8,timeIdx,i) = contacts{useTrials(i)}.FaxialAdj{traj};%???????
        d.S_ctk(9,firstTouchOn,i) = 1;%feature from VIDEO dont know if shifted though
        d.S_ctk(10,firstTouchOff,i) = 1;%feature from VIDEO dont know if shifted though
        d.S_ctk(11,firstTouchAll,i) = 1;%feature from VIDEO dont know if shifted though
        d.S_ctk(12,lateTouchOn,i) = 1;%feature from VIDEO dont know if shifted though
        d.S_ctk(13,lateTouchOff,i) = 1;%feature from VIDEO dont know if shifted though
        d.S_ctk(14,lateTouchAll,i) = 1;%feature from VIDEO dont know if shifted though
        d.S_ctk(15,:,i) = 0;%?????????????????????
        
        
        d.S_ctk(15,pinIn:pinOut,i) = 1;%feature from BEHAVIOR NOT SHIFTED!!!!!!!!!!!!!!!!!!!!!!
        d.S_ctk(16, ceil(1000*T.trials{useTrials(i)}.beamBreakTimes(T.trials{useTrials(i)}.beamBreakTimes > 0       ...
            &       T.trials{useTrials(i)}.beamBreakTimes < d.t/1000)),i) = 1;%feature from BEHAVIOR NOT SHIFTED!!!!!!!!!!!!!!!!!!!!!!
        
        d.S_ctk(6,setdiff(1:d.t,contacts{useTrials(i)}.contactInds{traj}),i) = 0;
        d.S_ctk(7,setdiff(1:d.t,contacts{useTrials(i)}.contactInds{traj}),i) = 0;
        d.S_ctk(8,setdiff(1:d.t,contacts{useTrials(i)}.contactInds{traj}),i) = 0;
        
        
        
        
        
    end
    
    waitbar(1, progressWin2, ['doing some other stuff with cell ', num2str(cellNumsFromWrapper{cellStep})]);
    
    
    d.S_ctk(15,1:min(find(nansum(squeeze(d.S_ctk(9,:,:))')))-1,:)= 0;  % define pole availablitity onset
    
    
    
    
    for i =1:length(useTrials);
        spiketimes = round(T.trials{useTrials(i)}.spikesTrial.spikeTimes ./ 10-T.whiskerTrialTimeOffset*1000);
        spiketimes = spiketimes(spiketimes>0 & spiketimes <=d.t);%%%%
        % had this fremoving the end of the spikes but i dont necesarily wan to do
        % that
        % % % spiketimes = spiketimes(spiketimes>0);
        d.R_ntk(1,spiketimes,i) = 1;
    end
    
    U{cellStep} = d;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%VARIABLES THAT NEED TO BE SHIFTED!!!!!!!!!!!!!!!!!!!!!!!!!!
    %%also spikes which are above%%%
    
    %WE SHIFT ALL OF THESE IN THIS PROCESS -PSM
    
    U{cellStep}.meta.poleOnset                 = cellfun(@(x)x.behavTrial.pinDescentOnsetTime,T.trials(useTrials))-T.whiskerTrialTimeOffset;
    U{cellStep}.meta.poleOffset                = cellfun(@(x)x.behavTrial.pinAscentOnsetTime ,T.trials(useTrials))-T.whiskerTrialTimeOffset;
    U{cellStep}.meta.trialStartTime                = cellfun(@(x)x.behavTrial.trialStartTime ,T.trials(useTrials))-T.whiskerTrialTimeOffset;
    
    
    
    
    U{cellStep}.meta.samplingPeriodTime        = cellfun(@(x)x.behavTrial.samplingPeriodTime-T.whiskerTrialTimeOffset ,T.trials(useTrials),'UniformOutput', false);
    U{cellStep}.meta.answerPeriodTime        = cellfun(@(x)x.behavTrial.answerPeriodTime-T.whiskerTrialTimeOffset ,T.trials(useTrials),'UniformOutput', false);
    % % %     U{cellStep}.meta.answerLickTime            = cellfun(@(x)x.behavTrial.answerLickTime-T.whiskerTrialTimeOffset     ,T.trials(useTrials), 'UniformOutput', false);
    U{cellStep}.meta.beamBreakTimes            = cellfun(@(x)x.behavTrial.beamBreakTimes-T.whiskerTrialTimeOffset     ,T.trials(useTrials), 'UniformOutput', false);
    U{cellStep}.meta.drinkingTime            = cellfun(@(x)x.behavTrial.drinkingTime-T.whiskerTrialTimeOffset     ,T.trials(useTrials), 'UniformOutput', false);
    
    
    
    %answer licks made to be a mat of numbers and nans, where the numbers
    %are shuifted based on -T.whiskerTrialTimeOffset
    answerLicks = cellfun(@(x)x.behavTrial.answerLickTime-T.whiskerTrialTimeOffset     ,T.trials(useTrials), 'UniformOutput', false);
    answerLicksEmptyIndex = cellfun(@isempty,answerLicks);
    answerLicks(answerLicksEmptyIndex) = {nan(1)};
    U{cellStep}.meta.answerLickTime   = cell2mat(answerLicks);
    
    
    beamBreakTimesCell = cellfun(@(x)x.beamBreakTimes-T.whiskerTrialTimeOffset     ,T.trials(useTrials), 'UniformOutput', false);
    %already shifted licks based on above
    beamBreakTimesMat   = cellNums2MatWithNansOrZerosTranslated(beamBreakTimesCell,'nan');
    U{cellStep}.meta.beamBreakTimesMat = beamBreakTimesMat';
    U{cellStep}.meta.beamBreakTimesCell = beamBreakTimesCell;
    
    %couldnt figure out a better way to do this
    %so had to use for loop just putting the timeout periods into a
    %mat and then subtracting delays
    timeoutPeriodTimes = cellfun(@(x)x.behavTrial.timeoutPeriodTimes,T.trials(useTrials), 'UniformOutput', false);
    for k = 1:numel(timeoutPeriodTimes)
        try
            temp1(k) = timeoutPeriodTimes{k}{1}(1)-T.whiskerTrialTimeOffset;
            temp2(k) = timeoutPeriodTimes{k}{1}(2)-T.whiskerTrialTimeOffset;
        catch
            temp1(k) = nan(1);
            temp2(k) = nan(1);
        end
    end
    
    U{cellStep}.meta.timeoutPeriodStart = temp1;
    U{cellStep}.meta.timeoutPeriodEnd = temp2;
    
    clear temp1 temp2
    
    
    
    %%%%%%%%ABOVE ARE SHIFTED%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %%%%%%VARIABLES THAT DON'T NEED TO BE SHIFTED!!!!!!!!!!!!!!!!!!!!
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %     U{cellStep}.meta.cellName          = SU.cellName{cellNum{cellStep}};
    %    % U{cellStep}.meta.recordingLocation = SU.recordingLocation{cellNum{cellStep}};
    U{cellStep}.meta.motorPosition     = cellfun(@(x)x.behavTrial.motorPosition,T.trials(useTrials));
    U{cellStep}.meta.goPosition        = cellfun(@(x)x.behavTrial.goPosition,T.trials(useTrials));
    U{cellStep}.meta.nogoPosition      = cellfun(@(x)x.behavTrial.nogoPosition,T.trials(useTrials));
    U{cellStep}.meta.trialType         = cellfun(@(x)x.behavTrial.trialType,T.trials(useTrials));
    U{cellStep}.meta.trialCorrect      = cellfun(@(x)x.behavTrial.trialCorrect,T.trials(useTrials));
    U{cellStep}.meta.folderDir             = {folderDir};
    U{cellStep}.meta.ranges            = unique([cellfun(@(x)x.behavTrial.nogoPosition,T.trials(useTrials)),cellfun(@(x)x.behavTrial.goPosition,T.trials(useTrials))]);
    U{cellStep}.meta.rangesAll            = [cellfun(@(x)x.behavTrial.nogoPosition,T.trials(useTrials));cellfun(@(x)x.behavTrial.goPosition,T.trials(useTrials))];
    U{cellStep}.meta.sweepArrayName    = {};%SU.sweepArrayName{cellNum{cellStep}};
    U{cellStep}.meta.harddrive         = {};
    % U{cellStep}.meta.C2distance        = sqrt(SU.recordingLocation{cellNum{cellStep}}(1)^2+SU.recordingLocation{cellNum{cellStep}}(2)^2)
    %  U{cellStep}.meta.isC2              = SU.distance{cellNum{cellStep}} < .16;
    % U{cellStep}.meta.isPV              = SU.isU{cellNum{cellStep}};
    U{cellStep}.meta.manipulation      = {};
    U{cellStep}.meta.performingTrials  = [];
    U{cellStep}.meta.performance       = [];
    U{cellStep}.meta.stimTrials        = {};
    %     U{cellStep}.whisker.follicleX      = cellfun(@(x)x.whiskerTrial.follicleCoordsX,T.trials(useTrials));
    %     U{cellStep}.whisker.follicleY      = cellfun(@(x)x.whiskerTrial.follicleCoordsY,T.trials(useTrials));
    tmpVar  = cellfun(@(x)x.whiskerTrial.barPos,T.trials(useTrials),'UniformOutput',false);
    for barFillIn = 1:size(tmpVar,2)
        barPositionTrimmed{barFillIn} = tmpVar{barFillIn}(1,2:3);
    end
    U{cellStep}.whisker.barPos = barPositionTrimmed;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%VARIABLES THAT I DON'T KNOW IF THEY NEED TO BE SHIFTED -PSM
    %     U{cellStep}.meta.SUnum             = cellNum{cellStep}
    
    
    %     U{cellStep}.meta.trialArrayName    = SU.trialArrayName{cellNum{cellStep}}
    %   %  U{cellStep}.meta.behaviorArrayName = contactsArrayNameSU.behaviorArrayName{cellNum{cellStep}};
    %     U{cellStep}.meta. = SU.contactsArrayName{cellNum{cellStep}};
    
    
    
    
    
    
    U{cellStep}.details.projectDetails = T.projectDetails;
    U{cellStep}.details.mouseName = T.mouseName;
    U{cellStep}.details.sessionName = T.sessionName;
    U{cellStep}.details.cellCode = T.cellCode;
    U{cellStep}.details.cellNum = T.cellNum;
    U{cellStep}.details.whiskerTrialTimeOffset = T.whiskerTrialTimeOffset;
    U{cellStep}.details.depth = T.depth;
    U{cellStep}.details.fractionCorrect = T.fractionCorrect;
    U{cellStep}.details.useTrials = useTrials;
    U{cellStep}.details.userRemovedTrials = userRemovedTrials;
    U{cellStep}.details.trialNumsUseTrials = trialNumsUseTrials;
    U{cellStep}.details.whiskerTrialNumsUseTrials = whiskerTrialNumsUseTrials;
    % %     U{cellStep}.details.trialCorrects = T.trialCorrects;%%dont want
    % this cause it isnt trimmed correctly
    
    
    
    
    
    
    
    waitbar(cellStep/length(cellNumsFromWrapper),progressWin3);
    
end
close(progressWin2)

try
    disp('making all time units into ms with no decimal points');
    U = msAndRoundUarray(U, 'ms');%turn units into ms time units
    % % % %     REMOVED BELOW CAUSE I CAN ADD LATER AND MAKES Uarray REALLY BIG
    % % % %     disp('adding filters to U array ');
    % % % %     U =  addFiltersToUarray(U);
catch message1
    disp(message1)
    disp('for some reason it broke you should save U array first and close')
    keyboard
end

cd([characterizationDir folderDir]); %want to save it here
display('saving... this may take some time');
% try
%     save(saveNameTryThisFirst,'U','-v7.3')
% catch
saveUname = [characterizationDir, folderDir,filesep, saveName]

waitbar(1,progressWin3, 'saving U array this may take some time');
save(saveName,'U','cellNumsFromWrapper', '-v7.3')
close(progressWin3)

% end
try
    yay
catch
    display('DONE');
end

