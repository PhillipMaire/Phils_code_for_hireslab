%%
fileOfTrialArrays = 'Z:\Users\Phil\Data\Characterization\FINAL TRIAL ARRAYS';


%% get all neuron numbers in a directory
cd(fileOfTrialArrays)
matFiles = dir('*mat');
clear matNames test
for k = 1:size(matFiles, 1)
    matNames{k,1} = matFiles(k).name;
    test2 = strfind(matNames{k}, '_');
    test2 = test2(end);
    test{k} = matNames{k}(test2+1 : strfind(matNames{k}, '.mat')-1);
    %         if ~isempty(strfind(matNames{k}, 'WL.mat'))
    %             counter = counter +1;
    %             wlNames{counter,1} = matNames{k};
    %             wlNums(counter, 1) = str2num(wlNames{counter}(strfind(wlNames{counter}, '-')+1 : strfind(wlNames{counter}, '_')-1));
    %         end
end

cellNumberForProjectString = test
%% ##########OOOOOOORRRRRRRRRR
%% select your onw cells
% cellNumberForProjectString = {'12'}
%% make text file
textFileLoc = 'Y:\Whiskernas\Data\Video\PHILLIP';
dateString = datestr(now,'yymmdd_HHMM')
fid = fopen( [textFileLoc, filesep, 'islagShiftCorrect ', dateString, '.txt'], 'wt' );
%% load cell building var


