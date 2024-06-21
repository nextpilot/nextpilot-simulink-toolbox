function r = ang2dcm(varargin)
% ang2dcm ������XYZ����ת�Ǵ����������Ҿ���
%
% dcm = ang2dcm(r1,r2,r3,...,'xyz...')
% dcm = ang2dcm([r1, r2, ...], 'xyz...')
% ����: 
%    r1, r2, r3, ����ת�Ƕȣ����Ȼ�sym���ţ�
%    'xyz...'����ÿ����ת���ᣬ��xyz�����
%
% Examples:
%
%  Determine the direction cosine matrix from rotation angles:
%  yaw = 0.7; pitch = 0.2; roll = 0.6;
%  dcm = ang2dcm(yaw, pitch, roll, 'zyx')
%
%  ʹ��sym�������㣬���й�ʽ�Ƶ�
%  syms yaw pitch roll real
%  dcm = ang2dcm(yaw, pitch, roll, 'zyx')
%
% See also ang2quat

if nargin < 2
    error('ang2dcm:inputerror', '���ٰ����������������');
else
    ang = cell2vector(varargin(1:end-1));
    act = varargin{end};
end

if length(ang) ~= length(act)
    warning('ang2dcm:lengtherror', '����ǶȺ�ת�᳤�Ȳ�һ�£�');
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