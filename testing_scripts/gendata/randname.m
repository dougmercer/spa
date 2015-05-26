function [name] = randname(N)
n = 1+ randi(N);
letters = 'a':'z';
cletters= 'A':'Z';
m = length(letters);
name = [cletters(randi(m)), letters(randi(m, 1, n-1))];