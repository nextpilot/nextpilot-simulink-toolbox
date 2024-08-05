cwd = fileparts(mfilename('fullpath')+".m");
mbeautifier_dir = fullfile(root,  'MBeautifier');
addpath(mbeautifier_dir)

% format m-file in code folder
root = fullfile(cwd, '../');
list = dir(fullfile(root, '**', '*.m'));
for i = 1:length(list)
    if ~contains(list(i).folder, 'MBeautifier')
        mfile = fullfile(list(i).folder, list(i).name);
        MBeautify.formatFile(mfile, mfile);
    end
end

rmpath(mbeautifier_dir)