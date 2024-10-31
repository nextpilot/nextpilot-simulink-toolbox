%% 发动机
% 发动机安装位置
engine.position  = [0,0,0];
% 发动机推力方向
engine.direction = [1,0,0];
% 发动机旋转方向
engine.rotation  = +1;
% 发动机拉力曲线
eng_perf1 = [
    %转速rpm	节气门开度	推力（N）
    3400	12/100	55
    4000	17/100	69.1
    4270	19/100	76
    4550	21/100	82.2
    4800	25/100	89.5
    5070	31/100	99.3
    5250	32/100	105.8
    5450	33/100	112.3
    5700	34/100	123.5
    6000	41/100	139
    6250	45/100	152.5
    6530	67/100	163.9
    7000	72/100	170
    7250	80/100	174.2
    ];
engine.thrust.delta = eng_perf1(:,2);
engine.thrust.force = eng_perf1(:,3);
% 发动机扭矩曲线
eng_perf2 = [
    % 节气门开度%	功率（kW）	扭矩(N*m)	转速(rpm)	燃油消耗率kg/（kW·h）
    20/100	0.69	1.57	4200	525
    30/100	1.92	3.31	5550	392
    40/100	2.45	3.65	6400	382
    50/100	3.23	4.47	6900	350
    60/100	3.63	4.85	7150	386
    70/100	3.74	4.92	7250	369
    80/100	3.78	4.92	7330	372
    90/100	3.84	4.92	7350	378
    100/100	3.84	4.99	7350	383
    ];
engine.torque.delta  = eng_perf2(:,1);
engine.torque.moment = eng_perf2(:,3);