function r = getdcm(q)
q0 = q.q0;
q1 = q.q1;
q2 = q.q2;
q3 = q.q3;
qx = [q0, q3, -q2; ...
    -q3, q0, q1; ...
    q2, -q1, q0];
qv = imag(q)';
r = qv * qv' + qx^2;