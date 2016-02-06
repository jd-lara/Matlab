function L_approx = losses_approx2(x,S)

Pg_slack=x(1);
Pg1=x(2);
Pg2=x(3);
Pg3=x(4);
Pg4=x(5);
Pg5=x(6);
pdiff=zeros(S.Bus.n,1);
qdiff=zeros(S.Bus.n,1);
pf=0.95;
s=sin(acos(pf));

n=1:S.Bus.n;
pdiff(n)=real(S.Bus.Load(n,1));
qdiff(n)=imag(S.Bus.Load(n,1));

pdiff(11)=-Pg1;
pdiff(15)=-Pg2;
pdiff(22)=-Pg3;
pdiff(37)=-Pg4;
pdiff(38)=-Pg5;

qdiff(11)=-s*Pg1;
qdiff(15)=-s*Pg2;
qdiff(22)=-s*Pg3;
qdiff(37)=0;
qdiff(38)=-0.07/50;


%Feeder1 
%Bus 22 
P_b22=(pdiff(22,1)^2+qdiff(22,1)^2)*real(S.Branch.Z(23,1));
Q_b22=(pdiff(22,1)^2+qdiff(22,1)^2)*imag(S.Branch.Z(23,1));
%Bus20
P_b20=((pdiff(20,1)+pdiff(22,1)+P_b22)^2+(qdiff(20,1)+qdiff(22,1)+Q_b22)^2)*real(S.Branch.Z(21,1));
Q_b20=((pdiff(20,1)+pdiff(22,1)+P_b22)^2+(qdiff(20,1)+qdiff(22,1)+Q_b22)^2)*imag(S.Branch.Z(21,1));
%Bus 21 
P_b21=(pdiff(21,1)^2+qdiff(21,1)^2)*real(S.Branch.Z(22,1));
Q_b21=(pdiff(21,1)^2+qdiff(21,1)^2)*imag(S.Branch.Z(22,1));
%Bus 19
P_b19=((pdiff(19,1)+pdiff(20,1)+P_b20+pdiff(21,1)+P_b21+pdiff(22,1)+P_b22)^2+(qdiff(19,1)+qdiff(20,1)+Q_b20+qdiff(21,1)+Q_b21+qdiff(22,1)+Q_b22)^2)*real(S.Branch.Z(20,1));
Q_b19=((pdiff(19,1)+pdiff(20,1)+P_b20+pdiff(21,1)+P_b21+pdiff(22,1)+P_b22)^2+(qdiff(19,1)+qdiff(20,1)+Q_b20+qdiff(21,1)+Q_b21+qdiff(22,1)+Q_b22)^2)*imag(S.Branch.Z(20,1));
%Bus 18
P_b18=((pdiff(18,1)+pdiff(19,1)+P_b19+pdiff(20,1)+P_b20+pdiff(21,1)+P_b21+pdiff(22,1)+P_b22)^2+(qdiff(18,1)+qdiff(19,1)+Q_b19+qdiff(20,1)+Q_b20+qdiff(21,1)+Q_b21+qdiff(22,1)+Q_b22)^2)*real(S.Branch.Z(18,1));
Q_b18=((pdiff(18,1)+pdiff(19,1)+P_b19+pdiff(20,1)+P_b20+pdiff(21,1)+P_b21+pdiff(22,1)+P_b22)^2+(qdiff(18,1)+qdiff(19,1)+Q_b19+qdiff(20,1)+Q_b20+qdiff(21,1)+Q_b21+qdiff(22,1)+Q_b22)^2)*imag(S.Branch.Z(18,1));
%Bus 17 
P_b17=((pdiff(17,1)+P_b18+pdiff(18,1)+pdiff(19,1)+P_b19+pdiff(20,1)+P_b20+pdiff(21,1)+P_b21+pdiff(22,1)+P_b22)^2+(qdiff(17,1)+Q_b18+qdiff(18,1)+qdiff(19,1)+Q_b19+qdiff(20,1)+Q_b20+qdiff(21,1)+Q_b21+qdiff(22,1)+Q_b22)^2)*real(S.Branch.Z(17,1));
Q_b17=((pdiff(17,1)+P_b18+pdiff(18,1)+pdiff(19,1)+P_b19+pdiff(20,1)+P_b20+pdiff(21,1)+P_b21+pdiff(22,1)+P_b22)^2+(qdiff(17,1)+Q_b18+qdiff(18,1)+qdiff(19,1)+Q_b19+qdiff(20,1)+Q_b20+qdiff(21,1)+Q_b21+qdiff(22,1)+Q_b22)^2)*imag(S.Branch.Z(17,1));
%Bus 16
P_b16=((pdiff(16,1)+P_b17+pdiff(17,1)+P_b18+pdiff(18,1)+pdiff(19,1)+P_b19+pdiff(20,1)+P_b20+pdiff(21,1)+P_b21+pdiff(22,1)+P_b22)^2+(qdiff(16,1)+Q_b17+qdiff(17,1)+Q_b18+qdiff(18,1)+qdiff(19,1)+Q_b19+qdiff(20,1)+Q_b20+qdiff(21,1)+Q_b21+qdiff(22,1)+Q_b22)^2)*real(S.Branch.Z(16,1));
Q_b16=((pdiff(16,1)+P_b17+pdiff(17,1)+P_b18+pdiff(18,1)+pdiff(19,1)+P_b19+pdiff(20,1)+P_b20+pdiff(21,1)+P_b21+pdiff(22,1)+P_b22)^2+(qdiff(16,1)+Q_b17+qdiff(17,1)+Q_b18+qdiff(18,1)+qdiff(19,1)+Q_b19+qdiff(20,1)+Q_b20+qdiff(21,1)+Q_b21+qdiff(22,1)+Q_b22)^2)*imag(S.Branch.Z(16,1));
%Bus 15
P_b15=(pdiff(15,1)^2+qdiff(15,1)^2)*real(S.Branch.Z(15,1));
Q_b15=(pdiff(15,1)^2+qdiff(15,1)^2)*imag(S.Branch.Z(15,1));
%Bus 14
P_b14=((pdiff(14,1)+P_b15+pdiff(15,1)+P_b16+pdiff(16,1)+P_b17+pdiff(17,1)+P_b18+pdiff(18,1)+pdiff(19,1)+P_b19+pdiff(20,1)+P_b20+pdiff(21,1)+P_b21+pdiff(22,1)+P_b22)^2+(qdiff(14,1)+qdiff(15,1)+Q_b15+Q_b16+qdiff(16,1)+Q_b17+qdiff(17,1)+Q_b18+qdiff(18,1)+qdiff(19,1)+Q_b19+qdiff(20,1)+Q_b20+qdiff(21,1)+Q_b21+qdiff(22,1)+Q_b22)^2)*real(S.Branch.Z(12,1));
Q_b14=((pdiff(14,1)+P_b15+pdiff(15,1)+P_b16+pdiff(16,1)+P_b17+pdiff(17,1)+P_b18+pdiff(18,1)+pdiff(19,1)+P_b19+pdiff(20,1)+P_b20+pdiff(21,1)+P_b21+pdiff(22,1)+P_b22)^2+(qdiff(14,1)+qdiff(15,1)+Q_b15+Q_b16+qdiff(16,1)+Q_b17+qdiff(17,1)+Q_b18+qdiff(18,1)+qdiff(19,1)+Q_b19+qdiff(20,1)+Q_b20+qdiff(21,1)+Q_b21+qdiff(22,1)+Q_b22)^2)*imag(S.Branch.Z(12,1));
%Bus 11
P_b11=(pdiff(11,1)^2+qdiff(11,1)^2)*real(S.Branch.Z(10,1));
Q_b11=(pdiff(11,1)^2+qdiff(11,1)^2)*imag(S.Branch.Z(10,1));
% Feeder 2
%Bus 37  
P_b37=(pdiff(37,1)^2+qdiff(37,1)^2)*real(S.Branch.Z(37,1));
Q_b37=(pdiff(37,1)^2+qdiff(37,1)^2)*imag(S.Branch.Z(37,1));
%Bus 38  
P_b38=(pdiff(38,1)^2+qdiff(38,1)^2)*real(S.Branch.Z(38,1));
Q_b38=(pdiff(38,1)^2+qdiff(38,1)^2)*imag(S.Branch.Z(38,1));
%Bus 39  
P_b39=(pdiff(39,1)^2+qdiff(39,1)^2)*real(S.Branch.Z(39,1));
Q_b39=(pdiff(39,1)^2+qdiff(39,1)^2)*imag(S.Branch.Z(39,1));
%Bus 3
P_b36=((pdiff(36,1)+P_b37+pdiff(37,1)+P_b38+pdiff(38,1)+pdiff(39,1)+P_b39)^2+(qdiff(36,1)+Q_b37+qdiff(37,1)+Q_b38+qdiff(38,1)+qdiff(39,1)+Q_b39)^2)*real(S.Branch.Z(36,1));
Q_b36=((pdiff(36,1)+P_b37+pdiff(37,1)+P_b38+pdiff(38,1)+pdiff(39,1)+P_b39)^2+(qdiff(36,1)+Q_b37+qdiff(37,1)+Q_b38+qdiff(38,1)+qdiff(39,1)+Q_b39)^2)*imag(S.Branch.Z(36,1));
%Bus 35 
P_b35=((pdiff(35,1)+P_b36+pdiff(36,1)+P_b37+pdiff(37,1)+P_b38+pdiff(38,1)+pdiff(39,1)+P_b39)^2+(qdiff(35,1)+Q_b36+qdiff(36,1)+Q_b37+qdiff(37,1)+Q_b38+qdiff(38,1)+qdiff(39,1)+Q_b39)^2)*real(S.Branch.Z(35,1));
Q_b35=((pdiff(35,1)+P_b36+pdiff(36,1)+P_b37+pdiff(37,1)+P_b38+pdiff(38,1)+pdiff(39,1)+P_b39)^2+(qdiff(35,1)+Q_b36+qdiff(36,1)+Q_b37+qdiff(37,1)+Q_b38+qdiff(38,1)+qdiff(39,1)+Q_b39)^2)*imag(S.Branch.Z(35,1));
%Bus 33  
P_b33=(pdiff(33,1)^2+qdiff(33,1)^2)*real(S.Branch.Z(34,1));
Q_b33=(pdiff(33,1)^2+qdiff(33,1)^2)*imag(S.Branch.Z(34,1));
%Bus 34
P_b34=((pdiff(34,1)+P_b33+pdiff(33,1)+P_b35+pdiff(35,1)+P_b36+pdiff(36,1)+P_b37+pdiff(37,1)+P_b38+pdiff(38,1)+pdiff(39,1)+P_b39)^2+(qdiff(34,1)+Q_b33+qdiff(33,1)+Q_b35+qdiff(35,1)+Q_b36+qdiff(36,1)+Q_b37+qdiff(37,1)+Q_b38+qdiff(38,1)+qdiff(39,1)+Q_b39)^2)*real(S.Branch.Z(33,1));
Q_b34=((pdiff(34,1)+P_b33+pdiff(33,1)+P_b35+pdiff(35,1)+P_b36+pdiff(36,1)+P_b37+pdiff(37,1)+P_b38+pdiff(38,1)+pdiff(39,1)+P_b39)^2+(qdiff(34,1)+Q_b33+qdiff(33,1)+Q_b35+qdiff(35,1)+Q_b36+qdiff(36,1)+Q_b37+qdiff(37,1)+Q_b38+qdiff(38,1)+qdiff(39,1)+Q_b39)^2)*imag(S.Branch.Z(33,1));
%Bus 32 
P_b32=((pdiff(32,1)+P_b34+pdiff(34,1)+P_b33+pdiff(33,1)+P_b35+pdiff(35,1)+P_b36+pdiff(36,1)+P_b37+pdiff(37,1)+P_b38+pdiff(38,1)+pdiff(39,1)+P_b39)^2+(qdiff(32,1)+Q_b34+qdiff(34,1)+Q_b33+qdiff(33,1)+Q_b35+qdiff(35,1)+Q_b36+qdiff(36,1)+Q_b37+qdiff(37,1)+Q_b38+qdiff(38,1)+qdiff(39,1)+Q_b39)^2)*real(S.Branch.Z(32,1));
Q_b32=((pdiff(32,1)+P_b34+pdiff(34,1)+P_b33+pdiff(33,1)+P_b35+pdiff(35,1)+P_b36+pdiff(36,1)+P_b37+pdiff(37,1)+P_b38+pdiff(38,1)+pdiff(39,1)+P_b39)^2+(qdiff(32,1)+Q_b34+qdiff(34,1)+Q_b33+qdiff(33,1)+Q_b35+qdiff(35,1)+Q_b36+qdiff(36,1)+Q_b37+qdiff(37,1)+Q_b38+qdiff(38,1)+qdiff(39,1)+Q_b39)^2)*imag(S.Branch.Z(32,1));
%Bus 31 
P_b31=((pdiff(31,1)+P_b32+pdiff(32,1)+P_b34+pdiff(34,1)+P_b33+pdiff(33,1)+P_b35+pdiff(35,1)+P_b36+pdiff(36,1)+P_b37+pdiff(37,1)+P_b38+pdiff(38,1)+pdiff(39,1)+P_b39)^2+(qdiff(31,1)+Q_b32+qdiff(32,1)+Q_b34+qdiff(34,1)+Q_b33+qdiff(33,1)+Q_b35+qdiff(35,1)+Q_b36+qdiff(36,1)+Q_b37+qdiff(37,1)+Q_b38+qdiff(38,1)+qdiff(39,1)+Q_b39)^2)*real(S.Branch.Z(31,1));
Q_b31=((pdiff(31,1)+P_b32+pdiff(32,1)+P_b34+pdiff(34,1)+P_b33+pdiff(33,1)+P_b35+pdiff(35,1)+P_b36+pdiff(36,1)+P_b37+pdiff(37,1)+P_b38+pdiff(38,1)+pdiff(39,1)+P_b39)^2+(qdiff(32,1)+Q_b32+qdiff(32,1)+Q_b34+qdiff(34,1)+Q_b33+qdiff(33,1)+Q_b35+qdiff(35,1)+Q_b36+qdiff(36,1)+Q_b37+qdiff(37,1)+Q_b38+qdiff(38,1)+qdiff(39,1)+Q_b39)^2)*imag(S.Branch.Z(31,1));
%Bus 30 
P_b30=((pdiff(30,1)+P_b31+pdiff(31,1)+P_b32+pdiff(32,1)+P_b34+pdiff(34,1)+P_b33+pdiff(33,1)+P_b35+pdiff(35,1)+P_b36+pdiff(36,1)+P_b37+pdiff(37,1)+P_b38+pdiff(38,1)+pdiff(39,1)+P_b39)^2+(qdiff(30,1)+Q_b31+qdiff(31,1)+Q_b32+qdiff(32,1)+Q_b34+qdiff(34,1)+Q_b33+qdiff(33,1)+Q_b35+qdiff(35,1)+Q_b36+qdiff(36,1)+Q_b37+qdiff(37,1)+Q_b38+qdiff(38,1)+qdiff(39,1)+Q_b39)^2)*real(S.Branch.Z(30,1));
Q_b30=((pdiff(30,1)+P_b31+pdiff(31,1)+P_b32+pdiff(32,1)+P_b34+pdiff(34,1)+P_b33+pdiff(33,1)+P_b35+pdiff(35,1)+P_b36+pdiff(36,1)+P_b37+pdiff(37,1)+P_b38+pdiff(38,1)+pdiff(39,1)+P_b39)^2+(qdiff(30,1)+Q_b31+qdiff(31,1)+Q_b32+qdiff(32,1)+Q_b34+qdiff(34,1)+Q_b33+qdiff(33,1)+Q_b35+qdiff(35,1)+Q_b36+qdiff(36,1)+Q_b37+qdiff(37,1)+Q_b38+qdiff(38,1)+qdiff(39,1)+Q_b39)^2)*imag(S.Branch.Z(30,1));
%Bus 29
P_b29=((pdiff(29,1)+P_b30+pdiff(30,1)+P_b31+pdiff(31,1)+P_b32+pdiff(32,1)+P_b34+pdiff(34,1)+P_b33+pdiff(33,1)+P_b35+pdiff(35,1)+P_b36+pdiff(36,1)+P_b37+pdiff(37,1)+P_b38+pdiff(38,1)+pdiff(39,1)+P_b39)^2+(qdiff(29,1)+Q_b30+qdiff(30,1)+Q_b31+qdiff(31,1)+Q_b32+qdiff(32,1)+Q_b34+qdiff(34,1)+Q_b33+qdiff(33,1)+Q_b35+qdiff(35,1)+Q_b36+qdiff(36,1)+Q_b37+qdiff(37,1)+Q_b38+qdiff(38,1)+qdiff(39,1)+Q_b39)^2)*real(S.Branch.Z(29,1));
Q_b29=((pdiff(29,1)+P_b30+pdiff(30,1)+P_b31+pdiff(31,1)+P_b32+pdiff(32,1)+P_b34+pdiff(34,1)+P_b33+pdiff(33,1)+P_b35+pdiff(35,1)+P_b36+pdiff(36,1)+P_b37+pdiff(37,1)+P_b38+pdiff(38,1)+pdiff(39,1)+P_b39)^2+(qdiff(29,1)+Q_b30+qdiff(30,1)+Q_b31+qdiff(31,1)+Q_b32+qdiff(32,1)+Q_b34+qdiff(34,1)+Q_b33+qdiff(33,1)+Q_b35+qdiff(35,1)+Q_b36+qdiff(36,1)+Q_b37+qdiff(37,1)+Q_b38+qdiff(38,1)+qdiff(39,1)+Q_b39)^2)*imag(S.Branch.Z(29,1));
%Bus 28
P_b28=((pdiff(28,1)+P_b29+pdiff(29,1)+P_b30+pdiff(30,1)+P_b31+pdiff(31,1)+P_b32+pdiff(32,1)+P_b34+pdiff(34,1)+P_b33+pdiff(33,1)+P_b35+pdiff(35,1)+P_b36+pdiff(36,1)+P_b37+pdiff(37,1)+P_b38+pdiff(38,1)+pdiff(39,1)+P_b39)^2+(qdiff(28,1)+Q_b29+qdiff(29,1)+Q_b30+qdiff(30,1)+Q_b31+qdiff(31,1)+Q_b32+qdiff(32,1)+Q_b34+qdiff(34,1)+Q_b33+qdiff(33,1)+Q_b35+qdiff(35,1)+Q_b36+qdiff(36,1)+Q_b37+qdiff(37,1)+Q_b38+qdiff(38,1)+qdiff(39,1)+Q_b39)^2)*real(S.Branch.Z(28,1));
Q_b28=((pdiff(28,1)+P_b29+pdiff(29,1)+P_b30+pdiff(30,1)+P_b31+pdiff(31,1)+P_b32+pdiff(32,1)+P_b34+pdiff(34,1)+P_b33+pdiff(33,1)+P_b35+pdiff(35,1)+P_b36+pdiff(36,1)+P_b37+pdiff(37,1)+P_b38+pdiff(38,1)+pdiff(39,1)+P_b39)^2+(qdiff(28,1)+Q_b29+qdiff(29,1)+Q_b30+qdiff(30,1)+Q_b31+qdiff(31,1)+Q_b32+qdiff(32,1)+Q_b34+qdiff(34,1)+Q_b33+qdiff(33,1)+Q_b35+qdiff(35,1)+Q_b36+qdiff(36,1)+Q_b37+qdiff(37,1)+Q_b38+qdiff(38,1)+qdiff(39,1)+Q_b39)^2)*imag(S.Branch.Z(28,1));
%Bus 27
P_b27=((pdiff(27,1)+P_b28+pdiff(28,1)+P_b29+pdiff(29,1)+P_b30+pdiff(30,1)+P_b31+pdiff(31,1)+P_b32+pdiff(32,1)+P_b34+pdiff(34,1)+P_b33+pdiff(33,1)+P_b35+pdiff(35,1)+P_b36+pdiff(36,1)+P_b37+pdiff(37,1)+P_b38+pdiff(38,1)+pdiff(39,1)+P_b39)^2+(qdiff(27,1)+Q_b28+qdiff(28,1)+Q_b29+qdiff(29,1)+Q_b30+qdiff(30,1)+Q_b31+qdiff(31,1)+Q_b32+qdiff(32,1)+Q_b34+qdiff(34,1)+Q_b33+qdiff(33,1)+Q_b35+qdiff(35,1)+Q_b36+qdiff(36,1)+Q_b37+qdiff(37,1)+Q_b38+qdiff(38,1)+qdiff(39,1)+Q_b39)^2)*real(S.Branch.Z(25,1));
Q_b27=((pdiff(27,1)+P_b28+pdiff(28,1)+P_b29+pdiff(29,1)+P_b30+pdiff(30,1)+P_b31+pdiff(31,1)+P_b32+pdiff(32,1)+P_b34+pdiff(34,1)+P_b33+pdiff(33,1)+P_b35+pdiff(35,1)+P_b36+pdiff(36,1)+P_b37+pdiff(37,1)+P_b38+pdiff(38,1)+pdiff(39,1)+P_b39)^2+(qdiff(27,1)+Q_b28+qdiff(28,1)+Q_b29+qdiff(29,1)+Q_b30+qdiff(30,1)+Q_b31+qdiff(31,1)+Q_b32+qdiff(32,1)+Q_b34+qdiff(34,1)+Q_b33+qdiff(33,1)+Q_b35+qdiff(35,1)+Q_b36+qdiff(36,1)+Q_b37+qdiff(37,1)+Q_b38+qdiff(38,1)+qdiff(39,1)+Q_b39)^2)*imag(S.Branch.Z(25,1));
%Bus 26 
P_b26=(pdiff(26,1)^2+qdiff(26,1)^2)*real(S.Branch.Z(27,1));
Q_b26=(pdiff(26,1)^2+qdiff(26,1)^2)*imag(S.Branch.Z(27,1));
%Bus 25
P_b25=((pdiff(25,1)+P_b26+pdiff(26,1))^2+(qdiff(25,1)+Q_b26+qdiff(26,1))^2)*real(S.Branch.Z(26,1));
Q_b25=((pdiff(25,1)+P_b26+pdiff(26,1))^2+(qdiff(25,1)+Q_b26+qdiff(26,1))^2)*imag(S.Branch.Z(26,1));
%Bus 24
P_b24=((pdiff(24,1)+P_b25+pdiff(25,1)+P_b26+pdiff(26,1))^2+(qdiff(24,1)+Q_b25+qdiff(25,1)+Q_b26+qdiff(26,1))^2)*real(S.Branch.Z(24,1));
Q_b24=((pdiff(24,1)+P_b25+pdiff(25,1)+P_b26+pdiff(26,1))^2+(qdiff(24,1)+Q_b25+qdiff(25,1)+Q_b26+qdiff(26,1))^2)*imag(S.Branch.Z(24,1));
%Bus 23
P_b23=((pdiff(23,1)+P_b24+pdiff(24,1)+P_b25+pdiff(25,1)+P_b26+pdiff(26,1)+P_b27+pdiff(27,1)+P_b28+pdiff(28,1)+P_b29+pdiff(29,1)+P_b30+pdiff(30,1)+P_b31+pdiff(31,1)+P_b32+pdiff(32,1)+P_b34+pdiff(34,1)+P_b33+pdiff(33,1)+P_b35+pdiff(35,1)+P_b36+pdiff(36,1)+P_b37+pdiff(37,1)+P_b38+pdiff(38,1)+pdiff(39,1)+P_b39)^2+(qdiff(23,1)+Q_b24+qdiff(24,1)+Q_b25+qdiff(25,1)+Q_b26+qdiff(26,1)+Q_b27+qdiff(27,1)+Q_b28+qdiff(28,1)+Q_b29+qdiff(29,1)+Q_b30+qdiff(30,1)+Q_b31+qdiff(31,1)+Q_b32+qdiff(32,1)+Q_b34+qdiff(34,1)+Q_b33+qdiff(33,1)+Q_b35+qdiff(35,1)+Q_b36+qdiff(36,1)+Q_b37+qdiff(37,1)+Q_b38+qdiff(38,1)+qdiff(39,1)+Q_b39)^2)*real(S.Branch.Z(14,1));
Q_b23=((pdiff(23,1)+P_b24+pdiff(24,1)+P_b25+pdiff(25,1)+P_b26+pdiff(26,1)+P_b27+pdiff(27,1)+P_b28+pdiff(28,1)+P_b29+pdiff(29,1)+P_b30+pdiff(30,1)+P_b31+pdiff(31,1)+P_b32+pdiff(32,1)+P_b34+pdiff(34,1)+P_b33+pdiff(33,1)+P_b35+pdiff(35,1)+P_b36+pdiff(36,1)+P_b37+pdiff(37,1)+P_b38+pdiff(38,1)+pdiff(39,1)+P_b39)^2+(qdiff(23,1)+Q_b24+qdiff(24,1)+Q_b25+qdiff(25,1)+Q_b26+qdiff(26,1)+Q_b27+qdiff(27,1)+Q_b28+qdiff(28,1)+Q_b29+qdiff(29,1)+Q_b30+qdiff(30,1)+Q_b31+qdiff(31,1)+Q_b32+qdiff(32,1)+Q_b34+qdiff(34,1)+Q_b33+qdiff(33,1)+Q_b35+qdiff(35,1)+Q_b36+qdiff(36,1)+Q_b37+qdiff(37,1)+Q_b38+qdiff(38,1)+qdiff(39,1)+Q_b39)^2)*imag(S.Branch.Z(14,1));
%Bus 13
P_b13=((pdiff(13,1)+P_b23+pdiff(23,1)+P_b24+pdiff(24,1)+P_b25+pdiff(25,1)+P_b26+pdiff(26,1)+P_b27+pdiff(27,1)+P_b28+pdiff(28,1)+P_b29+pdiff(29,1)+P_b30+pdiff(30,1)+P_b31+pdiff(31,1)+P_b32+pdiff(32,1)+P_b34+pdiff(34,1)+P_b33+pdiff(33,1)+P_b35+pdiff(35,1)+P_b36+pdiff(36,1)+P_b37+pdiff(37,1)+P_b38+pdiff(38,1)+pdiff(39,1)+P_b39)^2+(qdiff(13,1)+Q_b23+qdiff(23,1)+Q_b24+qdiff(24,1)+Q_b25+qdiff(25,1)+Q_b26+qdiff(26,1)+Q_b27+qdiff(27,1)+Q_b28+qdiff(28,1)+Q_b29+qdiff(29,1)+Q_b30+qdiff(30,1)+Q_b31+qdiff(31,1)+Q_b32+qdiff(32,1)+Q_b34+qdiff(34,1)+Q_b33+qdiff(33,1)+Q_b35+qdiff(35,1)+Q_b36+qdiff(36,1)+Q_b37+qdiff(37,1)+Q_b38+qdiff(38,1)+qdiff(39,1)+Q_b39)^2)*real(S.Branch.Z(13,1));
Q_b13=((pdiff(13,1)+P_b23+pdiff(23,1)+P_b24+pdiff(24,1)+P_b25+pdiff(25,1)+P_b26+pdiff(26,1)+P_b27+pdiff(27,1)+P_b28+pdiff(28,1)+P_b29+pdiff(29,1)+P_b30+pdiff(30,1)+P_b31+pdiff(31,1)+P_b32+pdiff(32,1)+P_b34+pdiff(34,1)+P_b33+pdiff(33,1)+P_b35+pdiff(35,1)+P_b36+pdiff(36,1)+P_b37+pdiff(37,1)+P_b38+pdiff(38,1)+pdiff(39,1)+P_b39)^2+(qdiff(13,1)+Q_b23+qdiff(23,1)+Q_b24+qdiff(24,1)+Q_b25+qdiff(25,1)+Q_b26+qdiff(26,1)+Q_b27+qdiff(27,1)+Q_b28+qdiff(28,1)+Q_b29+qdiff(29,1)+Q_b30+qdiff(30,1)+Q_b31+qdiff(31,1)+Q_b32+qdiff(32,1)+Q_b34+qdiff(34,1)+Q_b33+qdiff(33,1)+Q_b35+qdiff(35,1)+Q_b36+qdiff(36,1)+Q_b37+qdiff(37,1)+Q_b38+qdiff(38,1)+qdiff(39,1)+Q_b39)^2)*imag(S.Branch.Z(13,1));
%Bus 12
P_b12=((pdiff(12,1)+P_b13+pdiff(13,1)+P_b23+pdiff(23,1)+P_b24+pdiff(24,1)+P_b25+pdiff(25,1)+P_b26+pdiff(26,1)+P_b27+pdiff(27,1)+P_b28+pdiff(28,1)+P_b29+pdiff(29,1)+P_b30+pdiff(30,1)+P_b31+pdiff(31,1)+P_b32+pdiff(32,1)+P_b34+pdiff(34,1)+P_b33+pdiff(33,1)+P_b35+pdiff(35,1)+P_b36+pdiff(36,1)+P_b37+pdiff(37,1)+P_b38+pdiff(38,1)+pdiff(39,1)+P_b39)^2+(qdiff(12,1)+Q_b13+qdiff(13,1)+Q_b23+qdiff(23,1)+Q_b24+qdiff(24,1)+Q_b25+qdiff(25,1)+Q_b26+qdiff(26,1)+Q_b27+qdiff(27,1)+Q_b28+qdiff(28,1)+Q_b29+qdiff(29,1)+Q_b30+qdiff(30,1)+Q_b31+qdiff(31,1)+Q_b32+qdiff(32,1)+Q_b34+qdiff(34,1)+Q_b33+qdiff(33,1)+Q_b35+qdiff(35,1)+Q_b36+qdiff(36,1)+Q_b37+qdiff(37,1)+Q_b38+qdiff(38,1)+qdiff(39,1)+Q_b39)^2)*real(S.Branch.Z(11,1));
Q_b12=((pdiff(12,1)+P_b13+pdiff(13,1)+P_b23+pdiff(23,1)+P_b24+pdiff(24,1)+P_b25+pdiff(25,1)+P_b26+pdiff(26,1)+P_b27+pdiff(27,1)+P_b28+pdiff(28,1)+P_b29+pdiff(29,1)+P_b30+pdiff(30,1)+P_b31+pdiff(31,1)+P_b32+pdiff(32,1)+P_b34+pdiff(34,1)+P_b33+pdiff(33,1)+P_b35+pdiff(35,1)+P_b36+pdiff(36,1)+P_b37+pdiff(37,1)+P_b38+pdiff(38,1)+pdiff(39,1)+P_b39)^2+(qdiff(12,1)+Q_b13+qdiff(13,1)+Q_b23+qdiff(23,1)+Q_b24+qdiff(24,1)+Q_b25+qdiff(25,1)+Q_b26+qdiff(26,1)+Q_b27+qdiff(27,1)+Q_b28+qdiff(28,1)+Q_b29+qdiff(29,1)+Q_b30+qdiff(30,1)+Q_b31+qdiff(31,1)+Q_b32+qdiff(32,1)+Q_b34+qdiff(34,1)+Q_b33+qdiff(33,1)+Q_b35+qdiff(35,1)+Q_b36+qdiff(36,1)+Q_b37+qdiff(37,1)+Q_b38+qdiff(38,1)+qdiff(39,1)+Q_b39)^2)*imag(S.Branch.Z(11,1));
%Bus 10
P_b10=((pdiff(10,1)+P_b12+pdiff(12,1)+P_b13+pdiff(13,1)+P_b23+pdiff(23,1)+P_b24+pdiff(24,1)+P_b25+pdiff(25,1)+P_b26+pdiff(26,1)+P_b27+pdiff(27,1)+P_b28+pdiff(28,1)+P_b29+pdiff(29,1)+P_b30+pdiff(30,1)+P_b31+pdiff(31,1)+P_b32+pdiff(32,1)+P_b34+pdiff(34,1)+P_b33+pdiff(33,1)+P_b35+pdiff(35,1)+P_b36+pdiff(36,1)+P_b37+pdiff(37,1)+P_b38+pdiff(38,1)+pdiff(39,1)+P_b39+P_b14+pdiff(14,1)+P_b15+pdiff(15,1)+P_b16+pdiff(16,1)+P_b17+pdiff(17,1)+P_b18+pdiff(18,1)+pdiff(19,1)+P_b19+pdiff(20,1)+P_b20+pdiff(21,1)+P_b21+pdiff(22,1)+P_b22+pdiff(11,1)+P_b11)^2+(qdiff(10,1)+Q_b12+qdiff(12,1)+Q_b13+qdiff(13,1)+Q_b23+qdiff(23,1)+Q_b24+qdiff(24,1)+Q_b25+qdiff(25,1)+Q_b26+qdiff(26,1)+Q_b27+qdiff(27,1)+Q_b28+qdiff(28,1)+Q_b29+qdiff(29,1)+Q_b30+qdiff(30,1)+Q_b31+qdiff(31,1)+Q_b32+qdiff(32,1)+Q_b34+qdiff(34,1)+Q_b33+qdiff(33,1)+Q_b35+qdiff(35,1)+Q_b36+qdiff(36,1)+Q_b37+qdiff(37,1)+Q_b38+qdiff(38,1)+qdiff(39,1)+Q_b39+Q_b14+qdiff(14,1)+qdiff(15,1)+Q_b15+Q_b16+qdiff(16,1)+Q_b17+qdiff(17,1)+Q_b18+qdiff(18,1)+qdiff(19,1)+Q_b19+qdiff(20,1)+Q_b20+qdiff(21,1)+Q_b21+qdiff(22,1)+Q_b22+qdiff(11,1)+Q_b11)^2)*real(S.Branch.Z(8,1));
Q_b10=((pdiff(10,1)+P_b12+pdiff(12,1)+P_b13+pdiff(13,1)+P_b23+pdiff(23,1)+P_b24+pdiff(24,1)+P_b25+pdiff(25,1)+P_b26+pdiff(26,1)+P_b27+pdiff(27,1)+P_b28+pdiff(28,1)+P_b29+pdiff(29,1)+P_b30+pdiff(30,1)+P_b31+pdiff(31,1)+P_b32+pdiff(32,1)+P_b34+pdiff(34,1)+P_b33+pdiff(33,1)+P_b35+pdiff(35,1)+P_b36+pdiff(36,1)+P_b37+pdiff(37,1)+P_b38+pdiff(38,1)+pdiff(39,1)+P_b39+P_b14+pdiff(14,1)+P_b15+pdiff(15,1)+P_b16+pdiff(16,1)+P_b17+pdiff(17,1)+P_b18+pdiff(18,1)+pdiff(19,1)+P_b19+pdiff(20,1)+P_b20+pdiff(21,1)+P_b21+pdiff(22,1)+P_b22+pdiff(11,1)+P_b11)^2+(qdiff(10,1)+Q_b12+qdiff(12,1)+Q_b13+qdiff(13,1)+Q_b23+qdiff(23,1)+Q_b24+qdiff(24,1)+Q_b25+qdiff(25,1)+Q_b26+qdiff(26,1)+Q_b27+qdiff(27,1)+Q_b28+qdiff(28,1)+Q_b29+qdiff(29,1)+Q_b30+qdiff(30,1)+Q_b31+qdiff(31,1)+Q_b32+qdiff(32,1)+Q_b34+qdiff(34,1)+Q_b33+qdiff(33,1)+Q_b35+qdiff(35,1)+Q_b36+qdiff(36,1)+Q_b37+qdiff(37,1)+Q_b38+qdiff(38,1)+qdiff(39,1)+Q_b39+Q_b14+qdiff(14,1)+qdiff(15,1)+Q_b15+Q_b16+qdiff(16,1)+Q_b17+qdiff(17,1)+Q_b18+qdiff(18,1)+qdiff(19,1)+Q_b19+qdiff(20,1)+Q_b20+qdiff(21,1)+Q_b21+qdiff(22,1)+Q_b22+qdiff(11,1)+Q_b11)^2)*imag(S.Branch.Z(8,1));
%Feeder 3
% Bus 9
P_b9=(pdiff(9,1)^2+qdiff(9,1)^2)*real(S.Branch.Z(9,1));
Q_b9=(pdiff(9,1)^2+qdiff(9,1)^2)*imag(S.Branch.Z(9,1));
%Bus 8
P_b8=((pdiff(8,1)+P_b9+pdiff(9,1))^2+(qdiff(8,1)+Q_b9+qdiff(9,1))^2)*real(S.Branch.Z(7,1));
Q_b8=((pdiff(8,1)+P_b9+pdiff(9,1))^2+(qdiff(8,1)+Q_b9+qdiff(9,1))^2)*imag(S.Branch.Z(7,1));
%Bus 7
P_b7=((pdiff(7,1)+P_b8+pdiff(8,1)+P_b9+pdiff(9,1)+P_b10+pdiff(10,1)+P_b12+pdiff(12,1)+P_b13+pdiff(13,1)+P_b23+pdiff(23,1)+P_b24+pdiff(24,1)+P_b25+pdiff(25,1)+P_b26+pdiff(26,1)+P_b27+pdiff(27,1)+P_b28+pdiff(28,1)+P_b29+pdiff(29,1)+P_b30+pdiff(30,1)+P_b31+pdiff(31,1)+P_b32+pdiff(32,1)+P_b34+pdiff(34,1)+P_b33+pdiff(33,1)+P_b35+pdiff(35,1)+P_b36+pdiff(36,1)+P_b37+pdiff(37,1)+P_b38+pdiff(38,1)+pdiff(39,1)+P_b39+P_b14+pdiff(14,1)+P_b15+pdiff(15,1)+P_b16+pdiff(16,1)+P_b17+pdiff(17,1)+P_b18+pdiff(18,1)+pdiff(19,1)+P_b19+pdiff(20,1)+P_b20+pdiff(21,1)+P_b21+pdiff(22,1)+P_b22+pdiff(11,1)+P_b11)^2+(qdiff(7,1)+Q_b8+qdiff(8,1)+Q_b9+qdiff(9,1)+Q_b10+qdiff(10,1)+Q_b12+qdiff(12,1)+Q_b13+qdiff(13,1)+Q_b23+qdiff(23,1)+Q_b24+qdiff(24,1)+Q_b25+qdiff(25,1)+Q_b26+qdiff(26,1)+Q_b27+qdiff(27,1)+Q_b28+qdiff(28,1)+Q_b29+qdiff(29,1)+Q_b30+qdiff(30,1)+Q_b31+qdiff(31,1)+Q_b32+qdiff(32,1)+Q_b34+qdiff(34,1)+Q_b33+qdiff(33,1)+Q_b35+qdiff(35,1)+Q_b36+qdiff(36,1)+Q_b37+qdiff(37,1)+Q_b38+qdiff(38,1)+qdiff(39,1)+Q_b39+Q_b14+qdiff(14,1)+qdiff(15,1)+Q_b15+Q_b16+qdiff(16,1)+Q_b17+qdiff(17,1)+Q_b18+qdiff(18,1)+qdiff(19,1)+Q_b19+qdiff(20,1)+Q_b20+qdiff(21,1)+Q_b21+qdiff(22,1)+Q_b22+qdiff(11,1)+Q_b11)^2)*real(S.Branch.Z(6,1));
Q_b7=((pdiff(7,1)+P_b8+pdiff(8,1)+P_b9+pdiff(9,1)+P_b10+pdiff(10,1)+P_b12+pdiff(12,1)+P_b13+pdiff(13,1)+P_b23+pdiff(23,1)+P_b24+pdiff(24,1)+P_b25+pdiff(25,1)+P_b26+pdiff(26,1)+P_b27+pdiff(27,1)+P_b28+pdiff(28,1)+P_b29+pdiff(29,1)+P_b30+pdiff(30,1)+P_b31+pdiff(31,1)+P_b32+pdiff(32,1)+P_b34+pdiff(34,1)+P_b33+pdiff(33,1)+P_b35+pdiff(35,1)+P_b36+pdiff(36,1)+P_b37+pdiff(37,1)+P_b38+pdiff(38,1)+pdiff(39,1)+P_b39+P_b14+pdiff(14,1)+P_b15+pdiff(15,1)+P_b16+pdiff(16,1)+P_b17+pdiff(17,1)+P_b18+pdiff(18,1)+pdiff(19,1)+P_b19+pdiff(20,1)+P_b20+pdiff(21,1)+P_b21+pdiff(22,1)+P_b22+pdiff(11,1)+P_b11)^2+(qdiff(7,1)+Q_b8+qdiff(8,1)+Q_b9+qdiff(9,1)+Q_b10+qdiff(10,1)+Q_b12+qdiff(12,1)+Q_b13+qdiff(13,1)+Q_b23+qdiff(23,1)+Q_b24+qdiff(24,1)+Q_b25+qdiff(25,1)+Q_b26+qdiff(26,1)+Q_b27+qdiff(27,1)+Q_b28+qdiff(28,1)+Q_b29+qdiff(29,1)+Q_b30+qdiff(30,1)+Q_b31+qdiff(31,1)+Q_b32+qdiff(32,1)+Q_b34+qdiff(34,1)+Q_b33+qdiff(33,1)+Q_b35+qdiff(35,1)+Q_b36+qdiff(36,1)+Q_b37+qdiff(37,1)+Q_b38+qdiff(38,1)+qdiff(39,1)+Q_b39+Q_b14+qdiff(14,1)+qdiff(15,1)+Q_b15+Q_b16+qdiff(16,1)+Q_b17+qdiff(17,1)+Q_b18+qdiff(18,1)+qdiff(19,1)+Q_b19+qdiff(20,1)+Q_b20+qdiff(21,1)+Q_b21+qdiff(22,1)+Q_b22+qdiff(11,1)+Q_b11)^2)*imag(S.Branch.Z(6,1));
%BUS 4 
P_b4=((pdiff(4,1)+P_b7+pdiff(7,1)+P_b8+pdiff(8,1)+P_b9+pdiff(9,1)+P_b10+pdiff(10,1)+P_b12+pdiff(12,1)+P_b13+pdiff(13,1)+P_b23+pdiff(23,1)+P_b24+pdiff(24,1)+P_b25+pdiff(25,1)+P_b26+pdiff(26,1)+P_b27+pdiff(27,1)+P_b28+pdiff(28,1)+P_b29+pdiff(29,1)+P_b30+pdiff(30,1)+P_b31+pdiff(31,1)+P_b32+pdiff(32,1)+P_b34+pdiff(34,1)+P_b33+pdiff(33,1)+P_b35+pdiff(35,1)+P_b36+pdiff(36,1)+P_b37+pdiff(37,1)+P_b38+pdiff(38,1)+pdiff(39,1)+P_b39+P_b14+pdiff(14,1)+P_b15+pdiff(15,1)+P_b16+pdiff(16,1)+P_b17+pdiff(17,1)+P_b18+pdiff(18,1)+pdiff(19,1)+P_b19+pdiff(20,1)+P_b20+pdiff(21,1)+P_b21+pdiff(22,1)+P_b22+pdiff(11,1)+P_b11)^2+(qdiff(4,1)+Q_b7+qdiff(7,1)+Q_b8+qdiff(8,1)+Q_b9+qdiff(9,1)+Q_b10+qdiff(10,1)+Q_b12+qdiff(12,1)+Q_b13+qdiff(13,1)+Q_b23+qdiff(23,1)+Q_b24+qdiff(24,1)+Q_b25+qdiff(25,1)+Q_b26+qdiff(26,1)+Q_b27+qdiff(27,1)+Q_b28+qdiff(28,1)+Q_b29+qdiff(29,1)+Q_b30+qdiff(30,1)+Q_b31+qdiff(31,1)+Q_b32+qdiff(32,1)+Q_b34+qdiff(34,1)+Q_b33+qdiff(33,1)+Q_b35+qdiff(35,1)+Q_b36+qdiff(36,1)+Q_b37+qdiff(37,1)+Q_b38+qdiff(38,1)+qdiff(39,1)+Q_b39+Q_b14+qdiff(14,1)+qdiff(15,1)+Q_b15+Q_b16+qdiff(16,1)+Q_b17+qdiff(17,1)+Q_b18+qdiff(18,1)+qdiff(19,1)+Q_b19+qdiff(20,1)+Q_b20+qdiff(21,1)+Q_b21+qdiff(22,1)+Q_b22+qdiff(11,1)+Q_b11)^2)*real(S.Branch.Z(3,1));
Q_b4=((pdiff(4,1)+P_b7+pdiff(7,1)+P_b8+pdiff(8,1)+P_b9+pdiff(9,1)+P_b10+pdiff(10,1)+P_b12+pdiff(12,1)+P_b13+pdiff(13,1)+P_b23+pdiff(23,1)+P_b24+pdiff(24,1)+P_b25+pdiff(25,1)+P_b26+pdiff(26,1)+P_b27+pdiff(27,1)+P_b28+pdiff(28,1)+P_b29+pdiff(29,1)+P_b30+pdiff(30,1)+P_b31+pdiff(31,1)+P_b32+pdiff(32,1)+P_b34+pdiff(34,1)+P_b33+pdiff(33,1)+P_b35+pdiff(35,1)+P_b36+pdiff(36,1)+P_b37+pdiff(37,1)+P_b38+pdiff(38,1)+pdiff(39,1)+P_b39+P_b14+pdiff(14,1)+P_b15+pdiff(15,1)+P_b16+pdiff(16,1)+P_b17+pdiff(17,1)+P_b18+pdiff(18,1)+pdiff(19,1)+P_b19+pdiff(20,1)+P_b20+pdiff(21,1)+P_b21+pdiff(22,1)+P_b22+pdiff(11,1)+P_b11)^2+(qdiff(4,1)+Q_b7+qdiff(7,1)+Q_b8+qdiff(8,1)+Q_b9+qdiff(9,1)+Q_b10+qdiff(10,1)+Q_b12+qdiff(12,1)+Q_b13+qdiff(13,1)+Q_b23+qdiff(23,1)+Q_b24+qdiff(24,1)+Q_b25+qdiff(25,1)+Q_b26+qdiff(26,1)+Q_b27+qdiff(27,1)+Q_b28+qdiff(28,1)+Q_b29+qdiff(29,1)+Q_b30+qdiff(30,1)+Q_b31+qdiff(31,1)+Q_b32+qdiff(32,1)+Q_b34+qdiff(34,1)+Q_b33+qdiff(33,1)+Q_b35+qdiff(35,1)+Q_b36+qdiff(36,1)+Q_b37+qdiff(37,1)+Q_b38+qdiff(38,1)+qdiff(39,1)+Q_b39+Q_b14+qdiff(14,1)+qdiff(15,1)+Q_b15+Q_b16+qdiff(16,1)+Q_b17+qdiff(17,1)+Q_b18+qdiff(18,1)+qdiff(19,1)+Q_b19+qdiff(20,1)+Q_b20+qdiff(21,1)+Q_b21+qdiff(22,1)+Q_b22+qdiff(11,1)+Q_b11)^2)*imag(S.Branch.Z(3,1));
%BUS 3
P_b3=(pdiff(3,1)^2+qdiff(3,1)^2)*real(S.Branch.Z(2,1));
Q_b3=(pdiff(3,1)^2+qdiff(3,1)^2)*imag(S.Branch.Z(2,1));
%BUS 2
P_b2=(pdiff(2,1)^2+qdiff(2,1)^2)*real(S.Branch.Z(1,1));
Q_b2=(pdiff(2,1)^2+qdiff(2,1)^2)*imag(S.Branch.Z(1,1));
%BUS 5
P_b5=(pdiff(5,1)^2+qdiff(5,1)^2)*real(S.Branch.Z(4,1));
Q_b5=(pdiff(5,1)^2+qdiff(5,1)^2)*imag(S.Branch.Z(4,1));
%BUS 6
P_b6=(pdiff(6,1)^2+qdiff(6,1)^2)*real(S.Branch.Z(5,1));
Q_b6=(pdiff(6,1)^2+qdiff(6,1)^2)*imag(S.Branch.Z(5,1));

L_approx=(0*Pg_slack+P_b2+P_b3+P_b4+P_b5+P_b6+P_b7+P_b8+P_b9+P_b10+...
           P_b11+P_b12+P_b13+P_b14+P_b15+P_b16+P_b17+P_b18+P_b19+...
           P_b20+P_b21+P_b22+P_b23+P_b24+P_b25+P_b26+P_b27+P_b28+...
           P_b29+P_b30+P_b31+P_b32+P_b33+P_b34+P_b35+P_b36+P_b37+...
           P_b38+P_b39)*50; %Approximate Losses in MW. 

end
