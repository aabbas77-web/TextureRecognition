function [dst] = put_image(src,img,x0,y0,transparent_color,th)
[h,w] = size(src);
[ih,iw] = size(img);
dst = src;
for y=y0:y0+ih-1
    for x=x0:x0+iw-1
        if((x >= 1) && (x <= w) && (y >= 1) && (y <= h))
            c = img(y-y0+1,x-x0+1);
            if(abs(c - transparent_color) > th)
                dst(y,x) = c;
            end;
        end;
    end;
end;
%% EOF