function isi_easy (varargin)
%% input the numbr of times you want to iterate through all the files to make
%% as many images as you want to make.
numNormalInputs = 0;



if nargin > numNormalInputs
    if isa( varargin{1},'double')
        
        numInputs = varargin{1};
    else
        numInputs =1;
        
    end
else
    numInputs =1;
end





for k =1:numInputs
    [FileName,PathName,FilterIndex] = uigetfile('*.*');
    cd(PathName)
    if  contains(FileName,'result');
        isiM  = isi_showMeanMap(FileName);
        display(' ')
        display(' ')
        display(' ')
        display(' ')
        display('isiM for ISI image')
        display(FileName)
        
    elseif contains(FileName,'fromVid')
        isiM = load(FileName);
        isiM = isiM.vidFrameGray;
        display(' ')
        display(' ')
        display(' ')
        display(' ')
        display('isiM for ISI image from video ')
    else
        dirDetails = dir(PathName);
        dirDetailsCell = struct2cell(dirDetails);
        
        for k = 1:length(dirDetailsCell);
            if strcmp(FileName, dirDetailsCell(1,k));
                index = k;
            end
        end
        
        if dirDetailsCell{4,index}>500000;
            isi_image(FileName(1:end-8));
        else
            
            isiM2 = isi_showQCamRaw(FileName);
            display(' ')
            display(' ')
            display(' ')
            display(' ')
            display('isiM2 for VAS image')
            display(FileName)
        end
        
    end
    
    
    if nargin >=numNormalInputs
        [FileName2,PathName2,FilterIndex2] = uigetfile('*.*');
        if  contains( FileName2,'result');
            isiM  = isi_showMeanMap(FileName2);
            display(' ')
            display(' ')
            display(' ')
            display(' ')
            display('isiM for ISI image')
            display(FileName2)
        elseif contains(FileName2,'fromVid')
            isiM = load(FileName);
            isiM = isiM.vidFrameGray;
            display(' ')
            display(' ')
            display(' ')
            display(' ')
            display('isiM for ISI image from video ')
        else
            
            dirDetails = dir(PathName);
            dirDetailsCell = struct2cell(dirDetails);
            
            for k = 1:length(dirDetailsCell);
                if strcmp(FileName2, dirDetailsCell(1,k));
                    index = k;
                end
            end
            
            if dirDetailsCell{4,index}>500000;
                isi_image(FileName2(1:end-8))
            else
                
                isiM2 = isi_showQCamRaw(FileName2);
                display(' ')
                display(' ')
                display(' ')
                display(' ')
                display('isiM2 for VAS image')
                display(FileName2)
            end
            
        end
        isi_quickdraw (isiM,isiM2, FileName, FileName2)
    end
end