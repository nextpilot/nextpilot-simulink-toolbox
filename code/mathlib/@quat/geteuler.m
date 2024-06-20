function varargout = geteuler(q, s)
if nargin == 1
    s = 'zyx';
end

% ����MATLAB�Դ��ĺ�����
%(1)���պ��칤����quat2angle
%(2)�����˹�����quat2eul
q = col(q);
[r1, r2, r3] = quat2angle(q, s);

if nargout <= 1
    varargout{1} = [r1, r2, r3];
else
    varargout{1} = r1;
    varargout{2} = r2;
    varargout{3} = r3;
end