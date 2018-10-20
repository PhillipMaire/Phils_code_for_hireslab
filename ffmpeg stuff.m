
%%
string
%%


string = 'ffplay -vf eq=brightness=0.8:contrast=4: ';%gamma=.4 ';
directory = 'Z:\Data\HLab_ISI\ISI\AH0927\';
name = 'example.mp4';

commandFinal = [string, directory, name];

system(commandFinal);
%%

ffmpeg -framerate 1000 -i img%03d.png -c:v libx264 -pix_fmt yuv420p -crf 23 output.mp4
%%


string = 'ffplay -vf eq=brightness=0.8:contrast=4: ';%gamma=.4 ';
directory = 'Y:\Whiskernas\Data\Video\PHILLIP\AH0698\170601\';
name = 'c2_3_highcontrast_5_2.avi';

commandFinal = [string, directory, name];

system(commandFinal);
%%
counter = 1;
saveName = ['test', num2str(counter), '.mp4'];
contrastVar = 2;
brightnessVar = 0.5;
gammaVar = 0;
% commandFinal = ['ffmpeg -i ', directory, name, ' -b:v 800k -codec:v mpeg4 -vf eq=brightness=', num2str(brightnessVar), ':gamma=', num2str(gammaVar), ':contrast=', num2str(contrastVar), ' -c:a copy ', directory, saveName];
% commandFinal = ['ffmpeg -i ', directory, name, ' -codec:v mpeg4 -vf eq=brightness=', num2str(brightnessVar), ':gamma=', num2str(gammaVar), ':contrast=', num2str(contrastVar), ' -c:a copy ', directory, saveName];
commandFinal = ['ffmpeg -i ', directory, name, ' -b:v 1600k -codec:v mpeg4 -vf eq=brightness=', num2str(brightnessVar),...
    ':contrast=', num2str(contrastVar), ' -c:a copy ', directory, saveName];
system(commandFinal);
%%

counter = 0; 
contrastAll = (1.5:.05:1.8);
brightnessAll = (0.25:.05:.55);
for k = 1:length(contrastAll)
    for kk = 1:length(brightnessAll)
counter = counter +1; 
brightnessVar = brightnessAll(kk);
contrastVar = contrastAll(k);
saveName = ['test', num2str(counter), '.mp4'];
commandFinal = ['ffmpeg -i ', directory, name, ' -b:v 800k -codec:v mpeg4 -vf eq=brightness=', num2str(brightnessVar), ':contrast=', num2str(contrastVar), ' -c:a copy ', directory, saveName];
system(commandFinal);
end
end

%% change the frame rate
name = 'example.mp4';
directory = 'C:\Users\maire\Desktop\'
saveName = 'example6.mp4';


commandFinal = ['ffmpeg -i ', directory, name, ' -vcodec h264 -an -vf "fps=30, setpts=(1/10)*PTS" ',...
    directory, saveName];

% % %    'ffmpeg -i input_30fps.avi -vcodec h264 -an -vf "fps=60, setpts=(1/200)*PTS" output_200x_60fps.avi'

system(commandFinal)




