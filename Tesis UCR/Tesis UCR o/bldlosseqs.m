function bldlosseqs(S)

% Create a symbolic set of power flow equations
% Input:  Structure S including System information, after procesed with
%          readcf and bldybus      
% Output: Power flow equations in pfloweqs.m file


%Read and write the variables into the function from the structure
YB=S.Ybus;
Slack=S.Bus.SlackList;
PV=S.Bus.PVList;
Base=S.BaseMVA;

n=length(YB);
m=length(PV);

fid=fopen('losseqs.m','w+');
fprintf(fid,'function fl=losseqs(x,S)\n\n');
fprintf(fid,'Vs=S.Bus.Voltages(S.Bus.SlackList);\n');
fprintf(fid,'V=S.Bus.Voltages(S.Bus.PVList);\n');

% Symbolic Variables
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
   else 
     fprintf(fid,'V%d=x(%d);\n',k,l);  l=l+1;
     fprintf(fid,'d%d=x(%d);\n',k,l);  l=l+1;
   end
end



g=abs(real(YB)+0);

fprintf(fid,'\n\n');
fprintf(fid,'fl=0');
for ki=1:n,
    for kj=1:n
        if g(ki,kj)~=0 || g(kj,ki)~=0
            if ki~= kj, fprintf(fid,'+0.5*%d*%d*(V%d^2+V%d^2-2*V%d*V%d*cos(d%d-d%d))',Base,g(ki,kj),ki,kj,ki,kj,ki,kj); end
        end
    end
end
fprintf(fid,';');
fclose(fid);

