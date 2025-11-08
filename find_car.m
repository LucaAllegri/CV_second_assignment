function find_car(Temp, C, img, sample_n)
    [n,m] = size(C);
    [n_temp, m_temp] = size(Temp);

    seg = zeros(n,m);
    mask = C == max(C(:));%threshold on the hue componet
    seg = seg+mask;
    
    [~, linear_idx] = max(C(:));
    [row, col] = ind2sub(size(C), linear_idx);
  

    tit = sprintf("segmented object frame " + sample_n);
    figure,imagesc(seg),colormap gray, title(tit) %binary image (segmented image, i.e. detection of a given color)
    
    tit = sprintf("detected object frame " + sample_n);
    figure,imagesc(img),colormap gray,title(tit)
    hold on
    plot(col-(m_temp/2),row-(n_temp/2), '*r');
    rectangle('Position',[col-m_temp,row-n_temp,m_temp,n_temp],'EdgeColor',[1,0,0])
end