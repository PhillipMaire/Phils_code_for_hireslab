function PlotRastAndHist(spkToPlot,AmpsToPlot,figNum,spk)


%% PLOTTING SECTION for above subgroups for sorted vector spkToPlot
%% PlotRastAndHist(spikes_trials.spikesTrials,[1:30],1,

%use rast and hist forst to generate spk (or maybe it calls this
%automatically i forget)- PSM 

clf;subplot(4,1,1);hold on %uses the top half of the plot
for i = 1:length(spkToPlot)%each spk{i} contaisn all spike times for that trial
    %but the i is representative of trial number. "'k.'" is just black dot points  
    if ~isempty(spkToPlot{i})
    plot(spkToPlot{i},i,'k.')
    end
end
if figNum==11
plot(4.3,numel(hitSweepsSpks),'r.');
plot(4.3,numel(missSweepsSpks)+numel(hitSweepsSpks),'r.');
plot(4.3,numel(falseAlarmSweepsSpks)+numel(missSweepsSpks)+numel(hitSweepsSpks),'r.');
plot(4.3,numel(correctRejectionSweepsSpks)+numel(falseAlarmSweepsSpks)+numel(missSweepsSpks)+numel(hitSweepsSpks),'r.');
end

c_spk = vertcat(spkToPlot{:});%containates all the spikes times in order (as they appear).
%so that they are an N by 1 double. 
%then histc is used which automatically just produces a histogram. values 
bin = .01
edges = 0:bin:4.2;
h_spk = histc(c_spk,edges);
figure(figNum);subplot(4,1,4)%uses the bottom 1/4 of the plot
bar(edges+bin/2,h_spk/length(spk))%the "+bin/2" sets the bars so that there is a 
%little space between them. divided by length(spk) to normalize by trials.

sub6=subplot(4,1,3);
plot(AmpsToPlot)

Ymin=min(AmpsToPlot(10:end-1));
Ymin=Ymin-abs(Ymin*.1);
Ymax=max(AmpsToPlot(10:end-1));
Ymax=Ymax+abs(Ymax*.1);
axis([sub6],[0 4500 Ymin Ymax]);
clear Ymin Ymax


sub5=subplot(4,1,2);
ampAverageSmooth=smooth(AmpsToPlot,200);
diffampAverage=diff(ampAverageSmooth);
plot(diffampAverage,'r')

Ymin=min(diffampAverage(10:end-1));
Ymin=Ymin-abs(Ymin*.1);
Ymax=max(diffampAverage(10:end-1));
Ymax=Ymax+abs(Ymax*.1);

axis([sub5],[0 4500 Ymin Ymax]);
clear Ymin Ymax
