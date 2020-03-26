%% save the U array

% saveName = 'U_cells_180116'
% save(saveName,'U','-v7.3');
%
%
%
% %%
% clear U
% layer = 'S2BadContacts';
% cellNum = [1 7 8];
% trialCutoffs = repmat([1 999],numel(cellNum),1);
% %%%%set cvariable here to rename the U to a specific name that way we can
% %%%%have all the data here at onece
%
%%
allCONTACTS = dir('Z:\Users\Phil\Data\Characterization\LESION_EXPERIMENTS\AC_CONTACTS\*.mat')

layer = 'LESION_EXPERIMENTS';
for k = 1:length(allCONTACTS)
    tmpName = allCONTACTS(k).name;
    ind1 = strfind(tmpName, 'ConTA_') + length('ConTA_') ;
    ind2 = strfind(tmpName, '.mat')- 1;
    cellNumsFromWrapper{k} = tmpName(ind1:ind2);
    
end

 cellNumsFromWrapper = transpose({'999';'1000';'1006';'1007';'1008';'1009';'1013';'1014';'1015';'1016';'1017';'1018';'1019';'1020';'1021';'1023'})
k

%%
% clear U
% layer = 'LESION_EXPERIMENTS';
% cellNumsFromWrapper = [1000, 1006, 1007, 1008, 1009, 1013, 1014, 1015, 1016, 1017];
trialCutoffs = repmat([1 1024],numel(cellNumsFromWrapper),1);
% %%%%set cvariable here to rename the U to a specific name that way we can
% %%%%have all the data here at onece


%%
dateString1 = datestr(now,'yymmdd_HHMM');

