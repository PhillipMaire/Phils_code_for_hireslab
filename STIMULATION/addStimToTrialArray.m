%%

% clearvars -except U U2
stimDir = 'C:\Users\maire\Desktop\StimTrialMats\jonsS1Data';
matFiles = struct2cell(dir( [stimDir, filesep, '*.mat']));
stimFiles = matFiles(:, contains(  matFiles(1,:), 'stimTrials_EPHUS_'))
%
TAdir = 'Y:\Whiskernas\Data\Trial_Contacts_For_Curation\S1ForJon2\TArrays'
matFiles = struct2cell(dir( [TAdir, filesep, '*.mat']));
TAs = matFiles(:, contains(  matFiles(1,:), 'trial_array_'))

StimTrialMatsLocation = 'C:\Users\maire\Desktop\StimTrialMats';





for k = 1:size(TAs, 2)
    fprintf('%s%d%s%d\n','num ', k, ' of ',  size(TAs, 2))
    load([TAs{2, k}, filesep, TAs{1, k}]);
    searchName = ['stimTrials_EPHUS_' T.cellNum '.mat'];
    stimInd =  find(contains(stimFiles(1, :), searchName));
    if ~isempty(stimInd)
        
        stimInfo = stimFiles(:,stimInd);
        
        load( [stimInfo{2}, filesep, stimInfo{1}]);
        
        
        
        %%%%THIS SECTION IS FOR FINDING AND REMOVING STIM TRIALS
        cd(StimTrialMatsLocation) %used to load (or create if this is the first time) list of stim trials
        stimTrialvar = ['stimTrials_EPHUS_', T.trials{1, 1}.cellNum];
        
        disp('looking for stim trials');
        cd(['C:\Users\maire\Dropbox\HIRES_LAB\PHIL\Data\EPHUS\', ...
            filesep, T.trials{1, 1}.cellNum, filesep])
        
        allXSG =  struct2cell(dir ('*.xsg'));
        %%
        progressWin = waitbar(0,'loading XSG files');
        testIfStim = {};
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
            testIfStim{5,k} = xsgName(1:6);%
            
            
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
        %%
        cellNumT = contains(testIfStim(5, :), T.cellNum  );
        cellCodeT = contains(testIfStim(4, :), T.cellCode  );
        % these are the index of the cell for the XSG file
        cellTrials = find(cellCodeT.*cellNumT);
        testIfStim = testIfStim(:, cellTrials);
        %%
        actualEPHUSnumsREF = [];
        for kk = 1:size(testIfStim, 2)
            actualEPHUSnumsREF(kk) = str2num(testIfStim{2,kk});
        end
        %         isStimStruct = struct;
        %         isStimStruct.actualEPHUSnumsREF = actualEPHUSnumsREF;
        %         isStimStruct.testIfStim = testIfStim;
        tmp1  = find(cell2mat(testIfStim(3, :))>0);%ephus FIles stim strials 
        tmp2 = cellfun(@str2num, testIfStim(2, :)); %ephus files name
        isStimStruct.stimON = tmp2(tmp1); %name of ephus files 
        %         isStimStruct.stimOFF = find(cell2mat(testIfStim(3, :))<0);
        %         isStimStruct.stimUNKNOWN = find(cell2mat(testIfStim(3, :))==0);
        %         isStimStruct.stimONtrialRef = actualEPHUSnumsREF(isStimStruct.stimON);
        %         isStimStruct.stimOFFtrialRef = actualEPHUSnumsREF(isStimStruct.stimOFF);
        %         isStimStruct.stimUNKNOWNtrialRef = actualEPHUSnumsREF(isStimStruct.stimUNKNOWN);
        %%
        ephusInTarray = cellfun(@(x) x.spikesTrial.xsgFileNum, T.trials);%name of ephus files in Tarray
        
        % the common trials based on the names of the ephus trials (these are indices to the Tarray) 
        [sdfgsdfg, sdfg, TarrayStimON_Index] = intersect( isStimStruct.stimON, ephusInTarray);
        
        TarrayStimOFF_Index = setdiff(1:length(T.trials) , TarrayStimON_Index);
        
        linIndsToUseTrials = zeros(1, length(T.trials));
        linIndsToUseTrials(TarrayStimOFF_Index) = 1;
        
        T.orphanBehavTrials = linIndsToUseTrials;
        %%%%END ... SECTION IS FOR FINDING AND REMOVING STIM TRIALS
        
%         save([TAdir '\trial_array_' T.projectDetails.cellNumberForProject '.mat'],'T');
        
    end
end