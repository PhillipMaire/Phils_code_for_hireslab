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
    if any(contains(fieldnames(outputVarAll), 'mainFig'))
        figure(outputVarAll.mainFig);
    end
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
        if ~isfield(outputVarAll, 'allFigs')
            outputVarAll.allFigs{1} = mainFig;
            outputVarAll.allSubPlots = {};
            outputVarAll.allSubPlots{length(outputVarAll.allFigs)} = {};
        else
            outputVarAll.allFigs{end+1} = mainFig;
            outputVarAll.allSubPlots{length(outputVarAll.allFigs)} = {};
        end
        hold on
        
    end
    counterVar1 = counterVar1 +1;
    if outputVarAll.topDown
        tmp = reshape(1:(SP1*SP2)', [SP2,SP1])';
        outputVarAll.allSubPlots{length(outputVarAll.allFigs)}{end+1} = subplot(SP1, SP2, tmp(counterVar1));
    else
        outputVarAll.allSubPlots{length(outputVarAll.allFigs)}{end+1} = subplot(SP1, SP2, counterVar1)
    end
    outputVarAll.allCounter = allCounter;
    outputVarAll.counterVar1 = counterVar1;
    outputVarAll.mainFig = mainFig;
    
    outputVarAll.newPlotTrigger = mod( outputVarAll.allCounter, outputVarAll.SP2*outputVarAll.SP1) ==1;
    outputVarAll.lastPlotTrigger = mod( outputVarAll.allCounter, outputVarAll.SP2*outputVarAll.SP1) ==0;
    
else
    
    
    
    fprintf('\n\n\nRUN THIS AND BE HAPPY!!\n\n\nSP1 = 2;\nSP2 = 4;\n[SPout] = SPmaker(SP1, SP2);\nfor k = 1:10\n[SPout] = SPmaker(SPout);\nplot(rand(1, 50))\nend\n')
    
    
end