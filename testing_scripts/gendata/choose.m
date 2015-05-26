function [choice] = choose(cdf)
choice = find(rand(1) <= cdf, 1,'first');