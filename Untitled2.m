clc;
clear;
close all;

% a= [1,2;3,4]
% b = [2,4;3,4]
% 
% c = {a;b}

a = [1 2 3;2 3 4;1 2 5;1 3 6 ]
b = [1 2 3;1 3 6]

c = setdiff(a,b,'rows')