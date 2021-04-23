function[rp, sp, rn, sn, rate] = rstest(img)
    img_1 = bitxor(img,1);
    
    [rp, sp, rn, sn]=rs(img);
    [rp1, sp1, rn1, sn1]=rs(img_1);
    
    d0 = rp-sp;
    d1 = rp1-sp1;
    d_0 = rn-sn;
    d_1 = rn1-sn1;
    
    delta = (d_0 - d_1 - d1 - 3d0)^2 - 4*2*(d1+d0)*(d0-d_0);
    x1 = (-(d_0 - d_1 - d1 - 3d0)+sqrt(delta))/(2*2*(d1+d0));
    x2 = (-(d_0 - d_1 - d1 - 3d0)-sqrt(delta))/(2*2*(d1+d0));
    
    if (rp-sp) < (rn-sn)
        disp('是隐藏之后的');
    else
        disp('是隐藏之前的');
    end
    
    if abs(x1)<abs(x2)
        p = x1/(x1-1/2);
    else
        p = x2/(x2-1/2);
    end
    disp(p);
    
    rate = p * 2;

