% 函数功能: 这是一个绘制 SC 图的函数 
% 输入格式举例: 
%[corr_Wcoef, corr_Dcoef] = plotcorr_coef( 'test.png','kola.jpg',20,'db6',2,0.1, 0.99); 
% 参数说明: 
% test 为待测图像 
% original 为原始图像
% testMAXseed 为实验使用的最大随机数种子
% wavelet 为使用的小波函数 
% level 为小波分解的尺度 
% alpha 为水印强度 
% ratio 为算法中 d /n 的比例
% corr_Wcoef, corr_Dcoef 分别为利用不同种子检测出的相关性值的集合
function [corr_Wcoef, corr_Dcoef] = plotcorr_coef( test, original, testMAXseed, wavelet, level,alpha, ratio)
corr_Wcoef = zeros( testMAXseed,1) ;
corr_Dcoef = zeros( testMAXseed, 1) ;
s =1; 
for i = 1:testMAXseed
    [corr_coef, corr_DCTcoef] = wavedetect(test, original, i, wavelet,level, alpha,ratio);
    corr_Wcoef(s) = corr_coef;
    corr_Dcoef(s) = corr_DCTcoef;
    s = s +1;
end
subplot( 211) ;
plot( abs( corr_Wcoef) ) ; 
title( '常规检测阈值分析' ) ; 
xlabel( ' 种子' ) ; 
ylabel( '相关性值' ) ; 
subplot( 212) ; plot( abs( corr_Dcoef) ) ; 
%待测 
title( 'DCT 变换后检测阈值分析' ) ; 
xlabel( '种子' ) ;
ylabel( '相关性值' ) ;