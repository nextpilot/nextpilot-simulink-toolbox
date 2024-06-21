function varargout = read_excel_struct(xlsx,sldd,varargin)


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

list = table2cell(t);

%% 剖析bus名字
head = list(:,1);
parts = cellfun(@(s)strsplit(s,'.'), head, 'UniformOutput', 0);
ndeep = cellfun(@length, parts);

nrow = length(head);
ncol = max(ndeep);

% 初始化cell
head_elm_name(1:nrow,1:ncol) = {''};
head_elm_dims(1:nrow,1:ncol) = {[1 1]};
head_elm_kind(1:nrow,1:ncol) = {false};
head_bus_name(1:nrow,1:ncol) = {''};

for i = 1 : nrow
    k = ndeep(i);
    t = parts{i};
    for j = 1 : k
        token = regexpi(t{j},'(\w+)(\[[\d,\s]+\])*','tokens','once');
        % 变量名
        head_elm_name{i,j} = token{1};
        % 变量维度
        if ~isempty(token{2})
            head_elm_dims{i,j} = eval(token{2});
        end
        % 是否为节点
        if j < k
            head_elm_kind{i,j} = true;
        end
    end
    % 构造bus名字
    for j = 1 : k-1
        if j == 1
            head_bus_name{i,j} = head_elm_name{i,j};
        else
            head_bus_name{i,j} = [head_bus_name{i,j-1},'_',head_elm_name{i,j}];
        end
    end
end


%% 创建总线cell
bus = {};
for ideep = 1 : ncol-1
    bus_name_list = unique(head_bus_name(:,ideep),'stable');
    for jbus = 1 : length(bus_name_list)
        if isempty(bus_name_list{jbus})
            continue
        end
        % 创建bus
        bus{end+1} = {
            bus_name_list{jbus} % Name
            ''         % HeaderFile
            ''         % Description
            'Auto'     % DataScope
            '-1'       % Alignment
            {}
            };
        
        % 创建elem
        flag = strcmpi(head_bus_name(:, ideep), bus_name_list{jbus});
        [elem, eidx] = unique(head_elm_name(flag, ideep+1), 'stable');
        locs = find(flag);
        for kelm = 1 : length(elem)
            index = locs(eidx(kelm));
            if isempty(head_elm_name{index, ideep+1})
                continue
            end
            
            if head_elm_kind{index, ideep+1}  % sub-bus
                bus{end}{6}{end+1} = {
                    head_elm_name{index, ideep+1}           % 'Name'
                    head_elm_dims{index, ideep+1}           % 'Dimensions'
                    ['Bus: ', head_bus_name{index, ideep+1}]   % 'DataType'
                    -1                                  % 'SampleTime'
                    'real'                              % 'Complexity'
                    'Sample'                            % 'SamplingMode'
                    'Fixed'                             % 'DimensionsMode'
                    []                                  % 'Minimum'
                    []                                  % 'Maximum'
                    ''                                  % 'Units'
                    ''                                  % 'Description'
                    };
            else                   % elem
                bus{end}{6}{end+1} = {
                    head_elm_name{index, ideep+1}           % 'Name'
                    eval(list{index, 3})                    % 'Dimensions'
                    list{index, 2}                          % 'DataType'
                    list{index, 7}                          % 'SampleTime'
                    list{index, 8}                          % 'Complexity'
                    strrep(list{index, 10},'based','')      % 'SamplingMode'
                    list{index, 9}                          % 'DimensionsMode'
                    eval(list{index, 5})                    % 'Minimum'
                    eval(list{index, 6})                    % 'Maximum'
                    list{index, 4}                          % 'Units'
                    list{index, 11}                         % 'Description'
                    };
            end
        end
    end
end

%% 将cell转换为总线对象
[value, name] = nextpilot.simulink.cell2bus(bus);

%% 保存到sldd文件
if nargin > 1 && ~isempty(sldd)
    nextpilot.simulink.saveas(sldd, name, value)
end
if nargout == 1
    varargout{1} = value;
elseif nargout == 2
    varargout{1} = name;
    varargout{2} = value;
end