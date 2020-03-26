function varargout = imagescnan(E, varargin)

h = pcolor([E nan(size(E, 1), 1); nan(1, 1+size(E, 2))]);
shading flat;
set(gca, 'ydir', 'reverse');
if nargin==2 && varargin{1} 
%     options = varargin{1};
    set(h, 'EdgeColor', 'k');
end
if nargout ==1
    varargout{1} = h;
end