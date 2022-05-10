function Sigma=sigm(X)
D=size(X,2);
for i =1:32
Sigma(i,:,:)=eye(D);
end
end