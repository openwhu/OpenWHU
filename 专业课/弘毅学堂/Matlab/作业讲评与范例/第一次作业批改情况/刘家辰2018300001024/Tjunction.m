
clear


%%车流量赋值

ac=input('a车道车流量:');
bc=input('b车道车流量:');
cc=input('c车道车流量:');
dc=input('d车道车流量:');



%%单车道车流容纳量赋值
flag=0;
while flag==0
rcp=input('单车道车流容纳量:');
flag=1;
if(rcp<max([ac,bc,cc,dc]))
    sprintf('单车道容纳量小于单车道车流量，不合理！请重新输入！')
    flag=0;
end
end

%%车辆启动时间赋值

d=input('车辆启动时间(s):');



fun=@(x)(600/(x(1)+x(2)))*(0.5*bc*(1+bc/(rcp-bc))*(x(1)+d)*(x(1)+d)+0.5*(cc*(1+cc/(rcp-cc))+dc*(1+dc/(rcp-dc)))*(x(2)+d)*(x(2)+d));


lb=[d,d];
ub=[Inf,Inf];

A=[bc bc-rcp;cc-rcp cc;dc-rcp dc];
b=[-d*(rcp+bc);-d*(rcp+cc);-d*(rcp+dc)];



[t,T,exitflag]=fmincon(fun,[d;d],A,b,[],[],lb,ub);


if exitflag==1
    sprintf('2车道红灯时间%fs绿灯时间%fs\n3,4车道红灯时间%fs绿灯时间%fs',t(1),t(2),t(2),t(1))
else if exitflag==-2
    sprintf('当前道路车流量情况必定导致拥堵！')
    end
end
