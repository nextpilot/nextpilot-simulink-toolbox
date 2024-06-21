function excel2busobject(xlsx,sldd,varargin)

%% 输入参数处理
if nargin == 0
    [filename, pathname] = uigetfile({'*.xls;*.xlsx', 'Excel Files (*.xls,*xlsx)'},'Excel Files');
    if isequal(pathname, 0)
        return;
    else
        xlsx = fullfile(pathname, filename);
        [pathname,filename]=fileparts(xlsx);
        sldd = fullfile(pathname, [filename,'.sldd']);
    end    
elseif nargin == 1
    [pathname,filename]=fileparts(xlsx);
    sldd = fullfile(pathname, [filename,'.sldd']);
end

%% 读取excel文件
% 设置sheet属性
% opts = detectImportOptions(file,'Sheet','struct');
opts = matlab.io.spreadsheet.SpreadsheetImportOptions;
opts.Sheet              = 'struct';
opts.DataRange          = 'A2';
opts.VariableNamesRange = 'A1';
% opts.MissingRule = 'omitrow'
settings = {
    'Name'  ,  'DataType'  ,  'Dimensions'  ,  'Unit'  ,  'Min'   ,  'Max'   ,  'SampleTime'  ,  'Complexity'  ,  'DimensionsMode'  ,  'SamplingMode'  ,  'Description'   % varname
    'char'  ,  'char'      ,  'char'        ,  'char'  ,  'char'  ,  'char'  ,  'double'      ,  'char'        ,  'char'            ,  'char'          ,  'char'          % datatype
    ''      ,  'double'    ,  '1'           ,  ''      ,  '[]'    ,  '[]'    ,  -1            ,  'real'        ,  'Fixed'           ,  'Sample based'  ,  ''              % default
    };
opts.VariableNames               = settings(1,:);
opts.VariableTypes               = settings(2,:);
% 也可以使用setvaropts
[opts.VariableOptions.FillValue] = settings{3,:};

% 读取excel内容写入sldd
t = readtable(xlsx,opts);

% 删除空行和注释行
for i = size(t,1):-1:1
    if isempty(t.Name{i}) || t.Name{i}(1)=='#'
        t(i,:)=[];
    end
end

% 创建结构体
for i=1:size(t,1)
    cmd = ['s.', t.Name{i}, '= t(i,:);'];
    eval(cmd);
end

%% 将结构体转为bus对象
field= fieldnames(s);
for i = 1:length(field)
    nextpilot.simulink.struct2busobject(s.(field{i}), sldd, field{i});
end