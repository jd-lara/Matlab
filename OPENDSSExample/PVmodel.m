clear all;

irrad=0.9; % kW/m2
Pmpp=5.88; % kW
Pcut=0.1; % en pu

PVinput=[irrad;Pmpp;Pcut];

cur_irrad=[0 0 0 0 0 0 .1 .2 .3 .5 .8 .9 1.0 1.0 .99 .9 .7 .4 .1 0 0 0 0 0]; % en pu

temp=[25,25,25,25,25,25,25,25,35,40,45,50,60,60,55,40,35,30,25,25,25,25,25,25];

tvspx=[0;25;75;100]; tvspy=[1.2;1.0;0.8;0.6]; tvsp=[tvspx,tvspy];

effx=[.1;.2;.4;1.0]; effy=[.86;.9;.93;.97]; eff=[effx,effy];

PoutPV=PVoutput(PVinput,tvsp,cur_irrad,temp,eff)

kWhPV=sum(PoutPV)

kWhPVmes=30.4*kWhPV

kWhPVano=kWhPVmes*12