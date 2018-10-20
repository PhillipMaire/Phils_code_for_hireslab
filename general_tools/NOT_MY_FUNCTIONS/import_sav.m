function import_sav(sav_file,labels)
% Opens the import tool for importins a sav file
% 'sav_file' is the name of the SPSS\PSPP file to import
% 'labels' is a logical that if true then the file is imported using the
% labels and not the numeric values. Default is TRUE.

if nargin<2
    labels = true;
end
[p,csv_file] = fileparts(sav_file);
if isempty(p), p = cd; end
sps_file = [p '\convert2csv.sps'];
% sav_file = 'C:\Users\Eyal\Dropbox\MATLAB\atid\result.sav';
csv_file = [p '\' csv_file '.csv'];
fid = fopen(sps_file,'w');
fprintf(fid,'GET FILE =  ''%s''\n',sav_file);
fprintf(fid,'save translate\n');
fprintf(fid,'\t\t/outfile = ''%s''\n',csv_file);
fprintf(fid,'\t\t/type = CSV\n');
fprintf(fid,'\t\t/REPLACE\n');
fprintf(fid,'\t\t/FIELDNAMES\n');
if labels
    fprintf(fid,'\t\t/CELLS=LABELS.\n');
else
    fprintf(fid,'\t\t/CELLS=VALUES.\n');
end
fclose(fid);
command = ['"C:\Program Files\PSPP\bin\pspp.exe" ' sps_file];
system(command)
uiimport(csv_file)
end


















