function [n] = numOfFigs()
h =  findobj('type','figure');
n = length(h);