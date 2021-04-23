% 函数功能: 本函数将完成 W-SVD 模型下数字水印的检测 
% 输入格式举例: 
%[ corr_ coef, corr _DCTcoef] = wavedetect( 'test. png' ,'lenna. jpg' , 1983,‘ db6’ ,2,0.1, 0. 99) 
% 参数说明: 
% input 为输入原始图像 
% seed 为随机数种子 
% wavelet 为使用的小波函数 
% level 为小波分解的尺度 
% alpha 为水印强度 
% ratio 为算法中 d /n 的比例
% corr_coef, corr_DCTcoef 分别为不同方法下检测出的相关性值
function [corr_coef, corr_DCTcoef] = wavedetect(test,original,seed,wavelet,level,alpha,ratio)
dataoriginal = imread(original) ;
datatest = imread( test) ;
dataoriginal = double( dataoriginal) /255;
datatest = double( datatest) /255;
% 请大家注意这里的两个分母, 这是与图像文件格式有关的 
dataoriginal = dataoriginal(:,:, 1) ; datatest = datatest(:,:,1) ;
% 提取加有水印的图像的小波低频系数
[watermarkimagergb, watermarkimage, waterCA, watermark2, correlationU, correlationV] = wavemarksvd( original,'temp.png',seed, wavelet, level, alpha, ratio) ; 
% 提取待测图像的小波低频系数
[C, S] = wavedec2( datatest, level, wavelet) ;
CA_test = appcoef2( C, S, wavelet, level) ; 
% 提取原始图像的小波低频系数
[C, S] = wavedec2( dataoriginal, level, wavelet) ;
realCA = appcoef2( C, S, wavelet, level) ; 
% 生成两种水印
realwatermark = waterCA-realCA;
testwatermark = CA_test-realCA; 
% 计算相关性值 
corr_coef = trace( realwatermark' * testwatermark) /( norm( realwatermark, 'fro' ) * norm( testwatermark, 'fro') ) ; 
% DCT 系数比较
DCTrealwatermark = dct2( waterCA-realCA) ;
DCTtestwatermark = dct2( CA_test-realCA) ;
DCTrealwatermark = DCTrealwatermark ( 1: min ( 32, max ( size ( DCTrealwatermark) ) ) ,1:min( 32, max( size( DCTrealwatermark) ) ) ) ;
DCTtestwatermark = DCTtestwatermark ( 1: min ( 32, max ( size ( DCTtestwatermark) ) ) ,1:min( 32, max( size( DCTtestwatermark) ) ) ) ;
DCTrealwatermark( 1, 1) =0;
DCTtestwatermark( 1, 1) =0;
corr_DCTcoef = trace( DCTrealwatermark' * DCTtestwatermark) /( norm( DCTrealwatermark, 'fro' ) * norm( DCTtestwatermark,'fro') ) ;

