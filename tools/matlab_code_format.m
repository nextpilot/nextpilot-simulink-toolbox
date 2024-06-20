

cwd = fileparts(mfilename('fullpath') +  ".m");
root= fullfile(cwd, '../');

mbeautifier_dir=fullfile(root, 'code','MBeautifier');
addpath(mbeautifier_dir)
list = dir(fullfile(root, 'code','**','*.m'));
for i = 1:length(list)
    if ~contains(list(i).folder,'MBeautifier')
    mfile=fullfile(list(i).folder,list(i).name);
    MBeautify.formatFile(mfile,mfile);

    end
end
rmpath(mbeautifier_dir)