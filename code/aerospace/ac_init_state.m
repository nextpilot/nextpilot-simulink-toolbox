classdef ac_init_state  < matlab.mixin.SetGet
    properties
        lat_lon_alt = [ 0 0 0 ];
        vex_vey_vez = [0 0 0];
    end
    properties (Dependent)
        vbx_vby_vbz
    end
    properties
        phi_theta_psi =[0 0 0];
        wbx_wby_wbz = [0 0 0];
    end
    
    methods
        function set.phi_theta_psi(obj, v)
            if any(abs(v) > [pi, pi/2, pi])
                obj.phi_theta_psi = v * pi /180;
            else
                obj.phi_theta_psi = v;
            end
        end
        function set.vbx_vby_vbz(obj, v)
            v = angle2dcm(...
                obj.phi_theta_psi(3),...
                obj.phi_theta_psi(2),...
                obj.phi_theta_psi(1),...
                'zyx')' * v(:);
            obj.vex_vey_vez = v';
        end
        
        function v = get.vbx_vby_vbz(obj)
            v = angle2dcm(...
                obj.phi_theta_psi(3),...
                obj.phi_theta_psi(2),...
                obj.phi_theta_psi(1),...
                'zyx') * obj.vex_vey_vez(:);
            v = v';
        end
        
        function s = struct(obj)
            warning('off', 'MATLAB:structOnObject')
            s = builtin('struct',obj);
            warning('on', 'MATLAB:structOnObject')
        end
    end
end