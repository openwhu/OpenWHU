clear all;
img = imread('1_grey.png');
data = zeros(9,11);
j = -0.1;
for i=1:11
    j = j+0.1;
    data(1,i) = j;
    newimg = lsb(img,j);
    [data(2,i),data(3,i),data(4,i),data(5,i)]=rs(newimg);
    newimg = antiRsLsb(img,j);
    [data(6,i),data(7,i),data(8,i),data(9,i)]=rs(newimg);
end
% 创建 figure
figure1 = figure;

% 创建 axes
axes1 = axes('Parent',figure1,...
    'Position',[0.1 0.1 0.8 0.8]);
hold(axes1,'on');

% 使用 plot 的矩阵输入创建多行
plot1 = plot(data(1,:),data(2:5,:),'Parent',axes1);
set(plot1(1),'DisplayName','R_m', 'lineWidth', 2);
set(plot1(2),'DisplayName','S_m', 'lineWidth', 2);
set(plot1(3),'DisplayName','R_{-m}', 'lineWidth', 2);
set(plot1(4),'DisplayName','S_{-m}', 'lineWidth', 2);

% 创建 xlabel
xlabel({'嵌入率'});

% 创建 title
title({'嵌入率对RS的影响'});

% 创建 ylabel
ylabel({'R,S'});

box(axes1,'on');
% 创建 legend
legend1 = legend(axes1,'show');
% set(legend1,...
%     'Position',[0.349001735862759 0.699247595483372 0.0371093752483527 0.147998299671803]);

% % 创建 axes
% axes2 = axes('Parent',figure1,...
%     'Position',[0.584427083333334 0.105741056218058 0.263229166666665 0.815]);
% hold(axes2,'on');

% % 使用 plot 的矩阵输入创建多行
% plot2 = plot(data(1,:),data(6:9,:));
% set(plot2(1),'DisplayName','R+');
% set(plot2(2),'DisplayName','S+');
% set(plot2(3),'DisplayName','R-');
% set(plot2(4),'DisplayName','S-');
% 
% % 创建 xlabel
% xlabel({'隐写率'});
% 
% % 创建 title
% title({'抗RS分析的隐写方法'});
% 
% % 创建 ylabel
% ylabel({'R,S比率'});
% 
% box(axes2,'on');
% % 创建 legend
% legend2 = legend(axes2,'show');
% set(legend2,...
%     'Position',[0.802126735862759 0.608957987306201 0.0371093752483526 0.147998299671803]);