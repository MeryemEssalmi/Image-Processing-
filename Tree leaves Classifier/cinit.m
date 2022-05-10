function cinit=cinit(Xn)
n=size(Xn(1,:),2);
cinit=[-1 1.5 0 0.5*ones(1,n-3);2 -1 -0.5 0.5*ones(1,n-3);1 -1.5 0.5 0.5*ones(1,n-3);1 1 0 0.5*ones(1,n-3)];
%cinit=[-1.5 1 0 0.5*ones(1,n-3);1 -1 0 0.5*ones(1,n-3);1 1 0 0.5*ones(1,n-3);0 -1.5 0 0.5*ones(1,n-3)];
end