function [sum] = getPixelCorrelation(col)  % 获取像素相互关系
    len = size(col,1);
    sum = 0;
    for z = 2:len
        sum = sum + abs(col(z-1) - col(z));
    end
end