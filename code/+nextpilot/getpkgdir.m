function r = getpkgdir()
% windows可以使用RTW.TransformPaths对路径进行转换

r = strtok(fileparts(mfilename('fullpath')+".m"),'+');