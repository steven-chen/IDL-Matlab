close all; clear all; clc;
global AP;
global E;
global RSSI_mem;
global Packet_number;
Packet_number = 0;
%%-----------------------------------------
% Define the AP location
D = 10; % Define distance between AP
AP = [1,1;1,-1;-1,-1;-1,1]*D;
%AP = [1,1;1,-1;-sqrt(3)+1,0;]*D;
M = length(AP);
RSSI_mem = zeros(M,3); %column 1: SN; column 2: update; colunm 3: value
RSSI_mem(:,1) = [11;22;33;44]; % SerialNumber for AP

%%-----------------------------------------
% Cal the enviroment parameter E: RSSI1-RSSI0 = -10*E*log(D1/D0)
Ref_Distance0 = 1;   %Reference0 m
Ref_Rssi0     = -20; %Reference0 RSSI
Ref_Distance1 = 10;  %Reference1 m
Ref_Rssi1     = -40; %Reference1 RSSI
E = -(Ref_Rssi1-Ref_Rssi0)/10/log10(Ref_Distance1/Ref_Distance0);




%%-----------------------------------------
% Plot
B = D/5;
min_x = min(AP(:,1));
max_x = max(AP(:,1));
min_y = min(AP(:,2));
max_y = max(AP(:,2));

figure('name','IDL','NumberTitle','off','Color','w','position',[500 60 600 600]); hold on;
%axis([min_x-B,max_x+B,min_y-B,max_y+B]);
% ax1 = gca;
% set(ax1,'box','off');
% ax2 = axes('Position', get(ax1, 'Position'),'Color','none');
% set(ax2,'XTick',[],'YTick',[],'XColor','w','YColor','w','box','on','layer','top');

%set(gca,'xcolor','w','ycolor','w');
grid on; 
%set(gca,'xtick',[],'ytick',[]);


h=fill(AP(:,1),AP(:,2),'b');
set(h,'facealpha',.1);
set(h,'edgealpha',1);
xlabel('m');
ylabel('m');
title('Estimated Position');
axis square;
%axis equal; 


for i = 1:M
  plot(AP(i,1),AP(i,2),'-ro', 'MarkerFaceColor','r','MarkerSize',10);
end

p = plot(0,0,'bo','MarkerFaceColor','b','EraseMode','normal','MarkerSize',10); 
pt_str = sprintf('   (%d,%d)',0,0);
pt = text(0,0,pt_str);

x = 1:10;
y = 1:10;
for i = 1:10
update_position = 1;    
   if (update_position==1) 
      set(p,'XData',x(i),'YData',y(i));  
      pt_str = sprintf('   (%d,%d)',x(i),y(i));
      set(pt,'string',pt_str,'position',[x(i),y(i)]);
      drawnow;
      pause(0.9);
   end
end
%{

%%-------------------------------------
% Open serial port
s = serial('COM8');     % creat serial port obj  
set(s,'BaudRate',38400,'DataBits',8,'StopBits',1,...  
    'Parity','none','FlowControl','none');  % set properties for serial  
  
s.BytesAvailableFcnMode = 'terminator'; % byte number or terminator  
s.BytesAvailableFcn = {@serial_callback,p};   % {@mycallback,time}  
  
fopen(s); 
%}
