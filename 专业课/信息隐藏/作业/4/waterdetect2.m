function corr_coef = waterdetect2(test,original,seed,do_num,alpha)
%函数说明:检测DCT水印的函数
%参数说明
%test 为待检测的RGB图像文件
%original 为原始图像文件
%seed 为随机序列种子
%alpha 是尺度参数
%do_num 是进行投票选择的次数
%corr_coef 是检测相关值
imgorg=imread(original);
imgtest=imread(test);
imgorg=imgorg(:,:,1);
[m,n]=size(imgorg);
imgtest=imgtest(:,:,1);
%提取加有水印的图像的DCT系数
waterdct=dct2(imgtest);
%提取原始图像的DCT系数
waterdcto=dct2(imgorg);
%生成两种水印
realwatermark=cellauto(m,n,seed,do_num);
testwatermark=(waterdct-waterdcto)/alpha;
%计算相关性值
corr_coef=trace(realwatermark'*testwatermark)/(norm(realwatermark,'fro') * norm(testwatermark,'fro'));
end

