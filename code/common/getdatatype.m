function [mltype, mldims] = getdatatype(oldtype)

if isnumeric(oldtype)
    oldtype = class(oldtype);
    mldims = size(oldtype);
elseif ischar(oldtype)
    tokens = regexp(oldtype, '(\w+)(\[\d+\])*', 'tokens', 'once');
    oldtype = lower(tokens{1});
    if isempty(tokens{2})
        mldims = 1;
    else
        mldims = eval(tokens{2});
    end
else
    error('getdatatype:WrongInputDataType', 'Can''t Recognize DataType: %s', class(oldtype));
end

switch lower(oldtype)
    case {'double', 'float64'}
        mltype = 'double';
    case {'single', 'float', 'float32'}
        mltype = 'single';
    case {'uint64', 'unsigned long long'}
        mltype = 'uint64';
    case {'uint32', 'unsigned long', 'ulong'}
        mltype = 'uint32';
    case {'uint16', 'unsigned short', 'ushort'}
        mltype = 'uint16';
    case {'uint8', 'unsigned char', 'uchar'}
        mltype = 'uint8';
    case {'int64', 'long long'}
        mltype = 'int64';
    case {'int32', 'long'}
        mltype = 'int32';
    case {'int16', 'short'}
        mltype = 'int16';
    case {'int8', 'char'}
        mltype = 'int8';
    case {'uint'}
        mltype = 'uint32';
    case {'int'}
        mltype = 'int32';
    case {'bool', 'boolean', 'logcial'}
        mltype = 'logical';
    otherwise
        mltype = oldtype;
end