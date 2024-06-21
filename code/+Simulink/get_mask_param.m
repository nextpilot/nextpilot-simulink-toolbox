function [wsvar, dgvar, hprm, hmsk] = get_mask_param(blk)

if nargin == 0
    blk = gcb;
end

% get_param(gcb, 'MaskObject')
hmsk = Simulink.Mask.get(blk);

%
hprm = struct();
for i = 1:hmsk.numParameters
    name = hmsk.Parameters(i).Name;
    hprm.(name) = hmsk.Parameters(i);
end

% get_param(gcb, 'MaskWSVariables')
wslist = hmsk.getWorkspaceVariables();
wsvar = struct();
for i = 1:length(wslist)
    name = wslist(i).Name;
    value = wslist(i).Value;
    wsvar.(name) = value;
end

dglist = get_param(blk, 'MaskValues');
nmlist = get_param(blk, 'MaskNames');
dgvar = struct();
for i = 1 : length(dglist)
    name = nmlist{i};    
    value = dglist{i};
    dgvar.(name) = value;
end


