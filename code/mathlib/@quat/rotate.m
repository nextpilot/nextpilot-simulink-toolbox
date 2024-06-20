function n = rotate(q, v)
% 需要先将q归一化
q = normalize(q);
% 矢量坐标旋转
r = conj(q) * v * q;
% 提取虚部
n = imag(r);