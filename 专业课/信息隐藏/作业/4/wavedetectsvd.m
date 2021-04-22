function [corr_coef,corr_DCTcoef]=wavedetectsvd(test,original,seed,level,alpha)
%函数说明:完成W-SVD模式下数字水印的检测
%参数说明:
%seed 为随机数种子
%wavelet 使用的小波函数
%level 为小波分解的尺度
%alpha 为水印强度
%ratio 为算法中d/n的比例
%corr_coef,corr_DCTcoef分别为不同方法下检测出的相关值

imgorg=imread(original);
imgtest=imread(test);
imgorg=double(imgorg)/255;
imgtest=double(imgtest)/65535;
imgorg=imgorg(:,:,1);
imgtest=imgtest(:,:,1);

%提取加有水印的小波低频系数
[wmimgrgb,wmimg,wCA,wm2,correlationU,correlationV]=wavemarksvd(original,seed,level,alpha);
%提取待测图像的小波低频系数
[C,S]=wavedec2(imgtest,level,'db6');
CA_test=appcoef2(C,S,'db6',level);
%提取原始图像的小波低频系数
[C,S]=wavedec2(imgorg,level,'db6');
CA_ori=appcoef2(C,S,'db6',level);
%生成两种水印
realwm=wCA-CA_ori;
testwm=CA_test-CA_ori;
%计算相关值
corr_coef=trace(realwm'*testwm)/(norm(realwm,'fro')*norm(testwm,'fro'));
%DCT系数比较
DCTrealwm=dct2(wCA-CA_ori);
DCTtestwm=dct2(CA_test-CA_ori);
DCTrealwm=DCTrealwm(1:min(32,max(size(DCTrealwm))),1:min(32,max(size(DCTrealwm))));
DCTtestwm=DCTtestwm(1:min(32,max(size(DCTtestwm))),1:min(32,max(size(DCTtestwm))));
DCTrealwm(1,1)=0;
DCTtestwm(1,1)=0;
corr_DCTcoef=trace(DCTrealwm'*DCTtestwm)/(norm(DCTrealwm,'fro')*norm(DCTtestwm,'fro'));
end
