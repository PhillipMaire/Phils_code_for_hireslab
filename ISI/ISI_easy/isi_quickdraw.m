%%
function  isi_quickdraw (isiM, isiM2, varargin)
numNormalInputs = 2; 
RedImage = figure(10)
 imagesc(isiM)
colormap('gray')
imcontrast
figure(RedImage)
plotPoints = ginput();
close
h = figure
imagesc(isiM2)
hold on 
colormap('gray')
plot(plotPoints(:,1),plotPoints(:,2),'r.')
dateString = datestr(now,'yymmdd_HHMM');
saveString = dateString;
if nargin > numNormalInputs
    saveString = [varargin{1}(1:end-4),' ', varargin{2}(1:end-8),' ',dateString];
end
saveString = [saveString,'.jpg'];
 saveas(h ,saveString);
 imtool close all
end

