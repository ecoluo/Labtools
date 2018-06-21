

saveastiff(filename);
f=getframe(gcf);
imwrite(f.cdata,[filename,'.tiff']);