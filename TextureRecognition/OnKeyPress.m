function OnKeyPress(src,evnt)
if(strcmp(evnt.Key,'escape') == 1)
% if(evnt.Character == 'e')
% if((length(evnt.Modifier) == 1) & (strcmp(evnt.Modifier{:},'control')) & (evnt.Key == 'e'))
    setappdata(gcf,'canceling',1);
end;
%% EOF