function [ str ] = simplify_tag( str )
%SIMPLIFY_TAG takes an input, str, and performs the following operations
%set all characters to lowercase
%remove spaces
%remove all non-word characters (i.e., all non number/letters)
str = regexprep(lower(str(str~=' ')), '[^\w]', '');
end

