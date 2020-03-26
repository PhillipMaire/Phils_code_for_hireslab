%% USER SETTING
%{






startDir = 'X:\Video\PHILLIP\';
startDir = 'X:\Video\PHILLIP\';



cells2run = [15 58 63 64];
cells2run = cells2run+2000
deleteFilesOn = true;
[catchcell] = autoBuilder(startDir, cells2run, deleteFilesOn)







%}


function [catchcell] = autoBuilder(startDir, cells2run, deleteFilesOn)
if deleteFilesOn
    continue1 = false;
    question1 = 'Are you sure you want to delete ALL .WL .WST .WT and .WTLIA files in ALL THE DIRECTORIES LISTED?';
    question2 = 'ARE YOU REALLY REALLY SURE YOU WANT TO DO THAT? IF YOU DONT KNOW WHAT YOU ARE DOING THEN STOP!!';
    tmp1 = questdlg(question1);
    if strcmp(tmp1, 'Yes')
        tmp1 = questdlg(question2);
        if strcmp(tmp1, 'Yes')
            continue1 = true;
        end
    end
end
if continue1 == false
    error('stopped becasue  user wasn''t ready to delete all kinds of files, probs a good idea')
end
%%
tic
disp('finding all directories, this can take up to 1 min')
dirs = regexp(genpath(startDir),['[^;]*'],'match');
toc
%%
allcellBuilders = {};
% allCellDirs = {};
builderFileNums = [];
for k= 1:length(dirs)
    fprintf('searching in directory %d of %d\n', k, length(dirs))
    cd(dirs{k});
    tmp1  = dir('*_BUILDERSAVE.mat');
    for kk = 1:length(tmp1)
        %         keyboard
        %     if min(size(tmp1))>1
        %         error('2 BULDER FILES IN THE SAME DIRECTORY');
        %     elseif min(size(tmp1))==1
        allcellBuilders{end+1} = [dirs{k}, filesep, tmp1(kk).name];
        %         allCellDirs{end+1} = dirs{k};
        ind2 = strfind(allcellBuilders{end}, '_BUILDERSAVE.mat') - 1;
        ind1 = strfind(allcellBuilders{end}(1:ind2), '_');
        ind1 = ind1(end)+1;
        builderFileNums(end+1) = str2num(allcellBuilders{end}(ind1:ind2));
    end
end
if length(unique(builderFileNums)) ~= length(builderFileNums)
    keyboard
end

