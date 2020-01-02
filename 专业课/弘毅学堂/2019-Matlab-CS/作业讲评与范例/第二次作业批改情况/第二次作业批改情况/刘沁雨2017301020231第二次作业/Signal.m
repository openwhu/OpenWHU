function Signal=Signal(A,W,Phase,c,d,t0,t1,N)
    t=linspace(t0,t1,N);
    Data=exp(c*t)+exp(d*t)*A.*sin(W*t+Phase);
    Signal=[t'  Data'];
end
