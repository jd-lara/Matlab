function bldnncpfloweqs_m(S)

% Create a symbolic set of power flow equations
% Input:  Structure S including System information, after procesed with
%          readcf and bldybus      
% Output: Power flow equations in pfloweqs.m file


%Read and write the variables into the function from the structure
YB=S.Ybus;
Slack=S.Bus.SlackList;
PV=S.Bus.PVList;
PQG=find(S.Bus.busType==1);
pf=0.92;
s=tan(acos(pf));


n=length(YB);
%m=length(PV);

fid=fopen('pfloweqs_nnc.m','w+');
fprintf(fid,'function ceq_nnc=pfloweqs_nnc(x,S)\n\n');
fprintf(fid,'Vs=S.Bus.Voltages(S.Bus.SlackList);\n');
fprintf(fid,'V=S.Bus.Voltages(S.Bus.PVList);\n');
fprintf(fid,'Pg=real(S.Bus.Generation);\nQg=imag(S.Bus.Generation);\n');
fprintf(fid,'Pl=real(S.Bus.Load);\nQl=imag(S.Bus.Load);\n\n');

% Symbolic Voltages and powers
l=1;
for k=1:n,
   V(k)=sym(sprintf('V%d*cos(d%d)+i*V%d*sin(d%d)',k,k,k,k));
   Vc(k)=sym(sprintf('V%d*cos(d%d)-i*V%d*sin(d%d)',k,k,k,k)); % conjugate
   pv = find(PV==k);
   pqg = find(PQG==k);
   if k==Slack,
     fprintf(fid,'%c Slack bus (Type 3)\n','%');  
     fprintf(fid,'Pg%d=x(%d);\n',k,l);  l=l+1;
     fprintf(fid,'Qg%d=x(%d);\n',k,l);  l=l+1;
     fprintf(fid,'V%d=Vs;\n',k);  
     fprintf(fid,'d%d=0;\n',k);  
   elseif pv,
     fprintf(fid,'%c PV bus (Type 2)\n','%'); 
     fprintf(fid,'Qg%d=x(%d);\n',k,l);  l=l+1;
     fprintf(fid,'Pg%d=x(%d);\n',k,l);  l=l+1;
     fprintf(fid,'d%d=x(%d);\n',k,l);  l=l+1;
     fprintf(fid,'V%d=V(%d);\n',k,pv);  
   else
     fprintf(fid,'V%d=x(%d);\n',k,l);  l=l+1;
     fprintf(fid,'d%d=x(%d);\n',k,l);  l=l+1;
   end
end
   for k= PQG',
     fprintf(fid,'%c PQ buses with generators (Type 1)\n','%');
     fprintf(fid,'Pg%d=x(%d);\n',k,l);  l=l+1;
   end

YBc=conj(YB);
Ic=YBc*Vc.';

fprintf(fid,'\n\n');
fprintf(fid,'ceq_nnc = [');
l=1;
for k=1:n,
   S=vpa(V(k)*Ic(k),5);
   pv = find(PV==k);
   pqg = find(PQG==k);
   if k==Slack,
     fprintf(fid,'Pg%d-Pl(%d)-real(%s);\n',k,k,char(S));  l=l+1;
     fprintf(fid,'Qg%d-Ql(%d)-imag(%s);\n',k,k,char(S)); l=l+1;
   elseif pv,
     fprintf(fid,'Pg(%d)-Pl(%d)-real(%s);\n',k,k,char(S));  l=l+1;
     fprintf(fid,'Qg%d-Ql(%d)-imag(%s);\n',k,k,char(S)); l=l+1;
   elseif pqg 
     fprintf(fid,'Pg%d-Pl(%d)-real(%s);\n',k,k,char(S));  l=l+1;
     fprintf(fid,'Pg%d*%d-Ql(%d)-imag(%s);\n',k,s,k,char(S)); l=l+1;
   else
     fprintf(fid,'-Pl(%d)-real(%s);\n',k,char(S));  l=l+1;
     fprintf(fid,'-Ql(%d)-imag(%s);\n',k,char(S)); l=l+1;
   end
end


fprintf(fid,'];');
fclose(fid);

