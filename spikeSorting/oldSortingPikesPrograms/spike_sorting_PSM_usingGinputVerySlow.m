
%%%  [indexingMat,spksToPlotGood,spksToPlotBad, good, bad]= ...
%%%  spike_sorting_PSM(TrialIndCount,swall,swAdjusted,varargin) trial count
%%%  is an array each of trials it can be uneven (eg
%%%  [1:10:200,201,203,600])but normaally something like (1:100:600)
%%%  looking at 100 trials at a time. your maxe can be over the trial count
%%%  and the program will adjust it automatically. swall is all the spikes
%%%  each packaged in a cell for each trial. scaleORaligned jusr is a
%%%  string either 'scale' or 'aligned' to scale the spikes or simply align
%%%  them. preSpikeBaselineTime is how scale and aligned spikes are
%%%  positioned this is an vector array of the baseline time traditionally
%%%  set to (1:10) but if the begining of the spike is aroun 12 ms then a
%%%  better value might be something like (9:12), you can also use one
%%%  single number but this is not suggested.
%%%  varargin --> 1) input an old indexingMat
%%%  variable from previous work (note the indexingMat variable is saved for
%%%  each iteration in the current directory under indexingMatVar.mat, NOTE:
%%%  THAT THE indexingMat VARIABLE WILL ONLY BE CORRECT IF THE SAME
%%%  TrialIndCount VARIABLE WAS USED TO MAKE THAT indexingMat VARIABEL
%%%  (otherwise it will mix up trials obviously). 2) you can skip to this
%%%  plot number note the last plot is equal to numel(TrialIndCount)-1
%%% use skipToTrial for varargin 1 (as string) and then the trial num as
%%% double for varargin2 to skip to trial without loading a previous
%%% indexing mat (normally used just to view spikes from that traial)

%%%removed swAdjusted
function [indexingMat,spksToPlotGood,spksToPlotBad, good, bad]= ...
    spike_sorting_PSM(TrialIndCount,swall,scaleORaligned, preSpikeBaselineTime,varargin)
for k = 1:numel(swall)
    if ~isempty(find(swall{k}))
        timePoints = length(swall{k}(:,1));
    end
end
var2 = abs(TrialIndCount - length(swall));
trimTrialIndCount = find(var2==min(var2)) +2;
TrialIndCount = TrialIndCount(1:trimTrialIndCount);

maxNumPoints = 15;
setPoints = maxNumPoints*3;
if nargin == 4 || strcmp(varargin{1}, 'skipToTrial')
    %creat indexingMat variable if not passed through
    indexingMat = ones(length(TrialIndCount)-1, setPoints);%1 mean greater than 0 means less than
    indexingMat(:, 1:3:setPoints) = timePoints/2;%time %35 is number of points
    indexingMat(:,3:3:setPoints) = 9999999; %%MV NUMBER
    
elseif nargin >= 5
    indexingMat = varargin{1};
end
testCorrectIndexMat = indexingMat(:,[1:3:setPoints]);
testCorrectIndexMat = mode(reshape(testCorrectIndexMat, [1, numel(testCorrectIndexMat)]))*2
if testCorrectIndexMat ~= timePoints
    error('the swall input and the indexing mat aren''t a match, time points don''t match!!' );
end


swcat = [swall{:}];

if strcmp(lower(scaleORaligned), 'scale')
    swAdjusted = (swcat - repmat(mean(swcat(preSpikeBaselineTime,:)),timePoints,1))./repmat(max(swcat)-mean(swcat(preSpikeBaselineTime,:)),timePoints,1);
    plotLimY = [-2 1.2];
elseif strcmp(lower(scaleORaligned), 'aligned')
    swAdjusted = swcat - repmat(sum(swcat(preSpikeBaselineTime,:))/numel(preSpikeBaselineTime),timePoints,1);
    plotLimY = [-5 10];
else
    error('must be scale or aligned please adjust variable')
end


figName = figure(51);
figName.Units = 'normalized'
figName.OuterPosition = [0 0 .8 1];

[trash, spikeCountPerTrial] = cellfun(@size, swall);

