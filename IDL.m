%
close all; clear all; clc;
boundary = 0.5;
AP = [1,1;1,-1;-1,-1;-1,1]*10;
%AP = [2,1;2,-1;-2,-1;-2,1]*2;
%AP = [1,1;1,-1;-sqrt(3)+1,0;]*2;
%AP = [2,2;2,-2;-2*sqrt(3)+2,0;1,1;1,-1;-sqrt(3)+1,0];
%polyarea(AP(:,1),AP(:,2));

figure;
hold on;
h=fill(AP(:,1)+boundary,AP(:,2)+boundary,'w');
set(h,'edgealpha',0);
h=fill(AP(:,1)-boundary,AP(:,2)-boundary,'w');
set(h,'edgealpha',0);


h=fill(AP(:,1),AP(:,2),'b');
set(h,'facealpha',.1);
set(h,'edgealpha',1);

t = (0:1/32:1)'*2*pi;
x = 2.7*sin(t)+5;
y = 2.7*cos(t);

plot(x,y,'-r');
axis equal;

rssi = zeros(length(x),length(AP));
for i = 1:length(AP)
    for j = 1:length(x)
        rssi(j,i) = sqrt((x(j)-AP(i,1))^2+(y(j)-AP(i,2))^2);
    end
end
% figure; 
% plot(rssi)
noise = 0.08*randn(length(x),length(AP));
rssi_noise = 1*(rssi+noise);

for i = 1:length(x)
%for i = 1:1    
    for k = 1:2

%    for m = 1:length(AP)     
%    circle(AP(m,1),AP(m,2),rssi_noise(i,m));
%    end
   
   [sorted_rssi,idx] = sort(rssi_noise(i,:)); %distance from small to far
   AP_near1 = AP(idx(1),:);
   AP_near2 = AP(idx(2),:);
   AP_near3 = AP(idx(3),:);
   rssi_near1 = sorted_rssi(1);
   rssi_near2 = sorted_rssi(2);
   rssi_near3 = sorted_rssi(3);
   P = Triangle(AP_near1,AP_near2,AP_near3,rssi_near1,rssi_near2,rssi_near3);
   

  
    Px = real(P(1));
    Py = real(P(2));
   distance = 0;
   for l = 1:length(AP)
       distance = distance + sqrt((Px-AP(l,1))^2+(Py-AP(l,2))^2);
   end
   gain = distance/sum(rssi_noise(i,:));
   rssi_noise(i,:)= rssi_noise(i,:)*gain;
   
   end
    hold on;
    plot(Px,Py,'-bo', 'MarkerFaceColor','b');
    pause(0.01);
end


figure; 
plot(rssi);
hold on;
plot(rssi+noise);
R=rssi+noise;
R = 20*log10(1./R);