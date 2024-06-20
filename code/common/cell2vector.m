function v = cell2vector(c)

if all(cellfun(@isnumeric, c)) || all(cellfun(@(x)isa(x, 'sym'), c))
    c = cellfun(@(x)x(:), c, 'UniformOutput', false);
    v = cat(1, c{:});
else
    warning('off', 'symbolic:sym:sym:DeprecateExpressions')
    warning('off', 'symbolic:sym:sym:AssumptionsOnConstantsIgnored')
    v = sym(c, 'real');
    warning('on', 'symbolic:sym:sym:DeprecateExpressions')
    warning('on', 'symbolic:sym:sym:AssumptionsOnConstantsIgnored')
end