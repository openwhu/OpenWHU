clc;
close all;
clear;
x=zeros(100,100);
for k=15:1:60 %从15秒开始，避免红绿灯时长过短不符合实际情况
  for j=15:1:60
      if(k>=2*(1/5)*j) %在此做判断，避免红绿灯无法将上次红灯积累的小车全部放走导致小车越积越多
          y1=floor(j/5)+ceil((k-2*floor(j/5))/5);
          %红绿灯由绿变红时正在过街的小车看作是已经完全过街；红绿灯由红变绿时新加入的小车不计入积累小车数
      else
          break
      end
      if(j>1.5*0.3*k)
          y2=floor(0.3*k)+ceil(0.3*(j-1.5*floor(0.3*k)));
      else 
          continue
      end
      y3=floor(0.1*k)+ceil(0.1*(j-0.75*floor(0.1*k)));
      y=(y1+y2+y3)/(k+j);
      x(k,j)=y;
  end
end
max(max(x))