%Just hit play. 
clear all ; close all;
clc
S=readcf('base2.cf'); %This Function ONLY reads the information stored on the *cf file 
S=bldybus(S); 
bldpfloweqs(S)
S=pflow(S);

S.Bus.Voltages