function C = NCC_function(template,img)
    C = normxcorr2(template, img);
end