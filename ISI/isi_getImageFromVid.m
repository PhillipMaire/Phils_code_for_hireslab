function [] = isi_getImageFromVid(filename, frameNum)
vidFile = VideoReader(filename);
vidFile.CurrentTime = frameNum./vidFile.FrameRate;
 vidFrame = readFrame(vidFile);
filename = filename(1:strfind(filename, '.')-1);

imwrite(uint8(vidFrame), [filename, '.png'])
vidFrameGray = rgb2gray(vidFrame);
save([filename, 'fromVid'], 'vidFrameGray');
end

