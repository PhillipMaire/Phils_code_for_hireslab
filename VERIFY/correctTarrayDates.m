%% get dates for session name and the dates in whisker trials file names




TAs = struct2cell(dir('Y:\Whiskernas\Data\Trial_Contacts_For_Curation\S1ForJon2\TArrays\trial_array*'))

whiskerTrialDateName = {};
mp4FolderDateNames = {}
sessionNameDate = {}
vidDirAll = {}
cellLocAll = {}
for namek = 1:size(TAs, 2)
    load([TAs{2, namek}, filesep, TAs{1, namek}])
    cellLoc = str2double(T.projectDetails.cellNumberForProject) - 2000
    cellLocAll{namek, 1} = cellLoc;
    
    for minamize1 = 1
        PhysiologyDataLOC = 'C:\Users\maire\Dropbox\HIRES_LAB\PHYSIOLOGY_RECORDS';
        
        sheetName = 'S1_for_JON';
        ephusBase = 'C:\Users\maire\Dropbox\HIRES_LAB\PHIL\Data\EPHUS';
        %         ephusBase = 'Z:\Users\Phil\Data\EPHUS'
        videoloc    = 'X:\Video\PHILLIP';%%
        behavArrayLoc ='C:\Users\maire\Dropbox\HIRES_LAB\PHIL\Data\BehaviorArrays';% for saving after built
        behavFileLoc = 'C:\Users\maire\Dropbox\HIRES_LAB\PHIL\Data\Behavior';% actual behav data directory
        behaviorProtocalName = '@pole_contdiscrim_obj';%protocol name
        
        cd(PhysiologyDataLOC)
        physDat = struct2cell(dir('Physiology Data *'));
        [~, tmpInd] = max(cell2mat(physDat(end, :)));
        fileName = physDat{1, tmpInd};% get Phys data file name
        % %% load all the info form teh excell sheeet
        
        PhysSpreadSheet = readtable(fileName,'Sheet',sheetName, 'range', 'A2:BS500'); %A2 means data starts at A3
        PhysSpreadSheet2= table2cell(PhysSpreadSheet);
        cellNumberForProject = num2str(PhysSpreadSheet2{cellLoc, 3 });
        projectName = upper(sheetName);
        mouseName  =  PhysSpreadSheet2{cellLoc, 5 };
        sessionName =datestr(PhysSpreadSheet2{cellLoc, 10 }, 'yymmdd');
        code        = PhysSpreadSheet2{cellLoc, 7 };
        cellnum     = PhysSpreadSheet2{cellLoc, 8 };
        
        depth = PhysSpreadSheet2{cellLoc, 20 };  % in um from pia
        depth = round(depth);
        
        % %% automatically set up the correct directories
        ephusLoc = [ephusBase, filesep,cellnum ];
        disp(ephusLoc);
        behaviorFile = [behavArrayLoc '\solo_' mouseName '_' sessionName '.mat'];
        disp(behaviorFile);
        behavFullFileName =  [behavFileLoc, filesep, mouseName, filesep , ...
            'data_', behaviorProtocalName, '_', mouseName, '_', num2str(sessionName), 'a.mat'];
        tmp1 = strfind(behavFullFileName,  filesep);
        behavFileLocation = behavFullFileName(1:tmp1(end));
        disp(behavFullFileName)
        vidDir= ([videoloc filesep mouseName filesep sessionName filesep]);
        % automatic naming
        dirs = regexp(genpath(vidDir),['[^;]*'],'match');
        legthMesFiles = [];
        for k = 1:length(dirs)
            legthMesFiles(k)  =  length(dir([dirs{k} filesep '*.measurements']));
        end
        foldIND = find(legthMesFiles~=0);
        
        if length(foldIND) <1
            error('no measurements fiels')
        elseif length(foldIND)>1
            error('more than one folderwith mes files in it')
        else
            vidDir = dirs{foldIND};
            disp(vidDir)
        end
        % cd(behavFileLocation)
        
    end
    
    mp4vids = dir([vidDir, filesep, '*.mp4']);
    tmpName = mp4vids(1).name(8:13);
    mp4FolderDateNames{namek, 1} = tmpName;
    sessionNameDate{namek, 1} = T.sessionName;
    
    
    
    
    dateNameTarray = ''
    counter1 = 0;
    while isempty(dateNameTarray)
        counter1 = counter1 +1;
        try
            dateNameTarray =   T.trials{counter1}.whiskerTrial.trackerFileName;
            
        catch
        end
        
    end
    tmpName = dateNameTarray(8:13);
    whiskerTrialDateName{namek, 1} = tmpName;
    
    
    vidDirAll{namek, 1} = vidDir;
    
end

%%

whiskerTrialDateName
sessionNameDate
mp4FolderDateNames
cellLocAll
vidDirAll

mp4 = str2num(cell2mat(mp4FolderDateNames));
wname =  str2num(cell2mat(whiskerTrialDateName));
sesname = str2num(cell2mat(sessionNameDate));

toRenameWhisks = find(mp4 - wname)

mp4 - sesname

sesname - wname

%%



TAs = struct2cell(dir('Y:\Whiskernas\Data\Trial_Contacts_For_Curation\S1ForJon2\TArrays\trial_array*'))

for tmpk = 1:length(toRenameWhisks)
    disp(tmpk);
    namek = toRenameWhisks(tmpk);
    load([TAs{2, namek}, filesep, TAs{1, namek}])
    % counter1 = 0;
    for wk = 1:length(T.trials)
        %         counter1 = counter1 +1;
       
       
       try 
           T.trials{wk}.whiskerTrial.trackerFileName;
            T.trials{wk}.whiskerTrial.trackerFileName(8:13) = T.sessionName;
       catch
      
        end
        
    end
%     keyboard
    save(['Y:\Whiskernas\Data\Trial_Contacts_For_Curation\S1ForJon2\TArrays\' 'trial_array_' T.projectDetails.cellNumberForProject '.mat'], 'T')
    
    
end


