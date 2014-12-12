function serial_callback_2point(s,BytesAvailable,p,pt)
global RSSI_mem;
global Ref_Distance0;
global Ref_Rssi0;
global AP;
global E;
global Packet_number;
global R;
global Ref_Rssi0;
global Ref_Distance0;
global hc;


%disp('Serial Function Enter');
update_position = 0;  
%out = fscanf(s);
out = fread(s,9,'uint8');
%disp(out(3))
SN = out(3);
if out(5)<127
    read_value = out(5);
else
    read_value = out(5)-256;
end

RSSI_dbm = -73+read_value/2;
%fprintf(1,'Received From %d : %.2fdBm\n', SN,RSSI_dbm);
%data_cell = regexp(out,'\d*\.?\d*','match');
Packet_number = Packet_number+1;

serial_idx = find(RSSI_mem(:,1)==SN);
if (serial_idx)
    RSSI_mem(serial_idx,2)= 1;
    RSSI_mem(serial_idx,3)= RSSI_dbm;
    fprintf(1,'%d Received RSSI from %d: %2.f dBm\n', Packet_number,serial_idx, RSSI_dbm);
else
    disp('Error Serial Number!');
    return
end 

if all(RSSI_mem(:,2))
    update_position = 1;
end

if (update_position==1) 
    
disp('Update New Point');
% Turn dBm into m
% rssi_dbm = 0:-20:-60;
% rssi_m = zeros(1,length(AP));
rssi_dbm = RSSI_mem(:,3);



for k = 1:1
   %[sorted_rssi,idx] = sort(rssi_noise); %distance from small to far
   [sorted_rssi,idx] = sort(rssi_dbm,'descend'); %distance from small to far
   AP_near1 = AP(idx(1),:);
   AP_near2 = AP(idx(2),:);
   idx(1);
   idx(2);
   FP1 =  [RSSI_mem(idx(1),3+idx(1)),RSSI_mem(idx(1),3+idx(2))];
   FP2 =  [RSSI_mem(idx(2),3+idx(1)),RSSI_mem(idx(2),3+idx(2))];
   rssi_near1 = sorted_rssi(1);
   rssi_near2 = sorted_rssi(2);

   %P = Triangle(AP_near1,AP_near2,AP_near3,rssi_near1,rssi_near2,rssi_near3);
   P = TwoPoint(AP_near1,AP_near2,rssi_near1,rssi_near2,FP1,FP2);
   Py = real(P);
   Px = 0;


   
end

   set(p,'XData',Px,'YData',Py);
   pt_str = sprintf('   (%.1f,%.1f)',Px,Py);
   set(pt,'string',pt_str,'position',[Px,Py]);
   drawnow;
   %pause(0.01);
   RSSI_mem(:,2)=0;
   
end


