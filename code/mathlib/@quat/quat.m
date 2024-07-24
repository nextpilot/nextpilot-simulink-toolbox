classdef quat
    % 绕着轴 n = [cosβ1,cosβ2,cosβ3] 旋转角度 σ，则构成四元素
    % q = cos(σ/2) + sin(σ/2)*[cosβ1*i + cosβ2*j + cosβ3*k]
    properties
        real = 1 % 实部
        imag = [0, 0, 0] % 虚部
    end

    properties (Dependent)
        q0
        q1
        q2
        q3
    end

    methods
        function v = get.q0(q)
            v = q.real;
        end
        function q = set.q0(q, v)
            q.real = v;
        end
        function v = get.q1(q)
            v = q.imag(1);
        end
        function q = set.q1(q, v)
            q.imag(1) = v;
        end
        function v = get.q2(q)
            v = q.imag(2);
        end
        function q = set.q2(q, v)
            q.imag(2) = v;
        end
        function v = get.q3(q)
            v = q.imag(3);
        end
        function q = set.q3(q, v)
            q.imag(3) = v;
        end
        function q = set.imag(q, i)
            q.imag = i(:)';
        end
    end
    methods
        function q = quat(varargin)
            % quat()
            % quat(q)
            % quat([q0,q1,q2,q3])
            % quat(q0,[q1,q2,q3])
            % quat(q0,q1,q2,q3)
            % quat(...,'axis')
            % quat(...,'euler')
            % quat(...,'vector')
            % quat(...,'xyz...')


            if nargin == 0
                % do nothing
            elseif isa(varargin{1}, 'nextpilot.math.quat')
                q = varargin{1};
            elseif ias(varargin{1}, 'nextpilot.math.vect')
            elseif ias(varargin{1}, 'nextpilot.math.dcm')
            elseif isequal(size(varargin{1}), [3, 3])
            elseif ischar(varargin{end}) && ~isempty(varargin{end})
                switch lower(varargin{end}(1))
                    case {'x', 'y', 'z'}
                        q = q.seteuler(varargin{1:end});
                    case 'a'
                        q = q.setaxis(varargin{1:end-1});
                    case 'v'
                        q = q.setvect(varargin{1:end-1});
                    case 'e'
                        v = [varargin{end-1:-1:1}];
                        q = q.seteuler(v(3:-1:1));
                end
            else
                q = q.setelem(varargin{:});
            end
        end
    end

    methods (Static)

        %q = setelem(varargin)
        %q = setdcm(dcm)
        %q = setvect(a,b)
        %q = setaxis(varargin)
        %q = seteuler(varargin)

        function help()
            disp('  quat()')
            disp('  quat(q)')
            disp('  quat([q0,q1,q2,q3])')
            disp('  quat(q0,[q1,q2,q3]')
        end
    end
end
