%% Used to do whisker tracking on raw video data
%Attempts to process in parallel
%In theory, sections 3 (CLASSIFY) and 3.5 (CLASSIFY-SINGLE-WHISKER) should
%not be in use at the same time, since they do the same thing
% Created by SAH and JS, 2014-08-04

%%


%% (1) TRACE: Uses Janelia Farm's whisker tracking software to track all whiskers in a directory

mainDir = 'C:\';


folderNums = {...
        'test2'...
        'test3'...
        'test4'...
        'test5'...
%         'test6'...
%         'test7'...
%         'test8'...
    %     '180219'...
    %     '180220'...
    %     'AH0705\171102'...
    %     'AH0705\171103'...
    %     'AH0705\171104'...
    %     'AH0705\171105'...
    %     'AH0705\171106'...
    %     'AH0705\171107'...
    %     'AH0706\171031'...
    %     'AH0706\171101'...
    %     'AH0706\171102'...
    %     'AH0706\171103'...
    %     'AH0706\171105'...
    %     'AH0706\171106'...
    %     'AH0706\171107'...
    %     'AH0706\171108'...
    %     'AH0714\170923'...
    %     'AH0714\170924'...
    %     'AH0714\170925'...
    };



% % % % % % % % % % % % % % % % delete(gcp('nocreate')); %turns off all other parallel pool processes
% % % numCores = feature('numcores'); %identify number of cores available for MATLAB to use
% % % parpool('local',numCores); %parallel pool using max number of cores available
% % %

tic
%% set what you want done 1 is yes other is no
copyOwnDefaultParames = 1; %if you copy your own default params by hand then set to 1
trace = 1 ;
measure = 1;
classify = 1;
reclassify = 0;
saveRegBeforeReclass = 0;%save the regular (not reclassified yet) files to a new directory.
% only use whe testing because otherwise it gets too big (copies all
% files!!!)



for k= 1:length(folderNums)
    %     try
    newDir = [mainDir folderNums{k}];
    cd(newDir)
    if copyOwnDefaultParames == 1
        display('not copying default params file...using one in there or generating new one if none exists')
        status = 1; %set to 1 if copy default params is commented out
    elseif copyOwnDefaultParames == 0
        try
            makeDefaultParamsFile
        catch
            display('overwriting Deafult params file...')
            status = copyfile('C:\Users\maire\Desktop\default.parameters')
        end
    end
    
    if status
        %% trace step maek whisker file
        if trace == 1
            %% have to delete these for tracing new file with different parameters
            toDelete = dir('*detectorbank');
            for kk = 1:length(toDelete)
                delete(toDelete(kk).name);
            end
            %% TRACE PORTION OF CODE
            traces = dir('*.mp4'); %Searches only for .mp4 files, change if using other type (e.g. SEQ)
            parfor n=1:length(traces)%################parfor
                [~, outputFileName] = fileparts(traces(n).name);
                commandString = ['trace ' traces(n).name ' ' outputFileName];
                system(commandString)
                display([traces(n).name ' has been traced'])
            end
        end
        %% measure step make measure file
        % (2) MEASURE: Generates measurements of traced shapes for later evaluation
        if measure == 1
            
            measures = dir('*.whiskers');
            
            parfor n=1:length(measures)%################parfor
                [~, outputFileName] = fileparts(measures(n).name);
                commandString = ['measure ' '--face ' 'top ' measures(n).name ' ' outputFileName '.measurements']
                system(commandString);
                display([measures(n).name ' has been measured'])
            end
        end
        
        
        %% classify step edits a file (either measure or whisker dont know which) to classify whisker
        % (3) CLASSIFY: Helps refine tracing to more accurately determine which shapes are whiskers
        % % Use for multiple whiskers
        if classify == 1
            classes = dir('*.measurements');
            
            parfor n=1:length(classes)%################parfor
                [~, outputFileName] = fileparts(classes(n).name);
                commandString = ['classify ' classes(n).name ' ' outputFileName '.measurements ' 'top ' '--px2mm ' '0.033 ' '-n ' '-1 ' '--limit8.0:10.0 ' ]
                system(commandString);
                display([classes(n).name ' has been classified'])
            end
        end
        %% save and copy before reclassifying so we can tell the difference
        if saveRegBeforeReclass == 1 && reclassify == 1
            dateString = strcat(datestr(now,'yymmdd_HHMM'));
            newFold = [newDir, filesep, dateString];
            mkdir (newFold);
            [status,msg] = copyfile(newDir, newFold);
        end
        %% (4) RECLASSIFY: Refines previous step
        classes = dir('*.measurements');
        if reclassify == 1
            parfor n=1:length(classes)%################parfor
                [~, outputFileName] = fileparts(classes(n).name);
                system(['reclassify ' classes(n).name ' ' outputFileName '.measurements' ' ' '-n ' '1']);
                display([classes(n).name ' has been reclassified'])
                display([classes(n).name ' completed'])
            end
        end
        %%
    else
        errorCatch{k} = strcat(folderNums{k},' couldnt copy default params file');
    end
    %     catch
    %         errorCatch{k} = strcat(folderNums{k},' error in trace, measure or classify');
    %
    %     end
end
toc
%Please visit http://whiskertracking.janelia.org/wiki/display/MyersLab/Whisker+Tracking+Tutorial
%for more information
%   Clack NG, O'Connor DH, Huber D, Petreanu L, Hires A., Peron, S., Svoboda, K., and Myers, E.W. (2012)
%   Automated Tracking of Whiskers in Videos of Head Fixed Rodents.
%   PLoS Comput Biol 8(7):e1002591. doi:10.1371/journal.pcbi.1002591