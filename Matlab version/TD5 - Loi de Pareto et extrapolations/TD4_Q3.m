%---------------------------------------------------
% Risques Hydrologiques et Aménagement du Territoire
% TD5 - Corrigé
%---------------------------------------------------

clear all % effacer toutes les données en mémoire
close all % fermer toutes les fenêtres (p. ex. les figures) ouvertes
clc       % effacer toutes les entrées de la fenêtre de commande

% 3. Maximum de vraisemblance

load pluies_davos.txt % charger les données
% supprimer les années incomplètes
ind = find(pluies_davos(:,2)==1986); pluies_davos(ind,:) = [];
ind = find(pluies_davos(:,2)==2006); pluies_davos(ind,:) = [];
na = length(unique(pluies_davos(:,2))); % nombre d'années de données
pluie = pluies_davos(:,7); % stocker les précipitations dans la variable "pluie"

% -- question 1 --
annee = unique(pluies_davos(:,2)); % vecteur des années
for i = 1:length(annee) % pour chaque année...
    ind = find(pluies_davos(:,2)==annee(i)); % calculer les indices de l'année étudiée
    pmax(i) = max(pluie(ind)); % calculer la pluie maximale de l'année étudiée
end
%
% -- question 2 --
[parmhat,parmci] = gevfit(pmax); % ajuster une loi des valeurs extrêmes par le maximum de vraisemblance
parmhat(1)
% parmhat(1) is the shape parameter, K, parmhat(2) is the scale parameter, SIGMA, and parmhat(3) is the location parameter, MU
% puisque parmhat(1) > 0 les maxima annuels suivent une loi de type Fréchet
x = 0:50; % quantiles
Fr = gevcdf(x, parmhat(1), parmhat(2), parmhat(3))
% Fr = exp(-1./(1+parmhat(1)*(x-parmhat(3))./parmhat(2)).^(1/parmhat(1))); % probabilité de non-dépassement (Fréchet)
plot(1./(1-Fr),x, 'b') % graph des quantiles théoriques (Fréchet) en fonction du temps de retour
[f,x] = ecdf(pmax) % fonction de répartition empirique
hold on
plot(1./(1-f),x,'b.') % graph des quantiles empiqrique en fonction du temps de retour
axis([0 50 0 100]) % fixer les axes du graph
xlabel('période de retour T [années]')
ylabel('pluie [mm/j]')

% -- question 3 -- (voir les 2 premières parties de la série)

% *Méthode du renouvellement*
seuil = 45 % choisir un seuil qui a priori défini les valeurs extrêmes [mm/j]
Ps = pluie(find(pluie>seuil)); % sélection des pluies supérieures au seuil
Ps = sort(Ps); % ordonner les quantiles (valeurs de pluie) par ordre croissant
Ms = mean(Ps)  % moyenne empirique des pluies supérieures au seuil [mm/j]
ns = length(Ps) % nombre de pluies supérieures au seuil
I = [1:1:ns];    % vecteur donnant le rang de chacune de ces pluies ordonnées
T = na/ns.*(ns+1)./(ns+1.-I); % période de retour empirique (mais dépendante du seuil)
lambda = ns/na;    % calcul de lambda
mu = 1/(Ms-seuil); % calcul de mu
% calcul du quantile théorique pour des périodes de retour de 1 à 30 ans
C = seuil+log(lambda)/mu+1/mu.*log([1:30]); 
plot([1:30],C,'g') % courbe théorique

% *Loi de Pareto*
i=1;
for seuil = 1:80 % pour chaque valeur de seuil
E(i)=mean(pluie(find(pluie>seuil))-seuil); % calculer E(X-s|X>s)
i=i+1;
end
% ajustement sur un domaine limité (i.e. pour une tranche de valeurs de seuil)
s0 = 30;   % seuil minimum
smax = 58; % seuil maximum
p2 = polyfit([s0:smax],E(s0:smax),1) % régression linéaire sur le domaine limité
% paramètres de la loi de Pareto (xi et sigma)
xi = p2(1)/(1+p2(1))        % pente = xi/(1-xi)
sigma0 = p2(2)*(1-xi)+xi*s0 % ordonnée à l'origine = (sigma0-xi*so)/(1-xi) 
P0 = pluie(find(pluie>s0)); % pluie > s0 (échantillon)
ns = length(P0);            % nombre de valeurs dans l'échantillon
T = [0.1:0.1:50]; % vecteur des temps de retour d'interêt
plot(T,s0+sigma0/xi*((T*ns/na).^xi-1), 'r') % plot de xp = f(T) (quantile théorique)
hold on
Tempi = na/ns*(1./(1-[1:ns]./(ns+1))); % temps de retour empirique [années]
plot(Tempi,sort(P0),'r.') % plot des quantiles empiriques
legend('Frechet','Max. ann. empirique','Meth. renouvellement','Pareto théorique','Pareto reg. lin.', 'Location', 'SouthEast')
