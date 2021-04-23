clc 
clear all;
close all; 

%messagename=input('Enter message file name with extension:','s');
covername='3.jpg';
rate = 1;
stegomessagename='stego.txt';
cover=imread(covername);

sz=size(cover);
rows=sz(1,1);
cols=sz(1,2); 
colors=max(max(cover));

coverzero = cover;

cover=rgb2gray(cover);

blocksize=8;
quant_multiple=1;
DCT_quantizer=...
    [16 11 10 16 24 40 51 61;...
    12 12 14 19 26 58 60 55;...
    14 13 16 24 40 57 6 956;...
    14 17 22 29 51 87 80 62;...
    18 22 37 56 68 109 103 77;...
    24 35 55 64 81 104 113 92;...
    49 64 78 87 103 121 120 101;...
    72 92 95 98 112 100 103 99];

figure(2);imshow(coverzero);
title('OriginalImage');

pad_cols=(1-(cols/blocksize-floor(cols/blocksize)))*blocksize; 
if pad_cols==blocksize,pad_cols=0;
end
pad_rows=(1-(rows/blocksize-floor(rows/blocksize)))*blocksize;
if pad_rows==blocksize , pad_rows=0;
end

for extra_cols=1:pad_cols 
    coverzero(1:rows,cols+extra_cols)=coverzero(1:rows,cols);
end
cols=cols+pad_cols;%coverzeroisnowpad_colswider 
for extra_rows=1:pad_rows 
    coverzero(rows+extra_rows,1:cols)=coverzero(rows,1:cols);
end

rows= rows+pad_rows;

messagelength = floor(cols*rows*rate);
message = rand(1,messagelength);
for i=1:messagelength
    if message(i)>=0.5
        message(i)=1;
    else
        message(i)=0;
    end
end

for row=1 :blocksize:rows
    for col= 1: blocksize :cols
        DCT_matrix=coverzero(row:row+blocksize-1,col:col+blocksize-1); 
        DCT_matrix=dct2(DCT_matrix); %quantizeit(levelsstoredinDCT_quantizermatrix):
        %DCT_matrix=floor(DCT_matrix...
        % ./(DCT_quantizer(1:blocksize,1:blocksize)*quant_multiple)+0.5);
        DCT_matrix_test=(DCT_matrix./(DCT_quantizer(1:blocksize,1:blocksize)* quant_multiple));
        DCT_matrix=round(DCT_matrix./(DCT_quantizer(1:blocksize,1:blocksize)* quant_multiple)); 
        %DCT_matrix=round(DCT_matrix); 
        %placeitintothecompressed-imagematrix:
        jpeg_img_test(row:row+blocksize-1,col:col+blocksize-1)=DCT_matrix_test;
        jpeg_img(row:row+blocksize-1,col:col+blocksize-1)=DCT_matrix;
    end
end

%DCT figures
figure(3); histogram(jpeg_img);xlim([-10,10]);
figure(4);imshow(jpeg_img);


% bitlength=1;
% orijpeg=jpeg_img;
% for i=1:messagelength
%     for imbed=1:8
%         messageshift=bitshift(message(i),8-imbed);
%         showmess=uint8(messageshift);
%         showmess=bitshift(showmess,-7);
%         messagebit(bitlength)=showmess;
%         bitlength=bitlength+1;
%     end
% end

%embedding JSteg
i=1;
for row=1:rows
    for col=1:cols
        x=jpeg_img(row,col);
        if (x~=0) && (x~=1)
            r=mod(x,2);
            if r==0 
                if message(i)==1
                    if x < 0
                        x=x+1;
                    end
                    if x > 0
                        x = x - 1;
                    end
                end
            else
                if message(i)==0
                    if x < 0
                        x = x + 1;
                    end
                    if x > 0
                        x = x -1 ;
                    end
                end
            end
            if x == 0
                continue
            end
            i=i+1; 
        end
        jpeg_img(row,col)=x;
        if i==messagelength
            break;
        end
    end
    if i==messagelength
        break;
    end
