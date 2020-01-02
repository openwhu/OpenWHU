clear


%%车流量赋值
nc=zeros(1,8);
nc(1)=input('nss车道车流量:');
nc(2)=input('nsl车道车流量:');
nc(3)=input('sns车道车流量:');
nc(4)=input('snl车道车流量:');
nc(5)=input('wes车道车流量:');
nc(6)=input('wel车道车流量:');
nc(7)=input('ews车道车流量:');
nc(8)=input('ewl车道车流量:');

%%单车道车流容纳量赋值
flag=0;
while flag==0
n=input('单车道车流容纳量:');
flag=1;
if n<max(nc)
    sprintf('单车道容纳量小于单车道车流量，不合理！请重新输入！')
    flag=0;
end
end


%%车辆启动时间赋值

d=input('车辆启动时间(s):');



%%红灯时间上下限

lb=ones(1,9);
ub=Inf*ones(1,9);

%%规划初始值
t0=ones(1,9);

%%不等约束限制
A=zeros(8,9);
for i=1:8
    A(i,i)=n;
    A(i,9)=nc(i)-n;
end
b=-n*d*ones(8,1);

%%等式约束限制
Aeq=zeros(5,9);
Aeq(1,1)=1;Aeq(2,2)=1;Aeq(3,5)=1;Aeq(4,6)=1;
Aeq(1,3)=-1;Aeq(2,4)=-1;Aeq(3,7)=-1;Aeq(4,8)=-1;
Aeq(5,:)=1;Aeq(5,9)=-6;
beq=zeros(5,1);


%%目标函数
nc9=[nc 0];
fun=@(x)(1/x(9))*(sum(0.5*(x+d).*(x+d).*nc9.*(1+nc9./(n-nc9))));


%%规划函数
[t,T,exitflag]=fmincon(fun,t0,A,b,Aeq,beq,lb,ub);

%%结果输出

if exitflag==1
    sprintf('南北直行车道红灯时间%fs绿灯时间%fs\n南北左转车道红灯时间%fs绿灯时间%fs\n东西直行车道红灯时间%fs绿灯时间%fs\n东西左转车道红灯时间%fs绿灯时间%fs',t(1),t(9)-t(1),t(2),t(9)-t(2),t(5),t(9)-t(5),t(6),t(9)-t(6))
else if exitflag==-2
    sprintf('当前道路车流量情况必定导致拥堵！')
    end
end