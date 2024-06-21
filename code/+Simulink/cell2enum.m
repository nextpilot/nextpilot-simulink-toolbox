function [value, name] = cell2enum(c)

value = {};
name ={};
    
if isempty(c)    
    return;
end
count = length(c);
field = {'StorageType','DefaultValue','AddClassNameToEnumNames','DataScope','HeaderFile','Description'};
for i = 1 : count
    if isempty(c{i}{1})
        continue;
    end
    name{end+1} = c{i}{1};
    value{end+1} = Simulink.data.dictionary.EnumTypeDefinition;
    for j = 1:length(c{i}{8})
        appendEnumeral(value{end}, c{i}{8}{j}{:});
    end
    for j = 1 : length(field)
        value{end}.(field{j}) = c{i}{j+1};
    end
    removeEnumeral(value{end}, 1);
end
