clc;
clear;
close all;

[filename,pathname]=uigetfile({'*.*','All Files (*.*)'},'Pick a file');
file = strcat(pathname,filename);

input=inputdlg({'width','height','bit per pixel','CFA patterns(1~4)'});
col=str2num(input{1});
row=str2num(input{2});
bpp=str2num(input{3});
pattern=str2num(input{4});

fid=fopen(file,'rb');

% Bayer=fread(fid,[col,row],'uint8');
Bayer=fread(fid);
fclose(fid);
% Bayer=uint8(Bayer);

Bayer=reshape(Bayer,col,row);
Bayer=Bayer';
Bayer=Bayer/(2^bpp-1);

figure(1);
imshow(Bayer)

imwrite(Bayer,'bayer.jpg');

% CFA patterns
switch pattern
    case 1
        % R  Gr
        % Gb B
        r=Bayer(1:2:row,1:2:col);
        g(:,2:2:col)=Bayer(1:2:row,2:2:col);
        g(:,1:2:col)=Bayer(2:2:row,1:2:col);
        b=Bayer(2:2:row,2:2:col);
    case 2
        % Gr R
        % B  Gb
        r=Bayer(1:2:row,2:2:col);
        g(:,1:2:col)=Bayer(1:2:row,1:2:col);
        g(:,2:2:col)=Bayer(2:2:row,2:2:col);
        b=Bayer(2:2:row,1:2:col);
    case 3
        % B  Gb
        % Gr R
        r=Bayer(2:2:row,2:2:col);
        g(:,2:2:col)=Bayer(2:2:row,1:2:col);
        g(:,1:2:col)=Bayer(1:2:row,2:2:col);
        b=Bayer(1:2:row,1:2:col);
    case 4
        % Gb B
        % R  Gr
        r=Bayer(2:2:row,1:2:col);
        g(:,1:2:col)=Bayer(2:2:row,2:2:col);
        g(:,2:2:col)=Bayer(1:2:row,1:2:col);
        b=Bayer(1:2:row,2:2:col);
    otherwise
        errordlg('CFA patterns select err','err');
end

% r=reshape(r,240,320);
% g=reshape(g,row,320);
% b=reshape(b,240,320);

R=imresize(r,[row col],'bicubic');
G=imresize(g,[row col],'bicubic');
B=imresize(b,[row col],'bicubic');
I_color(:,:,1)=R;%����ת,��ֵ����һ��ƽ��
I_color(:,:,2)=G;%����ת����ֵ���ڶ���ƽ��
I_color(:,:,3)=B;%����ת����ֵ��������ƽ��

% R=imresize(r,[col row],'bicubic');
% G=imresize(g,[col row],'bicubic');
% B=imresize(b,[col row],'bicubic');
% I_color(:,:,1)=R';%����ת,��ֵ����һ��ƽ��
% I_color(:,:,2)=G';%����ת����ֵ���ڶ���ƽ��
% I_color(:,:,3)=B';%����ת����ֵ��������ƽ��


figure(2);
imshow(I_color)

[filenameOut,pathnameOut]=uiputfile('*.jpg','Save file name');
fileOut = strcat(pathnameOut,filenameOut);
imwrite(I_color,fileOut);

% subplot(2,2,1)
% imshow(I_color)
% title('ԭͼ');
% I_color_c=imresize(I_color,[row col],'bicubic');
% I_color_c2=imresize(I_color,[row col],'nearest');
% I_color_c3=imresize(I_color,[row col],'bilinear');
% subplot(2,2,2)
% imshow(I_color_c)
% title('��˫���β�ֵ���col*rowͼ');
% subplot(2,2,3)
% imshow(I_color_c2)
% title('������ڲ�ֵ���col*rowͼ');
% subplot(2,2,4)
% imshow(I_color_c3)
% title('��˫���Բ�ֵ���col*rowͼ');
