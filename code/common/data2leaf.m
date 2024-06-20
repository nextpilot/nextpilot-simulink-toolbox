function varargout = data2leaf(s, p, c)
if nargin == 1
    p = inputname(1);
    c = cell(0, 2);
elseif nargin == 2
    c = cell(0, 2);
end

if isstruct(s)
    for j = 1:length(s)
        d = getshapechar(size(s), j);
        f = fieldnames(s);
        for i = 1:length(f)
            c = nextpilot.matlab.data2leaf(s(j).(f{i}), [p, d, '.', f{i}], c);
        end
    end
else
    for i = 1:numel(s)
        d = getshapechar(size(s), i);
        c(end+1, 1:2) = {[p, d], s(i)};
    end
end

if nargout <= 1
    varargout{1} = c;
else
    varargout{1} = c(:, 1);
    varargout{2} = c(:, 2);
end

function shp = getshapechar(siz, ind)
% ȥ��dim����β����1
for i = length(siz):-1:1
    if siz(i) ~= 1
        break;
    else
        siz(i) = [];
    end
end
if isempty(siz)
    % ��������Ҫά��
    shp = '';
else
    % ������ת��Ϊ�±�
    k = cumprod(siz);
    sub = zeros(length(siz), 1);
    for i = length(siz):-1:2
        vi = rem(ind-1, k(i-1)) + 1;
        vj = (ind - vi) / k(i-1) + 1;
        sub(i) = vj;
        ind = vi;
    end
    sub(1) = ind;
    % ���±�ת��Ϊ�ַ���
    shp = ['(', strjoin(arrayfun(@num2str, sub, 'UniformOutput', 0), ','), ')'];
end
