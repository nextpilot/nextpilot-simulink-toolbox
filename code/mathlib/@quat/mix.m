function b = mix(q, v)
% ��Ԫ�ػ�ϻ�
% �������壬ʸ��a������Ԫ��q��ת�Ժ���ԭ����ϵ������ֵb
% b=q*a*conj(q)
% a=conj(q)*b*q
b = q * v * conj(q);