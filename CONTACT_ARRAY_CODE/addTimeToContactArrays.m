%% add time into contact arrays


% clearvars -except U U2
CONTdir = 'Y:\Whiskernas\Data\Trial_Contacts_For_Curation\S1ForJon2\FINISHED_CONTACTS';
matFiles = struct2cell(dir( [CONTdir, filesep, '*.mat']));
ConTAfiles = matFiles(:, find(contains(  matFiles(1,:), 'ConTA')))
%
TAdir = 'Y:\Whiskernas\Data\Trial_Contacts_For_Curation\S1ForJon2\TArrays'
matFiles = struct2cell(dir( [TAdir, filesep, '*.mat']));
TAs = matFiles(:, find(contains(  matFiles(1,:), 'trial_array_')))

% clearvars -except U U2
% CONTdir = 'C:\Users\maire\Dropbox\HIRES_LAB\PHIL\Data\Characterization\S1ForJon2\Contacts';
% matFiles = struct2cell(dir( [CONTdir, filesep, '*.mat']));
% ConTAfiles = matFiles(:, find(contains(  matFiles(1,:), 'ConTA')))
% %
% TAdir = 'C:\Users\maire\Dropbox\HIRES_LAB\PHIL\Data\Characterization\S1ForJon2\TArrays'
% matFiles = struct2cell(dir( [TAdir, filesep, '*.mat']));
% TAs = matFiles(:, find(contains(  matFiles(1,:), 'trial_array_')))


theseOnes = 1:size(TAs, 2);
theseOnes = setdiff(theseOnes, [])
for tmpk = 1:size(TAs, 2);
    saveOn = true;
    k = theseOnes(tmpk);
    Tarray = load([TAs{2, k}, filesep, TAs{1, k}]);
%     searchName = [Tarray.T.mouseName, '_',Tarray.T.sessionName, '_',   Tarray.T.cellNum, '_',     Tarray.T.cellCode];
searchName = ['ConTA_' Tarray.T.projectDetails.cellNumberForProject '.mat'];
    ContInd =  find(contains(ConTAfiles(1, :), searchName));
    if ~isempty(ContInd)
            Tarray.T.projectDetails.cellNumberForProject

        ContInfo = ConTAfiles(:,ContInd);
        clear contacts params
        load( [ContInfo{2}, filesep, ContInfo{1}]);
        
        saveName = [ContInfo{2}, filesep, ContInfo{1}];
        emptyTest = zeros (1, length(Tarray.T));
        for kk = 1:length(Tarray.T)
            if  ~isempty( Tarray.T.trials{kk}.whiskerTrial)
                emptyTest(kk) =  1;
            end
        end
        if ~isempty(find(emptyTest ==0 ))
            try
                segmentsTMP = findInARow(find(emptyTest ==0 ));
            catch
                keyboard
            end
            if segmentsTMP(end, 2) == length(Tarray.T)
                for kk = segmentsTMP(end, 1):segmentsTMP(end, 2)
                    contacts{1, kk} = []; % add blanks onto contacts becasue they are not there if there is no whisker info there
                end
            end
        end
        if  length(Tarray.T) ~= length(contacts)
            warning('these trial and contact arrays dont match')
            saveOn = false;
        end
        
        LcontArrays = zeros(1,length(Tarray.T) );
        timesArray = {};
        L_Tarray = zeros(1,length(Tarray.T) );
        for kk = 1:length(Tarray.T)
            if ~isempty( Tarray.T.trials{kk}.whiskerTrial)
                timesArray{kk} = Tarray.T.trials{kk}.whiskerTrial.time{:};
                L_Tarray(kk) = length(timesArray{kk});
            end
            
            if ~isempty(contacts{kk}) && isfield(contacts{kk}, 'M0combo');
                LcontArrays(kk) =  numel(contacts{kk}.M0combo{:});
            end
        end
        if all(L_Tarray == LcontArrays )
            for kk = 1:length(timesArray)
                contacts{kk}.time = timesArray{kk};
            end
            
        else
            warning ('these trial and contact arrays dont match at the level of the number of time points in each trial')
            saveOn = false;
        end
        if saveOn
                    save(saveName, 'contacts', 'params');
        end
    end
end































