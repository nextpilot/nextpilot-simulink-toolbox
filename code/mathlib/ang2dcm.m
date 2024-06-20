function r = ang2dcm(varargin)
% ang2dcm
% ang2dcm(a1,a2,a3,...,'xyz...')
%
import nextpilot.matlab.*
if nargin < 2
    error('ang2dcm:inputerror', '至少包含两个输入参数！');
else
    ang = cell2vector(varargin(1:end-1));
    act = varargin{end};
end

if length(ang) ~= length(act)
    warning('ang2dcm:lengtherror', '输入角度和转轴长度不一致！');
end
n = min(length(ang), length(act));

r = eye(3);
for i = 1:n
    r = sig2dcm(ang(i), act(i)) * r;
end

function r = sig2dcm(t, k)
s = sin(t);
c = cos(t);
switch k
    case 'x'
        r = [1, 0, 0; ...
            0, c, s; ...
            0, -s, c];
    case 'y'
        r = [c, 0, -s; ...
            0, 1, 0; ...
            s, 0, c];
    case 'z'
        r = [c, s, 0; ...
            -s, c, 0; ...
            0, 0, 1];
end