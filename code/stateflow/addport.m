% scope = {input, output, local, constant, parameter, data memory}
list={
    % name scope type size
    'vehicle_global_position','input', 'px4bus',-1
    'vehicle_local_position','input', 'px4bus',-1
    'vehicle_gps_position','input', 'px4bus',-1
    'sensor_combined','input', 'px4bus',-1
    'fw_pos_ctrl_status','input', 'px4bus',-1
    'vehicle_status','input', 'px4bus',-1
    'vehicle_land_detected','input', 'px4bus',-1
    'home_position','input', 'px4bus',-1
    'onboard_mission','input', 'px4bus',-1
    'offboard_mission','input', 'px4bus',-1
    'parameter_update','input', 'px4bus',-1
    'vehicle_command','input', 'px4bus',-1
    };

model='copter_navigator';

rt = sfroot;
ch = rt.find('-isa','Stateflow.Chart','-and','path','copter_navigation/Chart');
for i=1:size(list,1)
    % name
    parts = strsplit(list{i,1},'/');
    if length(parts)==1
        da = Stateflow.Data(ch);
        da.Name = parts{end};
    else
    end
    % scope/port
    parts=strplit(list{i,2});
    if length(parts)==1
    da.Scope=parts{1};
    else
        da.Scope=parts{1};
        da.Port=str2double(parts{2});
    end
    % datatype
    if strcmpi(list{i,3},'px4bus')
        da.DataType=['Bus: px4_',list{i,4}];
    else
        da.DataType=['Bus: px4_',list{i,4}];
    end
    % size
    
end

%sfsave()