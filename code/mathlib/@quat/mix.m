function b = mix(q, v)
% 四元素混合积
% 物理意义，矢量a经过四元素q旋转以后，在原坐标系的坐标值b
% b=q*a*conj(q)
% a=conj(q)*b*q
b = q * v * conj(q);