function result=traffic(v2,v3,v4)
result=[];
for t0=30:10:60
    for p=0.1:0.1:0.9
    N2=0;N3=0;N4=0;
    n2=0;n3=0;n4=0;
    T=0;
for t=1:1:3600
        if floor(t/5)>n2
            N2=N2+1;
            n2=n2+1;
        else
        end
        if floor(t/10*3)>n3
            N3=N3+1;
            n3=n3+1;
        else
        end
        if floor(t/6)>n4
            N4=N4+1;
            n4=n4+1;
        else
        end
        if 1<=mod(t,t0)&&mod(t,t0)<=(p*t0)
            k2=floor(mod(t,t0)/(1/v2))-floor(mod(t-1,t0)/(1/v2));
            N2=N2-k2;
            if N2<0
                N2=0;
            else
            end
        else
        end
        if mod(t,t0)>(p*t0)
            k3=floor((mod(t,t0)-p*t0)/(1/v3))-floor((mod(t-1,t0)-p*t0)/(1/v3));
            N3=N3-k3;
            if N3<0
                N3=0;
            else
            end
            k4=floor((mod(t,t0)-p*t0)/(1/v4))-floor((mod(t-1,t0)-p*t0)/(1/v4));
            N4=N4-k4;
            if N4<0
                N4=0;
            else
            end
        else 
            k3=floor(t0*(1-p)/(1/v3))-floor((t0*(1-p)-1)/(1/v3));
            N3=N3-k3;
            if N3<0
                N3=0;
            else
            end
            k4=floor(t0*(1-p)/(1/v4))-floor((t0*(1-p)-1)/(1/v4));
            N4=N4-k4;
            if N4<0
                N4=0;
            else
            end
        end
        T=T+N2+N3+N4;
end
    T_average=T/(40*60);
        result(floor((t0-20)/10),floor(p/0.1))=T_average;
    end
end
x=30:10:60;y=0.1:0.1:0.9;
surf(y,x,result);