function [sum] = getPixelCorrelation(col)
    len = size(col,1);
    sum = 0;
    for z = 2:len
        sum = sum + abs(col(z-1) - col(z));
    end
end