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

[corner_reg, R_map,centroids] = Harris_function(I , 0.04 , 0.3);

figure,imagesc(corner_reg.*I),colormap gray,title('Corner Regions')
figure,imagesc(R_map),colormap jet,title('R map');

figure,imagesc(I),colormap gray,title('Detected Corners')
hold on
plot(centroids(:,1), centroids(:,2),'*r')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[corner_reg, R_map,centroids] = Harris_function(I , 0.04 , 0.1);

figure,imagesc(I),colormap gray,title('Detected Corners with Lower Threshold')
hold on
plot(centroids(:,1), centroids(:,2),'*r')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[corner_reg, R_map,centroids] = Harris_function(I , 0.2 , 0.3);

figure,imagesc(I),colormap gray,title('Detected Corners with Higher k')
hold on
plot(centroids(:,1), centroids(:,2),'*r')