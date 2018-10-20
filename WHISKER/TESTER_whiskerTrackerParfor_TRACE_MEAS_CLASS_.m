%%
mainDir = 'Z:\Data\Video\PHILLIP\';
numFilesPerDir =4;

folderNums = {...
    'AH0705\171031'...
    'AH0705\171102'...
    'AH0705\171103'...
    'AH0705\171104'...
    'AH0705\171105'...
    'AH0705\171106'...
    'AH0705\171107'...
    '---AH0706\171031'...
    'AH0706\171101'...
    'AH0706\171102'...
    '---AH0706\171103'...
    'AH0706\171105'...
    '---AH0706\171106'...
    '---AH0706\171107'...
    '---AH0706\171108'...
    'AH0714\170923'...
    '---AH0714\170924'...
    'AH0714\170925'...
    };

tic
TestDir = 'Z:\Data\Video\PHILLIP\TEST';
cd(TestDir)
        status = copyfile('Z:\Users\Phil\code\settings\defaultParams\default.parameters')


for k= 1:length(folderNums)
    try
         newDir = [mainDir folderNums{k}];
        cd(newDir)
       
        
        

            
            MP4s = dir('*.mp4'); %Searches only for .mp4 files, change if using other type (e.g. SEQ)
              measures = dir('*.whiskers');
            for k = 1:numFilesPerDir
                [~, outputFileName] = fileparts(MP4s(k).name);
                [~, outputFileNameMeasures] = fileparts(measures(k).name);
                if strcmp(outputFileName, outputFileNameMeasures)
                outputFileName(end+1:end+4) = '.mp4';
                outputFileNameMeasures(end+1:end+9) = '.whiskers';
               copyfile( outputFileName, TestDir)
               copyfile( outputFileNameMeasures, TestDir)
                end
            end
     
    catch
        errorCatch{k} = strcat(folderNums{k},' error in trace, measure or classify');
        
    end
end
toc

%% test to see if your whisker files are fucked up 
for k= 1:length(folderNums)
    
          newDir = [mainDir folderNums{k}];
        cd(newDir)

      measures = dir('*.whiskers');
      test =  struct2cell(measures);
      test2 = test(4,:);

     
     badWhiskerFiles = cellfun(@(x) x<10000, test2, 'UniformOutput', 1);

    CountBadWhiskFiles(k) = sum(badWhiskerFiles);

end

CountBadWhiskFiles = CountBadWhiskFiles';
