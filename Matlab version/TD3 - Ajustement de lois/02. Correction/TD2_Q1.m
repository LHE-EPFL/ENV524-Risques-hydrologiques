%---------------------------------------------------
% Risques Hydrologiques et Am�nagement du Territoire
% TD2 - Corrig�
%---------------------------------------------------

clear all % effacer toutes les donn�es en m�moire
close all % fermer toutes les fen�tres (p. ex. les figures) ouvertes
clc       % effacer toutes les entr�es de la fen�tre de commande

% 1. M�thode des Moments

% param�tres des lois :
% loi log-normale -> mu et sigma
% loi negative binomiale -> r et p
% loi de Poisson -> lambda

% charger les donn�es
load('serie01.txt') % s�ries de nombres entiers
load('serie02.txt') % s�ries de nombres entiers
load('serie03.txt') % s�ries de nombres r�els

% la densit� de probabilit� (probability density function - pdf) n'est
% autre qu'un histogramme unitaire (dont l'aire totale est �gal � 1) des donn�es

% bornes superieures des s�ries
max1 = max(serie01);
max2 = max(serie02);
max3 = max(serie03);

% d�finition des intervalles pour les histogrammes
% (choisir la taille des intervalles en fonction de la r�partition des donn�es)
x1 = 0:2:max1;
x2 = 0:1:max2;
x3 = 0:0.2:max3;

% histogrammes
figure (1)       % ouvrir une fen�tre Figure 1
subplot(3,1,1)   % pour tracer plusieurs figures dans la m�me fen�tre
hist(serie01,x1) % tracer l'histogramme
title('s�rie 1') % titre
subplot(3,1,2)
hist(serie02,x2)
title('s�rie 2')
ylabel('nombre de valeurs')
subplot(3,1,3)
hist(serie03,x3)
title('s�rie 3')
xlabel('valeurs')

% histogrammes unitaires (dont l'aire totale est �gal � 1)
% on divise chaque histogramme par la taille de ses intervalles et le
% nombre total d'�v�nements (soit l'aire totale de l'histogramme)
h1 = hist(serie01,x1)/(x1(2)-x1(1))/length(serie01);
h2 = hist(serie02,x2)/(x2(2)-x2(1))/length(serie02);
h3 = hist(serie03,x3)/(x3(2)-x3(1))/length(serie03);

figure (2);
hold on
subplot(3,1,1)
plot(x1,h1,'rd')
title('s�rie 1')
subplot(3,1,2)
plot(x2,h2,'rd')
ylabel('probabilit�')
title('s�rie 2')
subplot(3,1,3)
plot(x3,h3,'rd')
xlabel('quantiles')
title('s�rie 3')

% moments
% les 1er et 2eme moments empirique d'une s�rie de donn�es sont
% respectivement la moyenne et la variance
m1 = mean(serie01)
s1 = var(serie01)
m2 = mean(serie02)
s2 = var(serie02)
m3 = mean(serie03)
s3 = var(serie03)

% La m�thode des moments consiste � �galiser les moments empiriques (issus 
% de la s�rie de donn�e) et les moments th�oriques (donn�s dans la 
% d�finition de la loi de probabilit�) pour estimer les param�tres de la 
% loi (les moments th�oriques d�pendent des param�tres de la loi). Le but
% est de caler la loi sur les donn�es et de voir si elle d�crit
% correctement la distribution de ces derni�res.
% Les 1er et 2eme moments empirique d'une s�rie de donn�es sont 
% respectivement la moyenne et la variance.

% loi NegBin (m1<s1 et nombres entiers) sur la serie01
p1 = m1/s1;        % estimation du 1er param�tre par la m�thode des moments
r1 = m1*p1/(1-p1); % estimation du 2eme param�tre par la m�thode des moments
subplot(3,1,1)
hold on
plot(x1,nbinpdf(x1,r1,p1),'b-') % graph de la loi N�gative Binomial en fonction des quantiles x1

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

% diagrammes quantiles th�oriques/quantiles empiriques (QQ plot)
% Un diagramme Quantile-Quantile permet de comparer les donn�es et la loi
% de probabilit� cal�e sur ces donn�es. Autrement dit, il permet d'estimer
% de mani�re visuelle si la loi choisie d�crit bien les donn�es.
% Un diagramme Quantile-Quantile donne pour une s�rie de valeurs de 
% probabilit� possible (entre 0 et 1) les quantiles th�oriques et
% empiriques associ�s.
% Par exemple, le calcul d'une pluie avec un temps de retour de 50 ans peut
% donner 200 mm/j d'apr�s les mesures faites � une station (quantiles 
% empiriques) et 220 mm/j d'apr�s la loi de probibilit� qui a �t� cal�e sur
% les donn�es (quantiles th�qoriques). C'est la diff�rence entre ces deux
% valeurs que permet d'observer un diagramme Quantile-Quantile.

figure (3)

[p1exp,q1exp]=ecdf(serie01); % quantiles empiriques (empirical cumulative distribution function)
q1th=nbininv(p1exp,r1,p1);   % quantiles th�oriques
subplot(3,1,1)
hold on
plot(q1exp,q1th,'b.')        % diagramme Quantile-Quantile
plot([0 max1],[0 max1],'r-') % droite y = x
title('s�rie 1')

% Si la loi calait parfaitement les donn�es, les points bleus seraient
% align�s sur la droite rouge. En pratique �a n'est jamais le cas. Cependant,
% si la loi d�crit bien les donn�es, les points doivent �tre plus ou moins align�s 
% avec la droite.

[p2exp,q2exp]=ecdf(serie02);
q2th=poissinv(p2exp,l2);
subplot(3,1,2)
hold on
plot(q2exp,q2th,'b.')
plot([0 max2],[0 max2],'r-')
ylabel('quantile th�orique')
title('s�rie 2')

[p3exp,q3exp]=ecdf(serie03);
q3th=logninv(p3exp,mu,sigma2);
subplot(3,1,3)
hold on
plot(q3exp,q3th,'b.')
plot([0 max3],[0 max3],'r-')
xlabel('quantile empirique')
title('s�rie 3')
