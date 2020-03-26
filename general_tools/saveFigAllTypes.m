function saveFigAllTypes(fn, varargin)
% saves as EPS, PDF, FIG with the function as the name and em
% function name then the fig handle then the save dir location. these can be left blank to fill in
% the otherone the only one needed is the the save name WITHOUT THE ENDING
h = gcf;
if ~isempty(varargin{1}) && nargin >1
    h = varargin{1};
end

tmpDir = pwd;
if ~isempty(varargin{2}) && nargin >= 3
    cd(varargin{2});
end
figure(h);

if ~isempty(varargin{3}) && nargin >=4
    funcName = varargin{3};
    if ~strcmp(funcName(end-1:end), '.m')
        funcName = [funcName, '.m'];
    end
    h.Name = hibernatescript(funcName);
end
%% matlab figure
savefig(h, [fn, '.fig']);
% EMF
set(h,'InvertHardCopy','Off'); % saves background color
saveas(h, [fn, '.emf'], 'meta') % no background color
%% EPS
export_fig([fn, '.eps'], '-depsc', '-painters', '-r1200', '-transparent')
fix_eps_fonts([fn, '.eps'], 'Arial')
%% pdf
export_fig([fn, '.pdf'], '-painters', '-r1200', '-transparent')
%% go back to the original directory
cd(tmpDir)