[cells2run2, ~, cells2runInd] = intersect(cells2run, builderFileNums, 'stable');
allcellBuilders2 = allcellBuilders(cells2runInd);
%% load teh necesarry info
catchcell = {};
for k = 1:length(allcellBuilders2)
    try
        crush
        pause(5)
        clearvars -except allcellBuilders2 dirs k catchcell deleteFilesOn
        sectionComp = 0;
        
        load(allcellBuilders2{k})
        sectionComp = 1
        sectionComp = 2
        
        %%
        %% Step 3 - run everything
        % DONT FORGET TO DELETE OLD FILES IF YOU HAVE MULTIPLE OF THE SAME TRIAL IN HERE!
        % select matching files
        %tmp = cellfun(@(x)str2num(x(15:end)),includef);
        %incf_idx = find(tmp>= 12 & tmp <=85);
        tic
        if ~exist('follicleExtrapDistInPix')
            follicleExtrapDistInPix =  33
        end
        
        if deleteFilesOn
            cd(vidDir)
            delete *_WL.mat
            delete *_WST.mat
            delete *_WT.mat
            delete *-WTLIA.mat
            
        end
        try
            vidFile.Width
        catch
            tmpVdir = dir( [vidDir, filesep, '*.mp4']);
            vidNum = Sample(1:length(tmpVdir));
            vidName = [tmpVdir(vidNum).folder , filesep, tmpVdir(vidNum).name];
            try
                vidFile = VideoReader(vidName);
                frame = readFrame(vidFile);
            catch
                vidFile = mmread(vidName);
                frame = vidFile.frames(1).cdata;
                vidFile.Width = vidFile.width;
                vidFile.Height = vidFile.height;
            end
            
        end
        try
            % Whisker.makeAllDirectory_WhiskerTrial(vidDir,0,'mask',maskPoints,...
            Whisker.makeAllDirectory_WhiskerTrial(vidDir,0,'mask',maskPoints,...
                'trial_nums',trialNums,'include_files',includef,...
                'barRadius',10,'faceSideInImage', 'top', 'framePeriodInSec',.001,...
                'imagePixelDimsXY',[vidFile.Width  vidFile.Height],'pxPerMm',33,...
                'mouseName',mouseName,'sessionName',sessionName,'protractionDirection','leftward')
        catch
            %%
            %%
            %%
            %%
            %%
            %%
            %%
            %%
            %%
            %%
            %%
            %%
            %%
            %%
            %%
            %%
            %%
            %%
            %%
            %%
            %%
            for k = 1:length(includef)
                includef{k}(9) = '9';
            end
            
            Whisker.makeAllDirectory_WhiskerTrial(vidDir,0,'mask',maskPoints,...
                'trial_nums',trialNums,'include_files',includef,...
                'barRadius',10,'faceSideInImage', 'top', 'framePeriodInSec',.001,...
                'imagePixelDimsXY',[vidFile.Width  vidFile.Height],'pxPerMm',33,...
                'mouseName',mouseName,'sessionName',sessionName,'protractionDirection','leftward')
            
            
        end
          %%
            %%
            %%
            %%
            %%
            %%
            %%
            %%
            %%
            %%
            %%
            %%
            %%
            %%
            %%
            %%
            %%
            %%
            %%
            %% i changed teh name of the video files and so this try catch is to change 18**** to 19****
            %%
        sectionComp = 3
        
        
        Whisker.makeAllDirectory_WhiskerSignalTrial(vidDir,'include_files',includef,'polyRoiInPix',[99-33 99+33],'follicleExtrapDistInPix',follicleExtrapDistInPix);
        sectionComp = 4
        
        Whisker.makeAllDirectory_WhiskerTrialLiteI(vidDir,'include_files',includef,'r_in_mm',3,'calc_forces',true,'whisker_radius_at_base', 36.5,'whisker_length', 18,'baseline_time_or_kappa_value',0);
        sectionComp = 5
        
        wl = Whisker.WhiskerTrialLiteArray(vidDir);
        sectionComp = 6
        
        save([vidDir filesep mouseName sessionName '-WTLIA.mat'],'wl');
        sectionComp = 7
        
        
        tid = 0; % Set trajectory ID to view
        Whisker.view_WhiskerTrialLiteArray(wl,tid)
        timeSpent = toc
        hours = timeSpent/(60*60)
        sectionComp = 8
        
        
        %%########%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%#################%%%%%
        %%%%%%%%%%%%%%%%WHISKER ARRAY BUILDER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%END%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%..........................................................%%%%%%%
        %%
        
        
        sectionComp = 10
        
        spikes_trials = s.get_spike_times; % takes into account allgood to replace spikes
        for i = 1:length(spikes_trials.spikesTrials)
            spikes_trials.spikesTrials{i}.spikeTimes = spikes_trials.spikesTrials{i}.spikeTimes(allgood{i});
        end
        
        save(['C:\Users\maire\Dropbox\HIRES_LAB\PHIL\Data\SpikesData\SweepArrays\sweepArray_' mouseName '_' sessionName '_' cellnum '_' code '_' cellNumberForProject '.mat'],'s')
        % save(['C:\Users\maire\Dropbox\HIRES_LAB\PHIL\Data\SpikesData\indexingVars\indexingMat_'  mouseName '_' sessionName '_' cellnum '_' code '_' cellNumberForProject '.mat'],...
        %     'indexingMat','spksToPlotGood' ,'spksToPlotBad', 'good', 'bad', 'TrialIndCount')
        save(['C:\Users\maire\Dropbox\HIRES_LAB\PHIL\Data\SpikesData\SpikeArrays\spikes_trials_'  mouseName '_' sessionName '_' cellnum '_' code '_' cellNumberForProject '.mat'],'spikes_trials')
        
        
        T = LCA.TrialArray(b,spikes_trials,wl);
        % to make this work projectDetails you must make that a property in
        % +LCA/@TrialArray/TrialArray.m file and then copy over the @projectDetails
        % folder into +LCA folder. Won't affect anyone elses stuff-PSM
        T.projectDetails = LCA.projectDetails;
        
        
        T.projectDetails.cellNumberForProject = cellNumberForProject;
        T.projectDetails.projectName = projectName;
        
        T.projectDetails.category1 = category1;
        T.projectDetails.category2 = category2;
        T.projectDetails.category3 = category3;
        T.projectDetails.category4 = category4;
        T.projectDetails.category5 = category5;
        T.projectDetails.cellNotes = cellNotes;
        
        T.projectDetails.prePerformanceRegion = prePerformanceRegion;
        T.projectDetails.goodPerformanceRegion = goodPerformanceRegion;
        T.projectDetails.postPerformanceRegion = postPerformanceRegion;
        
        T.projectDetails.spikesNormalRegion = spikesNormalRegion;
        T.projectDetails.spikesFastBrokeInCellRegion = spikesFastBrokeInCellRegion;
        
        
        
        T.whiskerTrialTimeOffset = whiskerTrialTimeOffset;
        T.depth = depth;
        T.recordingLocation = recordingLocation;
        
        
        
        for i = 1:length(T.trials)
            T.trials{i}.spikesTrial.spikeTimes = T.trials{i}.spikesTrial.spikeTimes(:);
        end
        
        save(['C:\Users\maire\Dropbox\HIRES_LAB\PHIL\Data\TrialArrayBuilders\trial_array_'  mouseName '_' sessionName '_' cellnum '_' code '_' cellNumberForProject '.mat'],'T')
        cd('C:\Users\maire\Dropbox\HIRES_LAB\PHIL\Data\TrialArrayBuilders\');
        
        figure;T.plot_spike_raster(0,'BehavTrialNum')
        T
        
        
        save(['C:\Users\maire\Dropbox\HIRES_LAB\PHIL\Data\Characterization\trial_array_'  cellNumberForProject '.mat'],'T')
        %date and time to make unique files in case of accidental overwirte can
        %delete these when not needed anymore
        save(['C:\Users\maire\Dropbox\HIRES_LAB\PHIL\Data\Characterization\trial_array_'  cellNumberForProject '_' dateString '_.mat'],'T')
        beep
        clipboard('copy',vidDir)
        try
            messageForPB = ['SUCCESS cellname ', num2str(cellNumberForProject)]
            pBullet = Pushbullet('o.LLzZkkdcd6WN8MG5HyQjFDsCCSmRBAzw')
            pBullet.pushNote([],'Cell TArray Builder',messageForPB)
            
        catch
        end
    catch catchMes
        if sectionComp~= 0
            cd(vidDir)
            save([num2str(cellNumberForProject), '_erroredOutSoSaved'])
            messageForPB = ['failpoint ', num2str(sectionComp), ' cellname ', ...
                num2str(cellNumberForProject)];
            
            pBullet = Pushbullet('o.LLzZkkdcd6WN8MG5HyQjFDsCCSmRBAzw')
            pBullet.pushNote([],'Cell TArray Builder',messageForPB)
            try
                pBullet.pushNote([],' ', catchMes.stack.file)
                pBullet = Pushbullet('o.LLzZkkdcd6WN8MG5HyQjFDsCCSmRBAzw')
                pBullet.pushNote([],'', catchMes.stack.name)
                pBullet = Pushbullet('o.LLzZkkdcd6WN8MG5HyQjFDsCCSmRBAzw')
                pBullet.pushNote([],'', num2str(catchMes.stack.line))
            catch
            end
            catchcell{end+1} = messageForPB
        end
    end
end


