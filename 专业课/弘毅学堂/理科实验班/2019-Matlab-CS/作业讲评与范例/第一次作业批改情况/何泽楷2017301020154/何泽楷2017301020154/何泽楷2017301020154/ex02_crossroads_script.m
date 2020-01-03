%% ex02 crossroads
clc; clear;
fprintf("\nThe crossroad part begins:");
N = [20, 12,  18, 10] / 60; % cars from four directions(ENWS) per second
t_0 = 2.3; % time needed for a car to go through the crossroad
f = [-N 1]; f(end) = -t_0 * sum(N); 
m = length(f);
aeq = zeros(m); aeq(end, end) =1; aeq(1, 1:m-1) = ones(1, m-1);
T_ub = 120; % upper bound for T, set arbitrarily
beq = zeros(m, 1); beq(end) = 1; beq(1) = T_ub;
percent_low = 0.2; 
A = percent_low * ones(m); 
A = A - diag(diag(A)); 
A = A + (percent_low-1) * eye(m);
A(end, :) = zeros(1, m); A(:, end) = zeros(1, m);
[x_1, fval_1] = linprog(f, A, zeros(1,m), aeq, beq, ...
    zeros(1, m), T_ub*ones(1,m));
fprintf("Green light time(in sec): %g, %g, %g, %g\n", x_1(1:4));
fprintf("with respect to car flow: %g, %g, %g, %g\n", N);
T = sum(x_1(1:4));
fprintf("Traffic light peroid: %gs\n", T);
fprintf("Optimal cars per second: %g\n", -fval_1/T);
