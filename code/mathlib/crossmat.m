function m = crossmat(varargin)
import nextpilot.matlab.*
v = cell2vector(varargin);
if length(v) ~= 3
    error('crossmat:lengtherror', '输入必须是长度为3的向量！');
end
m = [0, -v(3), v(2); ...
    v(3), 0, -v(1); ...
    -v(2), v(1), 0];