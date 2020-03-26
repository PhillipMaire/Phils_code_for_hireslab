function fix_eps_fonts(figfilestr, varargin)
% modified version of printeps
% to fix the problem of print (and export_fig) in changing text fonts to
% helvetica when saving the figure
if nargin > 1
   if ischar(varargin{1})
       actualfont = varargin{1};
   elseif isnumeric(varargin{1})
       figure(fignum);
   end
end
if ~exist('actualfont', 'var')
   actualfont = get(gca,'FontName');
end
fid = fopen(figfilestr);
ff = char(fread(fid))';
fclose(fid);
%these are the only allowed fonts in MatLab and so we have to weed them out
%and replace them:
mlabfontlist = {'AvantGarde','Helvetica-Narrow','Times-Roman','Bookman',...
   'NewCenturySchlbk','ZapfChancery','Courier','Palatino','ZapfDingbats',...
   'Helvetica'};%,'Symbol'};
for k = 1:length(mlabfontlist)
ff = strrep(ff,mlabfontlist{k},actualfont);
end
% open the file up and overwrite it
fid = fopen(figfilestr,'w');
fprintf(fid,'%s',ff);
fclose(fid);