function blk = get_selected_block(sys,varargin)
if nargin==0
    sys = gcs;
end
blk = find_system(sys,'SearchDepth',1,'CaseSensitive','off','Type','Block','Selected','on',varargin{:});
blk = setdiff(blk, sys);