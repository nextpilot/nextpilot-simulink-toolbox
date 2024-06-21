function sig = get_selected_signal(sys, varargin)
if nargin==0
    sys = gcs;
end
sig = find_system(sys,'FindAll','on','SearchDepth',1,'CaseSensitive','off','Type','line','Selected','on',varargin{:});