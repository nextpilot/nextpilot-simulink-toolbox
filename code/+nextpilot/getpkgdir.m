function r = getpkgdir()
% windows����ʹ��RTW.TransformPaths��·������ת��

r = strtok(fileparts(mfilename('fullpath')+".m"),'+');