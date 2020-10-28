a=perms(1:1:9);
answer=[];
x=0;
c1=0;
c2=0;
c3=0;
[n,m]=size(a);
for j=1:1:n
for i=1:1:4
    c1=c1+a(j,i)*10^(4-i);
end
c2=a(j,5);
for i=6:1:9
    c3=c3+a(j,i)*10^(9-i);
end
p=c1*c2;
if p==c3
    x=x+1;
    answer(x,:)=[c1 c2 c3];
else 
end
c1=0;
c2=0;
c3=0;
end
