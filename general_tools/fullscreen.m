function fullscreen(varargin)
% make full screen either fullscreen by itself
% or fullscreen(h) where h is fig handle
% or fullscreen(h, 2) for ful screen on the second monitor
% or fullscreen([], 2) for gcf and the second moniter
% or fullscreen([], 3) for gcf fill up both screens
if nargin == 3 && strcmpi(varargin{3}, 'all')
    h =  findobj('type','figure');
    for k = 1:length(h)
        fullscreen(h(k), varargin{2});
    end
else
    if nargin >= 1 && ~isempty(varargin{1})
        tmp1 = varargin{1};
    else
        tmp1 = gcf;
    end
    
    MP = get(0, 'MonitorPositions');
    
    
    if nargin ==2
        monNum = varargin{2};
    else
        monNum = 1;
    end
    
    
    if monNum<= size(MP, 1)
        tmp1.Position = MP(monNum, :);
        tmp1.WindowState = 'maximized';
    elseif  (monNum-1) == size(MP, 1) % make full across all screens
        
        pos2 = [min(MP(:, 1:2)), sum(MP(:, 3)), min(MP(:, 4))]
        tmp1.Position = pos2;
    else (monNum-1) > size(MP, 1)
        error('Too many screen inputs')
    end
    
end
drawnow
% pause(2);% give time for the fig to go fullscreen