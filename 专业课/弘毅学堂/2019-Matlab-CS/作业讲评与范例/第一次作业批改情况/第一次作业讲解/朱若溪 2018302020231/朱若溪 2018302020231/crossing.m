
t=0;%初始化2车道绿灯时间
a=0.3;%根据初始车流量初始化偏好因数
b=0.45;
c=0.25;
wait2=0;%初始化车队长度
wait3=0;
wait4=0;
num2=ones(1,20);%初始化数列
num3=num2;
num4=num2;
num_t=num2;
answer=[0 0 0];
 for i=1:20
%目标函数f=a*（12*(1-t)+wait2)+b*(18*t+wait3)+c*(10*t+wait4)=12*a+a*wait2+b*wait3+c*wait4+(-12*a+18*b+10*c)*t;
if -12*a+18*b+10*c>0
   t=0;
elseif -12*a+18*b+10*c<0
       t=1;
else t=0.3;
end
wait2=wait2+12-12*t;
wait3=wait3+18*t;
wait4=wait4+10*t;
%求解三元线性方程组：a+b+c=1, a:b:c=wait2:wait3:wait4
answer=inv([1 1 1;wait3 -1*wait2 0;wait4 0 -1*wait2])*[1,0,0]';
a=answer(1);
b=answer(2);
c=answer(3);
num2(i)=wait2;
num3(i)=wait3;
num4(i)=wait4;
num_t(i)=t;
 end
disp(num2);
disp(num3);
disp(num4);
disp(num_t);
x=1:20;
plot(x,num2,x,num3,x,num4);
xlabel('时间');
ylabel('等待车数');
title('等待车辆数目变化')
