function PlotAll_xsg(fileDir, varargin)
%funtion PlotAll_xsg works to plot multiple XSG files on a dingle plot you
%can choose to plot for example 3 xsg files per plot based on a directory
%that has 10 
%{



PlotAll_xsg('C:\Users\maire\Downloads\New folder (5)')

%}
%%%%%%%%%%%%%%%%%%%%full screen 
if nargin >=3 
if varargin{2} == 'full'
set(0, 'DefaultFigurePosition', [1, 41, 1920, 964]); 
elseif  varargin{2} == 'topleft'
%%%%%%%%%%%%%%%%%%%%top left screen
set(0, 'DefaultFigurePosition', [ 25   397   800   600])%top left screen
end
end
%%


% fileDir = 'Z:\Users\Phil\Data\whole cell\New folder';
dirinfo = dir(fileDir);

numOfTraces= length(dirinfo)-2; %based on folder names.in baseFolder
%subtract 2 due to the '.' and '..' when using dir.

for i = 3 : length(dirinfo)
    k = i-2;
    traceNames{k} = dirinfo(i).name;
    fName{k} = strcat(traceNames{k});
    trace.(fName{k}(1:end-4)) = dir([fileDir filesep traceNames{k}]);
end
%%
%set for the set you want to plot if you have multiple otherwise just use
%1 here

NumToPlot =input('how many traces per plot?');%num of traces per figure
for i = 1:100
    n=(i-1)*NumToPlot;
    var{i} = 1+n:NumToPlot+n;
end
%%
counter = 0;
numOftraces= numel(traceNames);
for k = 1 %determines which folder to look at 
      %%%%1:numel(traceNames)    us this for all the folders 
    %%(trace.(traceNames{k}(1:end-4)))-2;%- 2 to account for
    %the '.' and '..' from dir
    iterToPlot=floor(numOftraces/NumToPlot);
    for i=1:iterToPlot
        if (floor((numOftraces-counter)/NumToPlot))<iterToPlot
            error( 'too many empty traces to plot, set iterToPlot to minus 1 or more manually')
        end
        hold off
        figure(i)
        hold on
        for kk =   cell2mat(var(i))+2      %%%%   3:numel(traceNames{k})
%             XMGfile=trace.(traceNames{k})(kk).name;
            
            test1= strcat(fileDir, filesep, traceNames{i});
            d = load(test1, '-mat');
            if isempty(d.data.ephys)
                counter = counter+1;
               
                warning( strcat(XMGfile, 'was skipped becasue empty')) 
                pause(.25)
            else
            plot (d.data.ephys.trace_1)
            end
            if nargin >=2 
            if varargin{1} ==1
                pause 
                close
            end
            end
            
        end
    end
hold off

leftOverTrace = numOftraces-(iterToPlot*NumToPlot);
if leftOverTrace>=1
        figure
        hold on
        for kk =   (numOftraces-leftOverTrace+1):numOftraces     %%%%   3:numel(traceNames{k})
%             XMGfile=trace.(traceNames{k})(kk).name;
            
            test1= strcat(fileDir, filesep, traceNames{kk});
            d = load(test1, '-mat');
            plot (d.data.ephys.trace_1)
        end
    end
end



% %%
% test1= strcat(baseFolder, filesep, traceNames{k})
% test2 = dir(test1)
% test2.name