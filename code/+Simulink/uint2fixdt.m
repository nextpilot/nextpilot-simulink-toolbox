function uint2fixdt(sldd)

% �������еı���
hdict  = Simulink.data.dictionary.open(sldd);
hsect  = getSection(hdict, 'Design Data');
hentry = find(hsect);

% ������uint64���������޸�Ϊfixdt(0,64,0)
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

% ���������ֵ�
saveChanges(hdict)
close(hdict);