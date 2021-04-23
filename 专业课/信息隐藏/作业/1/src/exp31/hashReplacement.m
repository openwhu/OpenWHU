function [row, col] = hashReplacement(matrix, quantity, key1, key2, key3)
    % 载体矩阵的大小
    [X, Y] = size(matrix);
    
    % 初始化 row 和 col
    row = zeros([1, quantity]);
    col = zeros([1, quantity]);
    
    j = zeros([1, quantity]);
    
    for i = 1 : quantity
        v = round(i / X);
        u = mod(i, X);
        v = mod(v + md52num(md5(u + key1)), Y);
        u = mod(u + md52num(md5(v + key2)), X);
        v = mod(v + md52num(md5(u + key3)), Y);
        
        j(i) = v * X + u + 1;
        col(i) = mod(j(i), Y);
        row(i) = j(i) / Y;
        row(i) = floor(row(i)) + 1;
        
        if col(i) == 0
            col(i) = Y;
            row(i) = row(i) - 1;
        end
    end
end


function result = md52num(md5code)
    result = 0;
    for i = 1 : 32
        result = result + table(md5code(i)) * i;
    end
end


function a = table(character)
    switch character
        case '0' 
            a = 0;
        case '1' 
            a = 1;
        case '2' 
            a = 2;
        case '3' 
            a = 3;
        case '4' 
            a = 4;
        case '5' 
            a = 5;
        case '6' 
            a = 6;
        case '7' 
            a = 7;
        case '8'
            a = 8;
        case '9' 
            a = 9;
        case 'a'
            a = 10;
        case 'b'
            a = 11;
        case 'c'
            a = 12;
        case 'd'
            a = 13;
        case 'e'
            a = 14;
        otherwise
            a = 15;
    end
end


function y = md5(M)
    y = DataHash(M, 'MD5');
end