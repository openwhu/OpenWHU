function [availabler, availablec, image, blockquan, unable, difficult] = available(msg, count, row, col, m, n, image, R1, R0, lambda, randr, randc)
    msgquan = 1;
    unable = 0;
    difficult = 0;
    
    for blockquan = 1 : m * n
        % 计算 p1(Bi)
        p1bi = computep1bi(row(blockquan), col(blockquan), image);
        % 不可用快
        if p1bi >= R1 + 3 * lambda || p1bi <= R0 - 3 * lambda
            % 标记为无用
            row(blockquan) = -1;
            col(blockquan) = -1;
            unable = unable + 1;
            msgquan = msgquan - 1;
        % 难以调整块，讲该块标记为无用
        elseif msg(msgquan, 1) == 1 && p1bi <= R0
            % 调整 p1(Bi) 变得更小
            image = editp1bi(row(blockquan), col(blockquan), image, 1, 3 * lambda, randr, randc);
            row(blockquan) = -1;
            col(blockquan) = -1;
            difficult = difficult + 1;
            msgquan = msgquan - 1;
        % 难以调整块，将该块标记为无用
        elseif msg(msgquan, 1) == 0 && p1bi >= R1
            % 调整 p1(Bi) 变得更大
            image = editp1bi(row(blockquan), col(blockquan), image, 0, 3 * lambda, randr, randc);
            row(blockquan) = -1;
            col(blockquan) = -1;
            difficult = difficult + 1;
            msgquan = msgquan - 1;
        end
        msgquan = msgquan + 1;
        if msgquan == count + 1
            for i = (blockquan + 1) : m * n
                row(i) = -1;
                col(i) = -1;
            end
            disp(['消息长度：', num2str(msgquan - 1), ' bits, ', '总块数: ', num2str(m*n), '; 用到的块数: ', num2str(blockquan), '; 其中不可用的块有: ', num2str(unable), '; ', ...
                ' 难以调整块有: ', num2str(difficult)]);
            break;
        end
    end
    
    if msgquan <= count
        disp(['消息长度: ', num2str(msgquan - 1), '总块数: ', num2str(m*n), ' bits; 用到的块数: ', num2str(blockquan), '; 其中不可用的块有: ', num2str(unable), '; ', ...
                num2str(difficult), ' 块难以调整修改为不可用块']);
        disp('请根据以上数据更换载体');
        error("载体太小");
    end
    
    % 计算可用块的数量
    quan = 0;
    for i = 1 : m * n
        if row(i) ~= -1
            quan = quan + 1;
        end
    end
    
    if quan < count
        error('可用块的数量太小！请根据以上数据更换载体！');
    end
    % disp(['可用块的图像块为：', num2str(quan)]);
    
    % 生成可用的块的行标列标并与消息对应
    image = round(image);
    availabler = zeros([1, quan]);
    availablec = zeros([1, quan]);
    
    % 被标记为无用的块讲不含在 availabler 中
    j = 1;
    for i = 1 : m * n
        if row(i) ~= - 1
            availabler(j) = row(i) ;
            availablec(j) = col(i) ;
            j = j + 1;
        end
    end 
end
