t=0;
wait2=0;
wait3=0;
wait4=0;
a=0.3;%初始化偏好因数
b=0.45;
c=0.25;
num2=ones(1,10);
num3=num2;
num4=num2;
num_t=num2;
answer=[0 0 0];
 for i=1:10

if -12*a+18*b+10*c>0
   t=0;
elseif -12*a+18*b+10*c<0
       t=1;
else t=0.3;
end
if 50*t>wait2
    wait2=12-12*(t-wait2/50);
   
else
    wait2=12+wait2-50*t;
   
end
if 50*(1-t)>wait3
    wait3=18-18*(1-t-wait3/50);
    
else
    wait3=18+wait3-50*(1-t);
    
end
if 50*(1-t)>wait4
    wait4=10-10*(1-t-wait4/50);
   
else
    wait4=10+wait4-50*(1-t);
  
end
answer=inv([1 1 1;wait3 -1*wait2 0;wait4 0 -1*wait2])*[1,0,0]';
a=answer(1);
b=answer(2);
c=answer(3);
num2(i)=wait2;
num3(i)=wait3;
num4(i)=wait4;
num_t(i)=t;
 end
disp(mean(num2));
disp(mean(num3));
disp(mean(num4));
disp(num_t);
x=1:10;
plot(x,num2,x,num3,x,num4);
xlabel('时间');
ylabel('等待车数');
title('等待车辆数目变化')
