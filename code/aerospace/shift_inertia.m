function I=shift_inertia(jxyz, mass, move, euler, cog)
% jxyz ԭ����ϵ�Ĺ��Ծ�
% mass ԭ��������
% move  ƽ������ʸ��
% euler  ��תŷ����
% cog  ԭ��������λ��
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
% Ixx = ��y^2+z^2 dm
% Iyy = ��x^2+z^2 dm
% Izz = ��x^2+y^2 dm
% Ixy = Iyx = ��xy dm
% Iyz = Izy = ��yz dm
% Izx = Ixz = ��zx dm

I=jxyz;
m=mass;
%% ����ƽ��
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

%% ������ת
% ����������ϵo-xyz�е�ת���߾���I��û��Ҫ��I���������ᣬҲû��Ҫ��I���������
% ����ԭ����ϵo-xyz����ŷ����תR���õ�o-pqr����ϵ
%��1��������ʸ��v��ת��������
% v'*I*v
%��2������������ϵ��ת��������
% R*I*R'
phi=euler(1);theta=euler(2);psi=euler(3);
R=angle2dcm(psi,theta,phi,'zyx');
%  R=angle2dcm(phi,theta,psi,'zxz');
I=R*I*R';