function l = log(q)

[qv, sigma] = getaxisangle(q);

l = [0, qv * sigma / 2];

%quatlog(col(q))
