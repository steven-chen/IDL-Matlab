function [P] = TwoPoint(A,B,dA,dB,FP1,FP2)
%{
A [0 0]
B [0 1]
dA -55
dB -56
FP1 = -55 -56
FP2 = -55 -56
%}
%{
x = 0:10; 
y = sin(x); 
xi = 0:.25:10; 
yi = interp1(x,y,xi); 
%}
A = A(2);
B = B(2);
FP2
FP1
dA
dB
P1 = A + (B-A)*(dA-FP1(1))/(FP2(1)-FP1(1))
P2 = B + (A-B)*(dB-FP2(2))/(FP1(2)-FP2(2))

% FP1(1)
% FP2(1)
% A
% B
% dA
% P1 = interp1([FP1(1) FP2(1)],[A B],dA)
% P2 = interp1([FP2(2) FP1(2)],[B A],dB)
P = (P1+P2)/2;