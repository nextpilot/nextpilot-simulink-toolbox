function varargout = import_uorb_message(msg_files, save_files)
% import_uorb_message(msg_define_file, msg_save_file)
%
% msg_files:  uorb��Ϣ�ļ���֧��cellstr��char��string��string array�ȣ��ַ����п�����ͨ���
% save_files: ��������ļ���֧��sldd��xlsx�ļ���ʽ
%
% Examples
%
%   msg = 'msg\commander_state.msg'
%   msg = 'msg\*.msg'
%   msg = 'msg\**\*msg'
%   msg = {'msg\commander_state.msg', 'msg\*.msg', 'msg\**\*msg'}
%
% ���� Simulink.importExternalCTypes ������ת������ C/C++ ������



%% ��������
if isempty(msg_files)
    [filename, pathname] = uigetfile({'*.msg', 'uORB Msg Files (*.msg)'},'uORB Msg Files');
    if isequal(pathname, 0)
        return;
    else
        msg_files = fullfile(pathname, filename);
    end
end

% ��char��stringתΪcell
if ischar(msg_files)
    msg_files={msg_files};
elseif isstring(msg_files)
    msg_files = cellstr(msg_files);
end

%% ��ȡ�ļ�
msg_vars_list.bus ={};
msg_vars_list.enum={};
idx = 0;

for i=1:length(msg_files)
    % fprintf('[%d/%d] %s\n',i,length(msg_files),msg_files{i});
    list = dir(msg_files{i});
    for j = 1:length(list)
        idx = idx + 1;
        file = fullfile(list(j).folder,list(j).name);
        fprintf('[%d]%s\n',idx, file);

        [~,~,exts] = fileparts(file);
        % elem = [name, type, size, desc]
        % enum = [name, type, value, decs]
        if strcmpi(exts, '.h')
            [bus, enum] = read_msg_header(file);
        elseif strcmpi(exts, '.msg')
            [bus, enum] = read_msg_define(file);
        end
        if ~isempty(bus.elem)
            msg_vars_list.bus{end+1}=bus;
        end
        if ~isempty(enum.elem)
            msg_vars_list.enum{end+1}=enum;
        end
    end
end

%% ��������
[~,name,exts] = fileparts(save_files);
if isempty(exts) && strcmpi(name,'base')
    savetobase(save_files, msg_vars_list)
elseif strcmpi(exts, '.sldd')
    savetosldd(save_files, msg_vars_list);
end


%% ����б�
if nargout>0
    varargout{1} = msg_vars_list;
end


function [bus, enum] = read_msg_define(file)
[~,name]=fileparts(file);
name = camel2under(name);
bus.file = file;  bus.name={name};  bus.elem = [];
enum.file = file; enum.name={name}; enum.elem =[];

fid=fopen(file);
while ~feof(fid)
    % �������л���ע����
    tline = strtrim(fgetl(fid));
    if isempty(tline)
        continue
    elseif startsWith(tline, '# TOPICS')
        bus.name = strsplit(strtrim(strrep(tline, '# TOPICS','')));
        continue;
    elseif startsWith(tline ,'#')
        continue;
    end
    % ���ע�ͺͶ���
    tokens = regexpi(tline,'([^#]+)(.*)','tokens','once');
    left = tokens{1};
    rght = tokens{2};
    if contains(left,'=')
        % ö������
        % uint8 AIRSPD_MODE_MEAS = 0	# airspeed is measured airspeed from sensor
        tok = regexpi(left, '(\w+)\s+(\w+)\s*=\s*([-\d]+)','tokens','once');
        enum.elem(end+1).name = tok{2};
        enum.elem(end).type = tok{1};
        enum.elem(end).value = str2num(tok{3});
        enum.elem(end).comment=rght;
    else
        % �ṹ������
        % float32[3] vel_variance	# Variance in body velocity estimate
        tok=regexpi(tline,'(\w+)(\[\d+\])*\s+(\w+)','tokens','once');
        bus.elem(end+1).name = tok{3};
        bus.elem(end).type = tok{1};
        if isempty(tok{2})
            bus.elem(end).dims = 1;
        else
            bus.elem(end).dims=str2num(tok{2});
        end
        bus.elem(end).comment = rght;
    end
end
fclose(fid);


function [elem, enum] = read_msg_header(file)

bus.file = file;  bus.name={name};  bus.elem = [];
enum.file = file; enum.name={name}; enum.elem =[];

