function aero = read_aero_data(list)
% list = dir('**/C*');

aero = [];

for i = 1 : length(list)
    if list(i).isdir
        continue;
    end
    
    file = fullfile( list(i).folder, list(i).name);
    fprintf('[%d/%d] %s\n', i, length(list), file);
    
    aero(end+1).file = file;
    aero(end).name = list(i).name;
    
    % 打开文件
    fid = fopen(file);
    
    %% Forces
    headers ={
        'pressure_x','pressure_y','pressure_z',...
        'viscous_x','viscous_y','viscous_z',...
        'total_x', 'total_y', 'total_z',...
        'coeff_pressure_x', 'coeff_pressure_y', 'coeff_pressure_z'...
        'coeff_viscous_x','coeff_viscous_y','coeff_viscous_z',...
        'coeff_total_x','coeff_total_y','coeff_total_z'
        };
    rownames = {};
    data = [];
    % 跳过前5行
    for i = 1 : 5
        fgetl(fid);
    end
    while ~feof(fid)
        tline = fgetl(fid);
        if startsWith(tline, '-------------------------')
            tline = fgetl(fid);
        end
        split = regexpi(strtrim(tline), '[\s\(\)]+', 'split');
        rownames{end+1}= split{1};
        data(end+1, :) = cellfun(@str2double, split(2:end-1));
        if startsWith(tline, 'Net')
            break;
        end
    end
    aero(end).data{1} = array2table(data, 'VariableNames', headers, 'RowNames', rownames);
    
    %% Forces - Direction Vector (1 0 0)
    headers = {
        'pressure', 'viscous', 'total', ...
        'coeff_pressure', 'coeff_viscous','coeff_total'
        };
    rownames = {};
    data = [];

    for i = 1 : 4
        fgetl(fid);
    end
    while ~feof(fid)
        tline = fgetl(fid);
        if startsWith(tline, '-------------------------')
            tline = fgetl(fid);
        end
        split = regexpi(strtrim(tline), '[\s\(\)]+', 'split');
        rownames{end+1} = split{1};
        data(end+1, :) = cellfun(@str2double, split(2:end));
        if startsWith(tline, 'Net')
            break;
        end
    end
    aero(end).data{2} = array2table(data, 'VariableNames', headers, 'RowNames', rownames);
    
    %% 关闭文件
    fclose(fid);
end




