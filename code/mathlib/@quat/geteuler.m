function varargout = geteuler(q, s)
if nargin == 1
    s = 'zyx';
end

% 调用MATLAB自带的函数，
%(1)航空航天工具箱quat2angle
%(2)机器人工具箱quat2eul
q = col(q);
[r1, r2, r3] = quat2angle(q, s);

if nargout <= 1
    varargout{1} = [r1, r2, r3];
else
    varargout{1} = r1;
    varargout{2} = r2;
    varargout{3} = r3;
end