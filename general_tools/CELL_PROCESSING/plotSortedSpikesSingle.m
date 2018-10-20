%% plotSortedSpikes(trialNums, selectedArray, swall, s, 0.5)
function plotSortedSpikesSingle(trialNums, selectedArray, swall, s, varargin)




    spikes = selectedArray{trialNums};
    if ~isempty(spikes)
        
    if nargin >= 6
        Yposition = repmat(varargin{2},[1, length(spikes)]);
    else
        Yposition = swall{trialNums}(15, spikes);
    end
    if nargin>=5
       plotString = varargin{1};
    else
        plotString = 'ob';
    end
    display(['Plotting trial ', num2str(trialNums)]);
    

        

            plot(s.sweeps{trialNums}.spikeWaveforms{1}(spikes), Yposition,plotString)
   
        % for kk = 1: numel(selectedArray{k})
        % plot( repmat(spikes(kk),2,1), [-5,10], 'b')
        % end
    else
        display('NO SPIKES THIS TRIAL')
        
    end


end


