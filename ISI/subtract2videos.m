

function subtract2videos(vid1, vid2, varargin)
triggerNoAdpThresh = 0;
if nargin == 3
    triggerNoAdpThresh = 1;
end
contrastAdjLims = [0.1 0.70];
type1 = vid1(strfind(vid1, '.')+1:end);
type2 = vid2(strfind(vid2, '.')+1:end);
name1 = vid1(1:strfind(vid1, '.')-1);
name2 = vid2(1:strfind(vid2, '.')-1);
if strcmp(type1, 'avi')
    V1 = VideoReader(vid1);
    V2 = VideoReader(vid2);
    F1 = V1.Duration*V1.FrameRate;
    F2 = V2.Duration*V2.FrameRate;
    
    if F1~= F2
        error('vi files must have same number of frames');
    end
    nameVid = ['difVid',name1, name2, '.avi'];
    v = VideoWriter(nameVid);%%###
    v.FrameRate = V1.FrameRate;%%###
    open(v);
    timeSteps = V1.CurrentTime:1/V1.FrameRate:V1.Duration;
    senseVal = .1;
    winsmoothSize = 33;
    for k = 1:F1
        close all
        
        V1.CurrentTime =  timeSteps(k);
        v1f = (rgb2gray(V1.readFrame));
        V2.CurrentTime =  timeSteps(k);
        v2f = (rgb2gray(V2.readFrame));
        if ~triggerNoAdpThresh
            v1f = adaptthresh(v1f,senseVal,'Statistic','mean','NeighborhoodSize',[winsmoothSize ,winsmoothSize]);
            v2f = adaptthresh(v2f,senseVal,'Statistic','mean','NeighborhoodSize',[winsmoothSize ,winsmoothSize]);
        end
        
        newFrame = mat2gray(imsubtract(v1f, v2f));
        %                 newFrame = mat2gray((v1f- v2f));
        
        
        %     newIm2 = imsubtract(v1f, newIm);
        
        %     newFrame = (rgb2gray() - rgb2gray());
        %             newFrame =imadjust(newFrame);
        newFrame = imadjust(newFrame,contrastAdjLims,[]);
        writeVideo(v,newFrame);
        
    end
    close(v);
else %% assuming these are images
    
    
    V1 =    rgb2gray(imread( vid1));
    V2 =    rgb2gray(imread( vid2));
    if ~triggerNoAdpThresh
        v1f = adaptthresh(V1,senseVal,'Statistic','mean','NeighborhoodSize',[winsmoothSize ,winsmoothSize]);
        v2f = adaptthresh(V2,senseVal,'Statistic','mean','NeighborhoodSize',[winsmoothSize ,winsmoothSize]);
    end
    finalIm = mat2gray(imsubtract(v1f, v2f));
    finalIm = imadjust(finalIm,contrastAdjLims,[]);
    imwrite(finalIm, ['diffPic',name1, name2,'.png'])
    
end