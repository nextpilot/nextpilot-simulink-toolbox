function readsdlog
sdlog = '';

BLOCK_SIZE = 8192;
MSG_HEADER_LEN = 3;
MSG_HEAD1 = hex2dec('A3');
MSG_HEAD2 = hex2dec('95');
MSG_FORMAT_PACKET_LEN = 89;
MSG_FORMAT_STRUCT = "BB4s16s64s";
MSG_TYPE_FORMAT = hex2dec('80');


{
    'c', 'uint8',1
    'b', 'int8', 1
    'B', 'uint8',1
    '?', 'logical', 1
    'h', 'int16', 2
    'H', 'uint16', 2
    'i', 'int32', 4
    'I', 'uint32', 4
    'l', 'int32', 4
    'L', 'uint32', 4
    'q', 'int64', 8
    'Q', 'uint64', 8
    'f', 'single', 4
    'd', 'double', 8
    's', 'int8', 1    % char
    'p', 'int8', 1
    'P', 'uint32', 4
    'n', 'int8', 4   % char
    'N', 'int8', 16 % char
    'Z', 'int8', 64 % char
    };

keys  = {'c'}
value = {}
FORMAT_TO_STRUCT = containers.Map()


fid = fopen(sdlog);

while ~feof(fid)
    [data, count] = fread(fid,BLOCK_SIZE,'*uint8');
    buffer = [buffer, data];
    % 寻找帧头
    ptr = 1;
    is_head_found = false;
    while get_bytes_left > 2
        if (buffer[ip] == MSG_HEAD1 && buffer[ip+1] == MSG_HEAD2)
            is_head_found = true;
            break;
        else
            ptr = ptr + 1;
            continue
        end
    end
    % 解析数据
    ptr = ptr + 1;
    msg_type = buffer[ptr];
    if msg_type == MSG_TYPE_FORMAT
        % parse FORMAT message
        if get_bytes_left < MSG_FORMAT_PACKET_LEN
            break;
        else
            parse_msg_head
        end
    else
        % parse data message
    end
end

    function k = get_bytes_left()
        k = length(buffer) - ptr;
    end

    function parse_msg_head()
        
    end
end
