function [source] = antiRsLsb(source,rate)
    [m,n] = size(source);
    for i = 1:m*n*rate
        t = 0;
        if(mod(source(i), 2)==0 && mod(i,2)==1)
            if(source(i) == 0)
                source(i) = source(i)+1;
            else
                for j=[i,i-1,i+1,i-m,i-m+1,i-m-1,i+m,i+m+1,i+m-1]
                    if(j>0 && j<= m*n)
                        t=t+source(j)-source(i);
                    end
                end
                if(t>0)
                    source(i) = source(i)+1;
                else
                    source(i) = source(i)-1;
                end
            end
        elseif(mod(source(i), 2)==1 && mod(i,2)==0)
            if(source(i) == 255)
                source(i) = source(i)-1;
            else
                for j=[i,i-1,i+1,i-m,i-m+1,i-m-1,i+m,i+m+1,i+m-1]
                    if(j>0 && j<= m*n)
                        t=t+source(j)-source(i);
                    end
                end
                if(t>0)
                    source(i) = source(i)+1;
                else
                    source(i) = source(i)-1;
                end
            end
        end
    end
end