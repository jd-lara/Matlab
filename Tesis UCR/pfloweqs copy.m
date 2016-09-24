function func(YB,Slack,PV)
% Create a symbolic set of power flow equations
% Input:  YB -> Y-bus
%         Slack -> Slack bus number
%         PV -> PV buses list, i.e., [n1 n2 n3 ....]
% Output: Power flow equations in test.m file

n=length(YB);
m=length(PV);

fid=fopen('test.m','w');
fprintf(fid,'function f=func(x)\n\n');

% Symbolic Voltages and powers
l=1;
for k=1:n,
   V(k)=sym(sprintf('V%d*cos(d%d)+i*V%d*sin(d%d)',k,k,k,k));
   Vc(k)=sym(sprintf('V%d*cos(d%d)-i*V%d*sin(d%d)',k,k,k,k)); % conjugate
   pv = find(PV==k);
   if k==Slack,
     fprintf(fid,'%c Slack bus\n','%');  
     fprintf(fid,'Pg%d=x(%d);\n',k,l);  l=l+1;
     fprintf(fid,'Qg%d=x(%d);\n',k,l);  l=l+1;
     fprintf(fid,'V%d=Vs;\n',k);  
     fprintf(fid,'d%d=0;\n',k);  
   elseif pv,
     fprintf(fid,'%c PV bus\n','%'); 
     fprintf(fid,'Qg%d=x(%d);\n',k,l);  l=l+1;
     fprintf(fid,'d%d=x(%d);\n',k,l);  l=l+1;
     fprintf(fid,'V%d=V(%d);\n',k,pv);  
   else, 
     fprintf(fid,'V%d=x(%d);\n',k,l);  l=l+1;
     fprintf(fid,'d%d=x(%d);\n',k,l);  l=l+1;
   end
end


YBc=conj(YB);
Ic=YBc*Vc.';

fprintf(fid,'\n\n');
l=1;
for k=1:n,
   S=vpa(V(k)*Ic(k),5);
   pv = find(PV==k);
   if k==Slack,
     fprintf(fid,'f(%d)=Pg%d-Pl(%d)-real(%s);\n',l,k,k,char(S));  l=l+1;
     fprintf(fid,'f(%d)=Qg%d-Ql(%d)-imag(%s);\n',l,k,k,char(S)); l=l+1;
   elseif pv,
     fprintf(fid,'f(%d)=Pg(%d)-Pl(%d)-real(%s);\n',l,k,k,char(S));  l=l+1;
     fprintf(fid,'f(%d)=Qg%d-Ql(%d)-imag(%s);\n',l,k,k,char(S)); l=l+1;
   else, 
     fprintf(fid,'f(%d)=Pg(%d)-Pl(%d)-real(%s);\n',l,k,k,char(S));  l=l+1;
     fprintf(fid,'f(%d)=Qg(%d)-Ql(%d)-imag(%s);\n',l,k,k,char(S)); l=l+1;
   end
end

fclose(fid);

