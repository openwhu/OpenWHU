k = 1.380649e-23;
T = 27+273.15;
q = 1.602176565e-19;
Ut = k*T/q;
Is = 1e-14;
vb = -5;
Vd = -6:0.01:0.8;
a=Is*(exp(-5/Ut-1));
iD = (1e14*(Vd+5)+a)*1000.*(Vd>=-6&Vd<=-5)+Is*(exp(Vd/Ut-1))*1000.*(Vd >-5&Vd<=0.8);
plot(Vd,iD)
axis([-6 2 -20 20])
xlabel('Vd£¨V£©');
ylabel('iD£¨mA£©');
grid on