function [value, name]=cell2bus(c)
% busCell = ...
%     { ...
%         { ...
%         'myBusObj', ...
%         'MyHeader.h', ...
%         'My description', ...
%         'Exported', ...
%         '-1', ...
%         {
%             {'a',1,'double', [0.2 0],'real','Frame'}; ...
%             {'b',1,'double', [0.2 0],'real','Sample'}
%         },...
%         }, ...
%     };
    
busprop ={
    'HeaderFile'
    'Description'
    'DataScope'
    'Alignment'
    };
elmprop = {
    'Name'
    'Dimensions'
    'DataType'
    'SampleTime'
    'Complexity'
    'SamplingMode'
    'DimensionsMode'
    'Minimum'
    'Maximum'
    'Unit'
    'Description'
    };

nbus = length(c);
value{nbus, 1} = [];
name{nbus, 1} = '';
for i = 1:length(c)
    if ~isempty(c{i})
        name{i} = c{i}{1};
        % 设置bus属性
        value{i} = Simulink.Bus;
        for j = 1:4
            if ~isempty(c{i}{j+1})
                try value{i}.(busprop{j}) = c{i}{j+1}; end
            end
        end
        % 添加elem
        nelem = length(c{i}{6});        
        for j = 1:nelem
            for k = 1:11
                if ~isempty(c{i}{6}{j}{k})
                    try value{i}.Elements(j).(elmprop{k,1}) = c{i}{6}{j}{k}; end
                end
            end
        end
    end
end