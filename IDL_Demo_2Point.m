%hidematlab;
close all; clear all; clc;

global AP;
global E;
global RSSI_mem;
global Packet_number;
global R;
global Ref_Rssi0;
global Ref_Distance0;
global hc;
hc = zeros(1,4);
RD = load('R.mat');
R = RD.R;
Packet_number = 0;
%%-----------------------------------------
% Define the AP location
D = 1; % Define distance between AP
AP = [0,0;0,1;0,2;0,3]*D;
%AP = [1,1;1,-1;-sqrt(3)+1,0;]*D;
M = length(AP);
RSSI_mem = zeros(M,7); %column 1: SN; column 2: update; colunm 3: value; column 4~7, fingerprint
RSSI_mem(:,1) = [1;2;3;4]; % SerialNumber for AP
% RSSI_mem(1,4:7) = [-55,-56,-57,-58];
% RSSI_mem(2,4:7) = [-56,-55,-56,-57];
% RSSI_mem(3,4:7) = [-57,-56,-55,-56];
% RSSI_mem(4,4:7) = [-58,-57,-56,-55];
RSSI_mem(1,4:7) = [-55,-65,-75,-85];
RSSI_mem(2,4:7) = [-65,-55,-65,-75];
RSSI_mem(3,4:7) = [-75,-65,-55,-65];
RSSI_mem(4,4:7) = [-85,-75,-65,-55];
% SN3: 1m -66, 4m -72 -58  -82
% SN1: 1m -74, 4m -74 -55  -87
% SN2: 1m -62, 4m -74 -56  -80
% SN4: 1m -70, 4m -70 -58  -78
%%-----------------------------------------
% Cal the enviroment parameter E: RSSI1-RSSI0 = -10*E*log(D1/D0)
Ref_Distance0 = 0;   %Reference0 m
Ref_Rssi0     = -56; %Reference0 RSSI
Ref_Distance1 = 1;  %Reference1 m
Ref_Rssi1     = -81; %Reference1 RSSI
%E = -(Ref_Rssi1-Ref_Rssi0)/10/log10(Ref_Distance1/Ref_Distance0);




%%-----------------------------------------
% Plot
B = D/5;
min_x = min(AP(:,1));
max_x = max(AP(:,1));
min_y = min(AP(:,2));
max_y = max(AP(:,2));

hf = figure('name','IDL','NumberTitle','off','Color','w','position',[500 60 600 600]); hold on;
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(hf,'javaframe');
%jIcon=javax.swing.ImageIcon('C:\Program Files\MATLAB\R2013b\toolbox\simulink\simulink\blockdiagramicon.gif');
jIcon=javax.swing.ImageIcon('webicon.png');
jframe.setFigureIcon(jIcon);
%set(hf, 'menubar', 'none');

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
axis([min_x-B,max_x+B,min_y-B,max_y+B]);
%axis([min_x,max_x,min_y,max_y]);
%axis equal; 


for i = 1:M
  plot(AP(i,1),AP(i,2),'-ro', 'MarkerFaceColor','r','MarkerSize',10);
end

p = plot(0,0,'bo','MarkerFaceColor','b','EraseMode','normal','MarkerSize',10); 
%p = plot(0,0,'bo','MarkerFaceColor','b','EraseMode','background','MarkerSize',10);
pt_str = sprintf('   (%d,%d)',0,0);
pt = text(0,0,pt_str);
%ptime_str = sprintf('%d年%d月%d日%d时%d分%d秒',fix(clock));
%ptime = text(-10,-10,ptime_str);


%{
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
%}

%%-------------------------------------
% Add a timer
% T = timer('TimerFcn',{@timer_callback,ptime},'period',10,'ExecutionMode', 'fixedRate');
% start(T);
fid = fopen('Data.txt');
for i = 1:40
    serial_callback_2point(fid,9,p,pt)
    pause(0.2)
end
fclose(fid);

%%-------------------------------------
% Open serial port
%{
s = serial('COM9');     % creat serial port obj 
set(s,'BaudRate',57600,'DataBits',8,'StopBits',1,...  
    'Parity','none','FlowControl','none');  % set properties for serial  
  
%s.BytesAvailableFcnMode = 'terminator'; % byte number or terminator  
s.BytesAvailableFcnMode ='byte'; % byte number or terminator  
s.BytesAvailableFcnCount = 9; % byte number or terminator  
s.BytesAvailableFcn = {@serial_callback_2point,p,pt};   % {@mycallback,time}  

for i = 1:60
try
   fopen(s); 
   break;
catch err
   disp(err.message);
   pause(1)
   disp('--- Wait Serial Port ---');
end
   
end
disp('--- Start Serial Port ---');
% pause(6);
% disp('--- Close Serial Port ---');
% snew = instrfind;
% fclose(snew);
% exit;
%}