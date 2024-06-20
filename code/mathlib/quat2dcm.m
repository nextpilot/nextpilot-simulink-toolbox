function d = quat2dcm(varargin)
% d=quat2dcm([q0 q1 q2 q3])
% d=quat2dcm(q0,[q1 q2 q3])
% d=quat2dcm(q0,q1,q2,q3)


import nextpilot.matlab.*
import nextpilot.math.*
q = cell2vector(varargin);
if isnumeric(q)
    q = normalize(q);
end

q0 = q(1);
q1 = q(2);
q2 = q(3);
q3 = q(4);

qv = [q1; q2; q3];
qx = [; ...
    q0, q3, -q2; ...
    -q3, q0, q1; ...
    q2, -q1, q0; ...
    ];
d = qv * qv' + qx^2;
