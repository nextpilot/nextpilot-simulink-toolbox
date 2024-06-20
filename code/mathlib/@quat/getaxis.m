function [axis, sigma] = getaxis(q)

q = normalize(q);
q0 = q.real;
qv = q.imag;

cosz = q0;
sinz = norm(qv);
sigma = atan2(sinz, cosz) * 2;
axis = qv ./ sinz;