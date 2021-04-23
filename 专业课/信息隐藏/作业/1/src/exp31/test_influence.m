function [] = test_influence(gsi_image_path, msg_path, key)
    % 读取图像信息
    images = imread(gsi_image_path);
    image = round(double(images) / 255);
    
    % 读取隐藏信息 bit 流
    fp = fopen(msg_path, 'r');
    [msg, count] = fread(fp, 'ubit1');
    fclose(fp);
    
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
    
    % 开始测试
    test_num = 1;
    % preallocation for speed
    total_used_blocks_list = zeros(15, 1);
    unusable_blocks_list = zeros(15, 1);
    difficult_adjust_blocks_list = zeros(15, 1);
    for k = 5 : -1 : 1
        R1 = 50 + k;
        R0 = 50 - k;
        for lambda = 1 : 1 : 3
            disp(['test: ', num2str(test_num)]);
            disp(['R1 = ', num2str(R1), ', R0 = ', num2str(R0), ', λ = ', num2str(lambda)]);
            disp('==========================================================================');
            [~, ~, ~, total_used_blocks, unusable_blocks, difficult_adjust_blocks] = available(msg, count, row, col, m, n, image, R1, R0, lambda, randr, randc);
            % total_used_blocks_list = [total_used_blocks_list, total_used_blocks];
            % unusable_blocks_list = [unusable_blocks_list, unusable_blocks];
            % difficult_adjust_blocks_list = [difficult_adjust_blocks_list, difficult_adjust_blocks];
            total_used_blocks_list(test_num) = total_used_blocks;
            unusable_blocks_list(test_num) = unusable_blocks;
            difficult_adjust_blocks_list(test_num) = difficult_adjust_blocks;
            test_num = test_num + 1;
            disp('==========================================================================');
        end
    end
    
    % display info
    % disp(total_used_blocks_list);
    % disp(unusable_blocks_list);
    % disp(difficult_adjust_blocks_list);
    
    subplot(1, 2, 1);

    x_axis = (45 : 49);
  
    for i = 1 : 1 : 3
        % preallocation for speed
        y_axis = zeros(5, 1);
        index = 1;
        for j = i : 3 : 15
            % y_axis = [y_axis, unusable_blocks_list(j) / total_used_blocks_list(j)];
            y_axis(index) = unusable_blocks_list(j) / total_used_blocks_list(j);
            index = index + 1;
        end
        plot(x_axis, y_axis);
        hold on;
    end
    
    legend({'λ = 1, λ = 2', 'λ = 3'}, 'Location', 'northwest');
    % title('ratio of unusable blocks when changing R0');
    xlabel('value of R0');
    ylabel('ratio of unusable blocks'); 
    hold off;
    
    subplot(1, 2, 2);
    x_axis = (1 : 3);
    
    for i = 1 : 1 : 5
        y_axis = zeros(3, 1);
        index = 1;
        for j = i : 5 : 15
            % y_axis = [y_axis, unusable_blocks_list(j) / total_used_blocks_list(j)];
            y_axis(index) = unusable_blocks_list(j) / total_used_blocks_list(j);
            index = index + 1;
        end
        plot(x_axis, y_axis);
        hold on;
    end
    
    legend({'R0 = 45, R0 = 46, R0 = 47', 'R0 = 48, R0 = 49'}, 'Location', 'northwest');
    % title('ratio of unusable blocks when changing λ');
    xlabel('value of λ');
    ylabel('ratio of unusable blocks');
    hold off;
    
end