% ���ļ�
fid=fopen(file);
fskip(fid, 'struct __EXPORT');
fskip(fid, 3);

% ��ȡ�ṹ��
while ~feof(fid)
    tline = strtrim(fgetl(fid));
    if isempty(tline)
        continue;
    elseif contains(tline, '#ifdef __cplusplus')
        break;
    end
    % uint8_t _padding0[7]; // required for logger
    tokens = regexpi(tline, '(struct )*(.+) ([\d\w_]+)(\[\d+\])*;','tokens','once');
    bus.elem(end+1).name=tokens{3};
    bus.elem(end).type=tokens{2};
    if isempty(tokens{4})
        bus.elem(end).dims = 1;
    else
        bus.elem(end).dims = str2num(tokens{4});
    end
    bus.elem(end).comment='';

end

% ��ȡö��
while ~feof(fid)
    tline = strtrim(fgetl(fid));
    if isempty(tline)
        continue;
    elseif contains(tline, '#endif')
        break;
    end
    % static constexpr uint8_t MAIN_STATE_MANUAL = 0;
    tokens = regexpi(tline, 'static constexpr (.+) ([\d\w_]+) \= ([\-\d])+;','tokens','once');
    enum.elem(end+1).name=tokens{2};
    enum.elem(end).type=tokens{1};
    enum.elem(end).value=tokens{3};
    enum.elem(end).comment='';
end
% �ر��ļ�
fclose(fid);


function savetobase(ws, list)
for i = 1:length(list.bus)
    bus = list.bus{i};
    if isempty(bus)
        continue;
    end

    bobj = Simulink.Bus;
    clear eobj;
    for j=1:length(bus.elem)
        eobj(j)             = Simulink.BusElement;
        eobj(j).Name        = bus.elem(j).name;
        eobj(j).DataType    = getdatatype(bus.elem(j).type);
        eobj(j).Dimensions  = bus.elem(j).dims;
        eobj(j).Description = bus.elem(j).comment;
    end
    bobj.Elements = eobj;

    for k=1:length(bus.name)
        assignin(ws,[bus.name{k},'_s'],bobj);
    end
end

% ����ö������
for i = 1:length(list.enum)
    enum=list.enum{i};
    if isempty(enum)
        continue;
    end
    name = upper(enum.name{1});
    Simulink.defineIntEnumType(name,{enum.elem.name},[enum.elem.value]);
    for j=1:length(enum.elem)
        assignin(ws, enum.elem(j).name, enum.elem(j).value);
    end
end

%%
function savetosldd(sldd, list)
% ��ssld�ļ�
if exist(sldd,'file')
    dobj=Simulink.data.dictionary.open(sldd);
else
    dobj=Simulink.data.dictionary.create(sldd);
end
sobj = getSection(dobj,'Design Data');

% ������������
for i = 1:length(list.bus)
    bus = list.bus{i};
    if isempty(bus)
        continue;
    end

    bobj = Simulink.Bus;
    clear eobj

    for j=1:length(bus.elem)
        eobj(j)=Simulink.BusElement;
        eobj(j).Name = bus.elem(j).name;
        eobj(j).DataType = getdatatype(bus.elem(j).type);
        eobj(j).Dimensions = bus.elem(j).dims;
        eobj(j).Description = bus.elem(j).comment;
    end
    bobj.Elements = eobj;
    
    for k =1:length(bus.name)
        assignin(sobj,[bus.name{k},'_s'],bobj);
    end
end

% ����ö������
for i = 1:length( list.enum)
    enum = list.enum{i};
    if isempty(enum)
        continue;
    end

    % ��ö�����Ϊ����
    p = Simulink.Parameter();
    p.CoderInfo.StorageClass       = 'Custom';
    p.CoderInfo.CustomStorageClass = 'Const';

    name = upper(enum.name{1});
    nobj = Simulink.data.dictionary.EnumTypeDefinition;
    nobj.AddClassNameToEnumNames = true;
    for j=1:length(enum.elem)
        % ����ö����
        appendEnumeral(nobj,enum.elem(j).name,enum.elem(j).value, enum.elem(j).comment);
        % ����Ϊ����
        p.Value=[];
        set(p,{'DataType','Value','Description'},{getdatatype(enum.elem(j).type), enum.elem(j).value, enum.elem(j).comment});
        assignin(sobj, upper(enum.elem(j).name), p);
    end
    removeEnumeral(nobj,1)
    assignin(sobj,name,nobj);
end

% ����sldd�ļ�
saveChanges(dobj);
close(dobj);