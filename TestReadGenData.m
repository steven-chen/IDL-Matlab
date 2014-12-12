%
clear all; close all; clc;
fid = fopen('Data.txt','r');
for i = 1:20
out = fread(fid,9,'uint8');
  out(3)
  out(5)
end
fclose(fid);