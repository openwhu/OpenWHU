clear



r=1;

for i=1234:4987
   for j=2:9
      flag1=0;
      k=1;
      c=i*j;
      if c<10000
          str=sprintf('%d',i,j,c);
          flag1=1;
      end
      
      %%判断0不存在
      t=strfind(str,'0');
      if length(t)~=0
          flag1=0;
      end
      
      %%判断1-9存在且仅存在一次
      while k<10&flag1==1
          aim=sprintf('%d',k);
          t=strfind(str,aim);
          if length(t)~=1
              flag1=0;
          end
          k=k+1;
      end
      
      
      %%结果存储与输出
      if flag1==1
          result(r,:)=[i,j,c];
          r=r+1;
          sprintf('%dx%d=%d',i,j,c)
      end
   end
end