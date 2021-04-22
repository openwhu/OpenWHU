function [result, count, availabler, availablec] = binaryHide(cover, msg, goalfile, key, R0, R1, lambda)
    % display parameters
    disp(['R0: ', num2str(R0), ', R1: ', num2str(R1), ', lambda： ', num2str(lambda)]);
    % 读取文件信息
    frr = fopen(msg, 'r');
    [msg, count] = fread(frr, 'ubit1');
    % disp(['要隐藏的消息长度: ', int2str(count), ' bits']);
    fclose(frr);
    
    % 读取图像信息
    images = imread(cover);
    image = round(double(images) / 255);
    
    % 确定图像块的首地址
    [m, n] = size(image);
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
    
    % 随机置乱八个点
    temp = zeros(8);
    [randr, randc] = hashReplacement(temp, 64, key, m, n);
    
    % 分析可用的图像块，将不可用的图像块标记为 -1，这样在八
    [availabler, availablec, image] = available(msg, count, row, col, m, n, image, R1, R0, lambda, randr, randc);
    
    % 信息嵌入
    for i = 1 : count
        % 计算白像素的比例
        p1bi = computep1bi(availabler(i), availablec(i), image);
        if msg(i, 1) == 1
            % disp(1);
            if p1bi < R1
                % 使得 p1(Bi) > R1
                image = editp1bi(availabler(i), availablec(i), image, 0, R1-p1bi+1, randr, randc);
            elseif p1bi > R1 + lambda
                % 使得 p1(Bi) < R1 + λ
                image = editp1bi(availabler(i), availablec(i), image, 1, p1bi-R1-lambda+1, randr, randc);
            end
        end
        if msg(i, 1) == 0
            % disp(0);
            if p1bi > R0
                % 使得 p1(Bi) < R0
                image = editp1bi(availabler(i), availablec(i), image, 1, p1bi-R0+1, randr, randc);
            elseif p1bi < R0 - lambda
                % 使得 p1(Bi) > R0 - λ
                image = editp1bi(availabler(i), availablec(i), image, 0, R0-lambda-p1bi+1, randr, randc);
            end
        end
    end
    
    % 信息写回保存
    image = round(image);
    result = image;
    imwrite(result, goalfile);
    
    subplot(1, 2, 1);
    imshow(images);
    title('原始图像');
    
    subplot(1, 2, 2);
    imshow(result);
    title(['R0 = ', int2str(R0), ', R1 = ', int2str(R1), ', λ = ', int2str(lambda) ' 下 ', int2str(count), ' bits 信息的隐藏效果'])
end