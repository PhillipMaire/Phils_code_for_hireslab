%%
ampAverage=sum(amplitude,2)/length((trialCutoffs(1):trialCutoffs(end)));
%sums across trials and divides by number of trials to give 4000by1 vector 
%representing average amp for all trials.
%ampAverage(end+1:end+200)=0;%pads the end with 0's to plot correctly
%% RUN THIS FIRST it generates a normal histogram and raster

spk = cellfun(@(x)x.spikeTimes/10000,spikes_trials.spikesTrials,'uniformoutput',0);
trialCutoffs = [1 170];%amplitude is drawing from these trials.
size(spk)%spike data are drawing from this number of trials

%%warning: this depdends on the wrapper giving all the values so if the
%%wrapper has less than the trials for this cell then the histogram will be
%%of the entire population but the amplitudes will be for the selected
%%population of trials.turn on the below line to prevent this. 
spk = spk(trialCutoffs(1):trialCutoffs(end));
size(spk)


figure(10)
clf;subplot(2,1,1);hold on %uses the top half of the plot
for i = 1:length(spk)%each spk{i} contaisn all spike times for that trial
    %but the i is representative of trial number. "'k.'" is just black dot points  
    if ~isempty(spk{i})
    plot(spk{i},i,'k.')
    end
end

c_spk = vertcat(spk{:});%containates all the spikes times in order (as they appear).
%so that they are an N by 1 double. 
%then histc is used which automatically just produces a histogram. values 
bin = .1;
edges = 0:bin:4.2;
h_spk = histc(c_spk,edges);
figure(10);subplot(2,1,2)%uses the bottom half of the plot
bar(edges+bin/2,h_spk/length(spk))%the "+bin/2" sets the bars so that there is a 
%little space between them. divided by length(spk) to normalize by trials.












