%% shift everything to zero
function selectedRespShifted = shiftToZero(selectedResp)
% input a matrix of any size 'cutting out' the section you dont want with NAN values
% make sure each line of data are columns (:, k) 
% just shifts and gets rid of nans 

selectedRespShifted = nan(size(selectedResp));
for kk = 1:size(selectedResp,2)
    tmpVar = selectedResp(:,kk);
    findStart = find(~isnan(tmpVar), 1);
    if ~isempty(findStart)
        findEnd = find(~isnan(tmpVar));
        findEnd = findEnd(end);
        selectedRespShifted(1:length(findStart:findEnd), kk) = tmpVar(findStart:findEnd);
    end
end
end