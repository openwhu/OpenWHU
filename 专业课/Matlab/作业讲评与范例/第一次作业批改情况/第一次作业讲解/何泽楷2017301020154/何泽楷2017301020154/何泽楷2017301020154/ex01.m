%% Solution for Exercise 1
% 解算思路：利用MATLAB自带的perms函数列出 1:9 的所有排列，然后从这些排列
%     中直接找出答案
function out = ex01()
%EX01 Finding solution for Problem 01
    a = perms(1:9);
    out = a((a(:, 1)*1000 + a(:, 2) * 100 + a(:, 3) * 10 + a(:, 4)) .* a(:, 5) == (a(:, 6)*1000 + a(:, 7) * 100 + a(:, 8) * 10 + a(:, 9)), :);
end