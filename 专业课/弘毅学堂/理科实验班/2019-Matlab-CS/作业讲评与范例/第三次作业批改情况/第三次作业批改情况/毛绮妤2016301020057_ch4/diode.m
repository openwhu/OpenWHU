function diode
%根据二极管伏安特性曲线iD= Is*(exp(Vd/UT)-1),并假设反偏击穿后i呈线性变化，斜率为1e14
%利用以下参数建立二极管的MATLAB 模型：UT=kT/q，T=27℃，Is=1e-14； vb=5；电压取值范围为（-6v,0.8v）
T = 27 + 273;
Is = 1e-14;
vb = -5;
k = 1.38e-23;
q = 1.6e-19;
UT = k*T/q;

% Vd1 = linspace(vb-1,vb,100);
% Vd2 = linspace(vb,0.8,580);
% Vd = [Vd1,Vd2];
% iD1 = Is*(exp(vb/UT)-1)+1e14*(Vd1-vb);
% iD2 = Is*(exp(Vd2/UT)-1);
% iD = [iD1,iD2];
% 
% plot(Vd,iD);
% set(gcf,'color','w');    %图表背景设为白色
% title('二极管伏安特性曲线');
% text(-6,2.8*10^13,'I/A');text(1.2,-10*10^13,'U/V');     %在轴端标注x，y轴单位

%因为坐标轴若设为均匀刻度，则无法显示出完整的曲线，所以为了将坐标轴设为不均匀刻度，我们将图像分为三个子部分
Vd1=linspace(-5-100*10^(-14),-5,100); 
Vd21=linspace(-5,0,75);
Vd22=linspace(0,0.8,100);
iD1=Is*(exp(vb/UT)-1)+1e14*(Vd1-vb);
iD21 = Is*(exp(Vd21/UT)-1);
iD22 = Is*(exp(Vd22/UT)-1);

subplot(2,2,2),plot(Vd22,iD22);
xlim([0,2]);     %限定x轴，y轴刻度显示范围
set(gca,'color','none');
set(gca,'FontSize',8.5);
box off;   %隐藏边框
text(0,0.43,'I/A');text(1.7,0,'U/V');     %标注x轴，y轴单位
text(-0.5,0.47,'二极管伏安特性曲线');     

subplot('position',[0.271,0.13383,0.3,0.45]);plot(Vd21,iD21);
ylim([-5e-14,0]);xlim([-5,0]);   %限定x轴，y轴刻度显示范围
set(gca,'color','none'); 
set(gca,'FontSize',8.5);
box off
set(gca,'xaxislocation','top');      %将x轴位置调整到上方
set(gca,'yaxislocation','right');   %将y轴位置调整到右方

subplot('position',[0.211,0.13383,0.06,0.45]);plot(Vd1,iD1);
ylim([-5e-14,0]);xlim([-6,-5]);   %限定x轴，y轴刻度显示范围
set(gca,'color','none');
set(gca,'FontSize',8.5); 
box off;   
set(gca,'xaxislocation','top');     %将x轴位置调整到上方
set(gca,'ycolor','none');     %隐藏y轴
set(gcf,'color','w');   



