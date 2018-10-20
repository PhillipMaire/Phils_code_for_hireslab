if strcmp(U{1}.meta.layer,'L5b')
    [ndata, txt, alldata] =xlsread('CellsConversionChart170224','I23:J67');
    disp(U{1}.meta.layer);
    layer = 'L5b';
elseif strcmp(U{1}.meta.layer,'L3')
    [ndata, txt, alldata] =xlsread('CellsConversionChart170224','B25:C44');
    disp(U{1}.meta.layer);
    layer = 'L3';
elseif strcmp(U{1}.meta.layer,'L4')
    [ndata, txt, alldata] =xlsread('CellsConversionChart170224','O23:P28');
    disp(U{1}.meta.layer);
    layer = 'L4';
elseif strcmp(U{1}.meta.layer,'L3Out')
    [ndata, txt, alldata] =xlsread('CellsConversionChart170224','B77:C82');
    disp(U{1}.meta.layer);
    layer = 'L3Out';
elseif strcmp(U{1}.meta.layer,'L5bOut')
    [ndata, txt, alldata] =xlsread('CellsConversionChart170224','I75:J82');
    disp(U{1}.meta.layer);
    layer = 'L5bOut';
elseif strcmp(U{1}.meta.layer,'L5bInt')
    [ndata, txt, alldata] =xlsread('CellsConversionChart170224','V75:W81');
    disp(U{1}.meta.layer);
    layer = 'L5bInt';
elseif strcmp(U{1}.meta.layer,'BV')
    [ndata, txt, alldata] =xlsread('CellsConversionChart170224','W23:X28');
    disp(U{1}.meta.layer);
    layer = 'BV';
 end
txt=txt(~isnan(ndata));
ndata=ndata(~isnan(ndata));
baseline=cell(1,length(U));
touchONN=cell(1,length(U));

cont.thetaALL = []; cont.phaseALL = []; cont.spALL = []; cont.ampALL = []; 
cont.thetaNORM = [];

for p=1:length(U)
%     cellcode = txt{p};
    rec = p;
    %% this is used to mask out touches and allow analysis for phase, setpoint, and amplitude
    [objmask]= assist_touchmasks(U{rec});
    
    %use this to choose mask:
    %availtoend_mask, avail_mask, touchEx_mask, firsttouchEx_mask
    mask = objmask.touch;
    
