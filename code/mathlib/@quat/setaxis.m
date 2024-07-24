function q = setaxis(q, varargin)

% setaxis([beta1,beta2,beta3,sigma])
% setaxis([beta1,beta2,beta3]*sigma)
% setaxis([beta1,beta2,beta3],sigma)
% setaxis(beta1,beta2,beta3)
% setaxis(beta1,beta2,beta3,sigma)


% 绕着轴 n = [cosβ1,cosβ2,cosβ3] 旋转角度 σ，则构成四元素
% q = cos(σ/2) + sin(σ/2)*[cosβ1*i + cosβ2*j + cosβ3*k]

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