% 
% figure(10);
% sub3=subplot(4,1,3);
% plot(ampAverage)
% 
% Ymin=min(ampAverage(10:end-1));
% Ymin=Ymin-abs(Ymin*.1);
% Ymax=max(ampAverage(10:end-1));
% Ymax=Ymax+abs(Ymax*.1);
% axis([sub3],[0 4500 Ymin Ymax]);
% clear Ymin Ymax
% 
% sub4=subplot(4,1,2);
% ampAverageSmooth=smooth(ampAverage,200);
% diffampAverage=diff(ampAverageSmooth);
% plot(diffampAverage,'r')
% 
% Ymin=min(diffampAverage(10:end-1));
% Ymin=Ymin-abs(Ymin*.1);
% Ymax=max(diffampAverage(10:end-1));
% Ymax=Ymax+abs(Ymax*.1);
% axis([sub4],[0 4500 Ymin Ymax]);
% clear Ymin Ymax
% 
% %% RUN THIS to sort whisker amplitude based on trial type
% for i=1:numel(amplitude)/length(amplitude)%just combines into a linear array of cells
%     for ii=1:length(amplitude)
%     newAmp{1,i}(ii)=amplitude(ii,i);
%     end
% end
% 
% %used "sweepnums(2)" becasue amplitude is one less than the number of sweeps
% %don't know why this is.It could be shifted incorrectly "trialCutoffs" and
% %"useTrials" are used in wrapper to ultimatley determine the size of
% %variables like amplitude. 
% 
% %#########Also look into the misalignment due to shifts or
% %missing files (it may not make a difference if they are just video files)
% %set var1 to account for when trialCutoffs(1)~=1
% 
% %so because the behavior is based on the actual behavioral task data the
% %trials should start with 1 and thus be one more than the 
% 
% %because I'm using the b. data to index the correct newAmp amplitides I
% %accounted for the fact that we throw out the first trial in the behavioral
% %data by allowing var2 default value to be sweepnums(2) so that the first
% %value of the b. data is never used. I am fairly certain that this is
% %correct.
% 
% var1=trialCutoffs(1)-1; %for trialCutoffs values that don't start with 1
% var2=sweepnums(1+var1):sweepnums(end);%for indexing the correct values of 
% %the "b." data below
% 
% if sweepnums(end)~=trialCutoffs(end)+sweepnums(1)-1
%     disp('NOTE:sweepnums(end) doesnt equal trialCutoffs(end)+sweepnums(1)-1') 
%     beep
%     beep
%     
%     pause(5)
% %checks and corrects for missmatch between trialCutoffs(end) defined in the
% %wrapper and the sweepnums defined in trialArrayBuilder. This will only plot
% %all of the overlapping trials. FYI trialCutoffs(end)=trialCutoffs(2)
%     var2=var2(1:end-(sweepnums(end)-(trialCutoffs(end)+sweepnums(1)-1)));
% end 
% % b.hitTrialInds(1)is representing trial 2 based on behavior.
% %use var2=var2-1 to align 
% 
% NoVidNums=find(isnan(vv));
% count=0;
% for i=1:length(var2)
%     if numel(find(NoVidNums==var2(i)))==0 
%         count=count+1;
%         var3{count}=var2(i);
%     end
% end
% 
% var3=cell2mat(var3);
% 
% var3=var3;%initially here in case there was an off set because of 
% %videos (aplitude and phase calulations ect.) starting at 2 and behavior
% %starting at 1.
% hitSweepsAmps=newAmp(b.hitTrialInds(var3));
% missSweepsAmps=newAmp(b.missTrialInds(var3));
% falseAlarmSweepsAmps=newAmp(b.falseAlarmTrialInds(var3));
% correctRejectionSweepsAmps=newAmp(b.correctRejectionTrialInds(var3));
%  clear var1 var2 var3
% 
% 
% 
% hitSweepsAmps=reshape(cell2mat(hitSweepsAmps),4000,length(hitSweepsAmps));
% missSweepsAmps=reshape(cell2mat(missSweepsAmps),4000,length(missSweepsAmps));
% falseAlarmSweepsAmps=reshape(cell2mat(falseAlarmSweepsAmps),4000,length(falseAlarmSweepsAmps));
% correctRejectionSweepsAmps=reshape(cell2mat(correctRejectionSweepsAmps),4000,length(correctRejectionSweepsAmps));
% 
% [~, heighthitSweepsAmps]=size(hitSweepsAmps);
% [~, heightmissSweepsAmps]=size(missSweepsAmps);
% [~, heightfalseAlarmSweepsAmps]=size(falseAlarmSweepsAmps);
% [~, heightcorrectRejectionSweepsAmps]=size(correctRejectionSweepsAmps);
% 
% AmpSorted=cat(2,hitSweepsAmps,missSweepsAmps,falseAlarmSweepsAmps,correctRejectionSweepsAmps);
% AmpSorted=sum(AmpSorted,2)/sum(heighthitSweepsAmps+heightmissSweepsAmps+heightfalseAlarmSweepsAmps+heightcorrectRejectionSweepsAmps);
% AmpSortedLicked=cat(2,hitSweepsAmps,falseAlarmSweepsAmps);
% AmpSortedLicked=sum(AmpSortedLicked,2)/sum(heighthitSweepsAmps+heightfalseAlarmSweepsAmps);
% AmpSortedNoLicked=cat(2,missSweepsAmps,correctRejectionSweepsAmps);
% AmpSortedNoLicked=sum(AmpSortedNoLicked,2)/sum(heightmissSweepsAmps+heightcorrectRejectionSweepsAmps);
% AmpSortedCorrect=cat(2,hitSweepsAmps,correctRejectionSweepsAmps);
% AmpSortedCorrect=sum(AmpSortedCorrect,2)/sum(heighthitSweepsAmps+heightcorrectRejectionSweepsAmps);
% AmpSortedIncorrect=cat(2,missSweepsAmps,falseAlarmSweepsAmps);
% AmpSortedIncorrect=sum(AmpSortedIncorrect,2)/sum(heightmissSweepsAmps+heightfalseAlarmSweepsAmps);
% AmpSortedGo=cat(2,hitSweepsAmps,missSweepsAmps);
% AmpSortedGo=sum(AmpSortedGo,2)/sum(heighthitSweepsAmps+heightmissSweepsAmps);
% AmpSortedNoGo=cat(2,correctRejectionSweepsAmps,falseAlarmSweepsAmps);
% AmpSortedNoGo=sum(AmpSortedNoGo,2)/sum(heightcorrectRejectionSweepsAmps+heightfalseAlarmSweepsAmps);
% 
% 
% hitSweepsAmps=sum(hitSweepsAmps,2)/length(hitSweepsAmps);
% missSweepsAmps=sum(missSweepsAmps,2)/length(missSweepsAmps);
% falseAlarmSweepsAmps=sum(falseAlarmSweepsAmps,2)/length(falseAlarmSweepsAmps);
% correctRejectionSweepsAmps=sum(correctRejectionSweepsAmps,2)/length(correctRejectionSweepsAmps);
% %% RUN THIS SECOND to sort spikes based on trial type
% 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %%%%%%%%%%%%%%%Run This if you didnt run the last section%%%%%%%%%%%%%
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%UNTESTED-PSM%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % spk = cellfun(@(x)x.spikeTimes/10000,spikes_trials.spikesTrials,'uniformoutput',0);
% % trialCutoffs%amplitude is drawing from these trials.
% % size(spk)%spike data are drawing from this number of trials
% % 
% % %%warning: this depdends on the wrapper giving all the values so if the
% % %%wrapper has less than the trials for this cell then the histogram will be
% % %%of the entire population but the amplitudes will be for the selected
% % %%population of trials.turn on the below line to prevent this. 
% % spk = spk(trialCutoffs(1):trialCutoffs(end));
% % size(spk)
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %set var1 to account for when trialCutoffs(1)~=1
% var1=trialCutoffs(1)-1;
% var2=sweepnums(1+var1):sweepnums(end);%for indexing the correct values of 
% %the "b." data below
% if sweepnums(end)>trialCutoffs(end)+sweepnums(1)-1
%      disp('NOTE:sweepnums(end) doesnt equal trialCutoffs(end)+sweepnums(1)-1') 
% %checks and corrects for missmatch between trialCutoffs(end) defined in the
% %wrapper and the sweepnums defined in trialArrayBuilder. This will only plot
% %all of the overlapping trials. FYI trialCutoffs(end)=trialCutoffs(2)
% end
% hitSweepsSpks=spk(b.hitTrialInds(var2));
% missSweepsSpks=spk(b.missTrialInds(var2));
% falseAlarmSweepsSpks=spk(b.falseAlarmTrialInds(var2));
% correctRejectionSweepsSpks=spk(b.correctRejectionTrialInds(var2));
% clear var1 var2
% 
% spkSorted=cat(2,hitSweepsSpks,missSweepsSpks,falseAlarmSweepsSpks,correctRejectionSweepsSpks);
% spkSortedLicked=cat(2,hitSweepsSpks,falseAlarmSweepsSpks);
% spkSortedNoLicked=cat(2,missSweepsSpks,correctRejectionSweepsSpks);
% spkSortedCorrect=cat(2,hitSweepsSpks,correctRejectionSweepsSpks);
% spkSortedIncorrect=cat(2,missSweepsSpks,falseAlarmSweepsSpks);
% spkSortedGo=cat(2,hitSweepsSpks,missSweepsSpks);
% spkSortedNoGo=cat(2,correctRejectionSweepsSpks,falseAlarmSweepsSpks);
% %% #1 Run the numbered sections then follow with PLOTTING SECTION directly below. 
% %PLOT SORTED SPIKES BOTTOM TO TOP CORRECT-GO, INCORRECT GO, CORRECT-NOGO,
% %INCORRECT NO GO, title figure shows (and red dots plot) the number where
% %one section is switched into another. 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  spkToPlot=spkSorted; figNum=11
%  AmpsToPlot=AmpSorted;
% h=figure(figNum)
% 
% %below is all for naming the figure
% var1=numel(hitSweepsSpks);
% var2=numel(missSweepsSpks);
% var3=numel(falseAlarmSweepsSpks);
% var4=numel(correctRejectionSweepsSpks);
% 
% GoCor=strcat('GoCor_',num2str(var1));
% GoInc=strcat('GoInc_',num2str(var1+var2));
% NoGoInc=strcat('NoGoInc_',num2str(var1+var2+var3));
% NoGoCor=strcat('NoGoCor_',num2str(var1+var2+var3+var4));
% clear var1 var2 var3 var4
% 
% spkSortedFigName=strcat('spkSorted','_',GoCor,'_',GoInc,'_',NoGoInc,'_',NoGoCor);
% set(h,'name',spkSortedFigName)
% 
% 
% %% #2 PLOT CORRECT-GO TRIALS 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  spkToPlot=hitSweepsSpks;figNum=12
%  AmpsToPlot=hitSweepsAmps;
% h=figure(figNum)
% set(h,'name','hitSweepsSpks')
% PlotRastAndHist(spkToPlot,AmpsToPlot,figNum,spk)
% %% #3 PLOT INCORRECT-GO TRIALS 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  spkToPlot=missSweepsSpks;figNum=13
%  AmpsToPlot=missSweepsAmps;
% h=figure(figNum)
% set(h,'name','missSweepsSpks')
% PlotRastAndHist(spkToPlot,AmpsToPlot,figNum,spk)
% %% #4 PLOT INCORRECT-NOGO TRIALS 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  spkToPlot=falseAlarmSweepsSpks;figNum=14
%  AmpsToPlot=falseAlarmSweepsAmps;
% h=figure(figNum)
% set(h,'name','falseAlarmSweepsSpks')
% PlotRastAndHist(spkToPlot,AmpsToPlot,figNum,spk)
% %% #5 PLOT CORRECT-NOGO TRIALS 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  spkToPlot=correctRejectionSweepsSpks;figNum=15
%  AmpsToPlot=correctRejectionSweepsAmps;
% h=figure(figNum)
% set(h,'name','correctRejectionSweepsSpks')
% PlotRastAndHist(spkToPlot,AmpsToPlot,figNum,spk)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% #6 PLOT FOR ALL TRIALS WITH A LICK
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  spkToPlot=spkSortedLicked;figNum=16
%  AmpsToPlot=AmpSortedLicked;
% h=figure(figNum)
% set(h,'name','spkSortedLicked')
% PlotRastAndHist(spkToPlot,AmpsToPlot,figNum,spk)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% #7 PLOT FOR ALL TRIALS WITH NO LICKS 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  spkToPlot=spkSortedNoLicked;figNum=17
%  AmpsToPlot=AmpSortedNoLicked;
% h=figure(figNum)
% set(h,'name','spkSortedNoLicked')
% PlotRastAndHist(spkToPlot,AmpsToPlot,figNum,spk)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% #8 PLOT FOR ALL TRAILS WHICH WERE CORRECT
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  spkToPlot=spkSortedCorrect;figNum=18
%  AmpsToPlot=AmpSortedCorrect;
% h=figure(figNum)
% set(h,'name','spkSortedCorrect')
% PlotRastAndHist(spkToPlot,AmpsToPlot,figNum,spk)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% #9 PLOT FOR ALL TRAILS WHICH WERE INCORRECT
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  spkToPlot=spkSortedIncorrect;figNum=19
%  AmpsToPlot=AmpSortedIncorrect;
% h=figure(figNum)
% set(h,'name','spkSortedIncorrect')
% PlotRastAndHist(spkToPlot,AmpsToPlot,figNum,spk)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% #10 PLOT GO TRIALS 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  spkToPlot=spkSortedGo;figNum=20
%  AmpsToPlot=AmpSortedGo;
% h=figure(figNum)
% set(h,'name','spkSortedGo')
% PlotRastAndHist(spkToPlot,AmpsToPlot,figNum,spk)
% %% #11 PLOT NO-GO TRIALS 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  spkToPlot=spkSortedNoGo;figNum=21
%  AmpsToPlot=AmpSortedNoGo;
% h=figure(figNum)
% set(h,'name','spkSortedNoGo')
% PlotRastAndHist(spkToPlot,AmpsToPlot,figNum,spk)
% %% PLOTTING SECTION for above subgroups for sorted vector spkToPlot
% %%now using PlotRastAndHist instead of this but this can be used if needed.
% 
% 
% clf;subplot(4,1,1);hold on %uses the top half of the plot
% for i = 1:length(spkToPlot)%each spk{i} contaisn all spike times for that trial
%     %but the i is representative of trial number. "'k.'" is just black dot points  
%     if ~isempty(spkToPlot{i})
%     plot(spkToPlot{i},i,'k.')
%     end
% end
% if figNum==11
% plot(4.3,numel(hitSweepsSpks),'r.');
% plot(4.3,numel(missSweepsSpks)+numel(hitSweepsSpks),'r.');
% plot(4.3,numel(falseAlarmSweepsSpks)+numel(missSweepsSpks)+numel(hitSweepsSpks),'r.');
% plot(4.3,numel(correctRejectionSweepsSpks)+numel(falseAlarmSweepsSpks)+numel(missSweepsSpks)+numel(hitSweepsSpks),'r.');
% end
% 
% c_spk = vertcat(spkToPlot{:});%containates all the spikes times in order (as they appear).
% %so that they are an N by 1 double. 
% %then histc is used which automatically just produces a histogram. values 
% bin = .01
% edges = 0:bin:4.2;
% h_spk = histc(c_spk,edges);
% figure(figNum);subplot(4,1,4)%uses the bottom half of the plot
% bar(edges+bin/2,h_spk/length(spk))%the "+bin/2" sets the bars so that there is a 
% %little space between them. divided by length(spk) to normalize by trials.
% 
% sub6=subplot(4,1,3);
% plot(AmpsToPlot)
% 
% Ymin=min(AmpsToPlot(10:end-1));
% Ymin=Ymin-abs(Ymin*.1);
% Ymax=max(AmpsToPlot(10:end-1));
% Ymax=Ymax+abs(Ymax*.1);
% axis([sub6],[0 4500 Ymin Ymax]);
% clear Ymin Ymax
% 
% 
% sub5=subplot(4,1,2);
% ampAverageSmooth=smooth(AmpsToPlot,200);
% diffampAverage=diff(ampAverageSmooth);
% plot(diffampAverage,'r')
% 
% Ymin=min(diffampAverage(10:end-1));
% Ymin=Ymin-abs(Ymin*.1);
% Ymax=max(diffampAverage(10:end-1));
% Ymax=Ymax+abs(Ymax*.1);
% 
% axis([sub5],[0 4500 Ymin Ymax]);
% clear Ymin Ymax
% 
% 
% 
% 
% 
% %%
% b.rewardTime{167}(1)
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
