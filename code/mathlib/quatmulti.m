function r = quatmulti(p, q)

if ischar(p)
    p = str2sym(p);
elseif iscell(p)
    p = sym(p, 'real');
end

if ischar(q)
    q = str2sym(q);
elseif iscell(q)
    q = sym(q, 'real');
end

p0 = p(1);
pv = p(2:4);
q0 = q(1);
qv = q(2:4);

r0 = p0 * q0 - dot(pv, qv);
rv = p0 * qv + q0 * pv + cross(pv, qv);

r = [r0, rv];