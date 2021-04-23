function[rp, sp, rn, sn] = rs(img)
    order = [ %z字型读取数据顺序表
        1  9  2  3  10 17 25 18 ...
        11 4  5  12 19 26 33 41 ...
        34 27 20 13 6  7  14 21 ...
        28 35 42 49 57 50 43 36 ...
        29 22 15 8  16 23 30 37 ...
        44 51 58 59 52 45 38 31 ...
        24 32 39 46 53 60 61 54 ...
        47 40 48 55 62 63 56 64];    
    cols = im2col(img, [8 8], 'distinct');  % 将8x8 的块转化为列
    cols = cols(order, :);                  % 按照order的顺序排列数据
    [rp, sp, rn, sn, cp, cn] = deal(0);     % 初始化为0
    for col = cols
        pcb = getPixelCorrelation(col);
        flag = randi([1 3]);        %随机选择一种翻转方式
        switch flag
            case 1                  %交换函数F1
                cp = cp + 1;
                for i = 1:64
                    x = col(i);
                    if(mod(x, 2)==0)
                        col(i) = x+1;
                    else
                        col(i) = x-1;
                    end
                end
                pca = getPixelCorrelation(col);
                if pca > pcb
                    rp = rp + 1;
                elseif pca < pcb
                    sp = sp + 1;
                end
            case 2                  %偏移函数F-1
                cn = cn + 1;
                for i = 1:64
                    x = col(i);
                    if(mod(x, 2)==0)
                        col(i) = x-1;
                    else
                        col(i) = x+1;
                    end
                end
                pca = getPixelCorrelation(col);
                if pca > pcb
                    rn = rn + 1;
                elseif pca < pcb
                    sn = sn + 1;
                end
            case 3                  %恒等变换F0
        end
    end
    rp = rp / cp;
    sp = sp / cp;
    rn = rn / cn;
    sn = sn / cn;
    
    
    
end
