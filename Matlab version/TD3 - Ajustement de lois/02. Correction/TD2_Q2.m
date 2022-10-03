%---------------------------------------------------
% Risques Hydrologiques et Aménagement du Territoire
% TD2 - Corrigé
%---------------------------------------------------

clear all % effacer toutes les données en mémoire
close all % fermer toutes les fenêtres (p. ex. les figures) ouvertes
clc       % effacer toutes les entrées de la fenêtre de commande

% 2. Méthode du maximum de vraisemblance


%L'expression littérale de la vraisemblane est donnée dans le corrigé pdf de l'année dernière. 
% On l'ecrit ici en language matlab :
%lvrai=lambda.*sum(x)-length(x).*log(lambda.^k./gamma(k))-(k-1).*sum(log(x))
%avec x le vecteur de données
%lambda et k les paramètres de la loi

D1=load('seriegamma.txt') % chargement de données supposées issues d'une loi gamma

%Pour trouver le max de vraissemblance on va utiliser la fonction fminbnd sur -ln(Vraisemblance de la loi gamma). Il
%faut pour cela ecrire une fonction matlab, on l'appelle moinslogvraisemblanceloigamma

%function lvrai = moinslogvraisemblanceloigamma(lambda,k,x)

%lvrai=lambda.*sum(x)-length(x).*log(lambda.^k./gamma(k))-(k-1).*sum(log(x));

%Comme il y deux paramètres on va faire une boucle pour s'approcher du
%minimum que l'on initialise avec l'un des paramètres

k2=1 %on initialise sur k

for i=1:100
   
la2=fminbnd(@(la2) moinslogvraisemblanceloigamma(la2,k2,D1),0,10);
k2=fminbnd(@(k2) moinslogvraisemblanceloigamma(la2,k2,D1),0,10);
end
nc=100;% nombre 
dx=max(D1)/nc; 
x=0:dx:nc*dx

Gamvrai=gampdf(x,k2,1/la2);%ATTENION : le troisième paramètre doit être 1/la2 selon la définition matlb de la loi gamma



%On aurai pu aussi utiliser gamfit qui fait directement ce travail et on
%retrouve les même valeurs gamfit(D1)



plot(x,Gamvrai,'g')
title('comparaison de différentes méthodes')
xlabel('x') % légende de l'axe des abscisses
ylabel('pdf') % légende de l'axe des ordonnées
legend()
hold on

% on peut comparer ce résultat à celui que l'on aurait obtenu si on avait
% utilisé la methode des moments
M1=mean(D1) %Moyenne 
V1=var(D1) %Variance
%Quelle est l'expression de lambda et de k, les paramètres de la loi gamma obtenus avec la methode des moments?
la1=V1/M1;
k1=M1/la1;

Gam=gampdf(x,k1,la1) % Distribution gamma (un peu long à ecrire on utilise dond la fonction matlab)
plot(x,Gam,'m') %loi gamma comparée aux données

% et pourquoi pas tracer la densité de probabilité empirique!?

N=zeros(nc,1);
x=0:dx:nc*dx
% combien a-t-on d'événements par dx?
for j=1:length(D1)
for i=1:(length(x)-1)
if D1(j)<x(i+1) && D1(j)>=x(i);
    N(i)=N(i)+1;
end
end
end

dP=N/length(D1)
pdf=dP/dx %ici on obtient la densité de probabilité
figure(1)
plot((x(2):dx:x(end))-dx/2,pdf,'+') %On trace cette densité avec des points placés au milieu de chaque intervales
 % titre de la figure
legend('pdf trouvée avec la max de vraisemblance','pdf trouvée avec la méthode des moments','pdf empirique')


%Il est possible de représenter graphiquement ce minimum à l'aide de surf()

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
plot3(k2*ones(1001),la2*ones(1001),10*[0:1000],'g') %On trace ici une ligne verte verticale pour visualiser la position du minimum trouvé
xlabel('k')
ylabel('lambda')
zlabel('-ln(L)')

title('visualiser le minimum de -ln(vraisemblance de gamma)')


