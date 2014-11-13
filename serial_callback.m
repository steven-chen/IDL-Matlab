function serial_callback(s,BytesAvailable,p,pt)
global RSSI_mem;
global Ref_Distance0;
global Ref_Rssi0;
global AP;
global E;
global Packet_number;
global R;
global Ref_Rssi0;
global Ref_Distance0;



update_position = 0;  
out = fscanf(s);
%disp(out)
data_cell = regexp(out,'\d*\.?\d*','match');
%if length(data_cell)>4
   disp('--------------------');
   Packet_number = Packet_number+1
   %data = str2num(char(data_cell(3)));
   AP_num = (mod(Packet_number-1,length(AP))+1)
   AP_ser = floor((Packet_number-0.5)/4)+1
   serial_number = 11*AP_num;
   rssi = R(AP_ser,AP_num);
%else
%    return
%end
 




serial_idx = find(RSSI_mem(:,1)==serial_number);
if (serial_idx)
    RSSI_mem(serial_idx,2)= 1;
    RSSI_mem(serial_idx,3)= rssi;
    fprintf(1,'Received RSSI from %d\n', serial_idx);
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
rssi_noise = zeros(1,length(AP));
rssi_dbm = RSSI_mem(:,3);

for i = 1:length(AP)
    rssi_noise(i) = 10^(-(rssi_dbm(i)-Ref_Rssi0)/10/E)*Ref_Distance0;
end

 for k = 1:2
%    for m = 1:length(AP)     
%    circle(AP(m,1),AP(m,2),rssi_noise(m));
%    end   
   [sorted_rssi,idx] = sort(rssi_noise); %distance from small to far
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
   gain = distance/sum(rssi_noise);
   rssi_noise= rssi_noise*gain;
   
end

   set(p,'XData',Px,'YData',Py);
   pt_str = sprintf('   (%.1f,%.1f)',Px,Py);
   set(pt,'string',pt_str,'position',[Px,Py]);
   drawnow;
   pause(0.01);
   RSSI_mem(:,2)=0;
   
end


