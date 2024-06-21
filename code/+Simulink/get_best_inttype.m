function dtype = get_best_inttype(min, max)

if min < 0
    if min < intmin('int32') || max > intmax('int32')
        dtype = 'fixdt(1,64,0)';
    elseif min < intmin('int16') || max > intmax('int16')
        dtype = 'int32';
    elseif min < intmin('int8') || max > intmax('int8')
        dtype = 'int16';
    else
        dtype = 'int8';
    end
else
    if max > intmax('uint32')
        dtype = 'fixdt(0,64,0)';
    elseif max > intmax('uint16')
        dtype = 'uint32';
    elseif max > intmax('uint8')
        dtype = 'uint16';
    else
        dtype = 'uint8';
    end
end
