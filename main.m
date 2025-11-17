clc, clearvars, close all
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NCC-based segmentation
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------------------------------------
% RED CAR 
%------------------------------------

img{1}=im2gray(imread('Lab5_testimages/ur_c_s_03a_01_L_0376.png'));
img{2}=im2gray(imread('Lab5_testimages/ur_c_s_03a_01_L_0377.png'));
img{3}=im2gray(imread('Lab5_testimages/ur_c_s_03a_01_L_0378.png'));
img{4}=im2gray(imread('Lab5_testimages/ur_c_s_03a_01_L_0379.png'));
img{5}=im2gray(imread('Lab5_testimages/ur_c_s_03a_01_L_0380.png'));
img{6}=im2gray(imread('Lab5_testimages/ur_c_s_03a_01_L_0381.png'));

%%

figure,imagesc(img{1}),colormap gray

T{1}=img{1}(360:410,690:770);
figure,imagesc(T{1}),colormap gray;

for i=1:6
    C_red{i} = NCC_function(T{1}, img{i});
    figure, imagesc(C_red{i}), colormap gray;
end

for i=1:6
    find_car(T{1}, C_red{i}, img{i}, i);
end

%%
%------------------------------------
% DARK CAR 
%------------------------------------

T{2}=img{1}(370:410,560:642);
figure,imagesc(T{2}),colormap gray;

tic;
for i=1:6
    C_dark{i} = NCC_function(T{2}, img{i});
    figure, imagesc(C_dark{i}), colormap gray;
end

time_medium_template = toc;

for i=1:6
    find_car(T{2}, C_dark{i}, img{i},i);
end

%%
%------------------------------------
% SMALLER WINDOW
%------------------------------------

T{3}=img{1}(380:400,580:622);
figure,imagesc(T{3}),colormap gray;

tic;
for i=1:6
    C2_dark{i} = NCC_function(T{3}, img{i});
    figure, imagesc(C2_dark{i}), colormap gray;
end

time_small_template = toc;

for i=1:6
    find_car(T{3}, C2_dark{i}, img{i},i);
end


%%
%------------------------------------
% BIGGER WINDOW
%------------------------------------
T{4}=img{1}(350:430,540:662);
figure,imagesc(T{4}),colormap gray;

tic;
for i=1:6
    C3_dark{i} = NCC_function(T{4}, img{i});
    figure, imagesc(C3_dark{i}), colormap gray;
end

time_big_template = toc;

for i=1:6
    find_car(T{4}, C3_dark{i}, img{i},i);
end

%%
%------------------------------------
% PUNTO 3 
%------------------------------------



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Harris corner detection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tmp=imread('Lab5_testimages/i235.png');
I=double(tmp);
figure,imagesc(I),colormap gray

%compute x and y derivative of the image
dx=[1 0 -1; 2 0 -2; 1 0 -1]; 
dy=[1 2 1; 0  0  0; -1 -2 -1]; 


Ix=conv2(I,dx,'same'); %immagini delle derivate in direzione x
Iy=conv2(I,dy,'same'); %immagini delle derivate in direzione y
figure,imagesc(Ix),colormap gray,title('Ix')
figure,imagesc(Iy),colormap gray,title('Iy')

%compute products of derivatives at every pixel
Ix2=Ix.*Ix; Iy2=Iy.*Iy; Ixy=Ix.*Iy;

g = fspecial('gaussian', 9, 1.2); 
figure,imagesc(g),colormap gray,title('Gaussian')
Sx2=conv2(Ix2,g,'same'); Sy2=conv2(Iy2,g,'same'); Sxy=conv2(Ixy,g,'same');


%features detection
[rr,cc]=size(Sx2);
corner_reg=zeros(rr,cc);
R_map=zeros(rr,cc);
k=0.04;

for ii=1:rr
    for jj=1:cc
        %define at each pixel x,y the matrix
        M=[Sx2(ii,jj),Sxy(ii,jj);Sxy(ii,jj),Sy2(ii,jj)];
        %compute the response of the detector at each pixel
        R=det(M) - k*(trace(M).^2);
        R_map(ii,jj)=R;

        max_R_map = max(R_map(:));
        threshold = 0.3 * max_R_map;
        
        if R>threshold       
            corner_reg(ii,jj)=1;
        end
    end
end

figure,imagesc(corner_reg.*I),colormap gray,title('Corner Regions')
figure,imagesc(R_map),colormap jet,title('R map');

L= bwlabel(corner_reg);
prop=regionprops(L,'Centroid');

centroids = cat(1, prop.Centroid);

figure,imagesc(I),colormap gray,title('Detected Corners')
hold on
plot(centroids(:,1), centroids(:,2),'*r')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[rr,cc]=size(Sx2);
corner_reg=zeros(rr,cc);
R_map=zeros(rr,cc);
k=0.04;

for ii=1:rr
    for jj=1:cc
        %define at each pixel x,y the matrix
        M=[Sx2(ii,jj),Sxy(ii,jj);Sxy(ii,jj),Sy2(ii,jj)];
        %compute the response of the detector at each pixel
        R=det(M) - k*(trace(M).^2);
        R_map(ii,jj)=R;

        max_R_map = max(R_map(:));
        threshold = 0.1 * max_R_map;
        
        if R>threshold       
            corner_reg(ii,jj)=1;
        end
    end
end

L= bwlabel(corner_reg);
prop=regionprops(L,'Centroid');

centroids = cat(1, prop.Centroid);

figure,imagesc(I),colormap gray,title('Detected Corners with Lower Threshold')
hold on
plot(centroids(:,1), centroids(:,2),'*r')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

corner_reg=zeros(rr,cc);
R_map=zeros(rr,cc);
k=0.2;

for ii=1:rr
    for jj=1:cc
        %define at each pixel x,y the matrix
        M=[Sx2(ii,jj),Sxy(ii,jj);Sxy(ii,jj),Sy2(ii,jj)];
        %compute the response of the detector at each pixel
        R=det(M) - k*(trace(M).^2);
        R_map(ii,jj)=R;

        max_R_map = max(R_map(:));
        threshold = 0.3 * max_R_map;
        
        if R>threshold       
            corner_reg(ii,jj)=1;
        end
    end
end

L= bwlabel(corner_reg);
prop=regionprops(L,'Centroid');

centroids = cat(1, prop.Centroid);

figure,imagesc(I),colormap gray,title('Detected Corners with Lower k')
hold on
plot(centroids(:,1), centroids(:,2),'*r')