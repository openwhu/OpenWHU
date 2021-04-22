function [source] = lsb(source,rate)
    [m,n] = size(source);
    for i = 1:m*n*rate
        if(mod(source(i), 2)==0 && ~(mod(source(i), 2)==mod(i,2)))
            source(i) = source(i)+1;
        elseif(mod(source(i), 2)==1 && ~(mod(source(i), 2)==mod(i,2)))
            source(i) = source(i)-1;
        end
    end
end