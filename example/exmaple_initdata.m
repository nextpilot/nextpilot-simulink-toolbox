
%% 初始状态
plant.init.lat_lon_alt   = [30. 120. 440];
plant.init.vx_vy_vz      = [0 0 0];
plant.init.ax_ay_az      = [0 0 0];
plant.init.phi_theta_psi = [0,0,0];
plant.init.p_q_r         = [0 0 0];

%% 发动机
init_engine;

%% 旋翼动力
init_motor;

%% 气动数据
init_aerody;