%make sure the matrix isnt too big
TrialIndCount = TrialIndCount(~(TrialIndCount>length(swall)+1));
if TrialIndCount(end) ~= length(swall)+1
    TrialIndCount(end+1) = length(swall)+1;
end

startNum = 1;
if nargin>4
    if strcmp(varargin{1}, 'skipToTrial')
        startNum = varargin{2};
    elseif nargin == 6 %skip to this section
        startNum = varargin{2};
    end
end

for addNum= startNum: length(TrialIndCount)-1
    save('indexingMat','indexingMat')
    display('saved indexingMat automatically overwrites, load if program crashes')
    allSpikes = spikeCountPerTrial(1:TrialIndCount(1+addNum)-1);
    spikeCountPerTrialChunk = spikeCountPerTrial(TrialIndCount(addNum):TrialIndCount(1+addNum)-1);
    if sum(spikeCountPerTrialChunk)<1 %dont use no spike trials
        delete(spikeHandle)
        FigNameString = ['Plot ',num2str(addNum),'/', num2str(length(TrialIndCount)-1),'     Trials ', num2str(TrialIndCount(addNum)), '-',num2str(TrialIndCount(1+addNum)-1),'     Spikes ',num2str(test3), '-' num2str(test1)];
        title(FigNameString)
        lineMat(1:timePoints+1) = -1;
        line(0:timePoints, lineMat);
        text(7,0,'no spikes for this chunk- hit enter to continue')
        pause()
    else
        
        test1 = sum(allSpikes);
        test2 = sum(spikeCountPerTrialChunk);
        test3 = test1 - test2 +1;
        
        % addNum =5; % start with 1. make it 1 less than the numbers in TrialIndCount
        %%%%%%%%change addNum number to go through each chunk of the cell spike data
        
        
        hold off
        spikeHandle = plot(swAdjusted(:,test3:test1));
        FigNameString = ['Plot ',num2str(addNum),'/', num2str(length(TrialIndCount)-1),'     Trials ', num2str(TrialIndCount(addNum)), '-',num2str(TrialIndCount(1+addNum)-1),'     Spikes ',num2str(test3), '-' num2str(test1)];
        title(FigNameString)
        hold on
        ylim(plotLimY)
        grid minor
        yesTrigger = 0;
        newPointTrigger = 0;
        
        
        while yesTrigger == 0
            numGinput = 2;
            addNewPoint = 0;
            
            while newPointTrigger == 0
                % try
                if addNewPoint == 0
                    [time,miliVolts, button] = ginput(numGinput);
                    for k = 1:numel(time)
                        skipBy = k*3;
                        indexingMat(addNum, skipBy-2)= time(k);%set times
                        indexingMat(addNum, skipBy-1)= button(k)*10;%set the right clicks to 10 and left to timePoints
                        indexingMat(addNum, skipBy)= miliVolts(k);%set mV
                    end
                    
                    indexingMat2 = indexingMat;
                    indexOut = sort([(1:3:size(indexingMat,2)),(3:3:size(indexingMat,2))]);
                    indexingMat2(:,indexOut)= 0;%made to index aligned variable and removed all points
                    %except greater than or less than idicating columns
                    
                    indexingMat(indexingMat2==10) = 1;%replace the 10 with proper syntax 1 more than
                    indexingMat(indexingMat2==30) = 0;%replace the timePoints with proper syntax 0 less than
                    indexingMat(:,[1:3:size(indexingMat,2)]) = round(indexingMat(:,[1:3:size(indexingMat,2)]));%rounf time so it works
                    for k = 1:size(indexingMat, 2)/3
                        if indexingMat(addNum, k*3)<25 && indexingMat(addNum, k*3)>-10 %%only plot small enough values (can change if you values are larger for some reason)
                            if indexingMat(0+addNum,k*3-1) == 0
                                plusColor = '+b';%blue for less than
                            elseif indexingMat(0+addNum,k*3-1) == 1
                                plusColor = '+r';%red for greater than
                            else
                                error('need a one or zero for greater than or less than')
                            end
                            temp2= plot(indexingMat(addNum,k*3-2),indexingMat(addNum, k*3),plusColor);
                            plus_symbols(k) = temp2;
                        end
                    end
                    
                    
                    
                    
                elseif addNewPoint == 1
                    [time,miliVolts, button] = ginput(1);
                    if numel(time) == 1
                        numGinput = numGinput +1;
                        if numGinput>10
                            
                            close(figName)
                            error('more than 10 input values, too many')
                            return
                        end
                        skipBy = numGinput*3; %made numGinput into a counter
                        
                        indexingMat(addNum, skipBy-2)= time(1);%set times
                        indexingMat(addNum, skipBy-1)= button(1)*10;%set the right clicks to 10 and left to timePoints
                        indexingMat(addNum, skipBy)= miliVolts(1);%set mV
                    end
                    
                    indexingMat2 = indexingMat;
                    indexOut = sort([(1:3:size(indexingMat,2)),(3:3:size(indexingMat,2))]);
                    indexingMat2(:,indexOut)= 0;%made to index indexingMat variable and removed all points
                    %except greater than or less than idicating columns
                    
                    indexingMat(indexingMat2==10) = 1;%replace the 10 with proper syntax 1 more than
                    indexingMat(indexingMat2==30) = 0;%replace the timePoints with proper syntax 0 less than
                    indexingMat(:,[1:3:size(indexingMat,2)]) = round(indexingMat(:,[1:3:size(indexingMat,2)]));%rounf time so it works
                    if indexingMat(addNum, numGinput*3)<25 && indexingMat(addNum, numGinput*3)>-10 %%only plot small enough values (can change if you values are larger for some reason)
                        if indexingMat(0+addNum,numGinput*3-1) == 0
                            plusColor = '+b';%blue for less than
                        elseif indexingMat(0+addNum,numGinput*3-1) == 1
                            plusColor = '+r';%red for greater than
                        else
                            error('need a one or zero for greater than or less than')
                        end
                        plus_symbols(numGinput) = plot(indexingMat(addNum,numGinput*3-2),indexingMat(addNum, numGinput*3),plusColor);
                    end
                end
                
                
                save('indexingMatVar.mat','indexingMat')
                button = questdlg('is this correct?','>_<','Yes','No','yes & add 1 more point', 'Yes')
                switch button
                    case 'Yes';
                        yesTrigger =1;
                        newPointTrigger = 1;
                    case 'No';
                        if numGinput ==2
                            delete(plus_symbols(:));
                        else
                            delete(plus_symbols(numGinput));
                        end
                    case 'yes & add 1 more point';
                        newPointTrigger =0
                        
                        addNewPoint = 1;
                end
            end
        end
    end
