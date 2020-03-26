function [] = revivescript(funcString, varargin)

%% get user dirctory and set up reviveFolder if it isnt already
currentDir = pwd;
userProfile = getenv('USERPROFILE');
DLfolder = sprintf('%s\\Downloads', userProfile);
reviveFolder = [DLfolder, filesep, 'reviveFolder'];
if ~isdir(reviveFolder)
    mkdir(reviveFolder)
end
cd(reviveFolder)
%% name the function w
dateString1 = datestr(now,'yymmdd_HHMM_FFF');
funcName = 'tmp';
if nargin == 2
    funcName = varargin{1};
end
if contains(funcName(end-1:end), '.m')
    funcName = funcName(1:end-2);% we will add the .m later after the date
end
funcName = [funcName, '_', num2str(dateString1), '.m'];
%%
fid = fopen(funcName, 'wt');
fprintf(fid, '%s', funcString);
fclose(fid);
edit(funcName);
cd(currentDir)
