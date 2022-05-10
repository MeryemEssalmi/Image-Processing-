function Xn=centrer(Xn)
n=size(Xn(1,:),2);
for i=1:n
    Xn(:,i)=(Xn(:,i)-mean(Xn(:,i)))/std(Xn(:,i));
end
end