%%

% clearvars -except U U2
CONTdir = 'Y:\Whiskernas\Data\Trial_Contacts_For_Curation\S1ForJon2\FINISHED_CONTACTS';
matFiles = struct2cell(dir( [CONTdir, filesep, '*.mat']));
ConTAfiles = matFiles(:, find(contains(  matFiles(1,:), 'ConTA')))
%
TAdir = 'Y:\Whiskernas\Data\Trial_Contacts_For_Curation\S1ForJon2\TArrays'
matFiles = struct2cell(dir( [TAdir, filesep, '*.mat']));
TAs = matFiles(:, find(contains(  matFiles(1,:), 'trial_array_')))



%



for k = 1:size(TAs, 2)
    
    Tarray = load([TAs{2, k}, filesep, TAs{1, k}])
    searchName = [Tarray.T.mouseName, '_',Tarray.T.sessionName, '_',   Tarray.T.cellNum, '_',     Tarray.T.cellCode];
    ContInd =  find(contains(ConTAfiles(1, :), searchName));
    if ~isempty(ContInd)
        ContInfo = ConTAfiles(:,ContInd);
        clear contacts params
        load( [ContInfo{2}, filesep, ContInfo{1}]);
        
        saveName = [ContInfo{2}, filesep,'ConTA_', Tarray.T.projectDetails.cellNumberForProject, '.mat'];
        if exist(saveName) ~= 2
            save(saveName, 'contacts', 'params');
        end
        Tarray.T.projectDetails.cellNumberForProject
    end
    
    
    
end