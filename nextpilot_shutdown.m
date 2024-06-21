function nextpilot_finish
root = fileparts(mfilename('fullpath')+".m");
rmpath(genpath(root));