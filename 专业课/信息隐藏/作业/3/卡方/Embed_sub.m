function [ste_cover, len_total] = Embed_sub( input, file, output)
% 参数说明:
% input 是信息隐蔽载体图像, 为灰度BMP 图
% file 是秘密消息文件
% output 是信息隐秘后生成图像
% ste_cover 是信息隐秘后图像矩阵
% len_total 是秘密消息的长度, 即容量

% 读入图像矩阵
cover = imread( input) ;
ste_cover = cover;
ste_cover = double( ste_cover ) ;
% 将文本文件转换为二进制序列
f_id = fopen( file, 'r') ;
[ msg, len_total] = fread( f_id, 'ubit1');
% 判断嵌入消息量是否过大
[ m, n] = size( ste_cover ) ;
if len_total > m* n
error( '嵌入消息量过大, 请更换图像') ;
end
% p 作为消息嵌入位数计数器
p = 1;
for f2 = 1:n
    for f1 = 1:m
        ste_cover( f1, f2) = ste_cover( f1, f2) -mod( ste_cover( f1, f2) , 2) + msg( p, 1) ;
        if p == len_total
            break;
        end
        p = p + 1;
    end
    if p == len_total
        break;
    end
end
ste_cover = uint8( ste_cover ) ;
% 生成信息隐秘后图像
imwrite( ste_cover, output) ;
% 显示实验结果
subplot( 1, 2, 1) ; imshow( cover) ; title( '原始图像') ;
subplot( 1, 2, 2) ; imshow( output) ; title( '隐藏信息的图像') ;