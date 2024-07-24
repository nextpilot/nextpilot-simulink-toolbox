function varargout = import_param_message(varargin)
% ssld/base/mat文件支持的数据类型dtype有variable, mpt等
% import_param_from_json(json_file, save_file='base', csc_type='Simulink.Paramter')
% 
% 从json文件中导入param，并保存到save_file文件，save_file可以是'base'或实际的'sldd'文件
%
% Examples
%
%     import_param_from_json('parameters.json', 'base', 'auto')
%     import_param_from_json('parameters.json', 'param.sldd', 'Simulink.Parameter')
%

%% 参数处理
args = inputParser;
addOptional(args, 'param_json_file','',@isstring);
addOptional(args, 'param_save_file','base',@isstring);
addOptional(args, 'param_csc_type','Simulink.Parameter', @isstring);
parse(args, varargin{:})

param_json_file = args.Results.param_json_file;
if isempty(param_json_file)
    [filename, pathname] = uigetfile({'*.json', 'Param json Files (*.json)'},'uORB Msg Files');
    if isequal(pathname, 0)
        return;
    else
        param_json_file = fullfile(pathname, filename);
    end
end

%% 读取文件
param_vars_list = jsondecode(fileread(param_json_file));

%% 保存结果
param_save_file = args.Results.param_save_file;
param_csc_type = args.Results.param_csc_type;
[~,name,exts] = fileparts(param_save_file);
if isempty(exts) && strcmpi(name, 'base')
    savetowork(param_save_file, param_vars_list, param_csc_type)
elseif strcmpi(exts, '.sldd')
    savetosldd(param_save_file, param_vars_list, param_csc_type)
% elseif strcmpi(exts, '.xlsx') || strcmpi(exts, '.xls')
%     savetoxlsx(param_save_file, param_vars_list, param_csc_type)
% elseif strcmpi(exts, '.txt')
%     savetotext(param_save_file, param_vars_list, param_csc_type)
end

%% 输出列表
if nargout > 0
    varargout{1} = param_vars_list;
end


function savetowork(ws, list, csc)
for i = 1:length(list.parameters)
    meta = list.parameters{i};
    value = createParameter(csc, meta);
    assignin(ws, genvarname(meta.name), value);
end


function savetosldd(file, list, csc)
if exist(file, 'file')
    dobj = Simulink.data.dictionary.open(file);
else
    dobj = Simulink.data.dictionary.create(file);
end
sobj = getSection(dobj,'Design Data');

for i = 1:length(list.parameters)
    meta = list.parameters{i};
    value = createParameter(csc, meta);
    assignin(sobj, name, value);
end

saveChanges(dobj);
close(dobj);


function obj = createParameter(csc, meta)
type = getdatatype(meta.type);
% if strcmpi(type ,'int32')
%     type='uint32';
% end
value = cast(meta.default, type);

if strcmpi(csc, 'auto')
    obj = value;
else
    obj = feval(csc, value);
    obj.DataType = type;
    if isfield(meta, 'min')
        obj.Min = meta.min;
    end
    if isfield(meta,'max')
        obj.Max = meta.max;
    end
    if isfield(meta, 'unit')
        obj.Unit = meta.unit;
    end
    if isfield(meta, 'longDesc')
        obj.Description = meta.longDesc;
    end
end
