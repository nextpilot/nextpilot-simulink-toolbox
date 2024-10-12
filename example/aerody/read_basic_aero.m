function [force, moment] = read_basic_aero(cwd)
% cwd = fileparts([mfilename('fullpath'), '.m']);

%% 力系数
list = dir(fullfile(cwd, 'Cd*'));
meta = read_aero_data(list);
force = [];
for i = 1 : length(meta)
    alpha_beta = sscanf(meta(i).name, 'Cd_a%fb%f')';
    force(end+1,:) = [alpha_beta, meta(i).data{1}{end, end - 2 : end}];
end
force = sortrows(force, [1, 2]);
header = {'alpha', 'beta', 'cx', 'cy', 'cz'};
force = array2table(force,'VariableNames', header);


%% 力矩系数
list = dir(fullfile(cwd, 'Cm*'));
meta = read_aero_data(list);
moment = [];
for i = 1 : length(meta)
    alpha_beta = sscanf(meta(i).name, 'Cm_a%fb%f')';
    moment(end+1,:) = [alpha_beta meta(i).data{1}{end, end - 2 : end}];
end
moment = sortrows(moment, [1, 2]);
header = {'alpha', 'beta', 'cll', 'cm', 'cn'};
moment = array2table(moment,'VariableNames', header);


