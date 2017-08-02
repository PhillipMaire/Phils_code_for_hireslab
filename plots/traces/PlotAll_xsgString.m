% function PlotAll_xsg(fileDir)
%plot all XSG files from a folder into one plot
fileDir='Z:\Users\Phil\Data\whole cell\PM0037 for plotting'
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
TraceNamesToPlot= traceNames;
Index = 1:numel(traceNames);
cellName = 'ALL_CELLS';
count = 1;
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
      %%%%1:numel()    us this for all the folders 
    %%(trace.({k}(1:end-4)))-2;%- 2 to account for
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

%% PLOT ONLY ONE CELL E.G CELL AAAB otherwise index will be all numbers of cells 
%Index = 1:numel(traceNames); %for plotting all traces in folder
clear index
cellName = 'AAAA';
IndexC = strfind(traceNames, cellName);
Index = find(not(cellfun('isempty', IndexC)));

if isempty(Index)
    error('oops it doesnt seem that cell name is present')
else
TraceNamesToPlot = traceNames(Index);
end


%%
%use this to plot all of the XSG files 
count = count +1;
TracePlotHandle = figure(count);
hold on

figName = strcat( fName{1}(1:6),'_', cellName, '_',num2str(numel(Index)) ,'_','trials');
set(TracePlotHandle, 'name',figName, 'FileName',figName);


shift = 1;

traces2plot = tracesVar(Index);
for i = 1:numel(traces2plot)
    traceLength = numel(traces2plot{i});
    Xstart = shift;
    Xend = shift + traceLength -1;
    plot (Xstart:Xend,traces2plot{i})
    shift = shift + traceLength;
    
%     plot (42001:84000,tracesVar{2})
     
end
%%
%use this to plot select XSG files just dividethe x location by 42000
%(sampling rate 10,000 hZ time of trials 4.2s) then round that number up to
%get the disired trace. 

count = count +1;
TracePlotHandle = figure(count);
hold on
SelectedIndex = Index(1);
traceNamesPlotted = traceNames(SelectedIndex);
FirstTraceNum = traceNamesPlotted{1}(11:14);
if numel(SelectedIndex)>1
LastTraceNum = traceNamesPlotted{end}(11:14);
TraceNumbers = strcat(FirstTraceNum,'-', LastTraceNum);
else
TraceNumbers = FirstTraceNum;
end

figName = strcat( fName{1}(1:6),'_', cellName, '_','traces','_',TraceNumbers);
set(TracePlotHandle, 'name',figName, 'FileName',figName);

shift = 1; 
traces2plot = tracesVar(SelectedIndex);
for i = 1:numel(traces2plot)
    traceLength = numel(traces2plot{i});
    Xstart = shift;
    Xend = shift + traceLength -1;
    plot (Xstart:Xend,traces2plot{i})
    shift = shift + traceLength;
    
%     plot (42001:84000,tracesVar{2})
     
end



% %%
% test1= strcat(baseFolder, filesep, {k})
% test2 = dir(test1)
% test2.name