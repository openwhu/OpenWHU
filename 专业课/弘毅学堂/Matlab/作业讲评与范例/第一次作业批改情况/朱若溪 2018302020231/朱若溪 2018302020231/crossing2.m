t=0;
a=0.3;
b=0.45;
c=0.25;
wait2=0;
wait3=0;
wait4=0;
num2=ones(1,20);
num3=num2;
num4=num2;
num_t=num2;

 for i=1:20
f=12*a+a*wait2+b*wait3+c*wait4+(-12*a+18*b+10*c)*t;
if -12*a+18*b+10*c>0
   t=0;
elseif -12*a+18*b+10*c<0
       t=1;
else t=0.3;
end
wait2=wait2+12-12*t;
wait3=wait3+18*t;
wait4=wait4+10*t;
if (wait2>wait3)&(wait2>wait3)
    a=1; b=0; c=0;
elseif (wait3>=wait2)&(wait3>=wait4)
    a=0; b=1; c=0;
else
    a=0; b=0; c=1;
end
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
