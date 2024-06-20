function python(varargin)
cmd = ['python', sprintf(' "%s"', varargin{:})];
system(cmd);