%---------------------------------------------------
% Risques Hydrologiques et Am�nagement du Territoire
% TD2 - Corrig�
%---------------------------------------------------

clear all % effacer toutes les donn�es en m�moire
close all % fermer toutes les fen�tres (p. ex. les figures) ouvertes
clc       % effacer toutes les entr�es de la fen�tre de commande

% 2. Loi de probabilit� et ajustements

%-----------
% Question 1 Ajustement (qualitatif) d'une loi
%-----------

%On ouvre les diff�rents fichier

D1=load('serie01.txt');
D2=load('serie02.txt');
D3=load('serie03.txt');

% Mesure des diff�rents moments

%Ordre 1 Moyenne
M1=mean(D1)
M2=mean(D2)
M3=mean(D3)

%Ordre 2 Variance, renseigne sur l'�talement
V1=var(D1)
V2=var(D2)
V3=var(D3)

%Ordre 3 Sym�trie
S1=mean((D1-M1).^3)
S2=mean((D2-M2).^3)
S3=mean((D3-M3).^3)

%Allure rapide de la distribution � l'aide de hist
figure()
subplot(1,3,1)
histogram(D1,30)
title('histogramme') % titre de la figure
xlabel('x') % l�gende de l'axe des abscisses
ylabel('N') % l�gende de l'axe des ordonn�es
subplot(1,3,2)
histogram(D2,30)
title('histogramme')
xlabel('x')
ylabel('N')
subplot(1,3,3)
histogram(D3,30)
title('histogramme')
xlabel('x')
ylabel('N')

%L'allure nous permet de supposer que la distribution 1 correspond � une
%loi exponentielle, la distribution 2 � une loi gamma et la
%distribution 3 � une loi Gaussienne.
%Pour la distribution 2 on aurait pu penser � une loi de Poisson
%Cependant la loi de poisson �tant discr�te elle ne peut
% correspondre � ces donn�es qui pr�sentent de valeurs non discr�tes

%--------------------------------------------------------------

%Comparaison entre les s�ries empiriques et les s�ries th�oriques
%construite � partir des moments

%-----------------------------------------

%�tude de la s�rie 1


%distribution empirique
% largeur du compartiment
nc=100;
dx=max(D1)/nc;
N=zeros(nc,1);
x=0:dx:nc*dx;
% combien d'�v�nements par dx?
for j=1:length(D1)
    for i=1:(length(x)-1)
        if(D1(j)<x(i+1) && D1(j)>=x(i))
            N(i)=N(i)+1;
        end
    end
end


dP=N/length(D1)
pdf=dP/dx
figure()
plot((x(2):dx:x(end))-dx/2,pdf,'+')
title('comparaison des lois avec les donn�es') % titre de la figure
xlabel('x') % l�gende de l'axe des abscisses
ylabel('pdf') % l�gende de l'axe des ordonn�es
hold on

% comparaison avec les lois de distribution th�oriques

%loi exponentielle
x=0:0.01:20;
l=1/M1
expo=l*exp(-l*x);

%loi gaussienne
gaussienne=1/sqrt(2*pi*V1)*exp(-((x-M1)).^2./(2*V1));

%Loi Gamma: voir http://fr.wikipedia.org/wiki/Loi_Gamma pour la d�finition

theta=V1/M1

k=M1/theta

Gam=gampdf(x,k,theta) % Distribution gamma (un peu long � ecrire on utilise dond la fonction matlab)


plot(x,gaussienne,'r') % trac� de la Loi gaussienne
plot(x,expo,'g') %Loi exponentielle

plot(x,Gam,'m') %loi gamma

% On visualise que la loi expontielle et la loi gamma s'adapte bien aux
% donn�es.
%% -----------------------------------

% �tude de la s�rie 2



M2=mean(D2)
V2=var(D2)

%distribution empirique
% largeur du compartiment
nc=100;
dx=max(D2)/nc; %on prend la valeur maxd'un c�t� ou de l'autre
%pour ne pas perdre des valeurs extr^mes negatives par la suite.
N=zeros(nc,1);
x=0:dx:nc*dx
% combien d'�v�nements par dx?
for j=1:length(D2)
    for i=1:(length(x)-1)
        if D2(j)<x(i+1) && D2(j)>=x(i)
            N(i)=N(i)+1;
        end
    end
end

dP=N/length(D2)
pdf=dP/dx
figure()
plot((x(2):dx:x(end))-dx/2,pdf,'+')
title('comparaison des lois avec les donn�es') % titre de la figure
xlabel('x') % l�gende de l'axe des abscisses
ylabel('pdf') % l�gende de l'axe des ordonn�es
hold on

%coparaison avec les lois de distribution th�oriques
%loi exponentielle
x=0:0.01:20;
l=1/M2
expo=l*exp(-l*x);

%loi gaussienne
gaussienne=1/sqrt(2*pi*V2)*exp(-((x-M2)).^2./(2*V2));

%Loi Gamma: voir http://fr.wikipedia.org/wiki/Loi_Gamma pour la d�finition

theta=V2/M2

k=M2/theta

Gam=gampdf(x,k,theta) % Distribution gamma (un peu long � ecrire on utilise dond la fonction matlab)


plot(x,gaussienne,'r')
plot(x,expo,'g')
plot(x,Gam,'m') %loi gamma
legend
%% -----------------------------------
%�tude de la s�rie 3






