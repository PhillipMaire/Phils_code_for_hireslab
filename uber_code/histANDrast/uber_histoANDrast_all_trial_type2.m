%     %%  Plot raster
%     
%     
%     for cellNum =[1]
%         figure(10+cellNum);clf;hold on
%      go = find(U{cellNum}.meta.trialType==1);%all trials that are go 
%      nogo = find(U{cellNum}.meta.trialType==0);%all trials that are nogo 
%     
%      
%      
%      for i = 1:length(go) % i through all the go's
%         if sum(U{cellNum}.R_ntk(1,:,go(i)))>0%if there are spikes in this trial...
% 
%             plot(find(U{cellNum}.R_ntk(1,:,go(i))==1),i,'k.')
%         end
%         
%      end
%      
%      
%      
%      
%      for i = 1:length(nogo)
%           if sum(U{cellNum}.R_ntk(1,:,nogo(i)))>0%if there are spikes in this trial...
%           plot(find(U{cellNum}.R_ntk(1,:,nogo(i))==1),i+length(go),'k.')
%           end
%     end
%     end
%     set(gca,'ylim',[0 U{cellNum}.k]+1)
    %%
        for cellNum =[1]
        clearvars -except U cellNum
        h = figure(10+cellNum);
        clf;
        hsub1 = subplot('position', [0.08,0.33,.87,.68]);
        hold on
        
        set(gca,'ylim',[0 U{cellNum}.k]+1)
        
     go = U{cellNum}.meta.trialType==1;%all trials that are go 
     nogo = U{cellNum}.meta.trialType==0;%all trials that are nogo 
     correct = U{cellNum}.meta.trialCorrect==1;
     incorrect = U{cellNum}.meta.trialCorrect==0;
     lick = (go.*correct)+(nogo.*incorrect);
     nolick =lick==0;
     hit = (go.*correct);
     corrRej=(nogo.*correct);
     falseAlarm = nogo.*incorrect;
     miss = go.*incorrect;
     
     var1 = find(hit) ; 
     var2 = find(corrRej) ; 
     var3 = find(falseAlarm);
     var4 = find(miss);
     numVars = 1; 
     summedVar1 = zeros(1,4000);
     summedVar2 = summedVar1;
     summedVar3 = summedVar1;
     summedVar4 = summedVar1;
     
     smoothFactor = 30;
     smoothType = 'moving';
     normalizeSpikes = 1 ; %1 is yes 0 is no
     colorAtEndNumber = 4020:.2:4025;%add the colored part at the end to indicate trial type 
     colorSet = {'b', 'r', 'g', 'k'};%for tghe trial type
     
     %%%would be cool to get 1st lick times and look at spiking right
     %%%before licks like 50 ms and see if it predicts based on firing rate
     %%%if it will be a go or nogo trial (ie predicting outcome of reward)
     %%%you would have to control for the time of the lick relitive to pole
     %%%onset and make sure the whisker isnt consistantly hitting the pole
     %%%but it could be interesting. 
     
     %%% it would be great to see S2 neurons to a removed pole delay task
     %%% to remove sensory and decision variables especially whisker
     %%% contacts made from lick which is easy to confound with decision
     %%% variables IN FACT I NEED TO CHNAGE THIS WITH THE PROTOCAL RIGHT
     %%% NOW. AND TALK ABOUT THI IN LAB MEETING BECAUSE THE SOON I
     %%% IMPLEMENT THE BETTER AND SOON I CAN PUBLISH 
     summedVar1 = zeros(1,4000);
     summedVar2 = summedVar1;
     summedVar3 = summedVar1;
     summedVar4 = summedVar1;    

       poleAvailableTime =500;
      [licksLinInds, allLicksCell, firstLicks, trialStart, trialEnd] = lickExtractor(U, cellNum,poleAvailableTime);
     
      for i = 1:length(var1) % i through all the go's
        if sum(U{cellNum}.R_ntk(1,:,var1(i)))>0%if there are spikes in this trial...
            var1LinInds = U{cellNum}.R_ntk(1,:,var1(i))==1;
            summedVar1 = var1LinInds + summedVar1;
            allVar1LinInds(i,:) = var1LinInds;
            var1Inds = find(var1LinInds);
            var1IndsLickShifted = find(var1LinInds)-firstLicks(var1(i));
            %%%%
            
            allVar1Inds{i} = var1Inds;
            %%%%
            plot(var1IndsLickShifted,i,'k.')
            
        end
     end
     var1SummedSpikes = sum(allVar1LinInds, 1);
     var1SummedSpikesLickShifted = sum(allVar1LinInds, 1);
   
     

     plot(repmat(colorAtEndNumber,length(var1)),1:length(var1),strcat(colorSet{1},'.'))
