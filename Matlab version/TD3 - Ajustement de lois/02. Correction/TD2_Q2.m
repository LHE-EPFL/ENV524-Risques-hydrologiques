%---------------------------------------------------
% Risques Hydrologiques et Am�nagement du Territoire
% TD2 - Corrig�
%---------------------------------------------------

clear all % effacer toutes les donn�es en m�moire
close all % fermer toutes les fen�tres (p. ex. les figures) ouvertes
clc       % effacer toutes les entr�es de la fen�tre de commande

% 2. M�thode du maximum de vraisemblance


%L'expression litt�rale de la vraisemblane est donn�e dans le corrig� pdf de l'ann�e derni�re. 
% On l'ecrit ici en language matlab :
%lvrai=lambda.*sum(x)-length(x).*log(lambda.^k./gamma(k))-(k-1).*sum(log(x))
%avec x le vecteur de donn�es
%lambda et k les param�tres de la loi

D1=load('seriegamma.txt') % chargement de donn�es suppos�es issues d'une loi gamma

%Pour trouver le max de vraissemblance on va utiliser la fonction fminbnd sur -ln(Vraisemblance de la loi gamma). Il
%faut pour cela ecrire une fonction matlab, on l'appelle moinslogvraisemblanceloigamma

%function lvrai = moinslogvraisemblanceloigamma(lambda,k,x)

%lvrai=lambda.*sum(x)-length(x).*log(lambda.^k./gamma(k))-(k-1).*sum(log(x));

%Comme il y deux param�tres on va faire une boucle pour s'approcher du
%minimum que l'on initialise avec l'un des param�tres

k2=1 %on initialise sur k

for i=1:100
   
la2=fminbnd(@(la2) moinslogvraisemblanceloigamma(la2,k2,D1),0,10);
k2=fminbnd(@(k2) moinslogvraisemblanceloigamma(la2,k2,D1),0,10);
end
nc=100;% nombre 
dx=max(D1)/nc; 
x=0:dx:nc*dx

Gamvrai=gampdf(x,k2,1/la2);%ATTENION : le troisi�me param�tre doit �tre 1/la2 selon la d�finition matlb de la loi gamma



%On aurai pu aussi utiliser gamfit qui fait directement ce travail et on
%retrouve les m�me valeurs gamfit(D1)



plot(x,Gamvrai,'g')
title('comparaison de diff�rentes m�thodes')
xlabel('x') % l�gende de l'axe des abscisses
ylabel('pdf') % l�gende de l'axe des ordonn�es
legend()
hold on

% on peut comparer ce r�sultat � celui que l'on aurait obtenu si on avait
% utilis� la methode des moments
M1=mean(D1) %Moyenne 
V1=var(D1) %Variance
%Quelle est l'expression de lambda et de k, les param�tres de la loi gamma obtenus avec la methode des moments?
la1=V1/M1;
k1=M1/la1;

Gam=gampdf(x,k1,la1) % Distribution gamma (un peu long � ecrire on utilise dond la fonction matlab)
plot(x,Gam,'m') %loi gamma compar�e aux donn�es

% et pourquoi pas tracer la densit� de probabilit� empirique!?

N=zeros(nc,1);
x=0:dx:nc*dx
% combien a-t-on d'�v�nements par dx?
for j=1:length(D1)
for i=1:(length(x)-1)
if D1(j)<x(i+1) && D1(j)>=x(i);
    N(i)=N(i)+1;
end
end
end

dP=N/length(D1)
pdf=dP/dx %ici on obtient la densit� de probabilit�
figure(1)
plot((x(2):dx:x(end))-dx/2,pdf,'+') %On trace cette densit� avec des points plac�s au milieu de chaque intervales
 % titre de la figure
legend('pdf trouv�e avec la max de vraisemblance','pdf trouv�e avec la m�thode des moments','pdf empirique')


%Il est possible de repr�senter graphiquement ce minimum � l'aide de surf()

figure(2)

k3=0.1:0.01:4;
la3=0.1:0.01:2;
for i=1:length(k3)
    for j=1:length(la3)
G(j,i)=moinslogvraisemblanceloigamma(la3(j),k3(i),D1);
    end
end

surf(k3,la3,G,'edgecolor','none')
hold on
plot3(k2*ones(1001),la2*ones(1001),10*[0:1000],'g') %On trace ici une ligne verte verticale pour visualiser la position du minimum trouv�
xlabel('k')
ylabel('lambda')
zlabel('-ln(L)')

title('visualiser le minimum de -ln(vraisemblance de gamma)')


