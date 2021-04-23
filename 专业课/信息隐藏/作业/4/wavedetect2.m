% 函数功能: 本函数是一个检测 DCT 水印的函数 
% 输入格式举例: 
% corr_coef = wavedetect2( 'kolal.jpg','jpg','lenna. jpg','jpg',2019,3,0.2) 
% 参数说明: 
% test 为待检测的 RGB 图像文件名 
% permission1 为待检测的 RGB 图像文件格式 
% original 为原始图像文件名
% permission2 为原始图像文件格式
% seed 为随机序列种子 
% do_num 参数是进行投票选择的次数 
% alpha 是尺度参数 
% corr_coef 是检测相关值
function corr_coef = wavedetect2( test, permission1, original, permission2, seed, do_num, alpha)
dataoriginal = imread( original, permission2);
datatest = imread(test,permission1);
dataoriginal = dataoriginal( : , : , 1) ;
[ m, n] = size( dataoriginal) ;
datatest = datatest( : , : ,1) ; 
% 提取加有水印的图像的 DCT 系数
waterdct = dct2( datatest) ; 
% 提取原始图像的 DCT 系数
waterdcto = dct2( dataoriginal) ; 
% 生成两种水印
realwatermark = cellauto( m, n, seed, do_num) ;
testwatermark = (waterdct-waterdcto) /alpha; 
% 计算相关性值 
corr_coef = trace( realwatermark' * testwatermark) /( norm( realwatermark, 'fro' ) * norm( testwatermark, 'fro' ) ) ; 
%[ corr_Wcoef, corr_Dcoef] = plotcorr_coef(test,original,20, 'db6' ,2,alpha,1);
