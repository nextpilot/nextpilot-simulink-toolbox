function I=shift_inertia(jxyz, mass, move, euler, cog)
% jxyz 原坐标系的惯性矩
% mass 原物体质量
% move  平移坐标矢量
% euler  旋转欧拉角
% cog  原来的重心位置
narginchk(2,5);

if nargin<5
    cog=[0 0 0];
end
if nargin<4
    euler=[0 0 0];
end
if nargin<3
    move=[0 0 0];
end

% I = [
%     +Ixx -Ixy -Ixz
%     -Iyx +Iyy -Iyz
%     -Izx -Izy +Izz
%     ];
%
% Ixx = ∫y^2+z^2 dm
% Iyy = ∫x^2+z^2 dm
% Izz = ∫x^2+y^2 dm
% Ixy = Iyx = ∫xy dm
% Iyz = Izy = ∫yz dm
% Izx = Ixz = ∫zx dm

I=jxyz;
m=mass;
%% 坐标平移
a=move(1);b=move(2);c=move(3);
xc=cog(1);yc=cog(2);zc=cog(3);
ixx = (b^2+c^2) - 2*(b*yc+c*zc);
iyy = (a^2+c^2) - 2*(a*xc+c*zc);
izz = (a^2+b^2) - 2*(a*xc+b*yc);
ixy = a*b - (a*yc+b*xc);iyx=ixy;
iyz = b*c - (b*zc+c*yc);izy=iyz;
izx = c*a - (c*xc+a*zc);ixz=izx;
I = I + [ixx,-ixy,-ixz;-iyx,iyy,-iyz;-izx,-izy,izz]*m;
% I = I + [ixx,ixy,ixz;iyx,iyy,iyz;izx,izy,izz]*m;

%% 坐标旋转
% 假设在坐标系o-xyz中的转动惯矩是I，没有要求I是主惯性轴，也没有要求I必须过形心
% 另外原坐标系o-xyz经过欧拉旋转R，得到o-pqr坐标系
%（1）则绕着矢量v的转动惯量是
% v'*I*v
%（2）则在新坐标系的转动惯量是
% R*I*R'
phi=euler(1);theta=euler(2);psi=euler(3);
R=angle2dcm(psi,theta,phi,'zyx');
%  R=angle2dcm(phi,theta,psi,'zxz');
I=R*I*R';