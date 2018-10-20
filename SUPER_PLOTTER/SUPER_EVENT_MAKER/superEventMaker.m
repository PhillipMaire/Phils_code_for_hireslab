function               [megaPlotStruct]  =  superEventMaker(U, thingToDetermineInput, varargin)


%% need to auto generat the absline in case those go off and we have a mismatch
%% if input type is a matrix of events deal with it here
%% need to make a continious version of this for example if touches are a trial by trial length matrix
%% where touches are 1's then thus are a string of ones what we care about it the start and end of those
%% make two matrices where the startis one and the end is the same but in the z dimension. have a user set value for this
%% we dont want to guess at this.
argumentMinNumber = 2;

%% USER SETTING
        sigL = 0; % length of the signal (time added on to event chosen)
        % So this will be the length of the event (plus 1)
        shiftSig = 0; % length to shift away from signal
        % this is to include the baseline of the signal so shift it back 50 ms if you want
        % 50 ms of basline
        %% again, because we are adding these to the original index the total will be the ze of sigL +1
        %% and a shiftSig of 50 for example will include 49 ms of baseline and the 50th number will be the original indexs
for cellStep = 1:length(U)
    disp([num2str(cellStep), ' of ', num2str(length(U))])
    
    firstOrLastSWITCH = false;
    if nargin == argumentMinNumber
        %deafult values set above 
    elseif nargin == argumentMinNumber +2
        sigL = varargin{1};
        shiftSig = varargin{2};
    elseif nargin == argumentMinNumber +3
        warning('matrices of first and last will not match if you have non-zero signal length and shift values')
        % this is becasue the first and last of a continious array are both in 4000 by definition but for example
        % if a continious array of 1's were at the end of a trial say ms times 3985:4000 then a positive
        % shift value or a positive signal length would push the 'last' indice above 4000 and thus would be cut 
        % of off, but the 'first' indice woul dbe find (so lonf as it was under15). same is true for start cases 
        firstOrLastCMD = varargin{1};
        sigL = varargin{2};
        shiftSig = varargin{3};
    elseif nargin == argumentMinNumber +1
        firstOrLastCMD = lower(varargin{1});
        if strcmp(firstOrLastCMD, 'first') || strcmp(firstOrLastCMD, 'last')
            firstOrLastSWITCH = true;
        else
            error('string input must be either ''first'' or ''last'' to get the fisrt or last indice of a continious array')
        end
    else
        error('number of arguments is wrong')
    end
    
    
    
    if isstr(thingToDetermineInput)
        %         accepts a string that will extract valuse from U array
        thingToDetermine = eval(['U{cellStep}', thingToDetermineInput]);
    elseif iscell(thingToDetermineInput) && isequal(size(thingToDetermineInput), size(U))
        %         accepts a cell the same size as the U array where each cell is a different neuron
        thingToDetermine = thingToDetermineInput{cellStep};
    end
    
    
        if U{cellStep}.k <= 3
            error('MUST CONTAIN MORE THAN 3 TRIALS, DONT BE SHITTY')
        end
    trialLength = U{cellStep}.t;
    numTrials = U{cellStep}.k;
    nanEmpty = nan(trialLength, numTrials);
    makeLinInds = linspace(0, trialLength.*numTrials, numTrials+1);
    makeLinInds = makeLinInds(1:end-1);
    leewayCutoff = 0; % not yet programed in but will allow for regions where the signal you want (eg pole down +100 ms) goes over the
    % limit of the trial length. this will count it as long as it doesnt go over the trial length (4000) plus the leewayCutoff value
    % will have to have a way of dealing with this later by filling in the matrix with nans OORRRRR
    % I could take those values turn the cutoff to 4000 (or 1 if its the other direction) then mark it with a 1 if it was
    % modified liek that (shortened) and if it has any ones there and when I am ready I can generate the indexing array (all the numbers in
    % between the start and end, and pad with nans by looping with a known array length of nans and fill the rest in. might have to
    % distinguish between the types of trimming, with to 1 or to 4000
    
    %%% if the matrix matches this size then do some shit
    
    
    if numel(shiftSig ) ==1
        shiftSigFinal = repmat(shiftSig, [1 numTrials]);
    elseif find(size(shiftSig) == numTrials) == 2 &&  find(size(shiftSig) ~= numTrials) == 1
        shiftSigFinal = shiftSig;
        % do nothing cause it is in the correct format
    elseif find(size(shiftSig) == numTrials) == 1 &&  find(size(shiftSig) ~= numTrials) == 2
        % switch it around
        shiftSigFinal = shiftSig';
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
    
    % if is a matrix
    if isequal(size(thingToDetermine), [trialLength,numTrials])
        % just make the matrix input into lin inds, easy
        thingToDetermine = find(thingToDetermine);
    end
    thingToDetermineLIN = reshape(thingToDetermine, numel(thingToDetermine), 1);
    % if the input are lin inds transform into regular inds (i know this is counter intuative but I
    % want to make sure everything is trasnformed in the same way
    
    if nanmedian(thingToDetermineLIN)> (trialLength.*2)   % leave some wiggle room because behavior like licks for example can run over
        thingToDetermine2 = thingToDetermine./ trialLength;
        
        trialNums = ceil(thingToDetermine2);
        thingToDetermine2 = round((thingToDetermine2 - (floor(thingToDetermine2))).*trialLength) +1; % had to put plus one here to make index right 
        emptyNans = nan(trialLength, numTrials);
        for nanMatIter = 1:numTrials % turn into mat with nans
            indexInTrial = (find(trialNums == nanMatIter));
            emptyNans(1:length(indexInTrial), nanMatIter) = thingToDetermine2(indexInTrial);
        end
        thingToDetermine = emptyNans;
    end
    
    %% put  function here to find teh end or start of an array of ones in the matrix based on the user inouting
    %% either 'start' or 'end' request string
    if firstOrLastSWITCH
        startContSig = nan(trialLength, numTrials);
        endContSig = nan(trialLength, numTrials);
        
        for hhhhhhh = 1:numTrials
            thisTrial =  thingToDetermine(:,hhhhhhh);
            thisTrialChunks = (thisTrial - (1:trialLength)')+1;
            if ~isempty(thisTrialChunks)
                UniqueNums = unique(thisTrialChunks);
                UniqueNums = UniqueNums(~isnan(UniqueNums));
                for gggggg = 1:length(UniqueNums)
                    indsOfChunk = find(thisTrialChunks == UniqueNums(gggggg));
                    startContSig(gggggg, hhhhhhh) = thisTrial(indsOfChunk(1));
                    endContSig(gggggg, hhhhhhh) = thisTrial(indsOfChunk(end));
                    
                end
            end
        end
        if strcmp(firstOrLastCMD, 'first')
            thingToDetermine = startContSig;
        elseif strcmp(firstOrLastCMD, 'last')
            thingToDetermine = endContSig;
        else
            error('this error should never happen')
        end
    end
    
    %%
    thingToDetermineLIN = reshape(thingToDetermine, numel(thingToDetermine), 1);
    % if trial based inds are used
    if nanmedian(thingToDetermineLIN)< (trialLength.*3)  % leave some wiggle room because behavior like licks for example can run over
        % licks, pole up, pole down, and touchs (may need ot process just like the licks to make a nice matrix) will be processed here because they are all determined by the trial (not lin inds or matrix
        % of trialLength by numTrials
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         || max(thingToDetermineLIN) < (trialLength.*5) THIS DOESNT WORK BECASUE FOR SOME REASON SOME LICKS ARE LIKE 32000 SO I
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % DONT KNOW WHAT THAT IS
        %find on which axis the trials are on
        locOfTrialDim = find(size(thingToDetermine) == numTrials);
        locOfNumPerTrialDim = find(size(thingToDetermine) ~= numTrials);
        if isempty(locOfTrialDim) || isempty(locOfNumPerTrialDim) || locOfNumPerTrialDim==locOfTrialDim;
            error('either empty matrix or the the trials dont match or the num trials match the event length per trial...');
        elseif locOfTrialDim ~= 2 %this way I dont have to deal with different indexing
            thingToDetermine = thingToDetermine';
        end
        % To preserve the trial it was taken from make a matrix the same size and index as the same as the main matrix
        trialNumbers = ones(size(thingToDetermine))+ (makeLinInds./trialLength);
        
        %correct the time by the shift value so can be basic shift value or can be variable per trial
        % nans will clear that trial (so if you did this based on first lick and the trial had no lick, then it would eliminate that trial
        thingToDetermine = thingToDetermine + shiftSigFinal;
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
        
        % reshape everything because it need to be in events by 1 dimensions, and trial order is already
        % guaranteed to be correct dimentions
        ultimateMat = [reshape(thingToDetermine, size(TrialOrder)),...
            reshape(endSignal, size(TrialOrder)), ...
            reshape(trialNumbers, size(TrialOrder)),...
            reshape(TrialOrder, size(TrialOrder)),...
            reshape(thingToDetermineREGinds , size(TrialOrder)), ...
            reshape(endSignalREGinds, size(TrialOrder))];
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

end
