%% subplotMakerNumber = 1 ; subplotMaker
%% subplotMakerNumber = 2 ; subplotMaker
function [outputVarAll] = subplotMaker_2by4(SP1, SP2, beginOrCont,varargin)
%% PART 1
if beginOrCont == 1
    allCounter = 0;
    dateString = datestr(now,'mmddHHMMSS');
    addToFigNum = str2num(dateString);
    counterVar1 = SP1.*SP2;
    
    subplotLast = beginOrCont;
    outputVarAll.allCounter = allCounter;
    outputVarAll.counterVar1 = counterVar1;
    %% PART 2
elseif beginOrCont == 2
    outputVarAll = varargin{1};
    counterVar1 = outputVarAll.counterVar1;
    allCounter = outputVarAll.allCounter;
    try
        mainFig = outputVarAll.mainFig;
    catch
    end
    
    
    allCounter = allCounter+1;
    
    if counterVar1 == SP1.*SP2
        counterVar1 = 0 ;
        mainFig = figure;
        hold on
        
    end
    
    counterVar1 = counterVar1 +1;
    subplot(SP1, SP2, counterVar1)
    subplotLast = beginOrCont;
    
    
    outputVarAll.allCounter = allCounter;
    outputVarAll.counterVar1 = counterVar1;
    outputVarAll.mainFig = mainFig;
    %% PART 3
    
    % elseif subplotMakerNumber ==3 % reset to plot over
    %     allCounter = allCounter+1;
    %     if subplotLast~=3
    %         resetCounterNumber = counterVar1;
    %          subplotLast = beginOrCont;
    %     end
    %
    %     if counterVar1 == resetCounterNumber
    %         counterVar1 = 0 ;
    %         %                 mainFig = figure;
    %         hold on
    %
    %     end
    %     hold on
    %     counterVar1 = counterVar1 +1;
    %     subplot(SP1, SP2, counterVar1)
    %
    %     %% PART 4 input your own number of plots thats not the usual number
    % elseif subplotMakerNumber == 4
    %     subplotLast = beginOrCont;
    %     % saveCurrentVars = false;
    %     allCounter = 0;
    %     dateString = datestr(now,'mmddHHMMSS');
    %     addToFigNum = str2num(dateString);
    %     counterVar1 = SP1.*SP2;
    %
    
end