catchcell = cell(0);
for k = 1:length(cellNumberForProjectString)
    try
        clearvars -except    cellNumberForProject   catchcell k cellNumberForProjectString ...
            fid
        % added to deal with letter endings of a cell name like 16B
        %%%% BELOW literally only used for the figureso not even needed i dont think but no harm in keeping it
        %     [cellNumberForProjectModified, cellNumberForProjectOriginal] = cellNameLetterModify(cellNumberForProjectString{k});
        cellNumberForProjectOriginal = cellNumberForProjectString{k};
        %     cellNumberForProjectOriginal = num2str(cellNumberForProjectOriginal);
        %   try
        buildingVarLoc = ['Z:\Users\Phil\Data\BUILDER\SavedBuilderVars\buildingVars_' num2str(cellNumberForProjectOriginal)];
        disp('loading builder file, this takes awhile')
        load(buildingVarLoc)
        disp('done loading builder file')
        %% run modified jons code motor match behavior match and file location
        %% file location based on something in builder.... the vidoe location and other info
        %% ################################################
        %% ################################################
        %% ################################################
        %% ################################################
        %% ################################################
        %% ################################################
        %% ################################################
        %% ################################################
        %% ################################################
        %% ################################################
        %% ################################################
        %% ################################################
        load(['Z:\Users\Phil\Data\BehaviorArrays\solo_' mouseName '_' sessionName '.mat'])
        % % % % % % % try
        cd(d)
        % % % % % % % catch
        % % % % % % %
        % % % % % % %     d = ['Y:\Whiskernas', d(3:end)];
        % % % % % % %     cd(d)
        % % % % % % % end
        filelist=dir([d '*.measurements']);
        
        dirTrialNums = [];
        %trialNums=[100:241];  % enter which trial nums to process
        %includef=cell(length(trialNums),1);
        includef=cell(length(filelist),1);
        
        % Assign the trial numbers to existing .measurements files in the directory
        % NOTE : This assumes that the .measurements files have a four digit number
        % with leading zeros corresponding to trial number in string positions 29:32
        % of the file name.  These index numbers may need to be changed to match up
        % to the numerical code of the trial number.
        
        
        
        for i=1:length(filelist);
            dirTrialNums(i)=str2double(strtok(filelist(i).name(15:18),'.')); % extract out the trial number from each measurements file present in directory
        end
        trialNums = dirTrialNums;
        for i = 1: length(filelist)
            includef{i} = filelist(i).name(1:end-13);
        end
        
        
        %% IF THE BELOW DOESNT WORK BECASUE IT CANT FIND A BAR FILE OR SOMETHING THIS IFLE
        %% WILL REMOVE THE FILES THAT DONT MATCH USE THE MP4 DIRECTORY AND MEASUREMENTS
        %% MAKE SURE TO RUN THE ABOVE TO GET UPDATED TRIAL NUM AND FILE LISTS
        %% ##########################################################################
        %% ##########################################################################
        %% ##########################################################################
        %% ##########################################################################
        %% ##########################################################################
        % % % % % removeAllFilesThatDontMatchTrials(dir([d '*.mp4']), dir([d '*.measurements']))
        % % % % % removeAllFilesThatDontMatchTrials(dir([d '*.mp4']), dir([d '*.whiskers']))
        %% Optional section for cross correlating behavior and video trials, if you didn't pay attention to trial numbers
        
        % get behavior numbers
        
        for k = 1: length(b.trials)
            BehaviorTrialNums(k) = b.trials{k}.trialNum;
        end
        
        
        vv = nan(max(dirTrialNums),1);
        motor = nan(max(dirTrialNums),1);
        motor2 = nan(max(dirTrialNums),1);
        
        for i = 1:length(dirTrialNums)
            is_i_a_bTrial = find(BehaviorTrialNums == i,1);
            if ~isempty(is_i_a_bTrial)
                tmp2 = b.trials{is_i_a_bTrial}.motorPosition;
                motor2(BehaviorTrialNums(is_i_a_bTrial)) = tmp2;
            end
            
            if i<=length(b.trials) %is this enough or do we need actual trial nums
                tmp2 = b.trials{i}.motorPosition;
                motor(i+1) = tmp2;%why plus 1...?
            end
            
            if ~isempty(find(dirTrialNums == i,1)) % basically if measure file with this number exists
                %create matrix showing trial location
                fidx = find(dirTrialNums == i); %show index in matrix where trial is
                
                tmp = load([filelist(fidx).name(1:end-13) '.bar']);
                vv(i) = tmp(1,2);
            end
            
        end
        
        %this had to be built when we scrambled go and nogo positions for naive
        %mice.
        barxmotor = [motor vv];
        barxmotor2 = [motor2 vv];
        vvnorm =  (barxmotor-repmat(min(barxmotor),length(barxmotor),1)) ./ repmat((max(barxmotor)-min(barxmotor)),length(barxmotor),1); %normalize
        vvnorm2 =  (barxmotor2-repmat(min(barxmotor2),length(barxmotor2),1)) ./ repmat((max(barxmotor2)-min(barxmotor2)),length(barxmotor2),1); %normalize
        vvnormrd= round(vvnorm,2); %round so numbers will be comparable
        vvnormrd2= round(vvnorm2,2); %round so numbers will be comparable
       
        nanidx = sum(isnan(vvnormrd),2)>0;
        vvnormrd(nanidx,:)=[]; %remove NaN values which will mess with xcorr
        [c, lags] = xcorr(vvnormrd(:,1),vvnormrd(:,2));
        [~, mx] = max(c); %find max c value and max x value
        lag_shiftMOTOR = lags(mx) %find lag in between both bv and vv2
        
        nanidx2 = sum(isnan(vvnormrd2),2)>0;
        vvnormrd2(nanidx2,:)=[]; %remove NaN values which will mess with xcorr
        [c2, lags2] = xcorr(vvnormrd2(:,1),vvnormrd2(:,2));
        [~, mx2] = max(c2); %find max c value and max x value
        lag_shiftMOTOR2 = lags2(mx2) %find lag in between both bv and vv2
        
        
        %  Build behavior number vector
        
        gngThreshold = nanmean(vv); % for continuous pole postion with equal width go/nogo ranges, mean vv = the transition between go/nogo.
        vv2 = vv >= gngThreshold; % threshold for pole position on 1 side or the other
        vv3 = vv < gngThreshold;
        vvDiff = vv2-vv3;
        figure(23);
        plot([vvDiff],'.')
        hold on
        plot(vv3,'ro')
        bv = zeros(max(b.trialNums),1);
        
        bv(b.trialNums) = b.trialTypes*2-1; %1=GO and -1=NOGO and 0=NAN
        [c, lags] = xcorr(bv,vvDiff); %correlation between bv (behavioral GO and NOGO) and vv2 (video GO and NOGO trials)
        [mc, mx] = max(c); %find max c value and max x value
        lag_shiftBV = lags(mx) %find lag in between both bv and vv2
        
        for i = 1: length(filelist)
            includef{i} = filelist(i).name(1:end-13);
        end
        
        hold on
        % plot(bv,'go')
        resultsString = ['Behavior Lag = ' num2str(lag_shiftBV) '. Motor Lag = ' num2str(lag_shiftMOTOR) '. Motor Lag 2 = ' num2str(lag_shiftMOTOR2)]
        % if lag_shiftBV == lag_shiftMOTOR
        %     lag_shift = lag_shiftBV
        %     trialNums = dirTrialNums+lag_shift;  % correct the trial numbers
        %     lagShiftNotes = 'lag shifts matched' ;
        % else
        %     %     error('Lags are different for behavior and motors. Default setting lagshift to lagshiftBV. Override BELOW.')
        %     display()
        % % %     button = questdlg( ['Choose shift value. Behavior Lag = ' num2str(lag_shiftBV) '. Motor Lag = ' num2str(lag_shiftMOTOR) '.'], 'Lag Shift Value', 'Behavior', 'Motor', 'Cancel', 'Yes');
        % % %     switch button
        % % %         case 'Behavior'
        % % %             lag_shift = lag_shiftBV
        % % %             lagShiftNotes = 'lag shifts didn''t match, chose BEHAVIOR match'
        % % %         case 'Motor'
        % % %             lag_shift = lag_shiftMOTOR
        % % %             lagShiftNotes = 'lag shifts didn''t match, chose MOTOR match'
        % % %         case 'Cancel'
        % % %             OhNo
        % % %     end
        %     %will most likely encounter this when we go thru ARC/naive
        % end
        
        trialNums = dirTrialNums+lag_shift;
        
        % restrict processing to trials...
        startTrial = 1;
        endTrial = 99999999;
        includef = includef(trialNums >= startTrial & trialNums <=endTrial);
        trialNums =  trialNums(trialNums >= startTrial & trialNums <=endTrial);
        
        
        %% write to text file
        fprintf( fid, 'Cell %s\n Directory %s\n%s\n\n', cellNumberForProjectOriginal ,d, resultsString);
        %% ################################################
        %% ################################################
        %% ################################################
        %% ################################################
        %% ################################################
        %% ################################################
        %% ################################################
        %% ################################################
        %% ################################################
        %% ################################################
        %% ################################################
        %% ################################################
        %% ################################################
    catch catchMessage
        
        if ~exist('d', 'var')
            d = 'd not loaded :(   ';
        end
        fprintf( fid, 'Cell %s\n Directory %s errored out\n identifier: %s\n message: %s\n\n', ...
            cellNumberForProjectOriginal ,d, catchMessage.identifier, catchMessage.message);
        
    end
    
end
fclose(fid);