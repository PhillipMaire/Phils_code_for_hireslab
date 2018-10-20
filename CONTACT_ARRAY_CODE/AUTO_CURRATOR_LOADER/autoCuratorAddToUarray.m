%%


% characterizationDir = 'Z:\Users\Phil\Data\Characterization\';
% folderName = 'FINAL TRIAL ARRAYS';

% % trialCutoffs = repmat([1 1024],numel(cellNum),1);
%%%%set cvariable here to rename the U to a specific name that way we can
%%%%have all the data here at onece
%%%%

finalDir = 'Z:\Users\Phil\Data\Characterization\AUTOCURATED_CONTA\Most_Updated';
cd(finalDir)
dirlistTarrays = dir(finalDir);
CONTACT_NAMES = cell(0);
for k = 1:length(dirlistTarrays)
    if ~dirlistTarrays(k).isdir && ~isempty(strfind(lower(dirlistTarrays(k).name), 'cont'))
        CONTACT_NAMES{end+1} = dirlistTarrays(k).name;
    end
end


CONTACT_NAMES




%%

clear allCONTACTS
for k = 1:length(CONTACT_NAMES)
    disp(k)
    contNAME = CONTACT_NAMES{k};
    TMPcontact = load(contNAME);
    TMPcontact = TMPcontact.contacts;
    findUNDERSCORES = strfind(contNAME, '_');
    findDOTS = strfind(contNAME, '.');
    if numel(findUNDERSCORES)>2
        error('different naming format')
    end
    cellNumFromCONTA = (contNAME(findUNDERSCORES(1)+1 : findDOTS(1)-1));
    counterContacts = 0;
    %     keyboard
    for kk = 1:length(TMPcontact)
        TMPcontactSingle = TMPcontact{kk};
        if isempty(TMPcontactSingle)
            
        elseif isfield(TMPcontactSingle, 'trialNum')
            
            counterContacts = counterContacts+1;
            allCONTACTS(k).trialNum(counterContacts) = TMPcontactSingle.trialNum;
            allCONTACTS(k).contacts(counterContacts) = TMPcontactSingle.contactInds;
            allCONTACTS(k).autoCurSkipped(counterContacts)  = 0;
        elseif isfield(TMPcontactSingle, 'contactInds')
            
            if isstr(TMPcontactSingle.contactInds{:})% labeled as skipped
                counterContacts = counterContacts+1;
                allCONTACTS(k).trialNum(counterContacts) = nan;
                allCONTACTS(k).contacts{counterContacts} = [];
                allCONTACTS(k).autoCurSkipped(counterContacts)  = 1;
            end
        end
    end
    allCONTACTS(k).CellNumber = cellNumFromCONTA;
    %     allCellsContacts.cellNum(k) = cellNumFromCONTA;
    %     allCellsContacts.
end
open allCONTACTS
%%

% % % % % % %  keyboard
% % % % % % % %% fill in the U array
% % % % % % % 
% % % % % % % for k = 1: size(allCONTACTS, 2)
% % % % % % %     if ~isempty(allCONTACTS(k).contacts)
% % % % % % %         tmpCONTACTS = allCONTACTS(k);
% % % % % % %         for kk = 1:length(U)
% % % % % % %             if ~isempty(strcmp(U{kk}.details.projectDetails.cellNumberForProject, tmpCONTACTS.CellNumber))
% % % % % % %                 thisCellNumIND = kk;
% % % % % % %             end
% % % % % % %         end
% % % % % % %         
% % % % % % %         
% % % % % % %         fillInTheseTrials = intersect(U{k}.details.useTrials, tmpCONTACTS.trialNum);
% % % % % % %     end
% % % % % % % end











