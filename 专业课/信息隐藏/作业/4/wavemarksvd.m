% 函数功能: 本函数将完成 W-SVD 模型下数字水印的嵌入 
% 输入格式举例:
%[ watermarkimagergb, watermarkimage, waterCA, watermark, correlationU, correlationV] = wavemarksvd( ′ c: \lenna. jpg′ , ′ c: \test. png′ , 1983, ′ db6′ , 2,0.1,0. 99) 
% 参数说明:
% input 为输入原始图像 
% seed 为随机数种子 
% wavelet 为使用的小波函数 
% level 为小波分解的尺度 
% alpha 为水印强度 
% ratio 为算法中 d /n 的比例 
% watermarkimagergb 为加有水印的结果
% watermarkimage 为单层加水印的结果 
% waterCA 为加有水印模板的低频分解系数 
% watermark2 为由水印模板直接重构得到的水印形态, 仅便于直观认识, 本身无意义。 
% correlationU, correlationV 为替换正交矩阵后与未替换的正交矩阵的相关系数
function [watermarkimagergb, watermarkimage, waterCA, watermark, correlationU, correlationV]= wavemarksvd( input, goal, seed, wavelet, level, alpha, ratio)
% function watermark = wavemarksvd( input, goal, seed, wavelet, level, alpha, ratio)
% 读取原始图像
data = imread(input) ;
data = double(data)/255; 
datared = data(:,:,1) ;
% 在 R 层加水印 
% 对原始图像的 R 层进行小波分解记录原始大小, 并将其补成正方形
[C,Sreal] = wavedec2( datared,level,wavelet) ;
[row, list] = size(datared) ;
standard1 = max( row, list) ;
new = zeros( standard1, standard1) ;
if row <= list  
    new( 1:row,:) = datared;
else
    new(:,1:list) = datared;
end 
% 正式开始加水印 
% 小波分解, 提取低频系数
[C, S] = wavedec2(new,level,wavelet);
CA = appcoef2(C,S,wavelet,level); 
% 对低频系数进行归一化处理
[M,N] = size( CA) ;
CAmin = min(min( CA) ) ;
CAmax = max(max( CA) ) ;
CA = (1/( CAmax - CAmin) ) * ( CA - CAmin) ;
d = max(size(CA) ) ; 
% 对低频率系数单值分解
[U,sigma,V] =svd(CA); 
% 按输出参数得到要替换的系数的数量
np = round( d* ratio) ; 
% 以下是随机正交矩阵的生成 rand( ′ seed′ , seed) ;
rand('seed', seed)
M_V = rand( d, np) - 0.5;
[ Q_V, R_V] = qr( M_V, 0) ;
M_U = rand( d, np) - 0.5;
[ Q_U, R_U] = qr( M_U, 0) ;
% 替换
V2 = V; 
U2 = U; 
V(:, d - np +1: d) = Q_V(:, 1: np) ; 
U(:, d - np +1: d) = Q_U(:, 1: np) ;
sigma_tilda = alpha* flipud(sort( rand( d, 1))) ; 
correlationU = corr2( U, U2) ; 
% 计算替换的相关系数
correlationV = corr2( V, V2) ; 
% 生成水印 
watermark = U* diag( sigma_tilda, 0) * V' ; 
% 重构生成水印的形状, 便于直观认识, 本身无意义
watermark2 = reshape( watermark,1,S(1,1) * S( 1, 2) ) ;
waterC = C;
waterC( 1, 1: S( 1, 1) * S( 1, 2) ) = watermark2;
watermark2 = waverec2( waterC, S, wavelet) ; 
% 调整系数生成嵌入水印后的图像
CA_tilda = CA + watermark;
over1 = find( CA_tilda > 1) ;
below0 = find( CA_tilda < 0) ;
CA_tilda( over1) = 1;
CA_tilda( below0) = 0; 
% 系数调整, 将过幅系数与负数修正 
CA_tilda = ( CAmax-CAmin) * CA_tilda +CAmin; 
%系数还原到归一化以前的范围 
% 记录加有水印的低频系数
waterCA = CA_tilda;
if row <= list  
    waterCA = waterCA(1:Sreal(1,1),:) ;
else
    waterCA = waterCA(:,1:Sreal(1,2) ) ;
end 
% 重构
CA_tilda = reshape( CA_tilda, 1, S( 1, 1) * S( 1,2) ) ;
C( 1, 1:S( 1, 1) * S( 1, 2) ) = CA_tilda;
watermarkimage = waverec2( C, S, wavelet) ; 
% 将前面补上的边缘去掉
if row <= list  
    watermarkimage = watermarkimage( 1:row,:) ;
else
    watermarkimage = watermarkimage(:, 1:list) ;
end
watermarkimagergb = data; 
watermarkimagergb(:,:,1) = watermarkimage; 
imwrite( watermarkimagergb, goal,'BitDepth' ,8) ; 
% 通过写回修正过幅系数
watermarkimagergb2 = imread(goal) ;
figure(1) ; 
subplot( 321) ; imshow( watermark2*255) ; title('水印形态图' ) ; 
subplot( 323) ; imshow( data) ; title( ' 原始图像' ) ; 
subplot( 324) ; imshow( watermarkimagergb2) ; title( '嵌入水印后的 RGB 图像' ) ; 
subplot( 325) ; imshow( datared) ; title('R 层图像' ) ;
subplot( 326) ; imshow( watermarkimage) ; title( ' 嵌入水印后的 R 层图像' ) ; 