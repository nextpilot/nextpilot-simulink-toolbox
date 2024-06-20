function s = shape2string(varargin)

c = cellfun(@(x)x(:), varargin, 'UniformOutput', false);
d = cat(1, c{:});

if length(d) == 2 && d(1) == 1 && d(2) == 1
    s = '1';
else
    d = arrayfun(@num2str, d, 'UniformOutput', false);
    s = ['[', strjoin(d, ','), ']'];
end