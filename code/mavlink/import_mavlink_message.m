function import_mavlink_message(xml_file, save_file)


if isfile(xml_file)

end



tree =xmlread(xml_file);

mavlink.version=char(tree.getElementsByTagName('version').item(0).getTextContent);
mavlink.dialect=char(tree.getElementsByTagName('dialect').item(0).getTextContent);

% 处理枚举类型
enum_root = tree.getElementsByTagName('enums');
enum_list = enum_root.item(0).getChildNodes;
for i = 0 : enum_list.getLength-1
    enum_node = enum_list.item(i);
    if isempty(enum_node)
        continue
    end
    if ~strcmpi(enum_node.getNodeName,'#text') &&...
            ~strcmpi(enum_node.getNodeName,'#comment')
        k=0;
        enum_name = char(enum_node.getAttribute('name'));
        entry_list = enum_node.getChildNodes;
        mavlink.enumera.(enum_name).desc = '';
        for j = 0 : entry_list.getLength()
            entry = entry_list.item(j);
            if isempty(entry)
                continue
            end
            switch  char(entry.getNodeName)
                case 'entry'
                    k=k+1;
                    name = char(entry.getAttribute('name'));
                    value = char(entry.getAttribute('value'));
                    desc = strtrim(char(entry.getTextContent));
                    if isempty(value)
                        if k==1
                            value = 0;
                        else
                            value = mavlink.enumera.(enum_name).data{k-1,2}+1;
                        end
                    else
                        value = str2double(value);
                    end
                    mavlink.enumera.(enum_name).data(k,:)={name,value,desc};
                case 'description'
                    desc=strtrim(char(entry.getTextContent));
                    mavlink.enumera.(enum_name).desc=desc;
            end
        end
    end
end


% 处理消息类型
msgs_root = tree.getElementsByTagName('messages');
msgs_list = msgs_root.item(0).getChildNodes;
for i = 0 : enum_list.getLength-1
    msgs_node = msgs_list.item(i);
    if isempty(msgs_node)
        continue
    end
    if ~strcmpi(msgs_node.getNodeName,'#text') &&...
            ~strcmpi(msgs_node.getNodeName,'#comment')
        k=0;
        msgs_name = lower(char(msgs_node.getAttribute('name')));
        msgs_id = char(msgs_node.getAttribute('id'));
        field_list = msgs_node.getChildNodes;
        
        mavlink.message.(msgs_name).desc='';
        mavlink.message.(msgs_name).msgid=str2double(msgs_id);
        for j = 0 : field_list.getLength()
            field = field_list.item(j);
            if isempty(field)
                continue
            end
            switch  char(field.getNodeName)
                case 'field'
                    k=k+1;
                    type = char(field.getAttribute('type'));
                    name = char(field.getAttribute('name'));
                    desc = strtrim(char(field.getTextContent));
                    mavlink.message.(msgs_name).field(k,:)={type,name,desc};
                case 'description'
                    desc=strtrim(char(field.getTextContent));
                    mavlink.message.(msgs_name).desc=desc;
            end
        end
    end
end

%%
file='mav_dtype.sldd';
if exist(file,'file')
    dobj=Simulink.data.dictionary.open(file);
else
    dobj=Simulink.data.dictionary.create(file);
end
sobj = getSection(dobj,'Design Data');

% 处理枚举类型
enumera=mavlink.enumera;
field=fieldnames(enumera);
p=Simulink.Parameter();
p.CoderInfo.StorageClass='Custom';
p.CoderInfo.CustomStorageClass='Const';

for i=1:length(field)
    data = enumera.(field{i}).data;
    desc = enumera.(field{i}).desc;
    nobj = Simulink.data.dictionary.EnumTypeDefinition;
    nobj.AddClassNameToEnumNames = true;
    name = upper(upper(field{i}));
    for j = 1:size(data,1)
        try
            appendEnumeral(nobj,strrep(data{j,1},[name,'_'],''),data{j,2},data{j,3})
        catch
            appendEnumeral(nobj,strrep(data{j,1},[name,'_'],'A'),data{j,2},data{j,3})
        end
        set(p,{'Value','Description'},data(j,2:3));
        %assignin(sobj, upper(data{j,1}),p);
    end
    removeEnumeral(nobj,1)
    nobj.Description = desc;
    name = upper(field{i});
    if ~contains(name,'MAV_')
        name = ['MAV_',name];
    end
    assignin(sobj, name,nobj);
end

%% 处理总线类型
bobj_mav = Simulink.Bus;
eobj_mav(9) = Simulink.BusElement;
eobj_mav(1).Name = 'stx'; eobj_mav(1).DataType='uint8';
eobj_mav(2).Name = 'len'; eobj_mav(2).DataType='uint8';
eobj_mav(3).Name = 'seq'; eobj_mav(3).DataType='uint8';
eobj_mav(4).Name = 'sysid'; eobj_mav(4).DataType='uint8';
eobj_mav(5).Name = 'cmpid'; eobj_mav(5).DataType='uint8';
eobj_mav(6).Name = 'msgid'; eobj_mav(6).DataType='uint8';
eobj_mav(7).Name = 'payload'; eobj_mav(7).DataType='Bus: mav_payload';
eobj_mav(8).Name = 'cha'; eobj_mav(8).DataType='uint8';
eobj_mav(9).Name = 'chb'; eobj_mav(9).DataType='uint8';
bobj_mav.Elements = eobj_mav;
assignin(sobj,'mav_frame',bobj_mav);

message=mavlink.message;
field=fieldnames(message);
bobj_pay = Simulink.Bus;
eobj_pay(length(field)) = Simulink.BusElement;
for i = 1:length(field)
    detail=message.(field{i}).field;
    n=size(detail,1);
    
    clear eobj
    bobj = Simulink.Bus;
    bobj.Description=message.(field{i}).desc;
    eobj(n)=Simulink.BusElement;
    for j =1:n
        [kind,dims]=nextpilot.simulink.getdatatype(detail{j,1});
        eobj(j).Name=detail{j,2};
        eobj(j).DataType=kind;
        eobj(j).Description=detail{j,3};
        eobj(j).Dimensions=dims;
    end
    bobj.Elements = eobj;
    assignin(sobj,['mav_',field{i}],bobj);
    
    eobj_pay(i).Name = field{i};  eobj_pay(i).DataType = ['Bus: mav_',field{i}];
end
bobj_pay.Elements=eobj_pay;
assignin(sobj,'mav_payload',bobj_pay);
saveChanges(dobj);
close(dobj);
