function disp(q)
q0 = q.real;
qv = q.imag;
qs = {'i', 'j', 'k'};
if ~isa(q0, 'sym')
    fprintf('   %g', q0);
else
    fprintf('   (%s)', char(q0));
end
if ~isa(q0, 'sym') && ~isa(qv, 'sym')
    for i = 1:3
        if qv(i) < 0
            fprintf(' - %g%s', abs(qv(i)), qs{i});
        else
            fprintf(' + %g%s', qv(i), qs{i});
        end
    end
else
    for i = 1:3
        fprintf(' + (%s)*%s', char(qv(i)), qs{i});
    end
end
fprintf('\n');
