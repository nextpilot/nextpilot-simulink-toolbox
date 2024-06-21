function varargout = read_excel_param(xlsx, sldd, varargin)

%% 输入参数处理
if nargin == 0
    [filename, pathname] = uigetfile({'*.xls;*.xlsx', 'Excel Files (*.xls,*xlsx)'},'Excel Files');
    if isequal(pathname, 0)
        return;
    else
        xlsx = fullfile(pathname, filename);
    end
end

%% 读取excel文件
% 设置sheet属性
% opts = detectImportOptions(file,'Sheet','struct');
opts = matlab.io.spreadsheet.SpreadsheetImportOptions;
opts.Sheet              = 'param';
opts.DataRange          = 'A2';
opts.VariableNamesRange = 'A1';
settings = {
    'CSCType',  'Name'  ,  'Value'     ,  'DataType'  ,  'Dimensions'  ,  'Unit'  ,  'Min'   ,  'Max'   ,  'Complexity'  ,  'Description'   % varname
    'char',  'char'  ,  'char'      ,  'char'      ,  'char'        ,  'char'  ,  'char'  ,  'char'  ,  'char'        ,  'char'          % datatype
    ''    ,  ''      ,  '0'         ,  'double'    ,  '[1 1]'       ,  ''      ,  '[]'    ,  '[]'    ,  'real'        ,  ''              % default
    };
opts.VariableNames               = settings(1,:);
opts.VariableTypes               = settings(2,:);
% 也可以使用setvaropts
[opts.VariableOptions.FillValue] = settings{3,:};

% 读取excel内容写入sldd
t = readtable(xlsx,opts);

% 删除空行和注释行
for i = size(t,1):-1:1
    if isempty(t.CSCType{i}) || t.CSCType{i}(1)=='#'
        t(i,:)=[];
    end
end

%% 创建param对象
name = t.Name;
value = cell(size(t,1),1);
for i = 1:size(t,1)
    value{i} = createParameter(t.CSCType{i}, t(i,2:end), varargin{:});
end


%% 保存到sldd文件
if nargin > 1 && ~isempty(sldd)
    nextpilot.simulink.saveas(sldd, name, value);
end
if nargout == 1
    varargout{1} = value;
elseif nargout == 2
    varargout{1} = value;
    varargout{2} = name;
end


function obj = createParameter(csctype,val,varargin)
obj = feval(csctype);
obj.Value       = eval(val.Value{1});
obj.DataType    = val.DataType{1};
obj.Dimensions  = eval(val.Dimensions{1});
obj.Min         = eval(val.Min{1});
obj.Max         = eval(val.Max{1});
obj.Unit        = val.Unit{1};
obj.Description = val.Description{1};
% obj.Complexity = val.Complexity{1};