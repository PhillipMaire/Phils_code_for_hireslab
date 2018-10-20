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
for cellNum =[3]
    clearvars -except U cellNum
    h = figure(10+cellNum);
    clf;
    hsub1 = subplot('position', [0.08,0.33,.87,.65]);
    hsub2 = subplot('position', [0.08,0.08,.87,.17]);
    hold on
    
    set(gca,'ylim',[0 U{cellNum}.k]+1)
    
    
    smoothFactor = 30;
    smoothType = 'moving';
    normalizeSpikes = 1 ; %1 is yes 0 is no
    colorAtEndNumber = 4020:.2:4025;%add the colored part at the end to indicate trial type
    colorSet = {'b', 'r', 'g', 'k'};%for tghe trial type
    
    
    
    
   
    
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
        
 poleAvailableTime =500;
        [licksLinInds, allLicksCell, firstLicks, trialStart, trialEnd] = lickExtractor(U, cellNum,poleAvailableTime);
        
        
    
        
         numVars = 1;
        for iter1 = 1:numVars
            clear var1 var1LinInds var1Inds var1SummedSpikes
            hold on
           subplot(hsub1) 
           
        if iter1 == 1
            var1 = find(falseAlarm) ;
            addLength = 0;
            length1 = length(var1);
        elseif iter1 == 2
            var1 = find(corrRej);
            addLength = length1;
            length2 = length(var1);
        elseif iter1 == 3
            var1 = find(falseAlarm);
            addLength = addLength + length2;
             length3 = length(var1);
        elseif iter1 == 4
            var1 = find(miss);
            addLength = addLength +length3;
             
        end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       hold on 
        for i = 1:length(var1) % i through all the go's
            if sum(U{cellNum}.R_ntk(1,:,var1(i)))>0%if there are spikes in this trial...
                var1LinInds = U{cellNum}.R_ntk(1,:,var1(i))==1;
%                 var1LinInds = circshift(var1LinInds, [0, -firstLicks(var1(i))]);%shift the value
                
                if sum(var1LinInds(3840:3860))>0
                end
             
                allVar1LinInds(i+addLength,:) = var1LinInds;
                var1Inds = find(var1LinInds);
                var1IndsLickShifted = find(var1LinInds)-firstLicks(var1(i));
                %%%%
                
                allVar1Inds{i+addLength} = var1Inds;
                %%%%
                plot(var1Inds,i+addLength,'k.')
                
            end
        end
        var1SummedSpikes = sum(allVar1LinInds, 1);
        
        
        
        plot(repmat(colorAtEndNumber,length(var1)),1+addLength:length(var1)+addLength,strcat(colorSet{iter1},'.'))
        
        %      plot(allVar1Inds{},1:length(var1),'k.')%try to plot this with using cell fun or something
        
        % % % % % % % % % %
        % % % % % % % % % % %
        % % % % % % % % % % %          allVar1Inds
        % % % % % % % % % % %       [x2]=cellNums2MatWithZeros(allVar1Inds);
        % % % % % % % % % % % figure; plot(x2(1:188,:),1:188,'k.')
        % % % % % % % % % % %      x2(1:188,:)>0;
        % % % % % % % % % %   if numVars>1
        % % % % % % % % % %       for i = 1:length(var2) % i through all the go's
        % % % % % % % % % %           addLength1 = i+length(var1);
        % % % % % % % % % %         if sum(U{cellNum}.R_ntk(1,:,var2(i)))>0%if there are spikes in this trial...
        % % % % % % % % % %             var2LinInds = U{cellNum}.R_ntk(1,:,var2(i))==1;
        % % % % % % % % % %             summedVar2 = var2LinInds + summedVar2;
        % % % % % % % % % %             allVar2LinInds(i,:) = var2LinInds;
        % % % % % % % % % %             var2Inds = find(var2LinInds);
        % % % % % % % % % %
        % % % % % % % % % %             plot(var2Inds,addLength1,'k.')
        % % % % % % % % % %             plot(colorAtEndNumber,addLength1,strcat(colorSet{2},'.'))
        % % % % % % % % % %         end
        % % % % % % % % % %
        % % % % % % % % % %      end
        % % % % % % % % % %      var2SummedSpikes = sum(allVar2LinInds, 1);
        % % % % % % % % % %
        % % % % % % % % % %   end
        % % % % % % % % % %
        % % % % % % % % % %
        % % % % % % % % % %
        % % % % % % % % % %
        % % % % % % % % % %
        % % % % % % % % % %
        % % % % % % % % % %   if numVars>2
        % % % % % % % % % %       for i = 1:length(var3) % i through all the go's
        % % % % % % % % % %            addLength2 = i+length(var1)+length(var2);
        % % % % % % % % % %         if sum(U{cellNum}.R_ntk(1,:,var3(i)))>0%if there are spikes in this trial...
        % % % % % % % % % %             var3LinInds = U{cellNum}.R_ntk(1,:,var3(i))==1;
        % % % % % % % % % %             summedVar3 = var3LinInds + summedVar3;
        % % % % % % % % % %             allVar3LinInds(i,:) = var3LinInds;
        % % % % % % % % % %             var3Inds = find(var3LinInds);
        % % % % % % % % % %
        % % % % % % % % % %             plot(var3Inds,addLength2,'k.')
        % % % % % % % % % %             plot(colorAtEndNumber,addLength2,strcat(colorSet{3},'.'))
        % % % % % % % % % %         end
        % % % % % % % % % %
        % % % % % % % % % %      end
        % % % % % % % % % %      var3SummedSpikes = sum(allVar3LinInds, 1);
        % % % % % % % % % %   end
        % % % % % % % % % %
        % % % % % % % % % %
        % % % % % % % % % % if numVars>3
        % % % % % % % % % %       for i = 1:length(var4) % i through all the go's
        % % % % % % % % % %           addLength3 = i+length(var1)+length(var2)+length(var3);
        % % % % % % % % % %         if sum(U{cellNum}.R_ntk(1,:,var4(i)))>0%if there are spikes in this trial...
        % % % % % % % % % %             var4LinInds = U{cellNum}.R_ntk(1,:,var4(i))==1;
        % % % % % % % % % %             summedVar4 = var4LinInds + summedVar4;
        % % % % % % % % % %             allVar4LinInds(i,:) = var4LinInds;
        % % % % % % % % % %             var4Inds = find(var4LinInds);
        % % % % % % % % % %
        % % % % % % % % % %             plot(var4Inds,addLength3,'k.')
        % % % % % % % % % %            plot(colorAtEndNumber,addLength3,strcat(colorSet{4},'.'))
        % % % % % % % % % %
        % % % % % % % % % %         end
        % % % % % % % % % %
        % % % % % % % % % %      end
        % % % % % % % % % %      var4SummedSpikes = sum(allVar4LinInds, 1);
        % % % % % % % % % % end
        
        
        subplot(hsub2)
        if iter1 ==1
            hold off 
        else 
            hold on 
        end
        try
            if normalizeSpikes == 1
                normDivBy=length(var1);
            elseif normalizeSpikes == 0
                normDivBy = 0;
            end
            plot(smooth(var1SummedSpikes/normDivBy,smoothFactor,smoothType),colorSet{iter1})
        catch
        end
        linkaxes([hsub1, hsub2], 'x');
    
end
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