classdef vect
    properties
        direct = [0, 0, 1];
        sigma = 0
    end

    methods
        function obj = vect(varargin)
            if nargin == 1
                switch class(varargin{1})
                    case 'nextpilot.math.dcm'
                    case 'nextpilot.math.quat'
                    case 'nextpilot.math.vect'
                    case 'double'
                end
            end


        end
    end
end