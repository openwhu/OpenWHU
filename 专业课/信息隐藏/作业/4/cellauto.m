% 函数功能: 这是一个细胞自动机及相应的 vote 和 smooth 函数
% 输入格式举例: watermark = cellauto( 72, 72, 1983, 20) 
% 参数说明:
% row, col 为要求得到的水印模板大小 
% seed 为随机数种子
% do_num 为细胞自动机处理次数
function watermark = cellauto( row, col, seed, do_num) 
% 生成随机模板 
rand('seed',seed) ; 
chaoticrand = rand( row, col) > 0.5; 
% 转二值矩阵
chaotic = chaoticrand; 
% 扩大边界等待处理
temp = zeros( row + 2, col + 2) ; 
temp( 2:row +1, 2:col +1) = chaotic;
% 细胞自动机处理 
for i = 1:do_num  
% 边界补充  
    temp( 1, 2:col +1) = temp( row +1,2:col + 1) ; 
    temp( row +2, 2:col +1) = temp( 2,2:col + 1) ; 
    temp( 2:row +1, 1) = temp( 2:row + 1, col + 1) ;  
    temp( 2:row +1, col +2) = temp( 2:row +1, 2) ;
    temp( 1, 1) = temp( row +1, col +1) ;
    temp( row +2, col +2) = temp( 2,2) ;
    temp( 1, col + 2) = temp( row +1,2) ;
    temp( row +2, 1) = temp( 2, col +1) ; 
    % vote1 规则  
    cell1 = temp( 1:row,1:col) ;  
    cell2 = temp( 1:row,2:col + 1) ;  
    cell3 = temp( 1:row,3:col + 2) ;  
    cell4 = temp( 2:row + 1, 1:col) ;  
    cell5 = temp( 2:row + 1, 2:col +1) ;  
    cell6 = temp( 2:row + 1, 3:col +2) ;  
    cell7 = temp( 3:row + 2, 1:col) ; 
    cell8 = temp( 3:row + 2, 2:col +1) ; 
    cell9 = temp( 3:row + 2, 3:col +2) ;  
    temp( 2:row + 1, 2:col + 1) = ( cell1 + cell2 + cell3 + cell4 + cell5 + cell6 +cell7 + cell8 + cell9) >4;
end
chaoticcell = temp( 2:row +1, 2:col +1) ;
% 平滑处理
chaotic2 = chaoticcell; 
avg = fspecial('average',3) ; 
for j = 1:do_num
  chaotic2 = filter2( avg, chaotic2) ;
end
scale = max( max( chaotic2) ) ;
chaotic2 = chaotic2 /scale; 
% 水印生成
watermark = ( chaotic2 - mean2( chaotic2) * ones( row, col) ) ; 
subplot( 131) ; imshow( chaoticrand) ; title( '随机模式') ; 
subplot( 132) ; imshow( chaoticcell) ; title( '细胞模式' ) ; 
subplot( 133) ; imshow( watermark) ; title( '平滑模式( 水印) ' ) ; 
