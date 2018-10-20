%% 2013MakeFakeContactArrays

%%%% in the autosave contact program change as needed 
autoSaveDir = 'Z:\Users\Phil\Data\Characterization\autoSAVEcontacts\';


% characterizationDir = 'Z:\Users\Phil\Data\Characterization\';
% folderName = 'FINAL TRIAL ARRAYS';

% % trialCutoffs = repmat([1 1024],numel(cellNum),1);
%%%%set cvariable here to rename the U to a specific name that way we can
%%%%have all the data here at onece
%%%%

finalDir = 'Z:\Users\Phil\Data\Characterization\FINAL TRIAL ARRAYS';
cd(finalDir)
dirlistTarrays = dir(finalDir);
TarrayNames = cell(0);
for k = 1:length(dirlistTarrays)
    if ~dirlistTarrays(k).isdir
        %         dotIndex = strfind(dirlistTarrays(k).name, '.mat');
        TarrayNames{end+1} = dirlistTarrays(k).name;
    end
end
TarrayNames;
%%%% check to see if you contact arrays already exist

cd(autoSaveDir)
contNames = cell(0);
dirlistCont = dir(autoSaveDir);
for k = 1:length(dirlistCont)
    if ~dirlistCont(k).isdir
        %         dotIndex = strfind(dirlistTarrays(k).name, '.mat');
        contNames{end+1} = dirlistCont(k).name;
    end
end
contNames;
matchIndall = [];

%%% only run the ones that arent made yet
for k = 1:length(contNames)
    endInd = strfind(contNames{k}, '.') -1;
    contCellNums = contNames{k}(7:endInd);
    dontRunThese = ['trial_array_', contCellNums, '.mat'];
    %     for kk = 1:length(TarrayNames)
    matchInd = find(strcmpi( dontRunThese, TarrayNames));
    if ~isempty(matchInd)
        matchIndall(end+1) = matchInd;
    end
    %     end
end

runTheseTarrays = TarrayNames(setdiff(1:length(TarrayNames), matchIndall))

%%%% MAKE THE CONTACT ARRAYS
cd(finalDir)
for k = 1:length(runTheseTarrays)
    try
    
      load(runTheseTarrays{k});
    trialContactBrowserAutoSave(T);
    
    close all
    
    pause(5)
    
% % %         load(runTheseTarrays{k});
% % %         disp('Contacts data missing, building and assigning to workspace as "contacts"')
% % %         autoSaveName = ['ConTA_',  num2str(T.projectDetails.cellNumberForProject)];
% % %         [contacts, params]=autoContactAnalyzerSi(T);
% % %         contactsname = 'contacts';
% % %         assignin('base','contacts',contacts);
% % %         assignin('base','params',params);
% % %         
% % %         
% % %         finalSaveName = [autoSaveDir, autoSaveName]
% % %         save(finalSaveName, 'contacts', 'params')
% % %         display('Saved Contacts and Parameters')
% % %         close all
    catch
        close all
        for kk = 1:30
            warning(runTheseTarrays{k})
        end
        pause(5);
    end
end

%%
save('Z:\Users\Phil\Data\Characterization\autoSAVEcontacts\test', 'contacts', 'params')

