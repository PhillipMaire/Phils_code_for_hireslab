function [finalMask, maskDetails] = masky(varNames, rangeOfMask, C,remSegmentsLowerThan,  varargin)
%{
remLowerThan = 50; % removed segments lower than this length( acts on the NON MASK PART)
% and this makes sense because it doesnt matter how small the mask is it only matters how
% large the segments you are processing are
varNames = masky; % this auto generates the names of the mask variables. they dont have to be in
%this order but they obviously have to match the order of the input variables below
varNames =

  4×1 cell array

    {'touch'    }
    {'poleUP'   }
    {'poleDOWN' }
    {'amplitude'}
%% times for masks
touch_M = 0:50;
P_UP_M = 0:50;
P_down_M = 0:50;
amp = 0 ;
rangeOfMask = [{touch_M} {P_UP_M} {P_down_M}, {amp}]

% special setting for continious variables, the variable comes first and then the operator so this
%created a mask for all amplitudes less than 5.
maskyExtraSettings = [{''} {''}  {''} {'<5'}];


    [allMask, maskDetails] = masky(varNames, rangeOfMask, C, remLowerThan, maskyExtraSettings);

%}

V = {...
    'touch'...%1
    'poleUP'...%2
    'poleDOWN'...%3
    'amplitude'...%4
    'whiskOnset'...%5
    };
if nargin ==0
    finalMask = V(:);
    return
elseif nargin == 4
    %     [cmdMat{1:length(V)}] = deal([]);
elseif nargin == 5
    cmdMat = varargin{1};
    if ~all([length(varNames), length(rangeOfMask), length(cmdMat)] == length(varNames))
        error('all inputs must be the same size')
    end
    
    %      if length(cmdMat)< length(V) %make sure its the correct length
    %          cmdMat{length(cmdMat)+1:length(V)}= deal('');
    %      end
else
    error('Must be either 0, 4, or 5 inputs');
end
if ~all([length(varNames), length(rangeOfMask)] == length(varNames))
    error('all inputs must be the same size')
end
%% save the info for knowing what was blicked out for later use.
maskDetails = '';
for k = 1:length(rangeOfMask)
    if ~isempty(rangeOfMask{k})
        maskDetails = [maskDetails, varNames{k}, ' ', num2str(rangeOfMask{k}(1)),...
            ' to ', num2str(rangeOfMask{k}(end)), ' ', cmdMat{k}, ' , '];
    end
end
maskDetails = maskDetails(1:end-2);
maskDetails = [maskDetails, ', removed segments less than ', num2str(remSegmentsLowerThan)];
%%
allMaskInds = [];
[lia,locb] = ismember(lower(V), lower(varNames));
varInds = find(lia);

%% check if there are any string inputs that arent actually mask options
badBoys = setdiff(varNames, V(varInds));
if length(varInds) ~= length(varNames)
    string1 = '';
    for BB = 1:length(badBoys)
        string1 = [string1, badBoys{BB}, ', '];
    end
    error(['The following string input(s) -->[',string1(1:end-2), '] is not recognized as a valid variable name, please try again'])
end

%% make touch masks
key1 = 1;
if any(varInds== key1)
    R = rangeOfMask{locb(key1)};
    [allTouches, segments, protractionTouches] = GET_touches(C, 'all', false);
    [tmpInd, touchMask_masktrials, touchMask_maskTimes] = ...
        mask(allTouches, R, C.t, C.k);
    allMaskInds = [allMaskInds(:); tmpInd(:)];
end
%% make pole up masks
key1 = 2;
if any(varInds== key1)
    R = rangeOfMask{locb(key1)};
    [tmpInd, poleUP_masktrials, poleUP_maskTimes] = ...
        mask(C.meta.poleOnset, R, C.t, C.k);
    allMaskInds = [allMaskInds(:); tmpInd(:)];
    
end
%% make pole down masks
key1 = 3;
if any(varInds== key1)
    R = rangeOfMask{locb(key1)};
    [tmpInd, poleDOWN_masktrials, poleDOWN_maskTimes] = ...
        mask(C.meta.poleOffset, R, C.t, C.k, [], 'trialTime');
    allMaskInds = [allMaskInds(:); tmpInd(:)];
    
end
%%
key1 = 4;
if any(varInds== 4)
    R = rangeOfMask{locb(key1)};
    cmdStr = cmdMat{locb(key1)};
    %     if ~(all(size(`) == [C.t, C.k])); error('matrix not the corect size'); end
    var1 = squeeze(C.S_ctk(3, :, :));% check how nans are treated for > and <
    cmdStr = ['var1 = var1', cmdStr, ';'];
    
    try; eval(cmdStr); catch error(['the following string command, ', cmdStr, ' is not valid']); end
    [tmpInd, poleDOWN_masktrials, poleDOWN_maskTimes] = ...
        mask(var1, R, C.t, C.k);
    allMaskInds = [allMaskInds(:); tmpInd(:)];
end
%%
key1 = 5;
if any(varInds== key1)
    if contains('whiskOnset',  fieldnames(C))
        R = rangeOfMask{locb(key1)};
        
        [tmpInd, whiskOnset_trials, whiskOnset_maskTimes] = ...
            mask(C.whiskOnset.linIndsONSETS, R, C.t, C.k);
        allMaskInds = [allMaskInds(:); tmpInd(:)];
    else
        error('you need to load the whiksing onsets on the Uarray')
    end
end
%%
key1 = 6;
if any(varInds== key1)
    R = rangeOfMask{locb(key1)};
    
end
%%
key1 = 7;
if any(varInds== key1)
    R = rangeOfMask{locb(key1)};
    
end
%%
key1 = 8;
if any(varInds== key1)
    R = rangeOfMask{locb(key1)};
    
end
%%
key1 = 9;
if any(varInds== key1)
    R = rangeOfMask{locb(key1)};
    
end
%% combine masks
finalMask = unique(allMaskInds);
if remSegmentsLowerThan>0
    segs = findInARow(setdiff(1:(C.t .* C.k), finalMask), C.t);
    shortInds = find(segs(:, 3)<remSegmentsLowerThan);
    tmp2add = [];
    for k = 1:length(shortInds)
        TTT = segs(shortInds(k), 1):segs(shortInds(k), 2);
        tmp2add(1:end+length(TTT)) = [tmp2add(:); TTT(:)];
        
    end
    finalMask = unique([finalMask(:); tmp2add(:)]);
    
end
