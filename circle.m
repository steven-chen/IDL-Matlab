function circle(x,y,R)
alpha=0:pi/32:2*pi;%??[0,2*pi]
xx=R*cos(alpha);
yy=R*sin(alpha);
plot(x+xx,y+yy,'-')
%axis equal 