W = imread('lena_gray.bmp');
W = double(W)/255;
W_1 = W(100:200,100:200);
imwrite(W_1,'watermark.bmp');
disp('1');