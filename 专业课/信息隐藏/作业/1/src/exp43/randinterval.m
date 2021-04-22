%文件名:randinterval.m
%程序员:郭迟
%编写时间:2004.2.23
%函数功能:本函数将利用随机序列进行间隔控制,选择消息隐藏位.
%输入格式举例:[row,col]=randinterval(test,60,1983)
%参数说明:
%matrix为载体矩阵
%count为要嵌入的信息的数量(要选择的像素数量)
%key为密钥
%row为伪随机输出的像素行标
%col为伪随机输出的像素列标
function [row,col]=randinterval(matrix,count,key)
%计算间隔的位数
[m,n]=size(matrix);
interval1=floor(m*n/count)+1;
interval2=interval1-2;
if interval2<=0
   error( '载体太小不能将秘密信息隐藏进去!' );
end
%生成随机序列
rng(key);
a=rand(1,count);
%初始化
row=zeros([1 count]);
col=zeros([1 count]);
%计算row和col
r=1;
c=1;
row(1,1)=r;
col(1,1)=c;
for i=2:count
    if a(i)>=0.5
        c=c+interval1;
    else
        c=c+interval2;
    end
    if c>n              
       r=r+1;
       if r>m
           error( '载体太小不能将秘密信息隐藏进去!' );
       end
       c=mod(c,n);
       if c==0                                                                                 
           c=1;
       end
   end

row(1,i)=r;
col(1,i)=c;
end
