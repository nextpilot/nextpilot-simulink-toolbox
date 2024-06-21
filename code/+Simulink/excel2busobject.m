function excel2busobject(xlsx,sldd,varargin)

%% �����������
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

%% ��ȡexcel�ļ�
% ����sheet����
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
% Ҳ����ʹ��setvaropts
[opts.VariableOptions.FillValue] = settings{3,:};

% ��ȡexcel����д��sldd
t = readtable(xlsx,opts);

% ɾ�����к�ע����
for i = size(t,1):-1:1
    if isempty(t.Name{i}) || t.Name{i}(1)=='#'
        t(i,:)=[];
    end
end

% �����ṹ��
for i=1:size(t,1)
    cmd = ['s.', t.Name{i}, '= t(i,:);'];
    eval(cmd);
end

%% ���ṹ��תΪbus����
field= fieldnames(s);
for i = 1:length(field)
    nextpilot.simulink.struct2busobject(s.(field{i}), sldd, field{i});
end