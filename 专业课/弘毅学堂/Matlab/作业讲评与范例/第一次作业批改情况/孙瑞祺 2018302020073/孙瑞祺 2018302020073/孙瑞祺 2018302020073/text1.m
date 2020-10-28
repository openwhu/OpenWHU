clc;
close all;
clear;
y1=zeros(1,9);
y2=zeros(1,9);
while(1)  
x=randperm(9); %产生一个九维随机向量，且元素为1~9的整数%
 if (x(1)*1000+x(2)*100+x(3)*10+x(4))*x(5)==(x(6)*1000+x(7)*100+x(8)*10+x(9))
  y1=x;
  break
  end
end
while(1)  
x=randperm(9);
 if (x(1)*1000+x(2)*100+x(3)*10+x(4))*x(5)==(x(6)*1000+x(7)*100+x(8)*10+x(9))
  if (x==y1) %为防止输出的两个值是同一个解，在此做判断，若x与第一个解相等则继续循环%
  else
  y2=x ;
  break
  end
 end
end
y1
y2
