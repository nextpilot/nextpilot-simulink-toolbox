function ds = read_excel_testcase(xlsx)

%% �����������
if nargin == 0
    [filename, pathname] = uigetfile({'*.xls;*.xlsx', 'Excel Files (*.xls,*xlsx)'},'Excel Files');
    if isequal(pathname, 0)
        return;
    else
        xlsx = fullfile(pathname, filename);
    end 
end

%% ��ȡexcel�ļ�
[data,name]=xlsread(xlsx);
for i = 2:size(name,2)
    % (k)��  �滻Ϊ(:,k)
    % (i,j)���滻Ϊ(i,j,:)
    temp = regexprep(name{i}, {'\((\d+)\)$','\(([\d, ]+)\)$'}, {'(:,$1)','($1,:)'});
    eval([temp ' = data(:,i);']);
end

%% ����signal
time = data(:,1);
% ��ȡ�ź���
vars =unique(regexprep(name(2:end),'\(([\d, ]+)\)$', ''));
for i = 1:length(vars)
    if strfind(vars{i},'.')
        % ����ͨ�ṹ��תΪ ʱ�����нṹ��
        eval(sprintf( '%s = timeseries(%s,time);',vars{i}, vars{i}))
    else
        % ��ͨ����ҲתΪ ʱ�����У���ȻҲ���������Ϸ�����ʽ
        eval(sprintf( '%s = timeseries(%s,time);',vars{i}, vars{i}))
    end
end

%% ����dataset 
% ��ȡ�ӿ���
prts = unique(regexpi(name(2:end),'^([\w\d_]+)','match','once'),'stable');
% ����dataset
ds = Simulink.SimulationData.Dataset;
for i = 1:length(prts)
    % ds.addElement(sig, name); % ���Ƽ�addElement
    ds{i} = eval(prts{i});
    ds{i}.Name = prts{i};
end

% inp = Simulink.SimulationInput('sl_test_demo');
% inp.ExternalInput = ds;
% out= sim(inp);
%% �����ͬһ��ģ��
% in = Simulink.SimulationInput(bdroot);
% in.ExternalInput = ds;
% out = sim(in)

%% �����ݷ���
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

