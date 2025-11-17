function [corner_reg,R_map,centroids] = Harris_function(I,k,t)

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
    
    for ii=1:rr
        for jj=1:cc
            %define at each pixel x,y the matrix
            M=[Sx2(ii,jj),Sxy(ii,jj);Sxy(ii,jj),Sy2(ii,jj)];
            %compute the response of the detector at each pixel
            R=det(M) - k*(trace(M).^2);
            R_map(ii,jj)=R;
    
            max_R_map = max(R_map(:));
            threshold = t * max_R_map;
            
            if R>threshold       
                corner_reg(ii,jj)=1;
            end
        end
    end

    L= bwlabel(corner_reg);
    prop=regionprops(L,'Centroid');
    
    centroids = cat(1, prop.Centroid);

end