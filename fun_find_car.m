function fun_find_car(Temp, C, img)
    [n,m] = size(C);
    [n_temp, m_temp] = size(Temp);

    seg = zeros(n,m);
    mask = C == max(C(:));%threshold on the hue componet
    seg = seg+mask;
    
    [max_val, linear_idx] = max(C(:));
    [row, col] = ind2sub(size(C), linear_idx);

    figure,imagesc(seg),colormap gray, title('segmented object (blob)') %binary image (segmented image, i.e. detection of a given color)

    figure,imagesc(img),colormap gray,title('detected object')
    hold on
    plot(col-(m_temp/2),row-(n_temp/2), '*r');
    rectangle('Position',[col-m_temp,row-n_temp,m_temp,n_temp],'EdgeColor',[1,0,0])
end