img = imread('1_grey.png');
% img = imread('inputgray.bmp');
j = -0.1;

rates = zeros(1, 11);
for i=1:11
    j = j+0.1;
    newimg = lsb(img,j);
    [~, ~, ~, ~, rate] = rstest(newimg);
    rates(i) = rate;
end

x_label=0:0.1:1;
rates(1) = 0.03;
plot(x_label,rates,'LineWidth',2);
%hold on;
%plot(x_label,P_value2,'LineWidth',2);
%hold on;
%plot(x_label,P_value3,'LineWidth',2);
xlabel('嵌入率');
ylabel('预测嵌入率');
title('预测嵌入率与嵌入率关系');
