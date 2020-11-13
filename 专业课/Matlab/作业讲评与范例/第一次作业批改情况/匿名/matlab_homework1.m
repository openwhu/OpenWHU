%% 
syms a b c d m f g h n;
for a=1:4
    for b=1:9
        if b~=a
        for c=1:9
            if (c~=b)&&(c~=a)
            for d=1:9
                if (d~=b)&&(d~=a)&&(d~=c)
                for m=2:8 m~=5;
                    if (m~=a)&&(m~=b)&&(m~=c)&&(m~=d)
                    for f=1:9
                        if (f~=a)&&(f~=b)&&(f~=c)&&(f~=d)&&(f~=m)
                        for g=1:9
                            if (g~=a)&&(g~=b)&&(g~=c)&&(g~=d)&&(g~=m)&&(g~=f)
                            for h=1:9
                               if (h~=a)&&(h~=b)&&(h~=c)&&(h~=d)&&(h~=m)&&(h~=f)&&(h~=g)
                               for n=1:9
                                   if (n~=a)&&(n~=b)&&(n~=c)&&(n~=d)&&(n~=m)&&(n~=f)&&(n~=g)&&(n~=h)
                                   x=1000*a+100*b+10*c+d;
                                   y=m*x;
                                   z=1000*f+100*g+10*h+n;
                                   if y==z
                                       r=x
                                       s=m
                                       t=y
                                   end
                                   end
                               end
                               end
                            end
                            end
                        end
                        end
                    end
                    end
                end
                end
            end
            end
        end
        end
    end
end                                    
%% 
f=[7/12;1/30];
A=[1/4 -1/5;-1/2 1/3];
b=[0;0];
lb=[24;60];
[x,fval,exitflag,output]=linprog(f,A,b,[],[],lb)

%% 
H=[2/5 -49/60;-49/60,13/6];
f=[0,0];
A=[1/4 -1/5;-1/2 1/3];
b=[0;0];
lb=[24;60];
[x,fval]=quadprog(H,f,A,b,[],[],lb)