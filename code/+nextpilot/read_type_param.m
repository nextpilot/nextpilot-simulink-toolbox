function read_type_param(folder)

if nargin == 0
    folder = uigetdir('','PX4 Firmware Root Path');
    if isequal(folder, 0)
        return;
    end
end

% param
param_define_file = fullfile(folder, 'src\*_params.c');
param_saved_file  = 'px4_param.sldd';
nextpilot.pixhawk.readparam(param_define_file, param_saved_file);

% data type
%if exist(fullfile(folder,'build'),'folder')

msg_define_file = fullfile(folder, 'msg\*.msg');
msg_saved_file  = 'px4_dtype.sldd';
nextpilot.pixhawk.readdtype(msg_define_file, msg_saved_file);