end
indexingMat = indexingMat(1:addNum,:);
close(figName)
save('indexingMatVar.mat','indexingMat')
display('''indexingMat'' saved and trimmed correctly')















%%%%sorting out the spikes





count = 0;

% testFig = figure(21);%%%##

for addNum= 1: length(TrialIndCount)-1
    
    %     spikeCountPerTrialChunk = spikeCountPerTrial(TrialIndCount(addNum):TrialIndCount(1+addNum)-1);
    swallChunk = swall(TrialIndCount(addNum):TrialIndCount(1+addNum)-1);
    for i = 1:numel(swallChunk) %built to filter out each trial individually so can cross validate w/ licks
        INDEXnum = i+TrialIndCount(addNum)-1;
        swcatSingle = swallChunk{i};
        if isempty(swcatSingle)%%%%%%%%%%%%%%%%%%%%%%
            bad{INDEXnum,:}= [];
            good{INDEXnum} = [];
            newswall{INDEXnum} = [];
            spksToPlotGood{INDEXnum} = [];
            spksToPlotBad{INDEXnum} = [];
        else
            
            if strcmp(lower(scaleORaligned), 'scale')
                % use scaled spikes
                swSingle = (swcatSingle - repmat(mean(swcatSingle(preSpikeBaselineTime,:)),timePoints,1))./repmat(max(swcatSingle)-mean(swcatSingle(preSpikeBaselineTime,:)),timePoints,1);
                
            elseif strcmp(lower(scaleORaligned), 'aligned')
                %use aligned spikes
                swSingle = swcatSingle - repmat(sum(swcatSingle(preSpikeBaselineTime,:))/numel(preSpikeBaselineTime),timePoints,1);
            end
            %  plot(swalignedSingle);hold on%%%##
            %  xlim([0 timePoints])%%%##
            %        ylim([-10 15])%%%##
            if ~isempty(swallChunk{i});%%%%%%%%%%%%%%%%%%%%
                for k = 1:size(indexingMat, 2)/3
                    
                    %                %%%##
                    %                if indexingMat(addNum, k*3)<25 && indexingMat(addNum, k*3)>-10 %%only plot small enough values (can change if you values are larger for some reason)%%%##
                    %                             if indexingMat(0+addNum,k*3-1) == 0%%%##
                    %                                 plusColor = '+b';%blue for less than%%%##
                    %                             elseif indexingMat(0+addNum,k*3-1) == 1%%%##
                    %                                 plusColor = '+r';%red for greater than%%%##
                    %                             else%%%##
                    %                                 error('need a one or zero for greater than or less than')%%%##
                    %                             end%%%##
                    %                             temp2= plot(indexingMat(addNum,k*3-2),indexingMat(addNum, k*3),plusColor);%%%##
                    %                             plus_symbols(k) = temp2;%%%##
                    %                end
                    %                %%%##
                    %%%%use this to filter your spikes!!!   >_<
                    
                    if indexingMat(addNum,  (k-1)*3 + 2) == 1 %find each column with 1 or 0 indicating
                        %greater than (1) or less than (0) -- this is
                        %greater than case
                        %        badScale{i} = find(swscaleSingle(1,:)>9999999999999);%|swscale(22,:)<-.8|swscale(18,:)>-.2|swscale(17,:)<-3);%%|swscale(15,:)<-.4; %this is what you change to filter out bad spikes
                        badAligned{INDEXnum,k} = find(swSingle(indexingMat(addNum,  (k-1)*3 + 1),:) > indexingMat(addNum,  (k-1)*3 + 3));
                    elseif  indexingMat(addNum,  (k-1)*3 + 2) == 0
                        badAligned{INDEXnum,k} = find(swSingle(indexingMat(addNum,  (k-1)*3 + 1),:) < indexingMat(addNum,  (k-1)*3 + 3));
                    else
                        error('SYNTAX WRONG HAS TO BE 1 OR 0')
                    end
                end
                %                 if i == numel(swallChunk)%%%##
                %
                % % %                 pause()%%%##
                % %                  hold off%%%##
                %                 end%%%##
                tempBadSpikes= [badAligned{INDEXnum,:}];
                bad{INDEXnum,:}= tempBadSpikes;
                
                %                        goodScale{i} = setdiff(1:size(swscaleSingle,2),badScale{i});
                %                        goodAligned{i} = setdiff(1:size(swalignedSingle,2),badAligned{i});
                
                good{INDEXnum} = setdiff(1:size(swSingle,2),bad{INDEXnum});
                
                %
                %
                
            end
            
        end
        %                        newswScaleFilter{i} = swcatSingle(:,goodScale{i});
        %                        newswAlignedFilter{i} = swcatSingle(:,goodAligned{i});
        newswall{INDEXnum} = swcatSingle(:,good{INDEXnum}); %rewrites swall to keep only good spike columns DONT USE THIS
        spksToPlotGood{INDEXnum} = swcatSingle(:,good{INDEXnum});%all good spikes
        spksToPlotBad{INDEXnum} = swcatSingle(:,bad{INDEXnum});%all bad spikes
        %                        spksToPlotScale{i} = swcatSingle(:,goodScale{i});%all good spikes identified by the scaled display ( may contian bad spikes identified from the other display)
        %                        spksToPlotAligned{i} = swcatSingle(:,goodAligned{i});%all good spikes identified by the aligned display display( may contian bad spikes identified from the other display)
        %                        spksToPlotBadScale{i} = swcatSingle(:,badScale{i});%the bad spikes from the scale display
        %                        spksToPlotBadAligned{i} = swcatSingle(:,badAligned{i});%the bad spikes from the aligned display
        
    end
end
end