
%% 初始状态
plant.aircraft.init.phi_theta_psi = [0,0,0];



%% 舵机



%% 发动机


%% 旋翼动力

R = 1;
A = (45:90:360)';

% 电机安装位置
plant.motor.position = [R*cosd(A), R*sind(A), 0*A];
% 电机拉力轴向
plant.motor.thrustdir = [
    0 0 -1
    0 0 -1
    0 0 -1
    0 0 -1
    ];
% 电机旋转方向，拉力轴向右手定则（俯视，逆时针为正，顺时针为负）
plant.motor.spindir = [
    1
    -1
    -1
    1
    ];

