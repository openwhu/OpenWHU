% 函数功能: 本函数是一个嵌入水印的函数 
% 输入格式举例: 
% [ corr_coef, corr_DCTcoef] = dctwatermark('kola.jpg','kola1.jpg' , jpg,2019,3,0.2)
% 参数说明:
% original 为原始图像文件名 
% goal 为嵌入水印图像 
% permission 为图像文件格式 
% seed 为随机序列种子 
% alpha 是尺度参数 
% do_num 参数是进行投票选择的次数
function [watermark, datared, datadct, datared2] = dctwatermark ( orignal, goal,permission, seed, do_num, alpha)
data = imread( orignal,permission) ;
data = double( data) /255; datared = data(:,:, 1) ;
[ row, col] = size( datared) ;
datadct = dct2( datared) ;
% 调用函数 cellauto
watermark = cellauto( row, col, seed, do_num) ;
dataadd = datadct + alpha* watermark;
datared2 = idct2( dataadd) ; 
data(:,:,1) = datared2; 
% 显示结果 
subplot( 131) ; imshow( datared2) ; title( ' R 层图像' ) ;
subplot( 132) ; imshow( data) ; title( '加入水印后的图像' );
imwrite( data, goal, permission) ;
