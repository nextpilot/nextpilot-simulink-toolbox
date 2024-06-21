function tustin(sys,method,varargin)
%% 一阶向后差分
% z=exp(s*T)=1/exp(-s*T)=1/(1-s*T)
% s = (1-1/z)/T

%% 一阶向前差分
% 不推荐使用
% z = exp(T*s) = 1+T*s
% s = (z-1)/T

%% tusin
% z = exp(s*T)=exp(1/2*s*T)/exp(-1/2*s*T)= (1+s*T/2)/(1-s*T/2)
% s = 2/T*(z-1)/(z+1) 

syms z T w real
s = 2/T*(z-1)/(z+1);
pretty(collect(w/(s+w),z))


%% 双线
% s = w/tan(w*T/2)*(z-1)/(z+1)




switch method
    case 'zoh'
        
    case 'tustin'
    case 'pre-tustin'
end