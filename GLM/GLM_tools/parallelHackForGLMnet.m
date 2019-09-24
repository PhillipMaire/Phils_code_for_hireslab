function parallelHackForGLMnet(minNumWorkers, userDir,numModelsRunTotal)



p = gcp;
if p.NumWorkers<=minNumWorkers
    numModelsRunAtBreakPoint = length(dir('*_modRunNum_*'));
    numWorkersAtBreakPoint = p.NumWorkers;
    if length(dir([userDir, filesep, '*numModelsRunAtBreakPoint_numWorkersAtBreakPoint*'])) == 0
        save([userDir, filesep, 'numModelsRunAtBreakPoint_numWorkersAtBreakPoint.mat'],...
            'numModelsRunAtBreakPoint', 'numWorkersAtBreakPoint');
    end
    load([userDir, filesep, 'numModelsRunAtBreakPoint_numWorkersAtBreakPoint.mat'])
    while numModelsRunTotal < numModelsRunAtBreakPoint+numWorkersAtBreakPoint
        numModelsRunTotal = length(dir('*_modRunNum_*'));
    end
    error('too few cores are running')
end