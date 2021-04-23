function [] = disp_change(row, col, count, size)
a = ones(size);
for i = 1 : count
    a(row(i), col(i)) = 0;
imshow(a), title(['一共隐藏 ', int2str(count), ' bits 信息']);
end

