function q = setelem(q, varargin)

vect = [varargin{:}];
%q = quat;
if length(vect) == 1
    q.real = vect;
    q.imag = [0, 0, 0];
elseif length(vect) == 3
    q.real = 0;
    q.imag = vect;
elseif length(vect) == 4
    q.real = vect(1);
    q.imag = vect(2:4);
end