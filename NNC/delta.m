Dat.Card=6;
delta1=1/(Dat.Card-1);
alpha1=0:delta1:1;
k=0;
    Pesos=zeros(Dat.Card^3,3);
    for i=1:size(alpha1,2)
        for ii=1:size(alpha1,2)
            for iii=1:size(alpha1,2)
                k=k+1;
                Pesos(k,:)=[alpha1(i) alpha1(ii) alpha1(iii)];
                if sum(Pesos(k,:))>0
                    Pesos(k,:)=Pesos(k,:)/sum(Pesos(k,:));
                else
                    Pesos(k,:)=[0 0 1];
                end
            end
        end
    end
    Pesos=Pesos(1:k,:);