clc, clearvars, close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NCC-based segmentation
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------------------------------------
% RED CAR 
%------------------------------------

img{1}=im2gray(imread('Lab5_testimages\ur_c_s_03a_01_L_0376.png'));
img{2}=im2gray(imread('Lab5_testimages\ur_c_s_03a_01_L_0377.png'));
img{3}=im2gray(imread('Lab5_testimages\ur_c_s_03a_01_L_0378.png'));
img{4}=im2gray(imread('Lab5_testimages\ur_c_s_03a_01_L_0379.png'));
img{5}=im2gray(imread('Lab5_testimages\ur_c_s_03a_01_L_0380.png'));
img{6}=im2gray(imread('Lab5_testimages\ur_c_s_03a_01_L_0381.png'));

figure,imagesc(img{1}),colormap gray

T{1}=img{1}(360:410,690:770);
figure,imagesc(T{1}),colormap gray;

for i=1:6
    C_red{i} = normxcorr2(T{1}, img{i});
    figure, imagesc(C_red{i}), colormap gray;
end

for i=1:6
    fun_find_car(T{1}, C_red{i}, img{i});
end

%------------------------------------
% DARK CAR 
%------------------------------------

T{2}=img{1}(370:410,560:642);
figure,imagesc(T{2}),colormap gray;

for i=1:6
    C_dark{i} = normxcorr2(T{2}, img{i});
    figure, imagesc(C_dark{i}), colormap gray;
end

for i=1:6
    fun_find_car(T{2}, C_dark{i}, img{i});
end



%------------------------------------
% PUNTO 3 
%------------------------------------



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Harris corner detection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tmp=imread('Lab5_testimages\i235.png');
I=double(tmp);
figure,imagesc(I),colormap gray

%compute x and y derivative of the image
dx=[1 0 -1; 2 0 -2; 1 0 -1];  %MATRICI/KERNEL DEL FILTRO DI SOBEL 
dy=[1 2 1; 0  0  0; -1 -2 -1]; %PER L'APPROSSIMAZIONE DELLE DERIVATE SPAZIALI
%dx rileva i bordi verticali
%dy rileva i bordi orizzontali

Ix=conv2(I,dx,'same'); %immagini delle derivate in direzione x
Iy=conv2(I,dy,'same'); %immagini delle derivate in direzione y
figure,imagesc(Ix),colormap gray,title('Ix')
figure,imagesc(Iy),colormap gray,title('Iy')

%compute products of derivatives at every pixel
Ix2=Ix.*Ix; Iy2=Iy.*Iy; Ixy=Ix.*Iy;
%calcola i componenti della matrice di auto-correlazione

%compute the sum of products of  derivatives at each pixel
g = fspecial('gaussian', 9, 1.2); %crea un filtro gaussiano 9x9 con deviazione 1,2
figure,imagesc(g),colormap gray,title('Gaussian')
Sx2=conv2(Ix2,g,'same'); Sy2=conv2(Iy2,g,'same'); Sxy=conv2(Ixy,g,'same');
% convoluzione con il gaussiano (smoothing), somma pesata di una finestra
% crea gli elementi smussati della matrice di struttura locale M


%features detection
[rr,cc]=size(Sx2);
edge_reg=zeros(rr,cc); corner_reg=zeros(rr,cc); flat_reg=zeros(rr,cc);
R_map=zeros(rr,cc);
k=0.05;

for ii=1:rr
    for jj=1:cc
        %define at each pixel x,y the matrix
        M=[Sx2(ii,jj),Sxy(ii,jj);Sxy(ii,jj),Sy2(ii,jj)];
        %compute the response of the detector at each pixel
        R=det(M) - k*(trace(M).^2);
        R_map(ii,jj)=R;
        %threshod on value of R
        if R<-300000        %negativa qunado uno è alto e uno è basso 
            edge_reg(ii,jj)=1;
        elseif R>3000000     %alta qunado entrambi gli autovalori sono alti
            corner_reg(ii,jj)=1;
        else
            flat_reg(ii,jj)=1;   %vicina a zero qunado entrambi gli autovalori sono bassi
        end
    end
end

figure,imagesc(edge_reg.*I),colormap gray,title('edge regions')
figure,imagesc(corner_reg.*I),colormap gray,title('corner regions')
figure,imagesc(flat_reg.*I),colormap gray,title('flat regions')
figure,imagesc(R_map),colormap gray,title('R map')