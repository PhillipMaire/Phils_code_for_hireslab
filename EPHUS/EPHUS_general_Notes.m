%this program is to help accessing the ephus xsg files and
%explain what i learned form toying around with them    -Phil

    %load test xsg file.

    load('Z:\Users\Phil\Data\EPHUS\for testing\JC0170\JC0170AAAA0005.xsg','-mat')
    
    % use 'header' variable to look into the files
    

       
        %% info about Pulse jacker 
        
           header.pulseJacker.pulseJacker
       % current position (number corresponding to pulse settings)
        header.pulseJacker.pulseJacker.currentPosition
      
%first 12 featres of (channel names)
% header.pulseJacker.pulseJacker.pulseDataMap
%    ephys:700B-2-VCom      
%    stimulator:AO1        
%    stimulator:AOM        
%    stimulator:CamNewSeq
%    stimulator:LaserShutter
%    stimulator:bustedonRig1
%    stimulator:digOut7    
%    stimulator:frametrigout
%    stimulator:shutter2   
%    stimulator:shutterOrange
%    stimulator:x_galvo     
%    stimulator:y_galvo 
    
    %starting at 13 here b/c pulseDataMap has 12 (channel names (see above))strings in the first 12
    %spots and then the reset are structs. adjust as needed. 
    %note I don't know why 396 is the end, you will likely have to change
    %this. 
    iter = 13:396;
      for k = iter
          names {k} =   header.pulseJacker.pulseJacker.pulseDataMap{k}.name;
      end
        
      %now we have a list of names used for that trial which for example...
      %x_C2_4
      %y_C2_5
      %default-DC_0
      %on 0.4s-4s, 2ms, 40Hz_1
      %OFF_2
      %frametrig_1
      %note that there are many instances the ones ive looked at have the
      %same values with the exception of load time, I suspect that these
      %are loaded for various reasons and every time this happens it saves
      %a new struct. Either way I will be pulling from the first instance
      %of 'on 0.4s-4s, 2ms, 40Hz_1' for example to determine the settings
      %(in a real program for actual analysis)
           for k = iter
        types {k} =   header.pulseJacker.pulseJacker.pulseDataMap{k}.type;
           end
      
      %this isnt really useful there are two types that I lknow of,
      % squarePulseTrain and Analytic. they seem to be patterned, but I
      % don't know why...
      
      %% PULSEJACKER - indices of selected variable 
      % I just used this to compare the different copies of these to test
      % if they were all the same -- as mentioned above, Yes excluding load
      % time. 
              for k = iter
                x_C2_4(k) = strcmp(names{k}, 'x_C2_4');
                 PhilsStim(k) = strcmp(names{k}, 'on 0.4s-4s, 2ms, 40Hz_1');
              end
                 %% 
                 varTOtest = PhilsStim;
                 
           header.pulseJacker.pulseJacker.pulseDataMap{varTOtest};
      
      %% for loading in iterative XSG files
         %%
      startTrial = 600;
      
      for k = 1:10
      
     trial = startTrial+k;
     if trial <100
          loadName = ['PM0120AAAB00', num2str(trial), '.xsg'];
     else
     loadName = ['PM0120AAAB0', num2str(trial), '.xsg'];
      load(loadName,'-mat');
     end
  varList(k) =  header.pulseJacker.pulseJacker.currentPosition;
      end
        %% from Samson King's code: loading trials
        
                        % load(dk(useTrials{i}).name,'-mat')
        xsgname = [T.trials{useTrials(i)}.spikesTrial.cellNum ...
            T.trials{useTrials(i)}.spikesTrial.cellCode ...
            sprintf('%04d',T.trials{useTrials(i)}.spikesTrial.xsgFileNum) ...
            '.xsg'];
        load(xsgname,'-mat');
        
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      