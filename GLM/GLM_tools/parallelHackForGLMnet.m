function parallelHackForGLMnet(minNumWorkers, userDir,numModelsRunTotal)
% disp('boopboop')
% pause(2)
% pBullet = Pushbullet('o.LLzZkkdcd6WN8MG5HyQjFDsCCSmRBAzw')
% pBullet.pushNote([],'parallelHackForGLMnet',['parallelHackForGLMnet'])
% only allow one for loop to get through and save the variable
if length(dir([userDir, filesep, '*numModelsRunAtBreakPoint_numWorkersAtBreakPoint*'])) == 0
    p = gcp('nocreate');
    
    if p.NumWorkers<=minNumWorkers 
        numModelsRunAtBreakPoint = length(dir('*_modRunNum_*'));
        numWorkersAtBreakPoint = p.NumWorkers;
        
        save([userDir, filesep, 'numModelsRunAtBreakPoint_numWorkersAtBreakPoint.mat'],...
            'numModelsRunAtBreakPoint', 'numWorkersAtBreakPoint');
        
        % load the variables just to make sure it isnt updated by other for loops
        load([userDir, filesep, 'numModelsRunAtBreakPoint_numWorkersAtBreakPoint.mat'])
        
        % check to see if the remining cores finish their jobs
        while numModelsRunTotal < numModelsRunAtBreakPoint+numWorkersAtBreakPoint
             p = gcp;
            numModelsRunTotal = length(dir('*_modRunNum_*'))+(numWorkersAtBreakPoint-p.NumWorkers);
        end
        
        % when they are done running kill the program because another program is on a while loop
        % until all cells have run
        error('too few cores are running')
    end
end