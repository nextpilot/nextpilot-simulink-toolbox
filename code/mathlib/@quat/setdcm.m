function q = setdcm(q, dcm)

qs = dcm2quat(dcm);
%q=quat;
q.real = qs(1);
q.imag = qs(2:4);