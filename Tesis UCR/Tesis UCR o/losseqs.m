function fl=losseqs(x,S)

Vs=S.Bus.Voltages(S.Bus.SlackList);
V=S.Bus.Voltages(S.Bus.PVList);
% Slack bus
Pg1=x(1);
Qg1=x(2);
V1=Vs;
d1=0;
V2=x(3);
d2=x(4);
V3=x(5);
d3=x(6);
V4=x(7);
d4=x(8);
V5=x(9);
d5=x(10);
V6=x(11);
d6=x(12);
V7=x(13);
d7=x(14);
V8=x(15);
d8=x(16);
V9=x(17);
d9=x(18);
V10=x(19);
d10=x(20);
V11=x(21);
d11=x(22);
V12=x(23);
d12=x(24);
V13=x(25);
d13=x(26);
V14=x(27);
d14=x(28);
V15=x(29);
d15=x(30);
V16=x(31);
d16=x(32);
V17=x(33);
d17=x(34);
V18=x(35);
d18=x(36);
V19=x(37);
d19=x(38);
V20=x(39);
d20=x(40);
V21=x(41);
d21=x(42);
V22=x(43);
d22=x(44);
V23=x(45);
d23=x(46);
V24=x(47);
d24=x(48);
V25=x(49);
d25=x(50);
V26=x(51);
d26=x(52);
V27=x(53);
d27=x(54);
V28=x(55);
d28=x(56);
V29=x(57);
d29=x(58);
V30=x(59);
d30=x(60);
V31=x(61);
d31=x(62);
V32=x(63);
d32=x(64);
V33=x(65);
d33=x(66);
V34=x(67);
d34=x(68);
V35=x(69);
d35=x(70);
V36=x(71);
d36=x(72);
V37=x(73);
d37=x(74);
V38=x(75);
d38=x(76);
V39=x(77);
d39=x(78);


