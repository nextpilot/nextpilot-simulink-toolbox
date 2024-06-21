function ds = read_excel_testcase(xlsx)

%% 输入参数处理
if nargin == 0
    [filename, pathname] = uigetfile({'*.xls;*.xlsx', 'Excel Files (*.xls,*xlsx)'},'Excel Files');
    if isequal(pathname, 0)
        return;
    else
        xlsx = fullfile(pathname, filename);
    end 
end

%% 读取excel文件
[data,name]=xlsread(xlsx);
for i = 2:size(name,2)
    % (k)，  替换为(:,k)
    % (i,j)，替换为(i,j,:)
    temp = regexprep(name{i}, {'\((\d+)\)$','\(([\d, ]+)\)$'}, {'(:,$1)','($1,:)'});
    eval([temp ' = data(:,i);']);
end

%% 构造signal
time = data(:,1);
% 提取信号名
vars =unique(regexprep(name(2:end),'\(([\d, ]+)\)$', ''));
for i = 1:length(vars)
    if strfind(vars{i},'.')
        % 将普通结构体转为 时间序列结构体
        eval(sprintf( '%s = timeseries(%s,time);',vars{i}, vars{i}))
    else
        % 普通数组也转为 时间序列，当然也可以其它合法的样式
        eval(sprintf( '%s = timeseries(%s,time);',vars{i}, vars{i}))
    end
end

%% 构造dataset 
% 提取接口名
prts = unique(regexpi(name(2:end),'^([\w\d_]+)','match','once'),'stable');
% 创建dataset
ds = Simulink.SimulationData.Dataset;
for i = 1:length(prts)
    % ds.addElement(sig, name); % 不推荐addElement
    ds{i} = eval(prts{i});
    ds{i}.Name = prts{i};
end

% inp = Simulink.SimulationInput('sl_test_demo');
% inp.ExternalInput = ds;
% out= sim(inp);
%% 多次跑同一个模型
% in = Simulink.SimulationInput(bdroot);
% in.ExternalInput = ds;
% out = sim(in)

%% 大数据仿真
% sim(mdl1,'LoggingToFile','on','LoggingFileName','data1.mat');
% sim(mdl2,'LoggingToFile','on','LoggingFileName','data2.mat');
%
% dsr1 = Simulink.SimulationData.DatasetRef('data1.mat','logsout');
% dsr2 = Simulink.SimulationData.DatasetRef('data2.mat','logsout');
% dst1 = dsr1{12};
% dst2 = dsr2{7};
% input = Simulink.SimulationData.Dataset;
% input{1} = dst1;
% input{2} = dst2;
% ts = timeseries(rand(5,1),1,'Name','RandomSignals');
% input{3} = ts;
% sim(mdl3,'ExternalInput','input');