%     %% Plot raster
%     figure(4);clf
%     subplot(4,2,[1 2]);hold on
%     
%     for i = 1:U{rec}.k
%         if sum(U{rec}.R_ntk(1,:,i))>0
%             plot(find(U{rec}.R_ntk(1,:,i)==1),i,'k.')
%         else
%         end
%         
%     end
%     set(gca,'ylim',[0 U{rec}.k]+1)
%     
%     %% ONSET
%     touchIdx = [find(U{rec}.S_ctk(9,:,:)==1);find(U{rec}.S_ctk(12,:,:)==1)];
%     spikes = squeeze(U{rec}.R_ntk);
%     touchIdx = touchIdx(touchIdx<(numel(spikes)-151)); %elim last touches
%     spikesAligned = zeros(numel(touchIdx),201);
%     
%     for i = 1:size(spikesAligned,1)
%         spikesAligned(i,:) = spikes(touchIdx(i)+[-50:150]);
%     end
%     subplot(4,2,3);
%     bar(-50:150,sum(spikesAligned)/numel(touchIdx),'k');
%     set(gca,'xlim',[-50 150]);
%     xlabel('Time from all touch onset (ms)')
%     ylabel('spks / ms')
%     touchONN{p}=spikesAligned;
% 
%     %% OFFSET
%     touchIdx = [find(U{rec}.S_ctk(10,:,:)==1);find(U{rec}.S_ctk(13,:,:)==1)];
%     spikes = squeeze(U{rec}.R_ntk);
%     touchIdx = touchIdx(touchIdx<(numel(spikes)-151)); %elim offset touches at end of last trial
%     spikesAligned = zeros(numel(touchIdx),201);
%     
%     for i = 1:size(spikesAligned,1)
%         spikesAligned(i,:) = spikes(touchIdx(i)+[-50:150]);
%     end
%     subplot(4,2,4);
%     bar(-50:150,sum(spikesAligned)/numel(touchIdx),'k')
%     set(gca,'xlim',[-50 150])
%     xlabel('Time from all touch offset (ms)')
%     ylabel('spks / ms')
% 
%     
    %% THETA

    wndow=[5:10]; %because spikes don't occur right when theta happens, we are going to average spikes [wndow] after theta occurs
    theta = squeeze(U{rec}.S_ctk(1,:,:));
    selectedtheta = mask.*theta;
    theta_Idx = find(~isnan(selectedtheta));
        tmp=(theta_Idx/U{rec}.t)-floor(theta_Idx/U{rec}.t);
        oor=[find(tmp>=1-((max(wndow)+25)/10000)); find(tmp==0)];%indices out of range of wndow so elim; wiggle room of 25ms
        theta_Idx(oor)=[];

    thetaSpikes = selectedtheta(theta_Idx);
    %thetaSpikes(:,2)=U{rec}.R_ntk(theta_Idx);
       
    thetaSpikes(:,2) = nanmean(U{rec}.R_ntk(repmat(theta_Idx,1,numel(wndow))+repmat(wndow,numel(theta_Idx),1)),2);  

    [Tsorted TsortedBy TbinBounds]=binslin(thetaSpikes(:,1),thetaSpikes(:,2),'equalX',13);
    
    theta_sp = zeros(12,1);
    for i = 1:12;
        theta_sp(i) = sum(Tsorted{i})/numel(Tsorted{i})*1000;% 160125 changed back to 1000 from 100(which was stupid to even change to...)since we want it to be spks/s
    end
    
    %changed from using std function b/c here calculate pop avg first then do
    %stdev by each individual bin. std f(x) was using each bin as pop avg
    splitavg = zeros (12,1); %avg in each bin b/c bin together too big to avg together
    for i = 1:12;
        splitavg(i)=mean(Tsorted{i});
    end
    Tcibin=zeros(2,length(theta_sp)); %doing 95% ci of each bin in relation to each bin
    for i=1:length(theta_sp);
        [phat, pci] = binofit(sum(Tsorted{i}),numel(Tsorted{i}));
        Tcibin([2 1],i) = pci*1000;
    end
    Tcibin(Tcibin<0) = 0;
    TTune(rec)=max(theta_sp)-min(theta_sp);

    %% PHASE
    amp_mask = ones(size(squeeze(U{rec}.S_ctk(3,:,:)))); %amplitude mask used to filter out only periods of high whisking
    %amp_mask(U{rec}.S_ctk(3,:,:)<.5) = NaN;
    
    phase = squeeze(U{rec}.S_ctk(5,:,:));
    selectedPhase = mask.*amp_mask.*phase;
    sPhase_Idx = find(~isnan(selectedPhase));
        Ptmp=(sPhase_Idx/U{rec}.t)-floor(sPhase_Idx/U{rec}.t);
        Poor=[find(Ptmp>=1-((max(wndow)+25)/10000)); find(Ptmp==0)];%indices out of range of wndow so elim
        sPhase_Idx(Poor)=[];
    
    sPhaseSpikes = selectedPhase(sPhase_Idx);
    sPhaseSpikes(:,2) = U{rec}.R_ntk(sPhase_Idx);
    
    sPhaseSpikes(:,2) = nanmean(U{rec}.R_ntk(repmat(sPhase_Idx,1,numel(wndow))+repmat(wndow,numel(sPhase_Idx),1)),2);  

    
    [Psorted PsortedBy PbinBounds]=binslin(sPhaseSpikes(:,1), sPhaseSpikes(:,2), 'equalX', 13);
    
    FR_phase = zeros(12,1);
    for i = 1:12;
        FR_phase(i) = sum(Psorted{i})/numel(Psorted{i})*1000;% 160125 changed back to 1000 from 100(which was stupid to even change to...)since we want it to be spks/s
    end
    
    splitavg = zeros (12,1); %avg in each bin b/c bin together too big to avg together
    for i = 1:12;
        splitavg(i)=mean(Psorted{i});
    end
    Pcibin=zeros(2,length(FR_phase)); %doing 95% ci of each bin in relation to each bin
    for i=1:length(FR_phase);
        [phat, pci] = binofit(sum(Psorted{i}),numel(Psorted{i}));
        Pcibin([2 1],i) = pci*1000;
    end
    Pcibin(Pcibin<0) = 0;
    PTune(rec)=max(FR_phase)-min(FR_phase);

    %% AMPLITUDE
    amplitude = squeeze(U{rec}.S_ctk(3,:,:));
    selectedamp = mask.*amplitude;
    amp_idx=find(~isnan(selectedamp));
    ampSpikes = selectedamp(amp_idx);
    ampSpikes(:,2) = U{rec}.R_ntk(amp_idx);
    ampmax = max(ampSpikes(:,1));
    ampmin = min(ampSpikes(:,1));
    
    [Asorted AsortedBy AbinBounds]=binslin(ampSpikes(:,1),ampSpikes(:,2),'equalX',13);
    amp_sp = zeros(length(AbinBounds)-1,1);
    
    for i = 1:length(amp_sp);
        amp_sp(i) = sum(Asorted{i})/numel(Asorted{i})*1000; %160125 changed back to 1000 from 100(which was stupid to even change to...)since we want it to be spks/s
    end
    
    splitavg = zeros (12,1); %avg in each bin b/c bin together too big to avg together
    for i = 1:length(amp_sp);
        splitavg(i)=mean(Asorted{i}');
    end
    popavg=(mean(splitavg));
    
    Acibin=zeros(2,length(amp_sp)); %doing 95% ci of each bin in relation to each bin
    for i=1:length(amp_sp);
        [phat, pci] = binofit(sum(Asorted{i}),numel(Asorted{i}));
        Acibin([2 1],i) = pci*1000;
    end
    Acibin(Acibin<0) = 0;
    
    ATune(rec)=max(amp_sp)-min(amp_sp);
    %% SETPOINT
    setpoint = squeeze (U{rec}.S_ctk(4,:,:));
    selectedSP = mask.*setpoint;
    SP_Idx = find(~isnan(selectedSP));
    SPSpikes = selectedSP(SP_Idx);
    SPSpikes(:,2) = U{rec}.R_ntk(SP_Idx);
    spmax = max(SPSpikes(:,1));
    spmin = min(SPSpikes(:,1));
    
    %plotting setpoint in histogram with bins
    [Ssorted SsortedBy SbinBounds]=binslin(SPSpikes(:,1),SPSpikes(:,2),'equalX',13);
    FR_sp = zeros(12,1);
    
    for i = 1:12;
        FR_sp(i) = sum(Ssorted{i})/numel(Ssorted{i})*1000; %160125 changed back to 1000 from 100(which was stupid to even change to...)since we want it to be spks/s
    end
    
    splitavg = zeros (12,1); %avg in each bin b/c bin together too big to avg together
    for i = 1:12;
        splitavg(i)=mean(Ssorted{i}');
    end
    popavg=(mean(splitavg));
    
    Scibin=zeros(2,length(amp_sp)); %doing 95% ci of each bin in relation to each bin
    for i=1:length(amp_sp);
        [phat, pci] = binofit(sum(Ssorted{i}),numel(Ssorted{i}));
        Scibin([2 1],i) = pci*1000;
    end
    Scibin(Scibin<0) = 0;
    
    STune(rec)=max(FR_sp)-min(FR_sp);
 %% Plot Tuning Curves
% %     figure(42);clf; subplot(2,2,1)
%     hold on
%     tymax = max(theta_sp)*1.5;
%     plot(TbinBounds(1:end-1),theta_sp,'-b')
%     hold on; plot(TbinBounds(1:end-1),Tcibin(1,:),':k');
%     hold on; plot(TbinBounds(1:end-1),Tcibin(2,:),':k');
%     set(gca,'xlim',[TbinBounds(1) TbinBounds(end)],'ylim',[0 tymax])
%     xlabel('Theta (degrees)')
%     ylabel('spks / s')
%     
% %     subplot(2,2,2);
%     Atymax = max(amp_sp)*1.5;
%     plot(AbinBounds(1:end-1),amp_sp,'-b');
%     hold on; plot(AbinBounds(1:end-1),Acibin(1,:),':k');
%     hold on; plot(AbinBounds(1:end-1),Acibin(2,:),':k');
%     ymax = max(amp_sp)*2;
%     set(gca,'xlim',[ampmin ampmax],'ylim',[0 Atymax])
%     xlabel('Amplitude (degrees)')
%     ylabel('spks / s')
%     
% %     subplot(2,2,3);
%     Stymax = max(FR_sp)*1.5;
%     hold on
%     plot(SbinBounds(1:end-1),FR_sp,'-b');
%     hold on; plot(SbinBounds(1:end-1),Scibin(1,:),':k');
%     hold on; plot(SbinBounds(1:end-1),Scibin(2,:),':k');
%     set(gca,'xlim',[spmin spmax],'ylim',[0 Stymax])
%     xlabel('Setpoint (degrees)')
%     ylabel('spks / s')
%     
% %     subplot(2,2,4);
%     plot(-pi:pi/5.5:pi,FR_phase,'-b');
%     hold on; plot([-pi:pi/5.5:pi],Pcibin(1,:),':k');
%     hold on; plot([-pi:pi/5.5:pi],Pcibin(2,:),':k');
%     Ptymax = (max(FR_phase)*1.5)+.05;
%     set(gca,'xlim',[-pi pi],'xtick',pi*[-1:.5:1],'xticklabel',{'-pi','-pi/2',0,'pi/2','pi'},'ylim',[0 Ptymax])
%     xlabel('Phase (radians)')
%     ylabel('spks / s')
    %print(gcf,'-dpng',['Z:\Users\Jon\Projects\Characterization\' layer '\Figures\' cellcode '_' 'Raster_and_Tuning'])
    %print(gcf,'-dpng',['Z:\Users\Jon\Projects\Characterization\' layer '\Figures\' cellcode '_' 'TuningSquare'])
    %% Plot CFD (Cumulative Frequency Distribution) CFDPLOT matlab
    % LOLZ no need to write function ^.^
    
%     figure(43);hold on;subplot(2,2,1)
%     cdfplot(thetaSpikes(:,1))
%     set(gca,'xlim',[TbinBounds(1) TbinBounds(end)],'ytick',[0:.25:1])
%     xlabel('Theta');ylabel('Percentile');title('');grid off
%     subplot(2,2,2)
%     cdfplot(ampSpikes(:,1))
%     set(gca,'xlim',[AbinBounds(1) AbinBounds(end)],'ytick',[0:.25:1])
%         xlabel('Amplitude');ylabel('Percentile');title('');grid off
%     subplot(2,2,3)
%     cdfplot(SPSpikes(:,1));  
%     set(gca,'xlim',[SbinBounds(1) SbinBounds(end)],'ytick',[0:.25:1])
%     xlabel('Setpoint');ylabel('Percentile');title('');grid off
%     subplot(2,2,4)
%     cdfplot(sPhaseSpikes(:,1));
%     set(gca,'xlim',[-pi pi],'xtick',pi*[-1:.5:1],'xticklabel',{'-pi','-pi/2',0,'pi/2','pi'},'ytick',[0:.25:1])
%      xlabel('Phase');ylabel('Percentile');title('');grid off
     
     cont.thetaALL = [cont.thetaALL ; thetaSpikes(:,1)];
     cont.ampALL = [cont.ampALL ; ampSpikes(:,1)];
     cont.phaseALL = [cont.phaseALL; sPhaseSpikes(:,1)];
     cont.spALL = [cont.spALL;SPSpikes(:,1)];
        rest=thetaSpikes(ampSpikes(:,1)<=0.05);
        thetaNORM=thetaSpikes(:,1)-mean(rest);
        cont.rest=rest;
     cont.thetaNORM = [cont.thetaNORM ; thetaNORM];
end

    %% Plot CFD (Cumulative Frequency Distribution) CFDPLOT matlab

    figure(44);clf;subplot(2,2,1)
    cdfplot(TTune)
    xlabel('Spike Rate Change from Theta (Hz)');ylabel('Percentile');title('');grid off
    text(max(TTune)*(2/3),.7,['Mean = ' num2str(mean(TTune))],'FontSize',10);
    text(max(TTune)*(2/3),.6,['Median = ' num2str(median(TTune))],'FontSize',10)
    
    subplot(2,2,2)
    cdfplot(ATune)
    xlabel('Spike Rate Change from Amplitude (Hz)');ylabel('Percentile');title('');grid off
       text(max(ATune)*(2/3),.7,['Mean = ' num2str(mean(ATune))],'FontSize',10);
    text(max(ATune)*(2/3),.6,['Median = ' num2str(median(ATune))],'FontSize',10)
    
    subplot(2,2,3)
    cdfplot(STune)
    xlabel('Spike Rate Change from Setpoint (Hz)');ylabel('Percentile');title('');grid off
    text(max(STune)*(2/3),.7,['Mean = ' num2str(mean(STune))],'FontSize',10);
    text(max(STune)*(2/3),.6,['Median = ' num2str(median(STune))],'FontSize',10)
    
    subplot(2,2,4)
    cdfplot(PTune)
    xlabel('Spike Rate Change from Phase (Hz)');ylabel('Percentile');title('');grid off
       text(max(PTune)*(2/3),.7,['Mean = ' num2str(mean(PTune))],'FontSize',10);
    text(max(PTune)*(2/3),.6,['Median = ' num2str(median(PTune))],'FontSize',10)
    
    
    
