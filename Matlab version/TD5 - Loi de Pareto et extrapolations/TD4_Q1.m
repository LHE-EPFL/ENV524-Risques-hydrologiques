%---------------------------------------------------
% Risques Hydrologiques et Am�nagement du Territoire
% TD5 - Corrig�
%---------------------------------------------------

clear all % effacer toutes les donn�es en m�moire
close all % fermer toutes les fen�tres (p. ex. les figures) ouvertes
clc       % effacer toutes les entr�es de la fen�tre de commande

% On s'interesse ici � la statistique des valeurs extr�mes. Nous allons
% voir diff�rentes techniques qui permettent de d�duire une distribution,
% c'est � dire une loi de probabilit�, qui d�crit ces derni�res.

% Pour rappel, la th�orie des valeurs extr�mes permet de dire si la
% distribution des maxima d'un �chantillon de valeur (p. ex. de pluies
% journali�res) appartient � la familles des lois de valeur extr�me de
% Gumbel, Fr�chet ou Weibull (et ce quelle que soit la distribution de la 
% population originale). Il s'agit ensuite de caler une loi pour d�cire
% cette distribution des valeurs extr�mes et de l'extrapoler pour
% d�duire les quantiles extr�mes (valeurs, p. ex. de pluie journali�re,
% associ�es � un temps de retour, ici, important).

% 1. M�thode du renouvellement

% pr�paration des donn�es
load pluies_davos.txt % charger les donn�es
% supprimer les ann�es incompl�tes
ind = find(pluies_davos(:,2)==1986); pluies_davos(ind,:) = [];
ind = find(pluies_davos(:,2)==2006); pluies_davos(ind,:) = [];
na = length(unique(pluies_davos(:,2))); % nombre d'ann�es de donn�es
pluie = pluies_davos(:,7); % stocker les pr�cipitations dans la variable "pluie"

% tracer l'histogramme des pr�cipitations (avec 50 classes)
hist(pluie,50)
title('histogramme des donn�es de pluie � Davos') % titre de la figure
xlabel('pluie journali�re [mm/j]') % l�gende de l'axe des abscisses








seuil = 45 % choisir un seuil qui a priori d�fini les valeurs extr�mes [mm/j]
Ps = pluie(find(pluie>seuil)); % s�lection des pluies sup�rieures au seuil

Ps = sort(Ps); % ordonner les quantiles (valeurs de pluie) par ordre croissant
Ms = mean(Ps)  % moyenne empirique des pluies sup�rieures au seuil [mm/j]

ns = length(Ps); % nombre de pluies sup�rieures au seuil
I = [1:1:ns];    % vecteur donnant le rang de chacune de ces pluies ordonn�es
T = na/ns.*(ns+1)./(ns+1.-I); % p�riode de retour empirique (mais d�pendante du seuil)




%%
lambda = ns/na;    % calcul de lambda
mu = 1/(Ms-seuil); % calcul de mu
% calcul du quantile th�orique pour des p�riodes de retour de 1 � 30 ans
C = seuil+log(lambda)/mu+1/mu.*log([1:30]); 
figure (2)
plot([1:30],C,'r') % courbe th�orique
hold on
plot(T,Ps,'r.') % donn�es (repr�sent�es par des points)
xlabel('p�riode de retour T [ann�es]')
ylabel('pluie [mm/j]')
legend('quantiles th�oriques','quantiles empiriques', 'Location', 'SouthEast')






%%
C100_ren = seuil+log(lambda)/mu+1/mu.*log(100) % pluie centennale th�orique [mm/j]
% C100_ren = 94 mm/j

%% ajouter les courbes pour d'autres valeurs de seuil sur le graphique
seuil = 60 % choisir un seuil plus grand que la valeur pr�c�dente
Ps = pluie(find(pluie>seuil));
Ps = sort(Ps);
Ms = mean(Ps)
ns = length(Ps);
I = [1:1:ns];
T = na/ns.*(ns+1)./(ns+1.-I);
lambda = ns/na;
mu = 1/(Ms-seuil);
C = seuil+log(lambda)/mu+1/mu.*log([1:30]); 
plot([1:30],C,'g')
hold on
plot(T,Ps,'g.')

seuil = 30 % choisir un seuil plus petit que la valeur pr�c�dente
Ps = pluie(find(pluie>seuil));
Ps = sort(Ps);
Ms = mean(Ps)
ns = length(Ps);
I = [1:1:ns];
T = na/ns.*(ns+1)./(ns+1.-I);
lambda = ns/na;
mu = 1/(Ms-seuil);
C = seuil+log(lambda)/mu+1/mu.*log([1:30]); 
plot([1:30],C,'b')
hold on
plot(T,Ps,'b.')

legend('quantiles th�oriques s','quantiles empiriques s','quantiles th�oriques s2>s',...
    'quantiles empiriques s2>s','quantiles th�oriques s3<s','quantiles empiriques s3<s', 'Location', ...
    'SouthEast')

% Le choix de la valeur seuil est assez arbitraire. Elle doit �tre
% suffisamment grande pour d�finir des valeurs d�te "extr�mes", mais
% �galement suffisamment petite afin d'avoir un nombre de valeur suffisant
% pour que les r�sultats aient du sens. De mani�re g�n�rale, on cherche �
% ce que la loi cale au mieux les donn�es pour les valeurs importantes,
% puisque c'est ces derni�res qui nous interessent.
