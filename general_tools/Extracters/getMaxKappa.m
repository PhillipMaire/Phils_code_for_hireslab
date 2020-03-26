%%

function [maxDeltaTrialTimeInd, maxDeltaKappa, Sind, absMaxKappaINDS, Tcell] = getMaxKappa(C, start1, stop1)

%{
C is one cell from U array 
start and stop are two vectors of equal length determining the region for each touch to extract max
kappa. these can be any numbers 

maxDeltaTrialTimeInd - tim pooint in the trial time matrix where the max was found for each segment

maxDeltaKappa - the max value (negative or positive max is max away from 0) 

Sind - sorted ind cell to be used later if you want to resort easily 

absMaxKappaINDS - the indices within Tcell where the max number was found. so if one touch had
length 20 and the strogest kappa was 5 ms in from the touch then this number would be 5 

Tcell - reference cell made using start and stop 
%}
Dkap = GetRealKappa(C);
Tcell =  colonMulti(start1(:),stop1(:), 'cell');% only use up
% to the point where the defined touch period ends minus the min time an event could occur

kapExtract = cellfun(@(x) Dkap(x), Tcell, 'UniformOutput', false);
%         rangeKappa = cellfun(@(x) range(x), kapExtract);
absMaxKappa = cellfun(@(x) nanmax(abs(x)), kapExtract);

absMaxKappaINDS = cellfun(@(x) find(absMaxKappa(x) == abs(kapExtract{x}), 1, 'first'), num2cell(1:length(kapExtract)));
maxDeltaKappa = cellfun(@(x) kapExtract{x}(absMaxKappaINDS(x)), num2cell(1:length(kapExtract)));

maxDeltaTrialTimeInd = cellfun(@(x) Tcell{x}(absMaxKappaINDS(x)), num2cell(1:length(Tcell)));
[~, Sind] = sort(maxDeltaKappa);
% maxDeltaTrialTimeInd = maxDeltaTrialTimeInd(Sind);
% absMaxKappaINDS = absMaxKappaINDS(Sind);
% KSpk2 = KSpk(:, Sind);
% tuningCurve = 1000*(nansum(KSpk2(win1, :))./length(Twin{k}));