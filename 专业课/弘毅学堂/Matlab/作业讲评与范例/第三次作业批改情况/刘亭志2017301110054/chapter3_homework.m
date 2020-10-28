Vd=-6:0.01:0.8; 
iD=zeros(size(Vd)); 
k=1.38*10^(-23);T=273.15+27;q=1.602*10^(-19);UT=k*T/q;is=exp(-14);Ub=-5;K=exp(14);
for i=1:length(Vd)  
    if (Vd(i)>=-5)
        iD(i)=is*(exp(Vd(i)/UT)-1);
    else
        iD(i)=K*(Vd(i)-Ub)+is*(exp(Ub/UT)-1);
    end
end

plot(Vd,iD,'b');
xlabel('Vd(V)');ylabel('iD(A)');
grid on;