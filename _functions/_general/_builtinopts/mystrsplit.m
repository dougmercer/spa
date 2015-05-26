function [cellout] = mystrsplit(str, escape)
cellout = regexp(str, regexptranslate('escape', escape), 'split');
