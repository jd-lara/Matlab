Bus.con = [ ... 
  1  138  1  0  1  1;
  2  138  1  0  1  1;
  3  138  1  0  1  1;
 ];

Line.con = [ ... 
  1  2  100  138  60  0  0  0.00  0.05  0  0  0  0  0  0  1;
  1  3  100  138  60  0  0  0.00  0.05  0  0  0  0  0  0  1;
  3  2  100  138  60  0  0  0.00  0.05  0  0  0  0  0  0  1;
 ];

Shunt.con = [ ... 
   3  100  138  60  0   4.062  1;
  ];

SW.con = [ ... 
  1  100  138  1.0  0  999  -999  1.0  0.95  0.9  0.5  1  1;
 ];

PV.con = [ ... 
  2  100  138  0.9  0.95  999  -999  1.0  0.95  0.5  1;
 ];
  
PQ.con = [ ... 
  3  100  138  1.8  0.8718  1.0  0.95  0  1;
 ];

Bus.names = {... 
  'Area 1'; 'Area 2'; 'Area 3'};
