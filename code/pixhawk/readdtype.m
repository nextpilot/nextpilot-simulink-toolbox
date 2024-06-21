function varargout = readdtype(msg_define_file, msg_saved_file)
% readdtype(msg_file, save_file)
% msg_file，px4的uorb消息文件，可以使.msg也可以是.h
% save_file，结果保存文件，支持sldd，xlsx文件格式
%
% 采用Simulink.importExternalCTypes函数能转换常规C/C++数据类
% msgfile='E:\repository\pixhawk\msg\commander_state.msg';
% trgfile='px4_uorb_msg.m';


if nargin == 0
    [filename, pathname] = uigetfile({'*.h;*.msg', 'Msg Define Files (*.h;*.msg)'},'Msg Define Files');
    if isequal(pathname, 0)
        return;
    else
        msg_define_file = fullfile(pathname, filename);
        msg_saved_file  = 'base';
    end
elseif nargin == 1
    msg_saved_file = 'base';
end


if ischar(msg_define_file)
    if contains(msg_define_file,'*') || contains(msg_define_file,'?')
        [~,txt]=dos(['dir /b/s "' msg_define_file '"']);
        tmp = textscan(txt,'%s');
        msg_define_file = tmp{1};
    else
        msg_define_file = {msg_define_file};
    end
elseif ~iscellstr(msg_define_file)
    error('mavlink:readdtype:inputmuststring','MSG File must be a string!')
end


%% 读写文件
msg_vars_list = {};
for i=1:length(msg_define_file)
    file = msg_define_file{i};
    fprintf('[%d/%d] %s\n',i,length(msg_define_file),file);
    
    [~,name,exts] = fileparts(file);
    % elem = [name, type, size, desc]
    % enum = [name, type, value, decs]
    if strcmpi(exts, '.h')
        [elem, enum] = read_msg_header(file);
    elseif strcmpi(exts, '.msg')
        [elem, enum] = read_msg_define(file);
    end
    msg_vars_list(end+1, :) = {name, elem, enum};
end

%% 保存数据
[~,name,exts] = fileparts(msg_saved_file);
if isempty(exts) && strcmpi(name,'base')
    savetobase(msg_saved_file, msg_vars_list)
elseif strcmpi(exts, '.sldd')
    savetosldd(msg_saved_file, msg_vars_list);
elseif strcmpi(exts, '.xls') || strcmpi(exts, '.xlsx')
    savetoxlsx(msg_saved_file, msg_vars_list)
end


%% 输出列表
if nargout>0
    varargout{1} = msg_vars_list;
end

%%
function [elem, enum] = read_msg_define(file)
elem = {'timestamp','fixdt(0,64,0)',1,''};
enum = {};
fid=fopen(file);
while ~feof(fid)
    tline = strtrim(fgetl(fid));
    if isempty(tline) || tline(1)=='#'
        continue
    end
    tokens = regexpi(tline,'([^#]+)(.*)','tokens','once');
    left = tokens{1};
    rght = tokens{2};
    if contains(left,'=')
        % 枚举类型
        % uint8 AIRSPD_MODE_MEAS = 0	# airspeed is measured airspeed from sensor
        tok = regexpi(left, '(\w+)\s+(\w+)\s*=\s*([-\d]+)','tokens','once');
        enum(end+1,:)={tok{2},tok{1},str2num(tok{3}),rght};
    else
        % 结构体类型
        % float32[3] vel_variance	# Variance in body velocity estimate
        tok=regexpi(tline,'(\w+)(\[\d+\])*\s+(\w+)','tokens','once');
        if isempty(tok{2})
            elem(end+1,:)={tok{3},tok{1},1,rght};
        else
            elem(end+1,:)={tok{3},tok{1},str2num(tok{2}),rght};
        end
    end
end
fclose(fid);

%%
function [elem, enum] = read_msg_header(file)
fid=fopen(file);
nextpilot.matlab.fskip(fid, 'struct __EXPORT');
nextpilot.matlab.fskip(fid, 3);

% 读取结构体
elem = {};
while ~feof(fid)
    tline = strtrim(fgetl(fid));
    if isempty(tline)
        continue;
    elseif contains(tline, '#ifdef __cplusplus')
        break;
    end
    % uint8_t _padding0[7]; // required for logger
    tokens = regexpi(tline, '(struct )*(.+) ([\d\w_]+)(\[\d+\])*;','tokens','once');
    if isempty(tokens{4})
        elem(end+1,:) = {tokens{3},tokens{2},1, ''};
    else
        elem(end+1,:) = {tokens{3},tokens{2},str2num(tokens{4}), ''};
    end
