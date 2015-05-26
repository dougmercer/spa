function [ blurb ] = randaccess( )
letters = 'a':'z';
numbers = '0':'9';
blah = letters(randi(length(letters),1,3));
blergh = numbers(randi(length(numbers),1,3));
blurb = [blah, blergh];
end

