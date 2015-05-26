function [ F, P ] = quickfind( type, varargin )
%note: varargin and cases left in case i want to add stuff later
switch lower(type)
    case 'str'
        [F,P]=grep('-r','-R','-s', varargin{1}, './*.m');
    otherwise
        fprintf('Input should (''str'', arg)');
        F=[];
        P=[];
end
end

