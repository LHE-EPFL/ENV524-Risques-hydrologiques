%---------------------------------------------------
% Risques Hydrologiques et Aménagement du Territoire
% TD5 - Corrigé
%---------------------------------------------------

clear all % effacer toutes les données en mémoire
close all % fermer toutes les fenêtres (p. ex. les figures) ouvertes
clc       % effacer toutes les entrées de la fenêtre de commande

% On s'interesse ici à la statistique des valeurs extrêmes. Nous allons
% voir différentes techniques qui permettent de déduire une distribution,
% c'est à dire une loi de probabilité, qui décrit ces dernières.

% Pour rappel, la théorie des valeurs extrêmes permet de dire si la
% distribution des maxima d'un échantillon de valeur (p. ex. de pluies
% journalières) appartient à la familles des lois de valeur extrême de
% Gumbel, Fréchet ou Weibull (et ce quelle que soit la distribution de la 
% population originale). Il s'agit ensuite de caler une loi pour décire
% cette distribution des valeurs extrêmes et de l'extrapoler pour
% déduire les quantiles extrêmes (valeurs, p. ex. de pluie journalière,
% associées à un temps de retour, ici, important).

% 1. Méthode du renouvellement

% préparation des données
load pluies_davos.txt % charger les données
% supprimer les années incomplètes
ind = find(pluies_davos(:,2)==1986); pluies_davos(ind,:) = [];
ind = find(pluies_davos(:,2)==2006); pluies_davos(ind,:) = [];
na = length(unique(pluies_davos(:,2))); % nombre d'années de données
pluie = pluies_davos(:,7); % stocker les précipitations dans la variable "pluie"

% tracer l'histogramme des précipitations (avec 50 classes)
hist(pluie,50)
title('histogramme des données de pluie à Davos') % titre de la figure
xlabel('pluie journalière [mm/j]') % légende de l'axe des abscisses








seuil = 45 % choisir un seuil qui a priori défini les valeurs extrêmes [mm/j]
Ps = pluie(find(pluie>seuil)); % sélection des pluies supérieures au seuil

Ps = sort(Ps); % ordonner les quantiles (valeurs de pluie) par ordre croissant
Ms = mean(Ps)  % moyenne empirique des pluies supérieures au seuil [mm/j]

ns = length(Ps); % nombre de pluies supérieures au seuil
I = [1:1:ns];    % vecteur donnant le rang de chacune de ces pluies ordonnées
T = na/ns.*(ns+1)./(ns+1.-I); % période de retour empirique (mais dépendante du seuil)




%%
lambda = ns/na;    % calcul de lambda
mu = 1/(Ms-seuil); % calcul de mu
% calcul du quantile théorique pour des périodes de retour de 1 à 30 ans
C = seuil+log(lambda)/mu+1/mu.*log([1:30]); 
figure (2)
plot([1:30],C,'r') % courbe théorique
hold on
plot(T,Ps,'r.') % données (représentées par des points)
xlabel('période de retour T [années]')
ylabel('pluie [mm/j]')
legend('quantiles théoriques','quantiles empiriques', 'Location', 'SouthEast')






%%
C100_ren = seuil+log(lambda)/mu+1/mu.*log(100) % pluie centennale théorique [mm/j]
% C100_ren = 94 mm/j

%% ajouter les courbes pour d'autres valeurs de seuil sur le graphique
seuil = 60 % choisir un seuil plus grand que la valeur précédente
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

seuil = 30 % choisir un seuil plus petit que la valeur précédente
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

legend('quantiles théoriques s','quantiles empiriques s','quantiles théoriques s2>s',...
    'quantiles empiriques s2>s','quantiles théoriques s3<s','quantiles empiriques s3<s', 'Location', ...
    'SouthEast')

% Le choix de la valeur seuil est assez arbitraire. Elle doit être
% suffisamment grande pour définir des valeurs dîte "extrêmes", mais
% également suffisamment petite afin d'avoir un nombre de valeur suffisant
% pour que les résultats aient du sens. De manière générale, on cherche à
% ce que la loi cale au mieux les données pour les valeurs importantes,
% puisque c'est ces dernières qui nous interessent.
