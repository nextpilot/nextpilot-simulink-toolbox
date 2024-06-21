function under = camel2under(camel)
% camel2under 驼峰命名转下划线命名, 小写和大写紧挨一起的地方, 加上分隔符, 然后全部转小写
%
% Example:
%
% 'abcDefGh' ==> 'abc_def_gh'

under = lower(regexprep(camel, '([0-9a-z])([A-Z])', '$1_$2'));

