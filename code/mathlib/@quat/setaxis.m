function q = setaxis(q, varargin)

% setaxis([beta1,beta2,beta3,sigma])
% setaxis([beta1,beta2,beta3]*sigma)
% setaxis([beta1,beta2,beta3],sigma)
% setaxis(beta1,beta2,beta3)
% setaxis(beta1,beta2,beta3,sigma)


% ������ n = [cos��1,cos��2,cos��3] ��ת�Ƕ� �ң��򹹳���Ԫ��
% q = cos(��/2) + sin(��/2)*[cos��1*i + cos��2*j + cos��3*k]

vect = [varargin{:}];
if length(vect) == 3
    axis = vect;
    sigma = norm(vect);
elseif length(vect) == 4
    axis = vect(1:3);
    sigma = vect(4);
end

%q = quat;
axis = axis / norm(axis);
q.real = cosd(sigma/2);
q.imag = sind(sigma/2) * axis;
