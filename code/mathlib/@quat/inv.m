function q = inv(q)

absq = abs(q)^2;
q.real = q.real / absq;
q.imag = -q.imag / absq;
