%% miniUbuilder
tic
clear V
allDirs = dirFinder('C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\plots\SPIKES\MAIN_PLOTS\vArrayBuilderMats');

allMats = [];
varName = [];
counter = 0 ;
for dirITER = 1:length(allDirs)
    tmpDir = dir(allDirs{dirITER});
    for matITER = 1:length(tmpDir)
        if ~isempty(strfind(tmpDir(matITER).name, '.mat'))
            counter = counter +1;
            allMats{counter} = [tmpDir(matITER).folder filesep tmpDir(matITER).name];
            varName{counter} = tmpDir(matITER).name ;
        end
    end
    
end
varName = varName';
% V = struct;

for k = 1:length(varName)
%     disp(k)
    varName2 = varName{k};
    varName2(strfind(varName2, ' ')) = '';
    tmpInd = strfind(varName2, '.mat');
    varName2(tmpInd:tmpInd+3) = '';
    eval(['V.' varName2 ' = load(allMats{k});']);
    
end

toc
V