%      plot(allVar1Inds{},1:length(var1),'k.')%try to plot this with using cell fun or something 
     
     
% 
%          allVar1Inds
%       [x2]=cellNums2MatWithZeros(allVar1Inds);
% figure; plot(x2(1:188,:),1:188,'k.')
%      x2(1:188,:)>0;
  if numVars>1
      for i = 1:length(var2) % i through all the go's
          addLength1 = i+length(var1);
        if sum(U{cellNum}.R_ntk(1,:,var2(i)))>0%if there are spikes in this trial...
            var2LinInds = U{cellNum}.R_ntk(1,:,var2(i))==1;
            summedVar2 = var2LinInds + summedVar2;
            allVar2LinInds(i,:) = var2LinInds;
            var2Inds = find(var2LinInds);
            
            plot(var2Inds,addLength1,'k.')
            plot(colorAtEndNumber,addLength1,strcat(colorSet{2},'.'))
        end
        
     end
     var2SummedSpikes = sum(allVar2LinInds, 1);
   
  end
     
  
  
  
  
  
  if numVars>2
      for i = 1:length(var3) % i through all the go's
           addLength2 = i+length(var1)+length(var2);
        if sum(U{cellNum}.R_ntk(1,:,var3(i)))>0%if there are spikes in this trial...
            var3LinInds = U{cellNum}.R_ntk(1,:,var3(i))==1;
            summedVar3 = var3LinInds + summedVar3;
            allVar3LinInds(i,:) = var3LinInds;
            var3Inds = find(var3LinInds);
            
            plot(var3Inds,addLength2,'k.')
            plot(colorAtEndNumber,addLength2,strcat(colorSet{3},'.'))
        end
        
     end
     var3SummedSpikes = sum(allVar3LinInds, 1);
  end
     
     
if numVars>3
      for i = 1:length(var4) % i through all the go's
          addLength3 = i+length(var1)+length(var2)+length(var3);
        if sum(U{cellNum}.R_ntk(1,:,var4(i)))>0%if there are spikes in this trial...
            var4LinInds = U{cellNum}.R_ntk(1,:,var4(i))==1;
            summedVar4 = var4LinInds + summedVar4;
            allVar4LinInds(i,:) = var4LinInds;
            var4Inds = find(var4LinInds);
            
            plot(var4Inds,addLength3,'k.')
           plot(colorAtEndNumber,addLength3,strcat(colorSet{4},'.'))
            
        end
        
     end
     var4SummedSpikes = sum(allVar4LinInds, 1);
end   
     
     
     hsub2 = subplot('position', [0.08,0.08,.87,.17]);
     hold on 
     try
         if normalizeSpikes == 1
             normDivBy=[length(var1),length(var2),length(var3),length(var4)]; 
         elseif normalizeSpikes == 0 
              normDivBy = [1,1,1,1]; 
         end
      plot(smooth(var1SummedSpikes/normDivBy(1),smoothFactor,smoothType),colorSet{1})
%        if numVars>1
      plot(smooth(var2SummedSpikes/normDivBy(2),smoothFactor,smoothType),colorSet{2})
%        elseif numVars>2
      plot(smooth(var3SummedSpikes/normDivBy(3),smoothFactor,smoothType),colorSet{3})     
%        elseif numVars>3
      plot(smooth(var4SummedSpikes/normDivBy(4),smoothFactor,smoothType),colorSet{4})
      
     catch
     end
       linkaxes([hsub1, hsub2], 'x');
    end
    
     
     
     
     
     
     
     
     
