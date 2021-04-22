function count = kafang(input)
ste_cover = imread(input);
count=imhist(ste_cover);
h_length=size(count);
p_num=floor(h_length/2);   
r=0; %记录卡方统计量
K=0;
p_num = p_num-1;
for i=1:p_num
    if(count(2*i-1)+count(2*i))~=0
        r=r+(count(2*i-1)-count(2*i))^2/(2*(count(2*i-1)+count(2*i))); 
        K=K+1;
    end
end
    %r为卡方统计量，K-1为自由度
flag = chi2cdf(r,K-1);
P=1-flag;   
   
disp (P);

if P>0.8
    disp('图像是信息隐藏之后的');
else
    disp('图像是信息隐藏之前的');
end


end


