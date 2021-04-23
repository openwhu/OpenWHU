function [ S,P_value ] = kafang2( image)
% 函数功能：先对图像以嵌入率为rate进行顺序LSB嵌入，然后进行卡方隐写分析
% 输入参数：input是原始图像，rate是嵌入率，取值在[0,1]
% 输出参数：S存放卡方统计值，P保存对应的p值，即观察值与估计值相似程度的概率
% 调用例子：[ S,P_value ] = kafang( 'livingroom.tif',0.5 )
%读一幅图像

ste_cover=image; 
[m,n]=size(ste_cover); 

for i = 1 : 1 : m
    for j = 1 : 1 : n
        if ste_cover(i, j) < 0
            ste_cover(i, j) = 256 + ste_cover(i, j);
        end
    end
end

 %将ste_cover转换为uint8类型，使得imhist可以正常工作
 ste_cover=uint8( ste_cover);
 
 S=[];
 P_value=[];
 
 %将图像按5%的分割，一共分成20份
 interval=n/10;
 for j=0:9
    h=imhist(ste_cover(:,floor(j* interval)+1:floor((j+1)* interval)));
    h(1) = 0;
    h(2) = 0;
    h_length=size(h);
    p_num=floor(h_length/2);   
    Spov=0; %记录卡方统计量
    K=0;
    for i=1:p_num
        if(h(2*i-1)+h(2*i))~=0
            Spov=Spov+(h(2*i-1)-h(2*i))^2/(2*(h(2*i-1)+h(2*i))); 
            K=K+1;
        end
    end
    %Spov为卡方统计量，K-1为自由度
    P=1-chi2cdf(Spov,K-1);   
    
    if j~=0
      Spov=Spov+S(j); %若不注释则为累计卡方统计量 
    end
    
    S=[S Spov];
    P_value=[ P_value P];
 end

%显示变化曲线，x_label是横坐标，代表分析样本占整幅图像的百分比
x_label=0.1:0.1:1;
figure,
plot(x_label,P_value,'LineWidth',2),title('p值与分析图像的像素比例关系');
xlabel('分析图像的像素比例');
ylabel('p值');
ylim([0, 1])

