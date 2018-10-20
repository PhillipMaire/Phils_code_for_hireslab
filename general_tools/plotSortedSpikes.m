%% plotSortedSpikes(trialNums, selectedArray, swall, s, 0.5)
function plotSortedSpikes(trialNums, selectedArray, swall, s, varargin)

for k = trialNums
    spikes = selectedArray{k};
    
    if nargin >= 6
        Yposition = repmat(varargin{2},[1, length(spikes)]);
    else
        Yposition = swall{k}(15, spikes);
    end
    if nargin>=5
       plotString = varargin{1};
    else
        plotString = 'ob';
    end
    display(['Plotting trial ', num2str(k)]);
    
    if ~isempty(selectedArray{k})
      
           plot(s.sweeps{trialNums}.spikeWaveforms{1}(spikes), Yposition,plotString)
 
        % for kk = 1: numel(selectedArray{k})
        % plot( repmat(spikes(kk),2,1), [-5,10], 'b')
        % end
    else
        display('NO SPIKES THIS TRIAL')
        
    end
    while true
        w = waitforbuttonpress;
        switch w
            case 1 % (keyboard press)
                key = get(gcf,'currentcharacter');
                switch key
                    case 13 % 13 is the return key
                        disp('User pressed the return key. plotting next trial.')
                        break
                    otherwise
                        % Wait for a different command.
                end
        end
    end
end
end


