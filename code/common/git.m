function git(varargin)
cmd = ['git', sprintf(' "%s"', varargin{:})];
system(cmd);