function whichAll
remain = path;
diary('whichalloutput.txt');
while ~strcmp(remain,'')
   [token, remain] = strtok(remain,';');
   dircontents = dir([token '\*.m']);
   
   disp(['FOLDER: ' token]);
   disp('=======');
   %First entry in MATLAB toolbox folders happen to be Contents.m
   if (numel(dircontents)>0) && (~strcmp(dircontents(1).name,'Contents.m'))
       filename = strtok(dircontents(1).name,'.m');
       which(filename,'-all');
       disp(char(13))
   end
   for i=2:numel(dircontents)
       filename = strtok(dircontents(i).name,'.m');
       which(dircontents(i).name,'-all');
       disp(char(13))
   end
end
diary off;
disp('save text file as whichalloutput')
end