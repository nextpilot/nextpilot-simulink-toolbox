function [flag, tline] = fskip(fid, lines, origin)

% lines: ����������������ֱ������ĳ������
%       lines �ı����ʾ������ָ���ı�
%       lines > 1��ʾ�����ľ����������������У�
%       lines < 0��ʾ�����ķǿ����������������У�

if nargin == 1
    lines = 1;
    origin = 0;
elseif nargin == 2
    origin = 0;
end

if origin == 1
    frewind(fid);
end

if isnumeric(lines)
    [flag, tline] = skip_line(fid, lines);
else
    [flag, tline] = skip_text(fid, lines);
end

function [flag, tline] = skip_line(fid, line)
flag = false;

is_include_empty_line = line < 0;
k = 1;
line = abs(line);
while ~feof(fid)
    if k > line
        flag = true;
        break;
    end
    tline = fgets(fid);
    if ~is_include_empty_line && ~isempty(strtrim(tline))
        k = k + 1;
    elseif is_include_empty_line
        k = k + 1;
    end
end

function [flag, tline] = skip_text(fid, text)
flag = false;
while ~feof(fid)
    tline = fgetl(fid);
    if contains(tline, text)
        flag = true;
        break;
    end
end
