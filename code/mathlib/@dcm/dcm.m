classdef dcm 
    properties
        value = eye(3);
    end
    
    methods
        function obj=dcm(varargin)
            
            % dcm()
            % dcm(r)
            % dcm()
            
            obj.value=ang2dcm(varargin{:});
        end
        
     
    end
end