function               [megaPlotStruct]  =  SEM_sortBy(U, thingToDetermineString, megaPlotStruct)

% % % % 
% % % % %% need to auto generat the absline in case those go off and we have a mismatch
% % % % %% if input type is a matrix of events deal with it here
% % % % for cellStep = 1:length(U)
% % % %     thingToDetermine = eval(['U{cellStep}', thingToDetermineString]);
% % % %     thingToDetermineLIN = reshape(thingToDetermine, numel(thingToDetermine), 1);
% % % %     sigL = 100; %length of the signal (time added on to event chosen)
% % % %     shiftSig = 0; %length to shift away from signal
% % % % % % % % %     if U{cellStep}.k < 6
% % % % % % % % %         error('MUST CONTAIN MORE THAN 6 TRIALS, DONT BE SHITTY')
% % % % % % % % %     end
% % % %     trialLength = U{cellStep}.t;
% % % %     numTrials = U{cellStep}.k;
% % % %     nanEmpty = nan(trialLength, numTrials);
% % % %     makeLinInds = linspace(0, trialLength.*numTrials, numTrials+1);
% % % %     makeLinInds = makeLinInds(1:end-1);
% % % %     leewayCutoff = 0; % not yet programed in but will allow for regions where the signal you want (eg pole down +100 ms) goes over the
% % % %     % limit of the trial length. this will count it as long as it doesnt go over the trial length (4000) plus the leewayCutoff value
% % % %     % will have to have a way of dealing with this later by filling in the matrix with nans OORRRRR
% % % %     % I could take those values turn the cutoff to 4000 (or 1 if its the other direction) then mark it with a 1 if it was
% % % %     % modified liek that (shortened) and if it has any ones there and when I am ready I can generate the indexing array (all the numbers in
% % % %     % between the start and end, and pad with nans by looping with a known array length of nans and fill the rest in. might have to
    % distinguish between the types of trimming, with to 1 or to 4000
    
    %%% if the matrix matches this size then do some shit
    
    
    if numel(shiftSig ) ==1
        shiftSig = repmat(shiftSig, [1 numTrials]);
    elseif find(size(shiftSig) == numTrials) == 2 &&  find(size(shiftSig) ~= numTrials) == 1
        % do nothing cause it is in the correct format
    elseif find(size(shiftSig) == numTrials) == 1 &&  find(size(shiftSig) ~= numTrials) == 2
        % switch it around
        shiftSig = shiftSig';
    elseif numel(shiftSig ) ~= numTrials
        error('shift signal variable not formated correctly')
    end
    
    
    
    %% basic featres
    %%  - control the basline and response to determine how it will react, either throw that one out or include it but shorten the time
    %  - can input matrixs lin inds or regular inds and automatically detects this
    
    
    %% make transformaers for the licking for sure
    
    %% might need one to interpret the spikes
    
    
    %% - output is a matrix or lin inds of the thing for all baslines
    %% same matrix should contain the following
    % - trial number (index number) ,
    % -lin inds start and end obvious ,
    %% - which event it was for that trial (e.g. first or second touch)
    %% if it was trimmed to not normal length indexewd with a 1 or 0
    %% deal with cells and differnt formats??? prob just standardize the format and make transformer things.
    
    %% have second program that will sort and select the trials based on the output here
    
    % first determine if matrix, linear inds, or trial based ind or matrix
    if isequal(size(thingToDetermine), size(ones(trialLength,numTrials )))
        error(' havn''t developed the full matrix version yet')
        
        
        % linear inds must are used
    elseif nanmedian(thingToDetermineLIN)> (trialLength.*3)   % leave some wiggle room because behavior like licks for example can run over
        error(' havn''t developed the lin-inds version')
        % % %         || max(thingToDetermineLIN) > (trialLength.*5) < (trialLength.*5) THIS DOESNT WORK BECASUE FOR SOME REASON SOME LICKS ARE LIKE 32000 SO I
% DONT KNOW WHAT THAT IS 
        
        % trial based inds are used
    elseif nanmedian(thingToDetermineLIN)< (trialLength.*3)  % leave some wiggle room because behavior like licks for example can run over
        % licks, pole up, pole down, and touchs (may need ot process just like the licks to make a nice matrix) will be processed here because they are all determined by the trial (not lin inds or matrix
        % of trialLength by numTrials
% % %         || max(thingToDetermineLIN) < (trialLength.*5) THIS DOESNT WORK BECASUE FOR SOME REASON SOME LICKS ARE LIKE 32000 SO I
% DONT KNOW WHAT THAT IS 
        %find on which axis the trials are on
        locOfTrialDim = find(size(thingToDetermine) == numTrials);
        locOfNumPerTrialDim = find(size(thingToDetermine) ~= numTrials);
        if isempty(locOfTrialDim) || isempty(locOfNumPerTrialDim) || locOfNumPerTrialDim==locOfTrialDim;
            error('either empty matrix or the the trials dont match or the num trials match the event length per trial...');
        elseif locOfTrialDim ~= 2 %this way I dont have to deal with different indexing
            thingToDetermine = thingToDetermine';
        end
        % To preserve the trial it was taken from make a mtrax the same size and index it the same as the main matrix
        trialNumbers = ones(size(thingToDetermine))+ (makeLinInds./trialLength);
        
        %correct the time by the shift value so can be basic shift value or can be variable per trial
        % nans will clear that trial (so if you did this based on first lick and the trial had no lick, then it would eliminate that trial
        thingToDetermine = thingToDetermine + shiftSig;
        % all events not occuring in the region we have spikes just remove them
        removedInd.startRegionLarge = find(thingToDetermine>trialLength);
        removedInd.startRegionSmall = find(thingToDetermine<1);
        thingToDetermine(unique([removedInd.startRegionLarge; removedInd.startRegionSmall])) = nan;
        
        % get the end of the signal and trim where it goes over
        endSignal = thingToDetermine+sigL;
        removedInd.endRegionLarge = find(endSignal> trialLength);
        removedInd.endRegionSmall = find(endSignal< 1);
        endSignal(unique([removedInd.endRegionLarge; removedInd.endRegionSmall])) = nan;
        
        allGoodInds = intersect(find(~isnan(endSignal+makeLinInds)), find(~isnan(thingToDetermine+makeLinInds)));
        % transform to linear inds and we're done!
        thingToDetermineREGinds = thingToDetermine(allGoodInds);%for normal inds
        thingToDetermine = thingToDetermine +makeLinInds;
        thingToDetermine = thingToDetermine(allGoodInds);
        
        endSignalREGinds = endSignal(allGoodInds);%for normal inds
        endSignal = endSignal +makeLinInds;
        endSignal = endSignal(allGoodInds);
        
        trialNumbers = trialNumbers(allGoodInds);
        
        TrialOrder = [];
        uniqueTrials = unique(trialNumbers);
        for k2 = 1:length(uniqueTrials)
            k = uniqueTrials(k2);
            trialNumbers2 = trialNumbers(trialNumbers== k);
            TrialOrder(end+1:end+length(trialNumbers2), 1) =  1:length(trialNumbers2);
        end
        
        
        ultimateMat = [thingToDetermine, endSignal, trialNumbers, TrialOrder,thingToDetermineREGinds , endSignalREGinds];
        SS.Mat = ultimateMat;% super structs
        ultimateMatNames = {'lin-Ind start', 'lin-Ind stop','tria Index for U array', ...
            'ordered occurence of event in each trial given the current settings, so eliminated events (becasue of cut offs) will not be counted',...
            'regular indexing start', 'regular indexing end'};
        SS.MatNames = ultimateMatNames';
        megaPlotStruct{cellStep} = SS;
    else
        error('not recognized input')
        
    end
    
end





















