function saveas(file, name, value)

if strcmpi(file, 'base') || strcmpi(file, 'caller')
    for i = 1 : length(name)
        assignin(file, name{i}, value{i});
    end
elseif contains(file, '.mat')
    for i = 1 : length(name)
        eval(sprintf('%s = value{%d};', name{i},i));
        save(file, name{i}, '-append');
    end
elseif contains(file, '.sldd')
    if exist(file,'file')
        dobj=Simulink.data.dictionary.open(file);
    else
        dobj=Simulink.data.dictionary.create(file);
    end
    sobj = getSection(dobj,'Design Data');
    for i = 1 : length(name)
        assignin(sobj, name{i}, value{i});
    end
    saveChanges(dobj);
    close(dobj);
end