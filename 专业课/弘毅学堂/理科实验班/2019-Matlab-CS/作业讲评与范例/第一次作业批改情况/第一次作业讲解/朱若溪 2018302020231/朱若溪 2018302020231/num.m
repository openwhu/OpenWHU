mat=perms([1:1:9]);%生成全排列

for i=5*factorial(8)+1:factorial(9)%从4开头的排列开始检验
       vec=mat(i,:);
       if (vec(1)>=5)||(vec(4)==1)||(vec(5)==1)
       elseif ((1000*vec(1)+100*vec(2)+10*vec(3)+vec(4))*vec(5)==1000*vec(6)+100*vec(7)+10*vec(8)+vec(9))
              disp(sprintf('%d%d%d%d*%d = %d%d%d%d',vec(1),vec(2),vec(3),vec(4),vec(5),vec(6),vec(7),vec(8),vec(9)))
             
       
       end 
end

