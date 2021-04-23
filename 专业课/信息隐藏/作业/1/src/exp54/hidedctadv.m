%文件名：hidedctadv.m
%程序员：郭迟
%修改：李鹏
%编写时间：2003.11.25
%修改时间：2004.3.8
%函数功能：本函数用于DCT域的信息隐藏
%输入格式举例：[count,msg,data]=hidedctadv('lenna.jpg','1.jpg','1.txt',1982,1);
%参数说明：
%image为载体图象
%imagegoal为藏有秘密信息的载体，即隐秘载体
%msg为待隐藏的信息
%key为密钥，用来控制随机选块
%alpha为控制量，用来保证编码的正确性
%count为待隐藏信息的长度
%result为隐藏结果
function [count,msg,result]=hidedctadv(image,imagegoal,msg,key,alpha)
%按位读取秘密信息
frr=fopen(msg,'r');
[msg,count]=fread(frr,'ubit1');
fclose(frr);
data0=imread(image);
%将图象矩阵转为double型
data0=double(data0)/255;
%取图象的一层做隐藏
data=data0(:,:,1);
%对图象分块
T=dctmtx(8);
%对分块图象做DCT变换
DCTrgb=blkproc(data,[8 8],'P1*x*P2',T,T');
DCTrgb0=DCTrgb;
%产生随机的块选择,确定图像块的首地址
[row,col]=size(DCTrgb);
row=floor(row/8);
col=floor(col/8);
a=zeros([row col]);
[k1,k2]=randinterval(a,count,key);
for i=1:count
    k1(1,i)=(k1(1,i)-1)*8+1;
    k2(1,i)=(k2(1,i)-1)*8+1;
end
%信息嵌入
temp=0;
for i=1:count
   if msg(i,1)==0 
     if DCTrgb(k1(i)+4,k2(i)+1)>DCTrgb(k1(i)+3,k2(i)+2)
        temp=DCTrgb(k1(i)+4,k2(i)+1);
        DCTrgb(k1(i)+4,k2(i)+1)=DCTrgb(k1(i)+3,k2(i)+2); 
        DCTrgb(k1(i)+3,k2(i)+2)=temp; 
     end
   else
      if DCTrgb(k1(i)+4,k2(i)+1)<DCTrgb(k1(i)+3,k2(i)+2)
        temp=DCTrgb(k1(i)+4,k2(i)+1);
        DCTrgb(k1(i)+4,k2(i)+1)=DCTrgb(k1(i)+3,k2(i)+2); 
        DCTrgb(k1(i)+3,k2(i)+2)=temp; 
     end
   end  
  if DCTrgb(k1(i)+4,k2(i)+1)>DCTrgb(k1(i)+3,k2(i)+2)
      DCTrgb(k1(i)+3,k2(i)+2)=DCTrgb(k1(i)+3,k2(i)+2)-alpha;%将原本小的系数调整得更小
  else
      DCTrgb(k1(i)+4,k2(i)+1)=DCTrgb(k1(i)+4,k2(i)+1)-alpha;
  end    
end
%信息写回保存 
 DCTrgb1=DCTrgb;
 data=blkproc(DCTrgb,[8 8],'P1*x*P2',T',T);
 result=data0;
 result(:,:,1)=data;
 imwrite(result,imagegoal);
 