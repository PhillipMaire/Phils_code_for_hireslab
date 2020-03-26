function saveFigAllTypes2(fn,whichOnes, varargin)
% saves as EPS, PDF, FIG with the function as the name and em
% function name then the fig handle then the save dir location. these can be left blank to fill in
% the otherone the only one needed is the the save name WITHOUT THE ENDING
tmpDir = pwd;
h = gcf;
if ~isempty(varargin{1}) && nargin >2
    h = varargin{1};
end


if ~isempty(varargin{2}) && nargin >= 4
    cd(varargin{2});
end
tmpDir2 = pwd;
figure(h);

if ~isempty(varargin{3}) && nargin >=5
    funcName = varargin{3};
    if ~strcmp(funcName(end-1:end), '.m')
        funcName = [funcName, '.m'];
    end
    h.Name = hibernatescript(funcName);
end

%%
%% 1 matlab figure
if any(whichOnes == 1)
    mkdir([tmpDir2, filesep, 'FIGS']);
    cd([tmpDir2, filesep, 'FIGS']);
    savefig(h, [fn, '.fig']);
end
%% 2 EMF
if any(whichOnes == 2)
    mkdir([tmpDir2, filesep, 'EMF']);
    cd([tmpDir2, filesep, 'EMF']);
    set(h,'InvertHardCopy','Off'); % saves background color
    saveas(h, [fn, '.emf'], 'meta') % no background color
end
%% 3 EPS
if any(whichOnes == 3)
    mkdir([tmpDir2, filesep, 'EPS']);
    cd([tmpDir2, filesep, 'EPS']);
    export_fig([fn, '.eps'], '-depsc', '-painters', '-r1200', '-transparent')
    fix_eps_fonts([fn, '.eps'], 'Arial')
end
%% 4 pdf
if any(whichOnes == 4)
    mkdir([tmpDir2, filesep, 'PDF']);
    cd([tmpDir2, filesep, 'PDF']);
    export_fig([fn, '.pdf'], '-painters', '-r1200', '-transparent')
end
%%  5 PNG
if any(whichOnes == 5)
    mkdir([tmpDir2, filesep, 'PNG']);
    cd([tmpDir2, filesep, 'PNG']);
    saveas(h, [fn, '.png'], 'png');
end
%% go back to the original directory
cd(tmpDir)
