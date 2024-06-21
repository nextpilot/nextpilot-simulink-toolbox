function genexceltest

sys = bdroot;
%% 编译模型
warning('off','Simulink:Engine:ModelAlreadyCompiled')
feval(sys,[],[],[],'compile');
warning('on','Simulink:Engine:ModelAlreadyCompiled')

%%
data{1,1} = '#system';
data{2,1} = sys;

data{end+2,1} = '#description';
data{end+2,1} = '#requirement';
data{end+2,1} = '#configuration';
data{end+2,1} = '#parameter';
data{end+2,1} = '#criteria';
data(end+1:end+4,1:2) = {
    'ABS TOL', 0
    'REL TOL',0
    'LD TOL', 0
    'LG TOL', 0
    };


%% 处理输入接口
data{end+2,1} = '#input';

col = 2;
row = size(data,1);
data{row+1,1} = 'time';
portblk = find_system(sys,'SearchDepth',1,'BlockType','Inport');
for i = 1:size(portblk)
    h         = get_param(portblk{i},'handle');
    temp      = get(h, 'CompiledPortDataTypes');
    datatype  = temp.Outport{1};
    temp      = get(h, 'CompiledPortDimensions');
    dimension = temp.Outport;
    temp      = get(h, 'CompiledPortUnits');
    unit      = temp.Outport{1};
    name      = get(h, 'Name');
    if ismember(datatype, {'double','single','int32','uint32','int16','uint16','int8','uint8'})
        s = zeros(dimension, datatype);
    else
        temp =  get_param(portblk{i},'PortHandles');
        ph = temp.Outport;
        s = Simulink.Bus.createMATLABStruct(ph);
    end
    detail = nextpilot.matlab.data2leaf(s, name);
    for j = 1:size(detail,1)
        data(row+1:row+3,col) = {detail{j,1}, class(detail{j,2}), portblk{i}};
        col = col + 1;
    end
end

%% logging
% find_system()

%% outport
data{end+2,1} = '#output';

col = 2;
row = size(data,1);
data{row+1,1} = 'time';
portblk = find_system(sys,'SearchDepth',1,'BlockType','Outport');
for i = 1:size(portblk)
    h         = get_param(portblk{i},'handle');
    temp      = get(h, 'CompiledPortDataTypes');
    datatype  = temp.Inport{1};
    temp      = get(h, 'CompiledPortDimensions');
    dimension = temp.Inport;
    temp      = get(h, 'CompiledPortUnits');
    unit      = temp.Inport{1};
    name      = get(h, 'Name');
    if ismember(datatype, {'double','single','int32','uint32','int16','uint16','int8','uint8'})
        s = zeros(dimension, datatype);
    else
        temp = get_param(portblk{i},'PortHandles');
        ph = temp.Inport;
        s = Simulink.Bus.createMATLABStruct(ph);
    end
    detail = nextpilot.matlab.data2leaf(s, name);
    for j = 1:size(detail,1)
        data(row+1:row+3,col) = {detail{j,1}, class(detail{j,2}), portblk{i}};
        col = col + 1;
    end
end

%%
%feval(sys,[],[],[],'term')

xlswrite([sys,'.xlsx'],data)

