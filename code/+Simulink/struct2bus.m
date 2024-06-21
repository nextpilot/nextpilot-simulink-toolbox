function [buses,names] = struct2bus(value,varargin)
% struct2busobject(value, file, group, buses, names)

%% 输入参数处理
p = inputParser;
p.addRequired('value');
p.addOptional('file', 'none', @ischar);
p.addOptional('group', 'bus1', @ischar);
p.addOptional('buses', Simulink.Bus.empty);
p.addOptional('names', {}, @iscell);
p.parse(value,varargin{:});

file  = p.Results.file;
group = p.Results.group;
buses = p.Results.buses;
names = p.Results.names;

%% 创建bus对象
if isstruct(value)    
    % 创建父bus
    buses(end+1) = Simulink.Bus;
    names{end+1} = group;    
    field        = fieldnames(value);
    for i = 1:length(field)
        data = value.(field{i});
        if isstruct(data)
            buses(end).Elements(i) = createElement(data,field{i},group);
        else
            buses(end).Elements(i) = createElement(data,field{i});
        end
    end    
    % 创建子bus
    for i = 1:length(field)        
        data = value.(field{i});
        if isstruct(data)
            group_t        = [group, '_', field{i}];
            [buses, names] = nextpilot.simulink.struct2busobject(data,'',group_t, buses, names);
        end
    end
else
    
end

%% 保存bus对象
[~,~,ext] = fileparts(file);
if strcmpi(file,'base') ||  strcmpi(file,'caller')
    for i = 1:length(names)
        assignin(file,names{i},buses(i))
    end
elseif strcmpi(ext, '.mat')    
    for i = 1:length(names)
        eval('names{i}=buses(i);');
        save(file,names{i},'-append');
    end
elseif strcmpi(ext, '.sldd')
    if exist(file, 'file')
        dobj=Simulink.data.dictionary.open(file);
    else
        dobj=Simulink.data.dictionary.create(file);
    end
    sobj = getSection(dobj,'Design Data');
    for i = 1:length(names)
        assignin(sobj, names{i}, buses(i));
    end
    saveChanges(dobj);
    close(dobj);   
end

function eobj = createElement(value,name,group)
eobj = Simulink.BusElement;
if isstruct(value)
    eobj.Name              = name;
    eobj.DataType          = ['Bus: ', group, '_', name];
elseif iscell(value)
    eobj.Name              = name;
    eobj.DataType          = value{2};
    eobj.Dimensions        = value{3};
    eobj.Unit              = value{4};
    eobj.Min               = value{5};
    eobj.Max               = value{6};    
    eobj.SampleTime        = value{7};
    eobj.Complexity        = value{8};
    eobj.DimensionsMode    = value{9};
    eobj.SamplingMode      = value{10};
    eobj.Description       = value{11};
elseif istable(value)
    eobj.Name              = name;
    eobj.DataType          = value.DataType{1};
    eobj.Dimensions        = eval(value.Dimensions{1});
    eobj.Unit              = value.Unit{1};
    eobj.Min               = eval(value.Min{1});
    eobj.Max               = eval(value.Max{1});    
    eobj.SampleTime        = value.SampleTime;
    eobj.Complexity        = value.Complexity{1};
    eobj.DimensionsMode    = value.DimensionsMode{1};
    eobj.SamplingMode      = value.SamplingMode{1};
    eobj.Description       = value.Description{1};
elseif isnumeric(value)
    eobj                   = Simulink.BusElement;
    eobj.Name              = name;
    eobj.DataType          = class(value);
    eobj.Dimensions        = size(value);
else
    disp('无法识别的数据类型');
end


