

%% ### USER SET
materDir = 'Z:\Data\Video\PHILLIP';
numFilesToLookAt = 50;
allFiles = 0 ; % overide numFilesToLookAt and just look at all files

fid = fopen( [materDir, filesep, 'LagShiftresults.txt'], 'wt' );
% %% get all sub dirs
dAll = regexp(genpath(materDir),['[^;]*'],'match');
disp(['total directories ', num2str(length(dAll))])
for kk = 1: length(dAll)
    disp(['Percent done ', num2str(100*kk/length(dAll))]);
    workingDir = dAll{kk};
    cd(workingDir);
    matFiles = dir('*mat');
    counter = 0 ;
    clear wlNames wlNums numsFromWL matNames
    wlNames = [];
    for k = 1:size(matFiles, 1)
        matNames{k,1} = matFiles(k).name;
        if ~isempty(strfind(matNames{k}, 'WL.mat'))
            counter = counter +1;
            wlNames{counter,1} = matNames{k};
            wlNums(counter, 1) = str2num(wlNames{counter}(strfind(wlNames{counter}, '-')+1 : strfind(wlNames{counter}, '_')-1));
        end
    end
    if ~isempty(wlNames)
        [wlSorted, wlIndex] = sort(wlNums, 'ascend');
        if length(wlSorted)<numFilesToLookAt
            numFilesToLookAt = length(wlSorted)
            warning('num wl files less than numFilesToLookAt... forced to num of WL files')
        end
        if allFiles == 1
            theseFiles = 1:length(wlSorted);
        elseif allFiles == 0
            theseFiles = round(linspace(1, length(wlSorted), numFilesToLookAt));
        end
        theseFiles = wlSorted(theseFiles)';
        for k = 1:length(theseFiles)
            load(wlNames{find(wlNums == theseFiles(k))});
            numsFromWL(1, k) = wl.trialNum;
        end
        matchResult = (num2str(theseFiles - numsFromWL));
        fprintf( fid, '%s\n%s\n\n', workingDir ,matchResult);
    else
        disp('no wtfiles for following directory');
        disp(workingDir);
    end
end
fclose(fid);