classdef Parameter < Simulink.Parameter
    
    properties
        Decimal = [];
    end
    properties
        Increment = [];
    end
    
    methods
        function obj = Parameter(InputData)
            useLocalCustomStorageClasses(obj, 'pixhawk');
            % Set up object to use custom storage classes by default
            obj.CoderInfo.StorageClass = 'Custom';
            obj.CoderInfo.CustomStorageClass = 'Param';
        end
    end
    
end