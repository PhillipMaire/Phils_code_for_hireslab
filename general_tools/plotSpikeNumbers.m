%% plot the above spikes to figure out which is better

function plotSpikeNumbers(selectedArray, preSpikeBaselineTime, swall, varargin)


selectedArraySize = sum(cell2mat(cellfun(@numel,selectedArray, 'UniformOutput',false)))
if nargin == 5
    swcat = [swall{varargin{2}}];%get the spikes fro that trial 
    disp(['trial ', num2str(varargin{2})]);
    newswall{1} = swcat(:,selectedArray{varargin{2}});
    if ~isempty(newswall{1})
%     numSpikesPerPlot = varargin{1}; dont use this here
    
    allselectedArray = [newswall{:}];
    allselectedArrayAligned =  allselectedArray - repmat(sum(allselectedArray(preSpikeBaselineTime,:))/numel(preSpikeBaselineTime),30,1);
    allselectedArrayScale = (allselectedArray - repmat(mean(allselectedArray(preSpikeBaselineTime,:)),30,1))./repmat(max(allselectedArray)-mean(allselectedArray(preSpikeBaselineTime,:)),30,1);
    
    figure(20)
    
    plot(allselectedArrayAligned)
    
    else
       disp('NO SPIKES THIS TRIAL ');
         figure(20)
         for k = 1:10
         text(rand(1),rand(1),'NO SPIKES THIS TRIAL');
         pause(0.01);
         end
    end
    
else
    swcat = [swall{:}];
    for k = 1:numel(swall)
        swcatSingle = [swall{k}];
        newswall{k} = swcatSingle(:, selectedArray{k});
   
    end
    
    if nargin == 3
        
        numSpikesPerPlot = input(['Ther are ' num2str(selectedArraySize) ' spikes in this array, how many spikes per plot?'])
    elseif nargin >= 4
        selectedArraySize
        numSpikesPerPlot = varargin{1};
    end
    
    allselectedArray = [newswall{:}];
    allselectedArrayAligned =  allselectedArray - repmat(sum(allselectedArray(preSpikeBaselineTime,:))/numel(preSpikeBaselineTime),30,1);
    allselectedArrayScale = (allselectedArray - repmat(mean(allselectedArray(preSpikeBaselineTime,:)),30,1))./repmat(max(allselectedArray)-mean(allselectedArray(preSpikeBaselineTime,:)),30,1);
    
    %%%% look at selected array spikes
    figure(20)
    
    
    iters = 1:numSpikesPerPlot:selectedArraySize;
    if iters(end)~=selectedArraySize
        iters(end+1)=selectedArraySize;
    end
    display(['number of plots total is ' num2str(numel(iters)-1)])
    for i = 1:numel(iters)-1
        i
        plot(allselectedArrayAligned(:,iters(i):iters(i+1)))
        waitforbuttonpress
    end
end
waitforbuttonpress
close

end
