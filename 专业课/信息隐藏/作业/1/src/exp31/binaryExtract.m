function result = binaryExtract(stegocover, goalfile, key, R0, R1, lambda, count)
    stegoimage = imread(stegocover);
    stegoimage = round(double(stegoimage) / 255);
    
    [m, n] = size(stegoimage);
    m = floor(m / 10);
    n = floor(n / 10);
    
    temp = zeros([m, n]);
    [row, col] = hashReplacement(temp, m * n, m, key, n);
    
    for i = 1 : m * n
        if row(i) ~= 1
            row(i) = (row(i) - 1) * 10 + 1;
        end
        if col(i) ~= 1
            col(i) = (col(i) - 1) * 10 + 1;
        end
    end
    
    frr = fopen(goalfile, 'w');

    quan = 1;
    result = zeros([count, 1]);
    
    for i = 1 : m * n
        % 计算这一块的 p1(Bi)
        p1bi = computep1bi(row(i), col(i), stegoimage);
        if p1bi < R1 + 3 * lambda && p1bi > 50
            fwrite(frr, 1, 'ubit1');
            result(quan, 1) = 1;
            quan = quan + 1;
            % disp(1);
        elseif p1bi > R0 - 3 * lambda && p1bi < 50
            fwrite(frr, 0, 'ubit1');
            result(quan, 1) = 0;
            quan = quan + 1;
            % disp(0);
        end
        if quan == count + 1
            break;
        end
    end
    disp(['已经正确处理 ', num2str(quan - 1), ' bits 的消息']);
    fclose(frr);
end

