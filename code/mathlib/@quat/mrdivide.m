function r = mrdivide(p, q)
% r=p/q;
% r=p*q=mat(p)*col(q)  ==> q=p\r=mat(p)\col(r)
% r=p*q=mati(q)*col(r)  ==> p=p/q=mati(q)\col(r)

p = quat(p);
q = quat(q);

% r=quat(mati(q)\col(p));
r = p * inv(q);
