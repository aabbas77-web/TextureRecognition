function [dst,rect] = select_rect(src,h,w,is_resizable)
global scale;
figure;
set(gcf,'KeyPressFcn',@OnKeyPress);
set(gcf,'CloseRequestFcn','setappdata(gcbf,''canceling'',1)');
setappdata(gcf,'canceling',0);
imshow(src,'InitialMagnification',scale);
rect = [1 1 w-1 h-1];
% h_rect = imrect(gca,rect);
h_rect = imellipse(gca,rect);
setResizable(h_rect,is_resizable);
setFixedAspectRatioMode(h_rect,1);
api = iptgetapi(h_rect);
X = get(gca,'XLim');
Y = get(gca,'YLim');
X(1) = X(1)+1;
X(2) = X(2)-1;
Y(1) = Y(1)+1;
Y(2) = Y(2)-1;
fcn = makeConstrainToRectFcn('imrect',X,Y);
api.setDragConstraintFcn(fcn);
while(1)
    drawnow;
    if(getappdata(gcf,'canceling'))
        break;
    end;
end;
rect = round(api.getPosition());
api.delete();
delete(gcf);
dst = imcrop(src,rect);
%% EOF