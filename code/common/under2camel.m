function camel=under2camel(under)
%

camel =regexprep(under, '(_)(.)','${upper($2)}');