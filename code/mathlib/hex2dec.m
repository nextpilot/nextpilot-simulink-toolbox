function dec = hex2dec(hex, del)
if ischar(hex) && size(hex, 1) == 1
    if nargin == 1
        del = {' ', '\f', '\n', '\r', '\t', '\v'};
    end
    dec = hex2dec(strsplit(hex, del))';
else
    dec = hex2dec(hex);
end
