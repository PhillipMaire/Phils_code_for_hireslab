function adaptthreshVID(vidName, sensitivity1, winChunckSize)
V2 = VideoReader(vidName);
nameVid = ['f_',vidName];
dots1 = strfind(nameVid, '.');
nameVid =[nameVid(1:dots1), 'avi'];
v = VideoWriter(nameVid);%%###
v.FrameRate = V2.FrameRate;%%###
open(v);
for k = 1:V2.Duration*V2.FrameRate

        
    newFrame = adaptthresh(rgb2gray(V2.readFrame),sensitivity1,'Statistic','mean','NeighborhoodSize',winChunckSize);
  
    writeVideo(v,newFrame);
end
close(v)