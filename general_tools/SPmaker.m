%% EXAMPLE OF HOW TO USE
%{
SP1 = 2;
SP2 = 4;
[SPout] = SPmaker(SP1, SP2);
for k = 1:10
    [SPout] = SPmaker(SPout);
    plot(rand(1, 50))
end
%}
function [outputVarAll] = SPmaker(varargin)
%% PART 1
if nargin >= 2
    SP1 = varargin{1};
    SP2 = varargin{2};
    %     dateString = datestr(now,'mmddHHMMSS');
    %     addToFigNum = str2num(dateString);
    allCounter = 0;
    counterVar1 = SP1.*SP2;
    outputVarAll.allCounter = allCounter;
    outputVarAll.counterVar1 = counterVar1;
    
    outputVarAll.SP1 = SP1;
    outputVarAll.SP2 = SP2;
    outputVarAll.topDown = false;
    if nargin == 3
        if varargin{3} == 1
            outputVarAll.topDown = true;
        end
    end
    %% PART 2
elseif nargin == 1
    outputVarAll = varargin{1};
    counterVar1 = outputVarAll.counterVar1;
    allCounter = outputVarAll.allCounter;
    SP1 = outputVarAll.SP1;
    SP2 = outputVarAll.SP2;
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
    if outputVarAll.topDown
        tmp = reshape(1:(SP1*SP2)', [SP2,SP1])';
        subplot(SP1, SP2, tmp(counterVar1))
    else
        subplot(SP1, SP2, counterVar1)
    end
    outputVarAll.allCounter = allCounter;
    outputVarAll.counterVar1 = counterVar1;
    outputVarAll.mainFig = mainFig;
end