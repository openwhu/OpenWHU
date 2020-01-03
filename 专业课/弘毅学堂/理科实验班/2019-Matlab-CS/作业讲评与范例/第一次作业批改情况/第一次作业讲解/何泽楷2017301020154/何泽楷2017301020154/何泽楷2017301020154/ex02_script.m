%% ex02
% Script for finding optimal result for problem in Exercise 2
clc; clear ex02;
A = [-1,0.4; 1,-0.6]; % linear contraint matrix for 0.4t<=t_g<=0.6t, t > 0
% start with t_g=15 secs and t=30 secs
[x, fval] = fmincon('ex02', [15, 30], A, zeros(2,1), [], [], [0, 0], []);
fprintf("green light time: %gs, traffic light peroid: %gs\n", x);
fprintf("Optimal cars per second: %g\n", -fval);
