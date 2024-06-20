function q = seteuler(q, varargin)

if ischar(varargin{end})
    ang = [varargin{1:end-1}];
    xyz = varargin{end};
elseif length([varargin{:}]) == 3
    ang = [varargin{:}];
    xyz = 'zyx';
end

%q=quat();
for i = 1:length(ang)
    c = cos(ang(i)/2);
    s = sin(ang(i)/2);
    switch xyz(i)
        case {'x', 'X'}
            t = [c, s, 0, 0];
        case {'y', 'Y'}
            t = [c, 0, s, 0];
        case {'z', 'Z'}
            t = [c, 0, 0, s];
    end
    q = q * t;
end
