function r = mldivide(p, q)
% r=p\q
% r=p*q=mat(p)*col(q)  ==> q=p\r=mat(p)\col(r)
% r=p*q=mati(q)*col(r)  ==> p=p/q=mati(q)\col(r)
import nextpilot.math.*

p = quat(p);
q = quat(q);

r = inv(p) * q;