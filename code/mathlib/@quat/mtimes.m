function r = mtimes(p, q)
% ��Ԫ������Ԫ�����㣬P*Q
% ��Ԫ����ʸ�����㣬Q*v, v*Q
% ��Ԫ����������㣬Q*k��k*Q
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