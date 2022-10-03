%---------------------------------------------------
% Risques Hydrologiques et Aménagement du Territoire
% TD2 - Corrigé
%---------------------------------------------------

clear all % effacer toutes les données en mémoire
close all % fermer toutes les fenêtres (p. ex. les figures) ouvertes
clc       % effacer toutes les entrées de la fenêtre de commande

% 1. Méthode des Moments

% paramètres des lois :
% loi log-normale -> mu et sigma
% loi negative binomiale -> r et p
% loi de Poisson -> lambda

% charger les données
load('serie01.txt') % séries de nombres entiers
load('serie02.txt') % séries de nombres entiers
load('serie03.txt') % séries de nombres réels

% la densité de probabilité (probability density function - pdf) n'est
% autre qu'un histogramme unitaire (dont l'aire totale est égal à 1) des données

% bornes superieures des séries
max1 = max(serie01);
max2 = max(serie02);
max3 = max(serie03);

% définition des intervalles pour les histogrammes
% (choisir la taille des intervalles en fonction de la répartition des données)
x1 = 0:2:max1;
x2 = 0:1:max2;
x3 = 0:0.2:max3;

% histogrammes
figure (1)       % ouvrir une fenêtre Figure 1
subplot(3,1,1)   % pour tracer plusieurs figures dans la même fenêtre
hist(serie01,x1) % tracer l'histogramme
title('série 1') % titre
subplot(3,1,2)
hist(serie02,x2)
title('série 2')
ylabel('nombre de valeurs')
subplot(3,1,3)
hist(serie03,x3)
title('série 3')
xlabel('valeurs')

% histogrammes unitaires (dont l'aire totale est égal à 1)
% on divise chaque histogramme par la taille de ses intervalles et le
% nombre total d'évènements (soit l'aire totale de l'histogramme)
h1 = hist(serie01,x1)/(x1(2)-x1(1))/length(serie01);
h2 = hist(serie02,x2)/(x2(2)-x2(1))/length(serie02);
h3 = hist(serie03,x3)/(x3(2)-x3(1))/length(serie03);

figure (2);
hold on
subplot(3,1,1)
plot(x1,h1,'rd')
title('série 1')
subplot(3,1,2)
plot(x2,h2,'rd')
ylabel('probabilité')
title('série 2')
subplot(3,1,3)
plot(x3,h3,'rd')
xlabel('quantiles')
title('série 3')

% moments
% les 1er et 2eme moments empirique d'une série de données sont
% respectivement la moyenne et la variance
m1 = mean(serie01)
s1 = var(serie01)
m2 = mean(serie02)
s2 = var(serie02)
m3 = mean(serie03)
s3 = var(serie03)

% La méthode des moments consiste à égaliser les moments empiriques (issus 
% de la série de donnée) et les moments théoriques (donnés dans la 
% définition de la loi de probabilité) pour estimer les paramètres de la 
% loi (les moments théoriques dépendent des paramètres de la loi). Le but
% est de caler la loi sur les données et de voir si elle décrit
% correctement la distribution de ces dernières.
% Les 1er et 2eme moments empirique d'une série de données sont 
% respectivement la moyenne et la variance.

% loi NegBin (m1<s1 et nombres entiers) sur la serie01
p1 = m1/s1;        % estimation du 1er paramètre par la méthode des moments
r1 = m1*p1/(1-p1); % estimation du 2eme paramètre par la méthode des moments
subplot(3,1,1)
hold on
plot(x1,nbinpdf(x1,r1,p1),'b-') % graph de la loi Négative Binomial en fonction des quantiles x1

% loi de Poisson (m1=s1 et nombres entiers) sur la serie02
l2 = m2;
subplot(3,1,2)
hold on
plot(x2,poisspdf(x2,l2),'b-')

% loi Log-Normale (nombre entiers) sur la serie03
mu = log(m3)-1/2*log(1+s3/m3^2);
sigma2 = log(1+s3/m3^2);
subplot(3,1,3)
hold on
plot(x3,lognpdf(x3,mu,sigma2),'b-')
set(gca,'Yscale','Log')

% diagrammes quantiles théoriques/quantiles empiriques (QQ plot)
% Un diagramme Quantile-Quantile permet de comparer les données et la loi
% de probabilité calée sur ces données. Autrement dit, il permet d'estimer
% de manière visuelle si la loi choisie décrit bien les données.
% Un diagramme Quantile-Quantile donne pour une série de valeurs de 
% probabilité possible (entre 0 et 1) les quantiles théoriques et
% empiriques associés.
% Par exemple, le calcul d'une pluie avec un temps de retour de 50 ans peut
% donner 200 mm/j d'après les mesures faites à une station (quantiles 
% empiriques) et 220 mm/j d'après la loi de probibilité qui a été calée sur
% les données (quantiles théqoriques). C'est la différence entre ces deux
% valeurs que permet d'observer un diagramme Quantile-Quantile.

figure (3)

[p1exp,q1exp]=ecdf(serie01); % quantiles empiriques (empirical cumulative distribution function)
q1th=nbininv(p1exp,r1,p1);   % quantiles théoriques
subplot(3,1,1)
hold on
plot(q1exp,q1th,'b.')        % diagramme Quantile-Quantile
plot([0 max1],[0 max1],'r-') % droite y = x
title('série 1')

% Si la loi calait parfaitement les données, les points bleus seraient
% alignés sur la droite rouge. En pratique ça n'est jamais le cas. Cependant,
% si la loi décrit bien les données, les points doivent être plus ou moins alignés 
% avec la droite.

[p2exp,q2exp]=ecdf(serie02);
q2th=poissinv(p2exp,l2);
subplot(3,1,2)
hold on
plot(q2exp,q2th,'b.')
plot([0 max2],[0 max2],'r-')
ylabel('quantile théorique')
title('série 2')

[p3exp,q3exp]=ecdf(serie03);
q3th=logninv(p3exp,mu,sigma2);
subplot(3,1,3)
hold on
plot(q3exp,q3th,'b.')
plot([0 max3],[0 max3],'r-')
xlabel('quantile empirique')
title('série 3')
