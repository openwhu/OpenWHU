function ssw(input,watermark,seed,wavelet,level)
data=imread(input);
data=double(data)/255;
datared=data(:,:,1);%在R层加水印
%对原始图像的R层进行小波分解记录原始大小,并将其补成正方
%[C,Sreal]=wavedec2(datared,level,wavelet);
[row,list]=size(datared);
standard1=max(row,list);
new=zeros(standard1,standard1);
if row<=list
   new(1:row,:)=datared;
else
   new(:,1:list)=datared;
end   

%正式开始加水印
%小波分解,提取低频系数
[C,S]=wavedec2(new,level,wavelet);
CA=appcoef2(C,S,wavelet,level);
%对低频系数进行归一化处理
%[M,N]=size(CA);
%CAmin=min(min(CA));
%CAmax=max(max(CA));
%CA=(1/(CAmax-CAmin))*(CA-CAmin);
%d=max(size(CA));



%水印图像处理
%水印图像是一个灰度图像
W = imread(watermark);
W = double(W)/255;
W_ = gold(W,seed);
imwrite(W_,'ex_watermark.bmp');
[row2,list2]=size(W_);
W_new=zeros(standard1,standard1);
W_new(1:101,1:101) = W_;
[W_C,W_S]=wavedec2(W_new,level,wavelet);
W_CA=appcoef2(W_C,W_S,wavelet,level);

%对低频率系数单值分解
[U,sigma,V]=svd(CA);        %载体图片
[U_,sigma_,V_] = svd(W_CA); %水印图片

%重构
CAw = U_*sigma*V_;  %含有水印的CA！
CA_tilda=reshape(CAw,1,S(1,1)*S(1,2));
C(1,1:S(1,1)*S(1,2))=CA_tilda;
watermarkimage=waverec2(C,S,wavelet);
%imshow(datared);
%imshow(watermarkimage);

write_back = watermarkimage(1:row,1:list);
output = data;
output(:,:,1) = write_back;
imwrite(output,'output.bmp');

% --------------------------------------------
%提取水印
%小波分解,提取低频系数
[C,S]=wavedec2(watermarkimage,level,wavelet);
CA_1=appcoef2(C,S,wavelet,level);
%对低频系数进行归一化处理
%[M,N]=size(CA);
%CAmin=min(min(CA));
%CAmax=max(max(CA));
%CA=(1/(CAmax-CAmin))*(CA-CAmin);
%d=max(size(CA));
%对低频率系数单值分解
[U_e,sigma_e,V_e]=svd(CA_1);

%对低频系数进行归一化处理
%[W_M,W_N]=size(W_CA);
%W_CAmin=min(min(W_CA));
%W_CAmax=max(max(W_CA));
%W_CA=(1/(W_CAmax-W_CAmin))*(W_CA-W_CAmin);
%d=max(size(W_CA));

CAextract = U_e * sigma_ * V_e;
%CAextract = (CAmax-CAmin)*CAextract+CAmin;%系数还原到归一化以前的范围
%below0=find(CAextract<0);
%CAextract(below0)=0;

%重构
CA_tilda=reshape(CAextract,1,W_S(1,1)*W_S(1,2));
W_C(1,1:W_S(1,1)*W_S(1,2))=CA_tilda;
e_watermark=waverec2(W_C,W_S,wavelet);

extract_result = ungold(abs(e_watermark),seed);
result = extract_result(1:101,1:101);
imwrite(result,'extraction.bmp');

extr = imread('extraction.bmp');
extr = double(extr);
watermarking = imread(watermark);
watermarking = double(watermarking);
mistake = extr - watermarking;
mistake = abs(mistake);
total = sum(sum(watermarking));
mistake_total = sum(sum(mistake));
rates = mistake_total/total;
disp(rates);
disp('end');