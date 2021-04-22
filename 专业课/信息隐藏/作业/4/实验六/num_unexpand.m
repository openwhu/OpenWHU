function result = num_unexpand(a)
b = dec2bin(a);
l = length(b);
flag = l/2;
flag = floor(flag);
for i =1:flag
    
    if b(2*i-1) == '1' && b(2*i) == '1'
        str(i) = '1';
    elseif b(2*i-1) == '1' && b(2*i) == '0'
        str(i) = '1';
    elseif b(2*i-1) == '0' && b(2*i) == '1'
        str(i) = '0';
    elseif b(2*i-1) == '0' && b(2*i) == '0'
        str(i) = '0';
    end
end
result = bin2dec(str);
