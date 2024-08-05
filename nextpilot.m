function nextpilot(varargin)
root = fileparts(mfilename('fullpath')+".m");

action = 'init';

if nargin >= 1
    action = varargin{1};
end

switch action
    case 'init'
        addpath(genpath(root));
    case 'exit'
        rmpath(genpath(root));
end