global t1;
global t2;
t=0.8;
t2=0:1:80;
t1=(t*(t2))/(3-t);
T=80-t2;
if t<=0|t>=60/18|t2<=T*t*18/60
    disp('eror'),end
plot(t2,t1,'g',t2,T,'r')