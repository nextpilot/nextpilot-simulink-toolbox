function n = rotate(q, v)
% ��Ҫ�Ƚ�q��һ��
q = normalize(q);
% ʸ��������ת
r = conj(q) * v * q;
% ��ȡ�鲿
n = imag(r);