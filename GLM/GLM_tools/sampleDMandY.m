function [DM] = sampleDMandY(perc2model, limitModelTrialNumsTo, msRangeToModel , C, DM)
try 
   DM.Y3 = DM.Y;
   DM.X3 = DM.X;
    
catch
    
end
if isempty(limitModelTrialNumsTo)
    limitModelTrialNumsTo = inf;
end
if isempty(msRangeToModel)
    msRangeToModel = 1:C.t;
end

msRangeToModel = unique(ceil(msRangeToModel./DM.binSize));

DM.perc2model = perc2model;
if round(C.k.*DM.perc2model) > limitModelTrialNumsTo
    DM.perc2model = limitModelTrialNumsTo./C.k;
end

DM.tomodel = randsample(C.k, round(C.k.*DM.perc2model));
DM.toTest = setdiff(1:C.k , DM.tomodel);

DM.Xreshaped = reshape(DM.X3, C.t./DM.binSize, C.k, size(DM.X3, 2));
DM.Xreshaped = DM.Xreshaped(msRangeToModel, :, :);
DM.X2model = reshape(DM.Xreshaped(:, DM.tomodel, :), [], size(DM.X3, 2));
DM.X2test = reshape(DM.Xreshaped(:, DM.toTest, :), [], size(DM.X3, 2));

DM.Yreshaped = reshape(DM.Y3, [], C.k);
DM.Yreshaped = DM.Yreshaped(msRangeToModel, :, :);
DM.Y2model = DM.Yreshaped(:, DM.tomodel);
DM.Y2test = DM.Yreshaped(:, DM.toTest);
%% remove all nans
[DM.X2model, DM.Y2model, DM.XY2model_inds] = nanRemove(DM.X2model, DM.Y2model);
[DM.X2test, ~, DM.XY2test_inds] = nanRemove(DM.X2test, DM.Y2test);
DM.limitModelTrialNumsTo = limitModelTrialNumsTo;
DM.msRangeToModel = msRangeToModel;