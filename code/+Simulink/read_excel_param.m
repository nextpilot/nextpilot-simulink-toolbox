function varargout = read_excel_param(xlsx, sldd, varargin)

%% �����������
if nargin == 0
    [filename, pathname] = uigetfile({'*.xls;*.xlsx', 'Excel Files (*.xls,*xlsx)'},'Excel Files');
    if isequal(pathname, 0)
        return;
    else
        xlsx = fullfile(pathname, filename);
    end
end

%% ��ȡexcel�ļ�
% ����sheet����
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
% Ҳ����ʹ��setvaropts
[opts.VariableOptions.FillValue] = settings{3,:};

% ��ȡexcel����д��sldd
t = readtable(xlsx,opts);

% ɾ�����к�ע����
for i = size(t,1):-1:1
    if isempty(t.CSCType{i}) || t.CSCType{i}(1)=='#'
        t(i,:)=[];
    end
end

%% ����param����
name = t.Name;
value = cell(size(t,1),1);
for i = 1:size(t,1)
    value{i} = createParameter(t.CSCType{i}, t(i,2:end), varargin{:});
end


%% ���浽sldd�ļ�
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