end
%jsteg hist
figure(5);histogram(jpeg_img);xlim([-10,10]);
%卡方分析
kafang2(jpeg_img);
%Reconstructing Image

recon_img= coverzero-coverzero;

for row=1:blocksize:rows
    for col=1:blocksize:cols
        IDCT_matrix=jpeg_img(row:row+blocksize-1,col:col+blocksize-1);
        IDCT_matrix=round(idct2(IDCT_matrix.*(DCT_quantizer(1:blocksize,1:blocksize)*quant_multiple))); 
        recon_img(row:row+blocksize-1,col:col+blocksize-1)=IDCT_matrix;
    end
end

endrows=rows-pad_rows;
cols=cols-pad_cols; 
recon_img=recon_img(1:rows,1:cols); 

figure(6);imshow(recon_img);
imwrite(recon_img,"2.bmp");

pad_cols=(1-(cols/blocksize-floor(cols/blocksize)))*blocksize; 
if pad_cols==blocksize,pad_cols=0;end 
pad_rows=(1-(rows/blocksize-floor(rows/blocksize)))*blocksize; 
if pad_rows==blocksize,pad_rows=0;end

for extra_cols=1:pad_cols 
    recon_img(1:rows,cols+extra_cols)=recon_img(1:rows,cols);
end

cols=cols + pad_cols;

for extra_rows=1:pad_rows 
    recon_img(rows+extra_rows,1:cols)=recon_img(rows,1:cols);
end

rows=rows+pad_rows;

%coverzeroisnowpad_rowstaller 

jpeg_img=jpeg_img-jpeg_img;

for row=1:blocksize:rows
    for col=1:blocksize:cols
        DCT_matrix=recon_img(row:row+blocksize-1,col:col+blocksize-1); 
        DCT_matrix=dct2(DCT_matrix); %quantizeit(levelsstoredinDCT_quantizermatrix):%DCT_matrix=floor(DCT_matrix...% ./(DCT_quantizer(1:blocksize,1:blocksize)* quant_multiple)+0.5); 
        DCT_matrix=round(DCT_matrix./(DCT_quantizer(1:blocksize,1:blocksize)* quant_multiple)); 
        %DCT_matrix=round(DCT_matrix); 
        %placeitintothecompressed-imagematrix:jpeg_img(row:row+blocksize-1,col:col+blocksize-1)=DCT_matrix; 
        jpeg_img(row:row+blocksize-1,col:col+blocksize-1)=DCT_matrix;
    end
end

stego=jpeg_img;

figure(7);imshow(stego);
figure(8);hist(stego);

stegoindex=1;
imbed=1;
messagechar=0;
messageindex=1;
for row=1:rows
    for col=1:cols
        stegomessage = stego(row,col);
        if (stegomessage~=0) && (stegomessage~=1)
            r=mod(stegomessage,2);
            if(r==0)
                showmess=0;
            else
                showmess=1;
            end
            
            showmess=uint8(showmess);
            showmess=bitshift(showmess,(imbed-1));
            messagechar=uint8(messagechar+showmess);
            
            stegoindex = stegoindex + 1;
            
            imbed = imbed +1;
            if(imbed==9)
                messagestring(messageindex)=messagechar;
                messageindex=messageindex+1;
                messagechar=0;
                imbed=1;
            end
        end
        if(stegoindex==messagelength*8+1)
            break;
        end
    end
    if(stegoindex==messagelength*8+1)
        break;
    end
end

%disp(messagestring);
messagestringlength=length(messagestring);
stegostring=char(zeros(1,messagestringlength));
for i=1:messagestringlength
    stegostring(i)=char(messagestring(i));
end

fd1=fopen(stegomessagename,'w+');
fwrite(fd1,stegostring,'char');