% % % % % % % % % % % % % %      %%
% % % % % % % % % % % % % %      
% % % % % % % % % % % % % %      Q(isnan(Q))=0;
% % % % % % % % % % % % % %      poleAvailableTime = 500;
% % % % % % % % % % % % % %      
% % % % % % % % % % % % % %      [test1,tes2,trials]=size(U{1}.S_ctk(:,:,:));
% % % % % % % % % % % % % %      
% % % % % % % % % % % % % %      test4 = U{cellNum}.S_ctk(16,:,1:trials);
% % % % % % % % % % % % % %      test4(isnan(test4))=0;
% % % % % % % % % % % % % %      C = permute(test4,[1 3 2]);
% % % % % % % % % % % % % %      C = reshape(C,[],size(test4,2),1);
% % % % % % % % % % % % % %      
% % % % % % % % % % % % % %      
% % % % % % % % % % % % % %      
% % % % % % % % % % % % % %      
% % % % % % % % % % % % % %      find(test4)
% % % % % % % % % % % % % %      for trial = 1:trials
% % % % % % % % % % % % % %         test5{trial}=find(test4(1,:,trial));
% % % % % % % % % % % % % %      end
% % % % % % % % % % % % % %         
% % % % % % % % % % % % % % 
% % % % % % % % % % % % % %  [x]=cellNums2MatWithZeros(test5');
% % % % % % % % % % % % % %      
% % % % % % % % % % % % % % test7 = x(:,1);
% % % % % % % % % % % % % % averageLickShift = round(sum(test7(test7>0))/length(test7(test7>0)));
% % % % % % % % % % % % % % test7(test7==0)= averageLickShift
% % % % % % % % % % % % % % 
% % % % % % % % % % % % % % 
% % % % % % % % % % % % % % %%
% % % % % % % % % % % % % % 
% % % % % % % % % % % % % % r = rem(test7,10);
% % % % % % % % % % % % % % c = [cycle,cycle];
% % % % % % % % % % % % % % out = c(bsxfun(@plus,bsxfun(@plus,10 - r,0:9)*5,(1:5)'));

     





     
%      firstLickTime =
% %      allLickTimes
%     lick
%      sortedBarPos, sortedBarInd] = sort(U{1}.whisker.barPose
%yo bar position is an xy coordinates of the video will have to fit line to
%it and then i can get the actual 
%      
%      for i = 1:length(go) % i through all the go's
%         if sum(U{cellNum}.R_ntk(1,:,go(i)))>0%if there are spikes in this trial...
% 
%             plot(find(U{cellNum}.R_ntk(1,:,go(i))==1),i,'k.')
%         end
%         
%      end
%      
%      
%      
%      
%      for i = 1:length(nogo)
%           if sum(U{cellNum}.R_ntk(1,:,nogo(i)))>0%if there are spikes in this trial...
%           plot(find(U{cellNum}.R_ntk(1,:,nogo(i))==1),i+length(go),'k.')
%           end
%     end
%     end
%     set(gca,'ylim',[0 U{cellNum}.k]+1)
% %%
%     U{1}.meta.trialCorrect
%     U{1}.meta.trialType
%     
%      motorPosition: [1×512 double]
%           goPosition: [1×512 double]
%         nogoPosition: [1×512 double]
%            trialType: [1×512 logical]
%         trialCorrect: [1×512 double]
%            poleOnset: [1×512 double]
%           poleOffset: [1×512 double]
%                layer: {'S2BadContacts'}
%               ranges: [45000 125000]
%       sweepArrayName: {}
%            harddrive: {}
%         manipulation: {}
%     performingTrials: []
%          performance: []
%           stimTrials: {}
%     U{1}.varNames
%   Columns 1 through 7
%     'thetaAtBase'    'velocity'    'amplitude'    'setpoint'    'phase'    'deltaKappa'    'M0Adj'
%   Columns 8 through 12
%     'FaxialAdj'    'firstTouchOnset'    'firstTouchOffset'    'firstTouchAll'    'lateTouchOnset'
%   Columns 13 through 16
%     'lateTouchOffset'    'lateTouchAll'    'PoleAvailable'    'beamBreakTimes'
% %%
%     U{cellNum}.S_ctk(variableNum,time,trial)