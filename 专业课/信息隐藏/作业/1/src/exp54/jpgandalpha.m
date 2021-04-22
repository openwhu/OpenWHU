%文件名:jpgandalpha.m
%程序员:郭迟
%编写时间:2004.3.11
%函数功能:本函数将探讨DCT隐藏中的控制阈值alpha在JPEG条件对隐藏鲁棒性的影响.
%输入格式举例:result=jpgandalpha('c:\lenna.jpg','c:\secret.txt')
%参数说明:
%test为原始图像
%msg为待隐藏的信息
function result=jpgandalpha(test,msg)
%定义压缩质量比从10%到100%
quality=10 : 10 : 100;
alpha=[0.1, 0.2, 0.5, 1];
result=zeros([max(size(alpha)) max(size(quality))]);
resultr=0;
resultc=0;
for a=alpha
    resultr=resultr+1;
    [count,message,hideresult]=hidedctadv(test,'temp.jpg',msg,2003,a);
    resultc=0;
    different=0;
    for q=quality
        resultc=resultc+1;
        imwrite(hideresult,'temp.jpg','jpg','quality',q);
        msgextract=extractdctadv('temp.jpg','temp.txt',2003,count);
        for i=1:count
            if message(i,1)~=msgextract(i,1)
                different=different+1;
            end
        end
        result(resultr,resultc)=different/count;
        different=0;
    end
disp(['完成了第',int2str(resultr),'个(共4个)α的鲁棒性测试,请等待...']);    
end
%return
for i=1:4
    plot(quality,result(i,:));
    hold on;
end
legend({'α=0.1', 'α=0.2', 'α=0.5', 'α=1'}, 'Location', 'northeast');
xlabel('jpeg压缩率');
ylabel('提取的信息与原始信息不同的百分比例'); 
title('控制阈值α在JPEG条件对隐藏鲁棒性的影响')