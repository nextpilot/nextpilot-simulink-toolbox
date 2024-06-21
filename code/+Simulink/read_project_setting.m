function read_project_setting(xlsx, style)
if isempty(xlsx) || ~exist(xlsx,'file') 
    warndlg(['cant not find setting file:"', xlsx, '"'], 'File Not Find');
    return;
end

if nargin < 2
    style = 1;
end

[pathstr,filestr] = fileparts(which(xlsx));

% �������ֵ�
sldd = fullfile(pathstr, [filestr, '.sldd']);
if ~exist(sldd, 'file')
    Simulink.data.dictionary.create(sldd);
end

% ��������
sldd = fullfile(pathstr, [filestr, '_dtype.sldd']);
nextpilot.simulink.read_excel_enum(xlsx, sldd);
nextpilot.simulink.read_excel_struct(xlsx, sldd);

% ��������
sldd = fullfile(pathstr, [filestr, '_param.sldd']);
nextpilot.simulink.read_excel_param(xlsx, sldd);

% �źŶ���
% sldd = fullfile(pathstr, [filestr, '_signal.sldd']);
%nextpilot.simulink.read_excel_param(xlsx, sldd);



