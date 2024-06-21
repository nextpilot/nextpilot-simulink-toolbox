function read_excel_config(xlsx)

%%
if nargin == 0
    [filename, pathname] = uigetfile({'*.xls;*.xlsx', 'Excel Files (*.xls,*xlsx)'},'Excel Files');
    if isequal(pathname, 0)
        return;
    else
        xlsx = fullfile(pathname, filename);
    end    
end
[pathname,filename]=fileparts(xlsx);

%%
import nextpilot.simulink.*
sldd = fullfile(pathname, [filename,'_param.sldd']);
[value, name] = read_excel_param(xlsx);
save2sldd(sldd, name, value);

sldd = fullfile(pathname, [filename,'_dtype.sldd']);
[value, name] = read_excel_bus(xlsx);
save2sldd(sldd, name, value);

sldd = fullfile(pathname, [filename,'_dtype.sldd']);
[value, name] = read_excel_enum(xlsx);
save2sldd(sldd, name, value);

