function debug(ss)
% ����stateflow�е��øú���

persistent t0 ii jj
if isempty(t0)
    t0 = 0;
    ii = 0;
    jj = 0;
end

t = getSimulationTime();
if t ~= t0
    disp('-----------------------------------');
    ii = ii + 1;
    jj = 0;
end

jj = jj + 1;

fprintf('[%g|%g] %s\n', ii, jj, ss);

t0 = t;