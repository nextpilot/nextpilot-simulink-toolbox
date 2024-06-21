function fix_block_link(varargin)
% fixblocklink()�����ҵ�ǰmodel��unsolve link�������Ը���SourceType�����޸�
% fixblocklink(sys)������sysģ����unsolve link�������Ը���SourceType�����޸�
% fixblocklink(oldpath��newpath)�����ҵ�ǰģ�Ͱ���oldpath��unsolve link��Ȼ����newpath�����޸�
% fixblocklink(sys, oldpath, newpath)

% BlockType    = reference
% SourceBlock  = nplib/Math Basic/PIDAttenuation
% SourceLibraryInfo
% SourceType   = PIDAttenuation
% ReferenceBlock
% LockLinksToLibrary
% LinkStatus
% StaticLinkStatus

if nargin==0
    model = bdroot;
    oldpath = '';
    newpath = '';
elseif nargin==1
    model = varargin{1};
    oldpath = '';
    newpath = '';
elseif nargin == 2
    model = bdroot;
    oldpath = varargin{1};
    newpath = varargin{2};
end
model=bdroot;
oldpath='nplib/';
newpath='nplib_r2016b/';

list=find_system(model,...
    'Type','block',...
    'BlockType','Reference',...
    'StaticLinkStatus','unresolved');


    for i=1:length(list)
        srcpath = get_param(list{i},'SourceBlock');        
        if ~isempty(oldpath) && ~isempty(newpath)
            if strfind(srcpath, oldpath)                
                srcpath = strrep(srcpath, oldpath, newpath);
                set_param(list{i},'SourceBlock', srcpath);
            end
        elseif isempty(oldpath) && ~isempty(newpath)
            set_param(list{i},'SourceBlock', newpath);
        else
            %
        end
    end
