function [ ] = center_fig( h )
pos=get(h, 'Position');
screensize = get(0, 'ScreenSize');
pos(1) = ceil((screensize(3) - pos(3))/2);
pos(2) = ceil((screensize(4) - pos(4))/2);
set(h, 'Position', pos);
end