fl=0+0.5*50*6.968243e+00*(V1^2+V2^2-2*V1*V2*cos(d1-d2))+0.5*50*2.669379e+01*(V1^2+V3^2-2*V1*V3*cos(d1-d3))+0.5*50*5.337225e+01*(V1^2+V4^2-2*V1*V4*cos(d1-d4))+0.5*50*8.892224e+00*(V1^2+V5^2-2*V1*V5*cos(d1-d5))+0.5*50*8.889106e+00*(V1^2+V6^2-2*V1*V6*cos(d1-d6))+0.5*50*6.968243e+00*(V2^2+V1^2-2*V2*V1*cos(d2-d1))+0.5*50*2.669379e+01*(V3^2+V1^2-2*V3*V1*cos(d3-d1))+0.5*50*5.337225e+01*(V4^2+V1^2-2*V4*V1*cos(d4-d1))+0.5*50*5.364151e+01*(V4^2+V7^2-2*V4*V7*cos(d4-d7))+0.5*50*8.892224e+00*(V5^2+V1^2-2*V5*V1*cos(d5-d1))+0.5*50*8.889106e+00*(V6^2+V1^2-2*V6*V1*cos(d6-d1))+0.5*50*5.364151e+01*(V7^2+V4^2-2*V7*V4*cos(d7-d4))+0.5*50*2.467211e+01*(V7^2+V8^2-2*V7*V8*cos(d7-d8))+0.5*50*2.467211e+01*(V8^2+V7^2-2*V8*V7*cos(d8-d7))+0.5*50*2.467463e+01*(V8^2+V9^2-2*V8*V9*cos(d8-d9))+0.5*50*2.467463e+01*(V9^2+V8^2-2*V9*V8*cos(d9-d8))+0.5*50*4.763039e+01*(V10^2+V11^2-2*V10*V11*cos(d10-d11))+0.5*50*2.487477e+01*(V10^2+V12^2-2*V10*V12*cos(d10-d12))+0.5*50*1.970791e+01*(V10^2+V14^2-2*V10*V14*cos(d10-d14))+0.5*50*4.763039e+01*(V11^2+V10^2-2*V11*V10*cos(d11-d10))+0.5*50*2.487477e+01*(V12^2+V10^2-2*V12*V10*cos(d12-d10))+0.5*50*2.467211e+01*(V12^2+V13^2-2*V12*V13*cos(d12-d13))+0.5*50*2.467211e+01*(V13^2+V12^2-2*V13*V12*cos(d13-d12))+0.5*50*8.225726e+00*(V13^2+V23^2-2*V13*V23*cos(d13-d23))+0.5*50*1.970791e+01*(V14^2+V10^2-2*V14*V10*cos(d14-d10))+0.5*50*5.197643e+01*(V14^2+V15^2-2*V14*V15*cos(d14-d15))+0.5*50*3.064478e+01*(V14^2+V16^2-2*V14*V16*cos(d14-d16))+0.5*50*5.197643e+01*(V15^2+V14^2-2*V15*V14*cos(d15-d14))+0.5*50*3.064478e+01*(V16^2+V14^2-2*V16*V14*cos(d16-d14))+0.5*50*1.020932e+01*(V16^2+V17^2-2*V16*V17*cos(d16-d17))+0.5*50*1.020932e+01*(V17^2+V16^2-2*V17*V16*cos(d17-d16))+0.5*50*1.532285e+01*(V17^2+V18^2-2*V17*V18*cos(d17-d18))+0.5*50*5.898662e+00*(V17^2+V23^2-2*V17*V23*cos(d17-d23))+0.5*50*1.532285e+01*(V18^2+V17^2-2*V18*V17*cos(d18-d17))+0.5*50*3.064478e+01*(V18^2+V19^2-2*V18*V19*cos(d18-d19))+0.5*50*3.064478e+01*(V19^2+V18^2-2*V19*V18*cos(d19-d18))+0.5*50*2.467463e+01*(V19^2+V20^2-2*V19*V20*cos(d19-d20))+0.5*50*1.645705e+01*(V19^2+V21^2-2*V19*V21*cos(d19-d21))+0.5*50*2.467463e+01*(V20^2+V19^2-2*V20*V19*cos(d20-d19))+0.5*50*2.469732e+01*(V20^2+V22^2-2*V20*V22*cos(d20-d22))+0.5*50*1.645705e+01*(V21^2+V19^2-2*V21*V19*cos(d21-d19))+0.5*50*2.469732e+01*(V22^2+V20^2-2*V22*V20*cos(d22-d20))+0.5*50*8.225726e+00*(V23^2+V13^2-2*V23*V13*cos(d23-d13))+0.5*50*5.898662e+00*(V23^2+V17^2-2*V23*V17*cos(d23-d17))+0.5*50*6.438306e+00*(V23^2+V24^2-2*V23*V24*cos(d23-d24))+0.5*50*1.072796e+01*(V23^2+V27^2-2*V23*V27*cos(d23-d27))+0.5*50*6.438306e+00*(V24^2+V23^2-2*V24*V23*cos(d24-d23))+0.5*50*1.898392e+01*(V24^2+V25^2-2*V24*V25*cos(d24-d25))+0.5*50*1.898392e+01*(V25^2+V24^2-2*V25*V24*cos(d25-d24))+0.5*50*2.467463e+01*(V25^2+V26^2-2*V25*V26*cos(d25-d26))+0.5*50*2.467463e+01*(V26^2+V25^2-2*V26*V25*cos(d26-d25))+0.5*50*1.072796e+01*(V27^2+V23^2-2*V27*V23*cos(d27-d23))+0.5*50*3.294008e+01*(V27^2+V28^2-2*V27*V28*cos(d27-d28))+0.5*50*3.294008e+01*(V28^2+V27^2-2*V28*V27*cos(d28-d27))+0.5*50*5.482448e+00*(V28^2+V29^2-2*V28*V29*cos(d28-d29))+0.5*50*5.482448e+00*(V29^2+V28^2-2*V29*V28*cos(d29-d28))+0.5*50*5.482641e+00*(V29^2+V30^2-2*V29*V30*cos(d29-d30))+0.5*50*5.482641e+00*(V30^2+V29^2-2*V30*V29*cos(d30-d29))+0.5*50*9.547771e+00*(V30^2+V31^2-2*V30*V31*cos(d30-d31))+0.5*50*9.547771e+00*(V31^2+V30^2-2*V31*V30*cos(d31-d30))+0.5*50*1.047780e+01*(V31^2+V32^2-2*V31*V32*cos(d31-d32))+0.5*50*1.047780e+01*(V32^2+V31^2-2*V32*V31*cos(d32-d31))+0.5*50*9.208064e+00*(V32^2+V34^2-2*V32*V34*cos(d32-d34))+0.5*50*4.296253e+00*(V33^2+V34^2-2*V33*V34*cos(d33-d34))+0.5*50*9.208064e+00*(V34^2+V32^2-2*V34*V32*cos(d34-d32))+0.5*50*4.296253e+00*(V34^2+V33^2-2*V34*V33*cos(d34-d33))+0.5*50*7.659008e+00*(V34^2+V35^2-2*V34*V35*cos(d34-d35))+0.5*50*7.659008e+00*(V35^2+V34^2-2*V35*V34*cos(d35-d34))+0.5*50*3.075598e+01*(V35^2+V36^2-2*V35*V36*cos(d35-d36))+0.5*50*3.075598e+01*(V36^2+V35^2-2*V36*V35*cos(d36-d35))+0.5*50*1.701939e+01*(V36^2+V37^2-2*V36*V37*cos(d36-d37))+0.5*50*1.921463e+01*(V36^2+V38^2-2*V36*V38*cos(d36-d38))+0.5*50*1.732363e+01*(V36^2+V39^2-2*V36*V39*cos(d36-d39))+0.5*50*1.701939e+01*(V37^2+V36^2-2*V37*V36*cos(d37-d36))+0.5*50*1.921463e+01*(V38^2+V36^2-2*V38*V36*cos(d38-d36))+0.5*50*1.732363e+01*(V39^2+V36^2-2*V39*V36*cos(d39-d36));