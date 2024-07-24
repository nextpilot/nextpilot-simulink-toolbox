function varargout = readparam(param_define_file, param_saved_file, param_csc_type)
% ssld/base/mat文件支持的数据类型dtype有variable, mpt等

if nargin == 0
    [filename, pathname] = uigetfile({'*.c;', 'Param Define Files (*.c)'},'Param Define Files');
    if isequal(pathname, 0)
        return;
    else
        param_define_file = fullfile(pathname, filename);
        param_saved_file = 'base';
        param_csc_type = 'Simulink.Parameter';
    end
elseif nargin == 1
    param_saved_file = 'base';
    param_csc_type = 'Simulink.Parameter';
elseif nargin == 2
    param_csc_type = 'Simulink.Parameter';
end


% param_define_file='E:\repository\pixhawk\src\*_params.c';
if ischar(param_define_file)
    if contains(param_define_file,'*') || contains(param_define_file,'?')
        [~,txt]=dos(['dir /b/s "' param_define_file '"']);
        tmp = textscan(txt,'%s');
        param_define_file = tmp{1};
    else
        param_define_file = {param_define_file};
    end
elseif ~iscellstr(param_define_file)
    error('Param Define file must be a string!');
end


%% 读取文件
param_vars_list = {};
for i=1:length(param_define_file)
    file = param_define_file{i};
    fprintf('[%d/%d] %s\n',i,length(param_define_file),file);
    fid = fopen(file);
    while ~feof(fid)
        tline = strtrim(fgetl(fid));
        if isempty(tline) || ~contains(tline,'PARAM_DEFINE_')
            continue
        end
        tokens = regexpi(tline,'^PARAM_DEFINE_(.+)\(([\w_\d]+)\s*\,\s*([e\-\+\d\.]+)[f]?\)','tokens','once');
        if ~isempty(tokens)
            if strcmpi(tokens{1}, 'int32')
                type = 'int32';
            elseif strcmpi(tokens{1},'float')
                type = 'single';
            else
                type = 'single';
            end
            name = tokens{2};
            value = str2num(tokens{3});
            param_vars_list(end+1,:) = {name,type,value};
        end
    end
    fclose(fid);
end

%% 保存结果
[~,name,exts] = fileparts(param_saved_file);
if isempty(exts) && strcmpi(name, 'base')
    savetowork(param_saved_file, param_vars_list, param_csc_type)
elseif strcmpi(exts, '.sldd')
    savetosldd(param_saved_file, param_vars_list, param_csc_type)
elseif strcmpi(exts, '.xlsx') || strcmpi(exts, '.xls')
    savetoxlsx(param_saved_file, param_vars_list, param_csc_type)
elseif strcmpi(exts, '.txt')
    savetotext(param_saved_file, param_vars_list, param_csc_type)
end

%% 输出列表
if nargout > 0
    varargout{1} = param_vars_list;
end


function savetowork(ws, list, csc)
for i=1:size(list,1)
    name = list{i,1};
    value = createParameter(csc, list{i,2:3});
    assignin(ws,name, value);
end

function savetoxlsx(file, list, csc)
sheet = {'存储类型', '变量名', '取值', '数据类型', '维度大小', '物理单位', '最小取值', '最大取值', '是否复数', '注释描述'};
for i = 1:size(list,1)
    sheet(end+1, :) = {csc, list{i,1}, list{i,2}, list{i,3}, 1, '','','','',''};
end
xlswrite(file,sheet,'struct')


function savetosldd(file, list, csc)
if exist(file, 'file')
    dobj = Simulink.data.dictionary.open(file);
else
    dobj = Simulink.data.dictionary.create(file);
end
sobj = getSection(dobj,'Design Data');
for i = 1:size(list,1)
    name = list{i,1};
    value = createParameter(csc, list{i,2:3});
    assignin(sobj, name, value);
end
saveChanges(dobj);
close(dobj);

function savetotext(file, list, csc)
fid = fopen(file,'w');
for i = 1:size(list,1)
    % workspace.varname[2,3,4] = int8[1,2,3,4,....]
    n = list{i,1}; v=list{i,2};
    fprintf(fid, '%s%s::%s = %s\n', n, shape2string(size(v)), class(v), array2string(v));
end
fclose(fid);



function obj = createParameter(csc, type, value)
if ischar(value)
    value = str2num(value);
end
value = cast(value, type);

if strcmpi(csc, 'auto')
    obj = value;
else
    obj = feval(csc, value);
    obj.DataType = type;
end


function s = shape2string(shp)
for i=length(shp(:)):-1:2
    if shp(i)==1
        shp(i)=[];
    else
        break;
    end
end
s = array2string(shp);

function s = array2string(arr)
s = sprintf('%g,',arr);
s = ['[',s(1:end-1),']'];