end

% 读取枚举
enum = {};
while ~feof(fid)
    tline = strtrim(fgetl(fid));
    if isempty(tline)
        continue;
    elseif contains(tline, '#endif')
        break;
    end
    % static constexpr uint8_t MAIN_STATE_MANUAL = 0;
    tokens = regexpi(tline, 'static constexpr (.+) ([\d\w_]+) \= ([\-\d])+;','tokens','once');
    enum(end+1,:) = {tokens{2}, tokens{1}, str2num(tokens{3}), ''};
end
fclose(fid);

%%
function savetobase(ws, list)

for j = 1:size(list,1)
    name = list{j,1}; elem = list{j,2}; enum = list{j,3};
    if ~isempty(elem)
        bobj = Simulink.Bus;
        %elem = [{'timestamp','fixdt(0,64,0)',1,''};elem];
        clear eobj;
        for i=1:size(elem,1)
            eobj(i)             = Simulink.BusElement;
            eobj(i).Name        = elem{i,1};
            eobj(i).DataType    = nextpilot.simulink.getdatatype(elem{i,2});
            eobj(i).Dimensions  = elem{i,3};
            eobj(i).Description = elem{i,4};
        end
        bobj.Elements = eobj;
        assignin(ws,['px4_',name],bobj);
    end
    % 定义枚举类型
    name = upper(name);
    if ~isempty(enum)
        Simulink.defineIntEnumType(name,strrep(enum(:,1),[name,'_'], ''),[enum{:,3}]');
    end
end

%%
function savetosldd(sldd, list)
% 打开ssld文件
if exist(sldd,'file')
    dobj=Simulink.data.dictionary.open(sldd);
else
    dobj=Simulink.data.dictionary.create(sldd);
end
sobj = getSection(dobj,'Design Data');

for j = 1:size(list,1)
    clear eobj
    name = list{j, 1};
    % 定义总线类型
    elem = list{j, 2};
    if ~isempty(elem)
        bobj = Simulink.Bus;
        for i=1:size(elem,1)
            eobj(i)=Simulink.BusElement;
            eobj(i).Name = elem{i,1};
            eobj(i).DataType = nextpilot.simulink.getdatatype(elem{i,2});
            eobj(i).Dimensions = elem{i,3};
            eobj(i).Description = elem{i,4};
        end
        bobj.Elements = eobj;
        assignin(sobj,['px4_',name],bobj);
    end
    
    % 定义枚举类型
    enum = list{j, 3};
    p = Simulink.Parameter();
    p.CoderInfo.StorageClass       = 'Custom';
    p.CoderInfo.CustomStorageClass = 'Const';
    name = upper(name);
    if ~isempty(enum)
        nobj = Simulink.data.dictionary.EnumTypeDefinition;
        nobj.AddClassNameToEnumNames = true;
        for i=1:size(enum,1)
            appendEnumeral(nobj,strrep(enum{i,1}, [name,'_'], ''),enum{i,3},enum{i,4})
            %
            enum{i,2}=nextpilot.simulink.getdatatype(enum{i,2});
            p.Value=[];
            set(p,{'DataType','Value','Description'},enum(i,2:4));
            %assignin(sobj, ['PX4_',upper(enum{i,1})],p);
        end
        removeEnumeral(nobj,1)
        assignin(sobj,['PX4_',name],nobj);
    end
end
saveChanges(dobj);
close(dobj);

%%
function savetoxlsx(file, list)
s = {'变量名', '数据类型', '维度大小', '物理单位', '最大取值', '最小取值', '采样时间', '是否复数', '维度模式', '采样时间', '注释说明'};
e = {'变量名', '取值', '描述'};
for i = 1:size(list,1)
    name = list{i,1};
    elem = list{i,2};
    enum = list{i,3};
    for j = 1:size(elem)
        % name, type, size, decs
        s(end+1, [1,2,3,11]) = {[name,'.',elem{j,1}], nextpilot.simulink.getdatatype(elem{j,2}), str2num(elem{j,3}), elem{j,4}};
    end
    for j = 1:size(enum)
        % name, type, size, decs
        e(end+1, :) = {upper([name,'.',enum{j,1}]), enum{j,3}, enum{j,4}};
    end
end
xlswrite(file, s, 'struct');
if ~isempty(e)
    xlswrite(file, e, 'enum');
end


