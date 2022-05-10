clear all
close all

LeafType={'papaya','pimento','chrysanthemum','chocolate_tree'};%,... à décommenter pour ajouter de nouvelles espèces 
% 'duranta_gold','eggplant','ficus','fruitcitere','geranium','guava',...
% 'hibiscus','jackfruit','ketembilla','lychee','ashanti_blood','mulberry_leaf',...
% 'barbados_cherry','beaumier_du_perou','betel','pomme_jacquot','bitter_orange',...
% 'rose','caricature_plant','star_apple','chinese_guava','sweet_olive','sweet_potato',...
% 'thevetia','coeur_demoiselle','vieux_garcon','coffee','croton'};

K=length(LeafType);

label=[];
X=[];
for LT=LeafType
    
    filenames=dir([LT{1},filesep,'Training',filesep,'*.png']);
    
    
    for ifile=1:length(filenames)
        
        img=imread([filenames(ifile).folder,filesep,filenames(ifile).name]);
        X=[X;extractFeatures(img)];
        label=[label,LT];
        close all;
        
    end
end
%% Extraire les valeurs du test
Xtest=[];
labeltest=[];
for LT=LeafType
    
    filenames=dir([LT{1},filesep,'Test',filesep,'*.png']);
    
    
    for ifile=1:length(filenames)
        
        img=imread([filenames(ifile).folder,filesep,filenames(ifile).name]);
        Xtest=[Xtest;extractFeatures(img)];
        labeltest=[labeltest,LT];
        close all;
        
    end
end

%% Réduction de la dimension par ACP
mux=mean(X);
X=X-mux;
[U,D,V]=svd(X);
Xp=X*V;
ncp=2;
Xp=Xp(:,1:ncp);
Xtest=Xtest-mux;
Xptest=Xtest*V;
Xptest=Xptest(:,1:2);
% visualisation en 3d: on regarde 3 composantes de l'ACP

comp=[1 2]; % 3 premières composantes par défaut, à modifier pour visualiser d'autres composantes

figure(2), hold,
for LT=LeafType
    Ilt=find(strcmp(label,LT));
    scatter(Xp(Ilt,comp(1)),Xp(Ilt,comp(2)),'o','filled');
    
end
cp=[1 2]
for LT=LeafType
  
    Ilt=find(strcmp(label,LT));
    scatter(Xp(Ilt,cp(1)),Xp(Ilt,cp(2)),'o','filled');
    Ilttest=find(strcmp(labeltest,LT));
    scatter(Xptest(Ilttest,cp(1)),Xptest(Ilttest,cp(2)),'d','filled','MarkerEdgeColor',[0 .5 .5],...
              'LineWidth',1.5);
end
legend(LeafType(1:4),'Location','SouthWest');


% détermination de la dimension pour la suite du TD
 % peut être modifié!
y=[[1;0],[0;1],[0;0],[1;1]];
%%
Xte=Xptest;
Xte(1:5,2)=Xptest(1:5,2)+1;
Xte(6:10,2)=Xptest(6:10,2)-1;
Xte(11:15,2)=Xptest(11:15,2)-1;
Xte(11:15,1)=Xptest(11:15,1)-1;
Xt=Xp;
Xt(1:15,2)=Xp(1:15,2)+1;
Xt(16:30,2)=Xp(16:30,2)-1;
Xt(31:45,2)=Xp(16:30,2)-1;
Xt(31:45,1)=Xp(16:30,1)-1;
class=Xt';
t1=[repmat(y(:,1),1,15),repmat(y(:,2),1,15),repmat(y(:,3),1,15),repmat(y(:,4),1,15)];
figure
plotpv(class,t1)
hold on 
plot(Xte(:,1),Xte(:,2),'r*');
hold off
%%
net= perceptron;

% sse Sum squared error performance function.calculates a
  %network performance given targets, outputs, error weights and parameters
  %as the sum of squared errors.
i=0;
e=10;
linehandle=plotpc(net.IW{1},net.b{1})
x.adaptParam.passes=1;
while(sse(e) & i<1000)
    i=i+1;
[net,y1,e,xf] = adapt(net,class,t1);
linehandle=plotpc(net.IW{1},net.b{1},linehandle);
%drawnow;
end
view(net);
%getwb(net);
figure()
for p=1:20
y2=net([Xte(p,1);Xte(p,2)]);
if (y2(1)==1& y2(2)==1)
    hold,
    plot(Xte(p,1),Xte(p,2),'rx');
elseif (y2(1)==0 & y2(2)==1)
    hold,
    plot(Xte(p,1),Xte(p,2),'r*');

elseif (y2(1)==0& y2(2)==0)
    hold,
    plot(Xte(p,1),Xte(p,2),'ro');
elseif (y2(1)==1 & y2(2)==0)
    hold,
 plot(Xte(p,1),Xte(p,2),'r+');
end
%tracer le point avec une autre couleur?
hold on
plotpv(class,t1);
plotpc(net.IW{1},net.b{1});
end
hold off;
%%
clss=class;
y=[[-1;-1;-1;1],[-1;-1;1;-1],[-1;1;-1;-1],[1;-1;-1;-1]];
t2=[repmat(y(:,1),1,15),repmat(y(:,2),1,15),repmat(y(:,3),1,15),repmat(y(:,4),1,15)];
%plotpv(clss,t2);
figure(1)
hold on
plot(class(1,1:15),class(2,1:15),'k*')
plot(class(1,16:30),class(2,16:30),'r+')
plot(class(1,31:45),class(2,31:45),'b.')
plot(class(1,46:60),class(2,46:60),'go')
net= feedforwardnet([5]);
x.divideParam.trainRatio=1;
x.divideParam.valRatio=0;
x.divideParam.testRatio=0;
net = train(net,clss,t2);
view(net);
%xtest = [0.7; 1.2]; 
%ytest=net(xtest)
span = -2:.01:2;
[P1,P2]= meshgrid(span,span);
P= [P1(:),P2(:)]';
classerep = net(P);

figure(1)
m =mesh(P1,P2,reshape(classerep(1,:),length(span),length(span))-5);
set(m,'facecolor',[1 1 1], 'linestyle','none');
hold on
m =mesh(P1,P2,reshape(classerep(2,:),length(span),length(span))-5);
set(m,'facecolor',[1 1.0 0.5], 'linestyle','none');
m =mesh(P1,P2,reshape(classerep(3,:),length(span),length(span))-5);
set(m,'facecolor',[.4 1.0 .9], 'linestyle','none');
m =mesh(P1,P2,reshape(classerep(4,:),length(span),length(span))-5);
set(m,'facecolor',[1 0 1], 'linestyle','none');

view(2)
%%






