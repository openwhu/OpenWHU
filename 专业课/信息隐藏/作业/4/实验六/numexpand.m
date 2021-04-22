function result = numexpand(a)
b = dec2bin(a);
l = length(b);
for i =1:l
    if b(i) == '1'
        str((i-1)*2+1) = '1';
        str((i-1)*2+2) = '1';
%        str((i-1)*3+3) = '1';
%         str((i-1)*8+5) = '1';
%         str((i-1)*8+6) = '1';
%         str((i-1)*8+7) = '1';
%         str((i-1)*8+8) = '1';
       
    else
        str((i-1)*2+1) = '0';
        str((i-1)*2+2) = '0';
%         str((i-1)*3+3) = '0';
%         str((i-1)*8+5) = '0';
%         str((i-1)*8+6) = '0';
%         str((i-1)*8+7) = '0';
%         str((i-1)*8+8) = '0';
       
    end
end
result = bin2dec(str);
