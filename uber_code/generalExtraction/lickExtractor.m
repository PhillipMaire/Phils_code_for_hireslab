function [licksLinInds, allLicksCell, firstLicks, trialStart, trialEnd, licksPostPole, licksPrePole, averageLickShift] = ...
    lickExtractor(U, cellNum,offsetShift, varargin)
%where U is U array of cells
%does take into account the shift in the video justamke sure 
numMainVars = 3;

  trialStart =1;
  [test1,test2,trialEnd]=size(U{cellNum}.S_ctk(:,:,:));
  poleAvailableTime = 500;
if nargin >numMainVars
    poleAvailableTime = varargin{1};
end
if nargin >numMainVars+1
trialStart = varargin{2}(1);
trialEnd = varargin{2}(2);
end
     
   
     
     lickLinInds = U{cellNum}.S_ctk(16,:,trialStart:trialEnd);%16 is licks 
     lickLinInds(isnan(lickLinInds))=0;%replace nans with 0's
     
     
     licksLinInds = permute(lickLinInds,[1 3 2]);
     licksLinInds = reshape(licksLinInds,[],size(lickLinInds,2),1);%formating it to b 2 mat instread of 1 bytrials by time
     
     
     
     
     
     for trial = 1:numel(trialStart:trialEnd)
        allLicksCell{trial}=find(lickLinInds(1,:,trial));
     end
        

 [x]=cellNums2MatWithNansOrZeros(allLicksCell', 'zeros');
 x = x-offsetShift;
 test10 = repmat(poleAvailableTime',1,size(x,2));
 test1 = (x>test10);
  licksPostPole = x.*test1;
  test2 = ~test1;
  licksPrePole = x.*test2;
  licksPrePole(licksPrePole==-offsetShift)= 0;
firstLicks = x(:,1);
averageLickShift = round(sum(firstLicks(firstLicks>0))/length(firstLicks(firstLicks>0)));
firstLicks(firstLicks==-offsetShift)= averageLickShift;
end

