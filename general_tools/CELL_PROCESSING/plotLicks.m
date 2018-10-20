%%
function plotLicks(trialNums, sweepBeamBreakTimes)
for k = trialNums

position = 15;
licks = sweepBeamBreakTimes{k};
if sweepBeamBreakTimes{k}>0
plot(licks, position*ones(numel(licks),1),'+b')
for kk = 1: numel(sweepBeamBreakTimes{k})
plot( repmat(licks(kk),2,1), [-5,10], 'b')
end
else
 display('NO LICKS THIS TRIAL')   
    
end
while true
    w = waitforbuttonpress; 
    switch w 
        case 1 % (keyboard press) 
        	key = get(gcf,'currentcharacter'); 
              switch key
                  case 13 % 13 is the return key 
                      disp('User pressed the return key. Quitting the loop.')
                      break
                  otherwise 
                      % Wait for a different command. 
              end
      end
  end
end
end


