function [outputArg1] = ex02(X)
%EX02 function to optimize for Exercise 02
%   Average cars per seconds, negate the result to convert maximun optim.
%   problem to minimum optimization problem
    outputArg1 = -(0.2 .* X(:,1) ./ X(:,2) + 0.3 .* (1 - X(:,1)./X(:,2)));
end