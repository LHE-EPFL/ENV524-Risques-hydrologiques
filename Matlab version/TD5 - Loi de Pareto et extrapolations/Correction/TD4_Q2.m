%---------------------------------------------------
% Risques Hydrologiques et Aménagement du Territoire
% TD5 - Corrigé
%---------------------------------------------------

clear all % effacer toutes les données en mémoire
close all % fermer toutes les fenêtres (p. ex. les figures) ouvertes
clc       % effacer toutes les entrées de la fenêtre de commande

% 2. Loi de Pareto

% préparation des données
load pluies_davos.txt % charger les données
% supprimer les années incomplètes
ind = find(pluies_davos(:,2)==1986); pluies_davos(ind,:) = [];
ind = find(pluies_davos(:,2)==2006); pluies_davos(ind,:) = [];
na = length(unique(pluies_davos(:,2))); % nombre d'années de données
pluie = pluies_davos(:,7); % stocker les précipitations dans la variable "pluie"


% -- question 1 --
% calcul de la moyenne (i.e. de l'espérence E) de X-s sachant que X>s 
% (E(X-s|X>s)) pour différentes valeurs de seuil, X étant la variable
% aléatoire donnant les pluies journalières
i=1;
for seuil = 1:80 % pour chaque valeur de seuil
E(i)=mean(pluie(find(pluie>seuil))-seuil); % calculer E(X-s|X>s)
i=i+1;
end
figure (1)
plot ([1:80],E,'b*')
xlabel('seuil [mm/j]')
ylabel('E(X-s|X>s)')
hold on
% on observe graphiquement 3 domaines de valeur de seuil pour la fonction E(X-s|X>s)
% [1,29] faiblement croissante, [30,58] fortement croissante et [59, 80] décroissante
% xi et sigma0 pourront être estimés pour le domaine [30,58], pour un
% seuil plus petit les valeurs ne sont pas extrêmes et la loi de Pareto
% n'est pas adaptée et pour un seuil plus grand il n'y a plus
% assez de valeurs dans l'échantillon


% -- question 2 --
% ajustement des paramètres de la loi de Pareto par une régression linéaire
% sur la fonction E(X-s|X>s)

% régression linéaire sur le domaine entier (i.e. pour toutes les valeurs de seuil)
p1 = polyfit([1:80],E,1) % régression linéaire
plot([1:80],polyval(p1,[1:80]),'b-') % tracer la courbe de tendance
% remarque : une régression linéaire sur le domaine en entier ne semble pas adaptée

% ajustement sur un domaine limité (i.e. pour une tranche de valeurs de seuil)
s0 = 30;   % seuil minimum
smax = 58; % seuil maximum
plot([s0:smax],E(s0:smax),'r*')
p2 = polyfit([s0:smax],E(s0:smax),1) % régression linéaire sur le domaine limité
plot([s0:smax],polyval(p2,[s0:smax]),'r-') % tracer la courbe de tendance

% paramètres de la loi de Pareto (xi et sigma)
xi = p2(1)/(1+p2(1))        % pente = xi/(1-xi)
sigma0 = p2(2)*(1-xi)+xi*s0 % ordonnée à l'origine = (sigma0-xi*so)/(1-xi) 


% -- question 3 --
P0 = pluie(find(pluie>s0)); % pluie > s0 (échantillon)
ns = length(P0);            % nombre de valeurs dans l'échantillon

figure(2)
T = [0.1:0.1:50]; % vecteur des temps de retour d'interêt
semilogx(T,s0+sigma0/xi*((T*ns/na).^xi-1)) % plot de xp = f(T) (quantile théorique)
hold on

Tempi = na/ns*(1./(1-[1:ns]./(ns+1))); % temps de retour empirique [années]
% P = rang/(ns+1) -> T = (ns+1)/(rang) pour les valeurs classées par ordre
% décroissant -> T = (ns+1)/(1-rang) pour les valeurs classées par ordre
% croissant, le facteur na/ns permet de convertir T en années
semilogx(Tempi,sort(P0),'k.') % plot des quantiles empiriques
xlabel('T [années]')
ylabel('quantiles (pluie journalière en mm/j)')
legend('quantiles théoriques (Pareto)','quantiles empiriques', 'Location', 'SouthEast')

% -- question 4 -- 
% ajustement des paramètres de la loi de Pareto avec la méthode du maximum de vraisemblance

par = gpfit(P0-s0) % calcul des paramètres de la loi de Pareto avec gpfit
% attention les valeurs à ajuster selon cette loi sont les pluies P0 qui
% sont supérieures au seuil moins la valeur du seuil s0

% -- question 5 --
semilogx(T,s0+par(2)/par(1)*((T*ns/na).^par(1)-1),'r-')
legend('quantiles théoriques (Pareto)','quantiles empiriques', 'quantiles théoriques (Pareto) max. vrai.','Location', 'SouthEast')
% la méthode par régression linéaire de E(X-s|X>s) donne une loi de Pareto
% comparable à une loi de type Fréchet (xi>0) tandis que la méthode du
% maximum de vraismeblance a un comportement de type Gumbel (xi = 0)

% -- question 6 --
% valeurs extrapolées
C100_par_reg = s0+sigma0/xi*((100*ns/na).^xi-1) % 114.4 mm/j
C100_par_vraiss = s0+par(2)/par(1)*((100*ns/na).^par(1)-1) % 96.7 mm/j

% -------------------------------------------------------------------------
% comparaison des lois de Pareto pour différents seuils
figure(3)
hold on
semilogx(T,s0+par(2)/par(1)*((T*ns/na).^par(1)-1),'r-')

P0 = pluie(find(pluie>40)); % pluie > s0 (échantillon)
ns = length(P0);            % nombre de valeurs dans l'échanti
par = gpfit(P0-40); % calcul des paramètres de la loi de Pareto avec gpfit
semilogx(T,40+par(2)/par(1)*((T*ns/na).^par(1)-1),'m-')

P0 = pluie(find(pluie>50)); % pluie > s0 (échantillon)
ns = length(P0);            % nombre de valeurs dans l'échanti
par = gpfit(P0-50); % calcul des paramètres de la loi de Pareto avec gpfit
semilogx(T,50+par(2)/par(1)*((T*ns/na).^par(1)-1),'b-')

P0 = pluie(find(pluie>60)); % pluie > s0 (échantillon)
ns = length(P0);            % nombre de valeurs dans l'échanti
par = gpfit(P0-60); % calcul des paramètres de la loi de Pareto avec gpfit
semilogx(T,60+par(2)/par(1)*((T*ns/na).^par(1)-1),'k-')

axis([0 50 0 110])
xlabel('T [années]')
ylabel('quantiles (pluie journalière en mm/j)')
legend('s0 = 30 mm/j','s0 = 40 mm/j', 's0 = 50 mm/j','s0 = 60 mm/j','Location', 'SouthEast')