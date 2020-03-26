function [fileStringOutput] = hibernatescript(varargin)

% varargin{1} is the function name if the user wants to specify can be '[]' if you want to just set
% the second variable
% varargin{2} is a logical to overide error thatthe function is shadowd
% 
% so funcString = hibernatescript('sum'); will not work but funcString = hibernatescript('sum', true);
% will because there are multiple instances of sum. 
% evaluating the 1 line below 
% funcString = dummy90909090()
% will create a string of the function below becasue even though the line was evaluated the
% hibernatescript was inside a function that was properly run and thus it gets to data from the
% program it is inside 
% 
% function [funcString] = dummy90909090()
% funcString = hibernatescript();
% end
%
% funcString = hibernatescript('sum.m', true); % true to override the fact that there are shadowed sum
% files 
% eval(funcString) & wont do anything here because the text in 'sum.m' is all comments, but in another
% program where it is a script (without function at the top) it will run the script
% 
% revivescript(funcString)
% will replicate the text of the original input script and save it as a .m file in a reviveFolder
% in the users download folder path. then it opens it. you can pass a name through it if you'd like
% to name the function. Regardless it will be followed by a unique set of number


if nargin == 0 || isempty(varargin{1})
    db1 = dbstack;
    if size(db1, 1)==1 % this is true if you just evaluated the code and didnt run it
        error('you must either run the code (not evaluate it) with ''hibernatescript'' in it or specify a function name')
    else
        funcName = db1(2).file;% function that called this
    end
elseif nargin >= 1
    funcName = varargin{1};
    if ~contains(funcName(end-1:end), '.m')
        funcName = [funcName, '.m'];
        warning('add the ''.m'' ending to the file name please')
    end
end
if size(which(funcName,  '-all'), 1)>1 && (nargin<2 || varargin{2}~=true)
    error('Your selected function is shadowed, set second input to true if you want to overide this error')
elseif size(which(funcName,  '-all'), 1)>1 && nargin == 2 && varargin{2}==true
    warning('Overriding shadowed function error')
    % elseif size(which(funcName,  '-all'), 1)==1
    
elseif size(which(funcName,  '-all'), 1)==0
    error(['File ''', funcName, ''' not found'])
end
fileStringOutput = fileread(funcName);
if ~ismac  % for windows remove extra spaces 
fileStringOutput = regexprep(fileStringOutput, '\r', '');
end


