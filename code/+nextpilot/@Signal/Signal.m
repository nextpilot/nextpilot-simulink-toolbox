classdef Signal < Simulink.Signal
    
    methods
        %---------------------------------------------------------------------------
        function setupCoderInfo(h)
            % Use custom storage classes from this package
            useLocalCustomStorageClasses(h, 'pixhawk');
            
            % Set up object to use Global custom storage class by default
            h.CoderInfo.StorageClass = 'Auto';
            %h.CoderInfo.CustomStorageClass = 'uORB';
        end
        
        
        %-----------------------------------------------------------------------------------------------
        function h = Signal()
            % SIGNAL  Class constructor.
        end % end of constructor
        
    end % methods
    
end % classdef

%EOF
