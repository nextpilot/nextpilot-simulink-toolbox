function r = ang2dcm(varargin)
% ang2dcm 根据绕XYZ轴旋转角创建方向余弦矩阵
%
% dcm = ang2dcm(r1,r2,r3,...,'xyz...')
% dcm = ang2dcm([r1, r2, ...], 'xyz...')
% 其中: 
%    r1, r2, r3, 是旋转角度（弧度或sym符号）
%    'xyz...'，是每次旋转的轴，是xyz的组合
%
% Examples:
%
%  Determine the direction cosine matrix from rotation angles:
%  yaw = 0.7; pitch = 0.2; roll = 0.6;
%  dcm = ang2dcm(yaw, pitch, roll, 'zyx')
%
%  使用sym符号运算，进行公式推导
%  syms yaw pitch roll real
%  dcm = ang2dcm(yaw, pitch, roll, 'zyx')
%
% See also ang2quat

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
    case {'x','X'}
        r = [1, 0, 0; ...
            0, c, s; ...
            0, -s, c];
    case {'y','Y'}
        r = [c, 0, -s; ...
            0, 1, 0; ...
            s, 0, c];
    case {'z','Z'}
        r = [c, s, 0; ...
            -s, c, 0; ...
            0, 0, 1];
end