for cellStep = 1:length(cellNumsFromWrapper)
    clearvars -except cellStep cellNumsFromWrapper layer trialCutoffs k dateString1
    %loadSUDataFinalizedJC(cellNum(cellStep), SU)
    directory = 'Z:\Users\Phil\Data\Characterization\';
    
    cd([directory layer '\TArrays'])
    load(['trial_array_' num2str(cellNumsFromWrapper{cellStep}) '.mat'])
    cd([directory layer '\AC_CONTACTS'])
    load(['ConTA_' num2str(cellNumsFromWrapper{cellStep}) '.mat'])
    
    d.varNames = {'thetaAtBase', 'velocity', 'amplitude', 'setpoint', 'phase', ...
        'deltaKappa','M0Adj','FaxialAdj', 'firstTouchOnset', 'firstTouchOffset', ...
        'firstTouchAll', 'lateTouchOnset','lateTouchOffset','lateTouchAll','PoleAvailable','beamBreakTimes'}
    d.cellNum = cellNumsFromWrapper{cellStep}
    
    d.t = max(cellfun(@(x)round(x.whiskerTrial.time{1}(end)*1000)+1,T.trials(T.whiskerTrialInds)));
    
    %     d.t = max([cellfun(@(x)numel(x.whiskerTrial.theta{1}),T.trials(T.whiskerTrialInds)) ...
    %        cellfun(@(x)numel(x.whiskerTrial.time{1}),T.trials(T.whiskerTrialInds))] );
    %    [~,useTrials] = intersect(T.trialNums,UgoodtrialnumsCrop{cellStep});
    [~,useTrials] = intersect(T.trialNums,T.whiskerTrialNums);
    useTrials = useTrials(useTrials >= trialCutoffs(cellStep,1) & useTrials <= trialCutoffs(cellStep,2));
    
    d.k = length(useTrials);
    d.u = 1;
    d.c = 16;
    d.S_ctk = nan(d.c, d.t, d.k);
    d.R_ntk = zeros(1, d.t, d.k);
    %%%%how do i shift just the video and measurements without shifitng
    %%%%everything else? and make it work well so that peopple dont have to
    %%%%worry about it.
    
    useTrials = useTrials(:)';
    traj = 1;
    %% added by phil 180406 to ignore videos where the whisker fails to track too many frames in a row
    tooManyNansTest = [];nanTest = []; test4000 = [];
    for i = 1:length(useTrials);
        timeIdx = round(T.trials{useTrials(i)}.whiskerTrial.time{traj}*1000)+1;
        
        
        theta = nan(1,d.t);
        theta(timeIdx) = T.trials{useTrials(i)}.whiskerTrial.thetaAtBase{traj};
        
        winSizeOfNansMax = 4; % must be even;
        nanW1 = winSizeOfNansMax /2;
        nanidx = find(isnan(theta));
        nanidx = nanidx(nanidx > nanW1 & nanidx < length(timeIdx)-nanW1);
        for j = nanidx
            if j>=(4000-nanW1)
                theta(j)=nanmean(theta(j+[-nanW1:0]));
            else
                theta(j) = nanmean(theta(j+[-nanW1:nanW1]));
            end
        end
        
        nanTest(i) = isempty(find(isnan(theta)));
        test4000(i) = length(T.trials{useTrials(i)}.whiskerTrial.time{:}) ==4000;
        
    end
    tooManyNansTest = nanTest(:) .* test4000(:);
    
    if sum(tooManyNansTest(:))/length(tooManyNansTest(:)) ~= 1
        tmp = find(tooManyNansTest ==0);
        tmp2 = length(tmp);
        
        fprintf('%d %s',tmp2,'trials were discounted becasue too many nans in a row OR not 4000 whisker tracking points total, these trials where' );
        for oopsss = 1:tmp2
            disp(['Trial Number ',num2str(useTrials(tmp(oopsss)))]);
        end
    end
    useTrials = useTrials(tooManyNansTest==1);
    %%
    d.k = length(useTrials);
    d.u = 1;
    d.c = 16;
    d.S_ctk = nan(d.c, d.t, d.k);
    d.R_ntk = zeros(1, d.t, d.k);
    %%%%how do i shift just the video and measurements without shifitng
    %%%%everything else? and make it work well so that peopple dont have to
    %%%%worry about it.
    
    useTrials = useTrials(:)';
    %%
    for i = 1:length(useTrials);
        display(i)
        timeIdx = round(T.trials{useTrials(i)}.whiskerTrial.time{traj}*1000)+1;
        
        
        theta = nan(1,d.t);
        theta(timeIdx) = T.trials{useTrials(i)}.whiskerTrial.thetaAtBase{traj};
        
        %          winSizeOfNansMax = 8; % must be even;  SET A FEW LINES ABOVE
        %         nanW1 = winSizeOfNansMax /2;
        nanidx = find(isnan(theta));
        nanidx = nanidx(nanidx > nanW1 & nanidx < length(timeIdx)-nanW1);
        for j = nanidx
            if j>=3999
                theta(j)=nanmean(theta(j+[-nanW1:0]));
            else
                theta(j) = nanmean(theta(j+[-nanW1:nanW1]));
            end
        end
        
        firstTouchOn    = [];
        firstTouchOff   = [];
        firstTouchAll   = [];
        
        lateTouchOn     = [];
        lateTouchOff    = [];
        lateTouchAll    = [];
        
        
        numContactsTest = contacts{useTrials(i)}.contactInds{1};
        if isstr(numContactsTest) ||  isempty(numContactsTest) %if auto curator marked it as a non touch in preliminary sweep or if no touches
            segmentsTMP = [];
        else
            diffDetect = numContactsTest(:) - (1:length(numContactsTest))';
            [startNums , uniqueInds,~] = unique(diffDetect);
            startNums = numContactsTest(uniqueInds);
            lengthArray = circshift(uniqueInds, -1) - uniqueInds;
            lengthArray(end) = 1+length(numContactsTest)-uniqueInds(end);
            segmentsTMP = [startNums(:) , startNums(:)+lengthArray(:)-1];
            
        end
        contacts{useTrials(i)}.segmentInds{traj} =segmentsTMP;
        
        
        %%%%DONT USE THE BELOW FOR NOW -- NEED TO CHECK IF YOU SHOULD SHIFT
        %%%%THIS STUFF VVVVVVVVV
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
    
    %end
    
    
    d.S_ctk(15,1:min(find(nansum(squeeze(d.S_ctk(9,:,:))')))-1,:)= 0;  % define pole availablitity onset
    
    
    
    
    for i =1:length(useTrials);
        spiketimes = round(T.trials{useTrials(i)}.spikesTrial.spikeTimes/10-T.whiskerTrialTimeOffset*1000);
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
    
    
    
    %answer licks made to be amat of numbers and nans, where the numbers
    %are shuifted based on -T.whiskerTrialTimeOffset
    answerLicks = cellfun(@(x)x.behavTrial.answerLickTime-T.whiskerTrialTimeOffset     ,T.trials(useTrials), 'UniformOutput', false);
    answerLicksEmptyIndex = cellfun(@isempty,answerLicks);
    answerLicks(answerLicksEmptyIndex) = {nan(1)};
    U{cellStep}.meta.answerLickTime   = cell2mat(answerLicks);
    
    %need to make thie beam break times into a matrix having throuble cause
    %the different sizes
    
    
    
    beamBreakTimesCell = cellfun(@(x)x.beamBreakTimes-T.whiskerTrialTimeOffset     ,T.trials(useTrials), 'UniformOutput', false);
    %shift dem lick dawwwwwg VVV
    beamBreakTimesMat   = cellNums2MatWithNansOrZerosTranslated(beamBreakTimesCell,'nan')-T.whiskerTrialTimeOffset;
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
    %     U{cellStep}.meta.cellName          = SU.cellName{cellNum(cellStep)};
    %    % U{cellStep}.meta.recordingLocation = SU.recordingLocation{cellNum(cellStep)};
    U{cellStep}.meta.motorPosition     = cellfun(@(x)x.behavTrial.motorPosition,T.trials(useTrials));
    U{cellStep}.meta.goPosition        = cellfun(@(x)x.behavTrial.goPosition,T.trials(useTrials));
    U{cellStep}.meta.nogoPosition      = cellfun(@(x)x.behavTrial.nogoPosition,T.trials(useTrials));
    U{cellStep}.meta.trialType         = cellfun(@(x)x.behavTrial.trialType,T.trials(useTrials));
    U{cellStep}.meta.trialCorrect      = cellfun(@(x)x.behavTrial.trialCorrect,T.trials(useTrials));
    U{cellStep}.meta.layer             = {layer};
    U{cellStep}.meta.ranges            = unique([cellfun(@(x)x.behavTrial.nogoPosition,T.trials(useTrials)),cellfun(@(x)x.behavTrial.goPosition,T.trials(useTrials))]);
    U{cellStep}.meta.sweepArrayName    = {};%SU.sweepArrayName{cellNum(cellStep)};
    U{cellStep}.meta.harddrive         = {};
    % U{cellStep}.meta.C2distance        = sqrt(SU.recordingLocation{cellNum(cellStep)}(1)^2+SU.recordingLocation{cellNum(cellStep)}(2)^2)
    %  U{cellStep}.meta.isC2              = SU.distance{cellNum(cellStep)} < .16;
    % U{cellStep}.meta.isPV              = SU.isU{cellNum(cellStep)};
    U{cellStep}.meta.manipulation      = {};
    U{cellStep}.meta.performingTrials  = [];
    U{cellStep}.meta.performance       = [];
    U{cellStep}.meta.stimTrials        = {};
    U{cellStep}.whisker.follicleX      = cellfun(@(x)x.whiskerTrial.follicleCoordsX,T.trials(useTrials));
    U{cellStep}.whisker.follicleY      = cellfun(@(x)x.whiskerTrial.follicleCoordsY,T.trials(useTrials));
    U{cellStep}.whisker.barPos         = cellfun(@(x)x.whiskerTrial.barPos,T.trials(useTrials),'UniformOutput',false);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%VARIABLES THAT I DON'T KNOW -PSM
    %     U{cellStep}.meta.SUnum             = cellNum(cellStep)
    
    
    %     U{cellStep}.meta.trialArrayName    = SU.trialArrayName{cellNum(cellStep)}
    %   %  U{cellStep}.meta.behaviorArrayName = contactsArrayNameSU.behaviorArrayName{cellNum(cellStep)};
    %     U{cellStep}.meta. = SU.contactsArrayName{cellNum(cellStep)};
    
    
    
    
    
    
    U{cellStep}.details.projectDetails = T.projectDetails;
    U{cellStep}.details.mouseName = T.mouseName;
    U{cellStep}.details.sessionName = T.sessionName;
    U{cellStep}.details.cellCode = T.cellCode;
    U{cellStep}.details.cellNum = T.cellNum;
    U{cellStep}.details.whiskerTrialTimeOffset = T.whiskerTrialTimeOffset;
    U{cellStep}.details.depth = T.depth;
    U{cellStep}.details.fractionCorrect = T.fractionCorrect;
    U{cellStep}.details.useTrials = useTrials;
    
    % %     U{cellStep}.details.trialCorrects = T.trialCorrects;%%dont want
    % this cause it isnt trimmed correctly
    
    
    
    
    
    
    
    
end
cd('Z:\Users\Phil\Data\Characterization\LESION_EXPERIMENTS');

try
    yay
catch
    display('DONE');
end
saveName = ['U_cells_', dateString1]
save(saveName,'U', 'cellNumsFromWrapper','-v7.3');