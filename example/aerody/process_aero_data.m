clc
clear

cwd = fileparts([mfilename('fullpath'),'.m']);

%% 基础构型
[force, moment] = read_basic_aero(fullfile(cwd, 'basic'));
% 力
temp = sortrows(force(1:end-1, :), [2, 1]);
alpha = unique(temp.alpha);
beta = unique(temp.beta);
field = {'cx', 'cy', 'cz'};
for i = 1 : 3
    aero.basic.(field{i}).alpha = alpha;
    aero.basic.(field{i}).beta = beta;
    aero.basic.(field{i}).coeff =  reshape(temp.(field{i}), length(alpha), length(beta));
end

% 力矩
temp = sortrows(moment(1:end-1, :), [2, 1]);
alpha = unique(temp.alpha);
beta = unique(temp.beta);
field = {'cll', 'cm', 'cn'};
for i = 1 : 3
    aero.basic.(field{i}).alpha = alpha;
    aero.basic.(field{i}).beta = beta;
    aero.basic.(field{i}).coeff =  reshape(temp.(field{i}), length(alpha), length(beta));
end

%% 舵面气动
folder = {'left-aileron', 'right-aileron', 'left-rudder', 'right-rudder'};
for i = 1 : length(folder)
    config = strrep(folder{i},'-','_');
    [force, moment] = read_delta_aero(fullfile(cwd, folder{i}));
    
    % 力
    temp = sortrows(force, [3, 2, 1]);
    alpha = unique(temp.alpha);
    beta = unique(temp.beta);
    delta = unique(temp.delta);
    field = {'cx', 'cy', 'cz'};
    
    for j = 1 : 3
        % 基础构型系数
        coeff_basic = interpn(aero.basic.(field{j}).alpha, aero.basic.(field{j}).beta, aero.basic.(field{j}).coeff, alpha, beta');
        % 当前构型
        aero.(config).(field{j}).alpha = alpha;
        aero.(config).(field{j}).beta = beta;
        aero.(config).(field{j}).delta = delta;
        aero.(config).(field{j}).coeff =  reshape(temp.(field{j}), length(alpha), length(beta), length(delta));
        % 减去基本构型
        for k = 1 : length(delta)
            aero.(config).(field{j}).coeff(:,:,k) = aero.(config).(field{j}).coeff(:,:,k) - coeff_basic;
        end
    end
    
    % 力矩
    temp = sortrows(moment, [3, 2, 1]);
    alpha = unique(temp.alpha);
    beta = unique(temp.beta);
    delta = unique(temp.delta);
    field = {'cll', 'cm', 'cn'};
    for j = 1 : 3
        % 基础构型系数
        coeff_basic = interpn(aero.basic.(field{j}).alpha, aero.basic.(field{j}).beta, aero.basic.(field{j}).coeff, alpha, beta');
        % 当前构型
        aero.(config).(field{j}).alpha = alpha;
        aero.(config).(field{j}).beta = beta;
        aero.(config).(field{j}).delta = delta;
        aero.(config).(field{j}).coeff =  reshape(temp.(field{j}), length(alpha), length(beta), length(delta));
        % 减去基本构型
        for k = 1 : length(delta)
            aero.(config).(field{j}).coeff(:,:,k) = aero.(config).(field{j}).coeff(:,:,k) - coeff_basic;
        end
    end
end

%% 起落架
[force, moment] = read_basic_aero(fullfile(cwd, 'landgear'));
config = 'landgear';
% 力
temp = sortrows(force, [2 1]);
alpha = unique(temp.alpha);
beta = unique(temp.beta);
field = {'cx', 'cy', 'cz'};
for j = 1 : 3
    % 基础构型系数
    coeff_basic = interpn(aero.basic.(field{j}).alpha, aero.basic.(field{j}).beta, aero.basic.(field{j}).coeff, alpha, beta');
    % 当前构型
    aero.(config).(field{j}).alpha = alpha;
    aero.(config).(field{j}).beta = beta;
    aero.(config).(field{j}).coeff =  reshape(temp.(field{j}), length(alpha), length(beta));
    % 减去基本构型
    aero.(config).(field{j}).coeff = aero.(config).(field{j}).coeff - coeff_basic;
end

% 力矩
temp = sortrows(moment, [2, 1]);
alpha = unique(temp.alpha);
beta = unique(temp.beta);
field = {'cll', 'cm', 'cn'};
for j = 1 : 3
    % 基础构型系数
    coeff_basic = interpn(aero.basic.(field{j}).alpha, aero.basic.(field{j}).beta, aero.basic.(field{j}).coeff, alpha, beta');
    % 当前构型
    aero.(config).(field{j}).alpha = alpha;
    aero.(config).(field{j}).beta = beta;
    aero.(config).(field{j}).coeff =  reshape(temp.(field{j}), length(alpha), length(beta));
    % 减去基本构型
    aero.(config).(field{j}).coeff = aero.(config).(field{j}).coeff - coeff_basic;
end