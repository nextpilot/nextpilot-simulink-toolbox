function varargout = read_excel_enum(xlsx,sldd,varargin)

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
opts = matlab.io.spreadsheet.SpreadsheetImportOptions;
opts.Sheet              = 'enum';
opts.DataRange          = 'A2';
opts.VariableNamesRange = 'A1';
% opts.MissingRule = 'omitrow'
settings = {
    'Name'  ,  'Value'  ,  'Description'   % varname
    'char'  ,  'double' ,  'char'          % datatype
    ''      ,   -1      ,    ''            % default
    };
opts.VariableNames               = settings(1,:);
opts.VariableTypes               = settings(2,:);
% Ҳ����ʹ��setvaropts
[opts.VariableOptions.FillValue] = settings{3,:};

t = readtable(xlsx, opts);

% ɾ�����к�ע����
for i = size(t,1):-1:1
    if isempty(t.Name{i}) || t.Name{i}(1)=='#'
        t(i,:)=[];
    end
end

% �����ṹ��
% for i=1:size(t,1)
%     cmd = ['s.', t.Name{i}, '= t(i,:);'];
%     eval(cmd);
% end

%% ����ö��cell
temp = cellfun(@(s)strsplit(s,'.'), t.Name,'UniformOutput', 0);
for i = 1:length(temp)
    if length(temp{i}) == 1
        temp{i} = {'', temp{i}{1}};
    end
end
temp = cat(1, temp{:});
group = unique(temp(:,1));
names = temp(:,1);

c = table2cell(t);
c(:,1) = temp(:,2);

enum = cell(length(group),1);
for i = 1 : length(group)
    flag = strcmpi(group{i}, names);
    count = sum(flag);
    elem = mat2cell(c(flag, :), ones(count,1), 3);
    for j = 1 : count
        if elem{j}{2} == -1
            if j == 1
                elem{j}{2} = 0;
            else
                elem{j}{2} = elem{j-1}{2}+1;
            end
        end
    end
    enum{i} = {
        group{i} % name
        'Native Integer' % StorageType
        elem{1}{1}        % DefaultValue
        true     % AddClassNameToEnumNames
        'Auto'   % DataScope
        ''       % HeaderFile
        ''       % Description
        elem
        };
end

%% ��cellת��Ϊö�ٶ���
[value, name] = nextpilot.simulink.cell2enum(enum);
% ͬʱ��ö������ת��Ϊdefine
for i = 1:length(enum)*0
    dtype = nextpilot.simulink.get_best_inttype(enum{i}{8}{1}{2},enum{i}{8}{end}{2});
    for j = 1 : length(enum{i}{8})
        if isempty(enum{i}{1})
            name{end+1} = upper(enum{i}{8}{j}{1});
        else
            name{end+1} = upper([enum{i}{1}, '_', enum{i}{8}{j}{1}]);
        end
        p = Simulink.Parameter(enum{i}{8}{j}{2});
        p.DataType = dtype;
        p.CoderInfo.StorageClass = 'Custom';
        p.CoderInfo.CustomStorageClass = 'Define';
        value{end+1} = p;
    end
end

%% ���浽sldd�ļ�
if nargin > 1 && ~isempty(sldd)
    nextpilot.simulink.saveas(sldd, name, value)
end

if nargout == 1
    varargout{1} = value;
elseif nargout == 2
    varargout{1} = name;
    varargout{2} = value;
end
