function uint2fixdt(sldd)

% 查找所有的变量
hdict  = Simulink.data.dictionary.open(sldd);
hsect  = getSection(hdict, 'Design Data');
hentry = find(hsect);

% 将所有uint64数据类型修改为fixdt(0,64,0)
k = 1;
for i = 1:length(hentry)
    value = getValue(hentry(i));    
    if isa(value, 'Simulink.Bus')
        for j = 1:length(value.Elements)
            if strcmpi(value.Elements(j).DataType, 'uint64')
                fprintf('[%d] %s\n',k,hentry(i).Name);k=k+1;
                value.Elements(j).DataType = 'fixdt(0,64,0)';
            end
        end
        setValue(hentry(i), value);
    elseif ~isnumeric(value)
        try
            if strcmpi(value.DataType, 'uint64')
                fprintf('[%d] %s\n',k,hentry(i).Name);k=k+1;
                value.DataType = 'fixdt(0,64,0)';
                setValue(hentry(i), value);
            end
        end
    end
end

% 保存数据字典
saveChanges(hdict)
close(hdict);