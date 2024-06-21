% 将code目录添加到搜索路径
root = fileparts(mfilename('fullpath')+".m");
addpath(genpath(fullfile(root,'..','code')));