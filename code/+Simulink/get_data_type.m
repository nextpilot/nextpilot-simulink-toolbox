function [sltype, sldims] = getdatatype(oldtype)

if isnumeric(oldtype)
    oldtype = class(oldtype);
    sldims  = size(oldtype);
elseif ischar(oldtype)
    tokens  = regexp(oldtype,'([^\s\[]+)\s*(\[[\d, ]+\])*','tokens','once');
    oldtype = lower(tokens{1});
    if isempty(tokens{2})
        sldims = 1;
    else
        sldims = eval(tokens{2});
    end
else
    error('getdatatype:WrongInputDataType','Can''t Recognize DataType: %s', class(oldtype));
end

switch lower(oldtype)
    case {'double','float64'}
        sltype = 'double';
    case {'single','float','float32','real_t'}
        sltype = 'single';
    case {'uint64','unsigned long long','uint64_t'}
        sltype = 'fixdt(0,64,0)';
    case {'uint32','unsigned long','ulong','uint32_t'}
        sltype = 'uint32';
    case {'uint16','unsigned short','ushort','uint16_t'}
        sltype = 'uint16';
    case {'uint8','unsigned char','uchar','uint8_t'}
        sltype = 'uint8';
    case {'int64','long long','int64_t'}
        sltype = 'fixdt(1,64,0)';
    case {'int32','long','int32_t'}
        sltype = 'int32';
    case {'int16','short','int16_t'}
        sltype = 'int16';
    case {'int8','char','int5_t'}
        sltype = 'int8';
    case {'uint'}
        sltype = 'uint32';
    case {'int'}
        sltype='int32';
    case {'bool','boolean','logcial'}
        sltype = 'boolean';
    otherwise
        sltype = oldtype;
end