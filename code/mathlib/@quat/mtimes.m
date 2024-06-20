function r = mtimes(p, q)
% 四元素与四元素运算，P*Q
% 四元素与矢量运算，Q*v, v*Q
% 四元素与标量运算，Q*k，k*Q
import nextpilot.math.*
p = quat(p);
q = quat(q);

p0 = real(p);
pv = imag(p);
q0 = real(q);
qv = imag(q);

r0 = p0 * q0 - dot(pv, qv);
rv = p0 * qv + q0 * pv + cross(pv, qv);

r = quat(r0, rv);