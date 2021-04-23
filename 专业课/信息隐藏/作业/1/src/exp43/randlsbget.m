%文件名:randlsbget.m
%程序员:李巍
%编写时间:2004.2.29
%函数功能:本函数将完成提取隐秘于LSB上的秘密消息
%输入格式举例:result=randlsbget('d.jpg',50,'secret.txt',1988)
%参数说明:
%output是信息隐秘后的图像
%len_total是秘密消息的长度
%goalfile是提取出的秘密消息文件
%key是随机间隔函数的密钥 
%result是提取的消息 
function result=randlsbget(output,len_total,goalfile,key)
ste_cover=imread(output);
ste_cover=double(ste_cover);
%判断嵌入消息量是否过大
[m,n]=size(ste_cover);
frr=fopen(goalfile,'w');
%p作为消息嵌入位数计数器,将消息序列写回文本文件
p=1;
%调用随机间隔函数选取像素点 
[row,col]=randinterval(ste_cover,len_total,key);
disp('row: ');
disp(row);
disp('col: ');
disp(col);
for i=1:len_total
     if bitand(ste_cover(row(i),col(i)),1)==1
         fwrite(frr,1,'ubit1');
         result(p,1)=1;
     else  
         fwrite(frr,0,'ubit1');
         result(p,1)=0;
     end
     if p==len_total
         break;
     end    
     p=p+1;
end
disp(result);
fclose(frr);
