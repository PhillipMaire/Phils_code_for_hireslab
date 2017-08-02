% function PlotAll_xsg(fileDir)
%plot all XSG files from a folder into one plot
fileDir='Z:\Users\Phil\Data\whole cell\PM0015'
% fileDir = 'Z:\Users\Phil\Data\whole cell\New folder';
dirinfo = dir(fileDir);

numOfTraces= length(dirinfo)-2; %based on folder names.in baseFolder
%subtract 2 due to the '.' and '..' when using dir.
clear traceNames
for i = 3 : length(dirinfo)
    k = i-2;
    traceNames{k} = dirinfo(i).name;
    fName{k} = strcat(traceNames{k});
    trace.(fName{k}(1:end-4)) = dir([fileDir filesep traceNames{k}]);
end
%%
var1 = traceNames

%%
%set for the set you want to plot if you have multiple otherwise just use
%1 here

% NumToPlot =input('how many traces per plot?');%num of traces per figure
% for i = 1:100
%     n=(i-1)*NumToPlot;
%     var{i} = 1+n:NumToPlot+n;
% end
%%
counter = 0;
numOftraces= numel(traceNames);
for k = 1 %determines which folder to look at 
      %%%%1:numel(traceNames)    us this for all the folders 
    %%(trace.(traceNames{k}(1:end-4)))-2;%- 2 to account for
    %the '.' and '..' from dir
    for i=1:numOftraces
            
            fileName= strcat(fileDir, filesep, traceNames{i});
            d = load(fileName, '-mat');
            if isempty(d.data.ephys)
                counter = counter+1;
                warning( strcat(fileName, 'XMGfile was skipped becasue empty')) 
                pause(.25)
            else
            tracesVar{i} = d.data.ephys.trace_1;    
            end
%             if nargin >=2 
%             if varargin{1} ==1
%                 pause 
%                 close
%             end
%             end
            
       
    end
end

OutputName = 'allTraces';
save([fileDir OutputName '.mat'], 'tracesVar');

%%
%use this to plot all of the XSG files 

fig6 = figure(6)
hold on
shift = 1;
traces2plot = tracesVar(1:107);
for i = 1:numel(traces2plot)
    traceLength = numel(traces2plot{i});
    Xstart = shift;
    Xend = shift + traceLength -1;
    plot (Xstart:Xend,traces2plot{i})
    shift = shift + traceLength;
    
%     plot (42001:84000,tracesVar{2})
     
end



% %%
% test1= strcat(baseFolder, filesep, traceNames{k})
% test2 = dir(test1)
% test2.name