M3=mean(D3)


V3=var(D3)


S3=mean((D3-M3).^3)


%distribution empirique
% largeur du compartiment
nc=100;
dx=max(D3)/nc; %on prend la valeur maxd'un c�t� ou de l'autre
%pour ne pas perdre des valeurs extr^mes negatives par la suite.
N=zeros(nc,1);
x=0:dx:nc*dx
% combien d'�v�nements par dx?
for j=1:length(D3)
    for i=1:(length(x)-1)
        if D3(j)<x(i+1) && D3(j)>=x(i);
            N(i)=N(i)+1;
        end
    end
end

dP=N/length(D3)
pdf=dP/dx
figure()
plot((x(2):dx:x(end))-dx/2,pdf,'+')
title('comparaison des lois avec les donn�es') % titre de la figure
xlabel('x') % l�gende de l'axe des abscisses
ylabel('pdf') % l�gende de l'axe des ordonn�es
hold on

%comparaison avec les lois de distribution th�oriques

%loi exponentielle
x=0:0.01:max(D3);
l=1/M3
expo=l*exp(-l*x);

%loi gaussienne
gaussienne=1/sqrt(2*pi*V3)*exp(-((x-M3)).^2./(2*V3));

%Loi Gamma: voir http://fr.wikipedia.org/wiki/Loi_Gamma pour la d�finition

theta=V3/M3
k=M3/theta
Gam=gampdf(x,k,theta) % Distribution gamma (un peu long � ecrire on utilise dond la fonction matlab)


plot(x,gaussienne,'r') %trac� de la loi Gaussienne
plot(x,expo,'g')
plot(x,Gam,'m') %loi gamma

%Cette distribution 3 peu aussi bien �tre une loi gamma qu'une loi de
%gauss

%----------------------------------

%trac� du quantile pour la distribution 3
figure()
% on compare les donn�es brutes � une distribution gaussienne on trouve une
% tr�s bonne corr�latiion
% pd = ProbDistUnivParam('normal',[M3 sqrt(V3)])
pd = makedist('Normal','mu',M3,'sigma', V3);
qqplot(D3,pd)

%%
%-----------
% Question 2 Loi binomiale et loi de Poisson
%-----------


%-------------------------------------------2.1-1

p=0.1; % choix des param�tres de la loi
m=100;

%Loi binomiale
yb=zeros(1,30);
yp=zeros(1,30);
xb=[1:1:30];

for k=1:30
    yb(k)=factorial(m)/factorial(k)/factorial(m-k)*p^k*(1-p)^(m-k);% On aurait put aussi utiliser y=binopdf(k,100,0.1)
    yp(k)=exp(-p*m)*(p*m)^k/factorial(k); %loi de poisson
end

figure
plot(xb,yb,'b-')
hold on
plot(xb,yp,'m-')





%-------------------------------------------2.1-2


k=5;
m=100;
yb=zeros(1,20);
yp=zeros(1,20);
xp=[1:1:20]./100;
%Loi binomiale
for p=1:20
    yb(p)=factorial(m)/factorial(k)/factorial(m-k)*(p/100)^k*(1-(p/100))^(m-k); %loi binomiale
    yp(p)=exp(-(p/100)*m)*((p/100)*m)^k/factorial(k); %loi de poisson
end

figure
plot(xp,yb,'b-')
hold on
plot(xp,yp,'m-')



%-------------------------------------------2.1-3
% D�termination de la contdition � remplir pour pouvoir approximer la loi
% binomiale par la loi de Poisson
m=100;
yb=zeros(20,20);
yp=zeros(20,20);
xp=[1:1:20]./100;
erreur=zeros(20,20);
for p=1:20
    for k=1:20
        yb(p,k)=factorial(m)/factorial(k)/factorial(m-k)*(p/100)^k*(1-(p/100))^(m-k);
        yp(p,k)=exp(-(p/100)*m)*((p/100)*m)^k/factorial(k);
        erreur(p,k)=max([erreur(p,k),abs(yb(p,k)-yp(p,k))/yb(p,k)]);% On enregistre l'erreur relative max pour toutes les configuration
    end
end
figure
plot(xp,erreur(:,1)) %On trace toutes les allures de l'erreur
hold on
plot(xp,erreur(:,2))
xlabel('p','Interpreter','latex')
ylabel('Error','Interpreter','latex')
legend({'k=1','k=2'})
[p,k]=find(erreur<0.1);


%-------------------------------------------2.1-4
% La condition a respecter doit �tre moins de 10% d'erreur
[P,K]=meshgrid(0.001:0.001:0.5,1:1:50)
yb=factorial(m)./factorial(K)./factorial(m-K).*P.^K.*(1-P).^(m-K);
yp=exp(-P*m).*(P*m).^K./factorial(K);
erreur=log(abs(yb-yp)./yb);
mesh(P,K,erreur)
[p,k]=find(erreur<0.1);

%plot(p,k) permet de visualiser les p et les k qui v�rifie
%On visualise que pour une certaine valeur de p k doit �tre compris entre
%deux valeurs

% avant p= 15% k est inferieur � 10p+150
%apr�s p=15% k doit �tre compris entre k=10p-150 et k=10p+150
%ces conditions sont � v�rifier... car les erreurs relatives pour les
%petites veleurs semble jouer des r�les trop important...










