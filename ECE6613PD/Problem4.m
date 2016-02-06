Bus.con = [ ... 
  1 140  1  0  4  1;
  2 140  1  0  4  1;
  3 140  1  0  4  1;
  4  20  1  0  4  1;
 ];

Line.con = [ ... 
  1  2  200  140  60  1  0  0.00486  0.04858  0  0  0  0  0  0  1;
  1  3  200  140  60  1  0  0.00486  0.04858  0  0  0  0  0  0  1;
  2  3  200  140  60  1  0  0.00486  0.04858  0  0  0  0  0  0  1;
  3  4  200   20  60  0  0  0.00     0.04858  0  0  0  0  0  0  1;
 ];


SW.con = [ ... 
  2  100  140  1.0  0  0.5  -0.5  1.2  0.8  1  1  1  1;
 ];

PV.con = [ ... 
  1  100  140  0.6  1.0  1.0  -1.0  1.2  0.8  1  1;
 ];

PQ.con = [ ... 
  3  100  140  0.0  0.0    1.05  0.95  0  1 ;
  4  100   20  1.8  0.8719 1.05  0.95  0  1 ;
 ];



Bus.names = {... 
  'Bus 01'; 'Bus 02'; 'Bus 03';'Bus 04'};

