function e=calculererror(X,b,o)
classe=X;
K=1;
e=0;
cpt=0;
for i=1:b
    cpt=cpt+1;
    if(classe(i)~=K)
     e=e+1;
    end
     if(cpt==o)
         cpt=0;
         K=K+1;
     end
end
end
      