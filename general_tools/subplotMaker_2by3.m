%% subplotMakerNumber = 1 ; subplotMaker
%% subplotMakerNumber = 2 ; subplotMaker

%% PART 1
if subplotMakerNumber == 1
    SP1 = 2; %subplot indice 1
    SP2 = 3; %subplot indice 2
    %     SP1 = 3; %subplot indice 1
    %     SP2 = 2; %subplot indice 2
    % saveCurrentVars = false;
    allCounter = 0;
    dateString = datestr(now,'mmddHHMMSS');
    addToFigNum = str2num(dateString);
    counterUnique984398598435 = SP1.*SP2;
    
    subplotLast = subplotMakerNumber;
    %% PART 2
elseif subplotMakerNumber == 2
    allCounter = allCounter+1;
    
    if counterUnique984398598435 == SP1.*SP2
        counterUnique984398598435 = 0 ;
        mainFig = figure;
        hold on
        
    end
    
    counterUnique984398598435 = counterUnique984398598435 +1;
    subplot(SP1, SP2, counterUnique984398598435)
    subplotLast = subplotMakerNumber;
    
    
    
    %% PART 3
    
elseif subplotMakerNumber ==3 % reset to plot over
    allCounter = allCounter+1;
    if subplotLast~=3
        resetCounterNumber = counterUnique984398598435;
         subplotLast = subplotMakerNumber;
    end
    
    if counterUnique984398598435 == resetCounterNumber
        counterUnique984398598435 = 0 ;
        %                 mainFig = figure;
        hold on
        
    end
    hold on
    counterUnique984398598435 = counterUnique984398598435 +1;
    subplot(SP1, SP2, counterUnique984398598435)
    
    %% PART 4 input your own number of plots thats not the usual number
elseif subplotMakerNumber == 4
    subplotLast = subplotMakerNumber;
    % saveCurrentVars = false;
    allCounter = 0;
    dateString = datestr(now,'mmddHHMMSS');
    addToFigNum = str2num(dateString);
    counterUnique984398598435 = SP1.*SP2;
    
    
end