%---------------------------------------------------
% Risques Hydrologiques et Am�nagement du Territoire
% TD5 - Corrig�
%---------------------------------------------------

clear all % effacer toutes les donn�es en m�moire
close all % fermer toutes les fen�tres (p. ex. les figures) ouvertes
clc       % effacer toutes les entr�es de la fen�tre de commande

% 3. Maximum de vraisemblance

load pluies_davos.txt % charger les donn�es
% supprimer les ann�es incompl�tes
ind = find(pluies_davos(:,2)==1986); pluies_davos(ind,:) = [];
ind = find(pluies_davos(:,2)==2006); pluies_davos(ind,:) = [];
na = length(unique(pluies_davos(:,2))); % nombre d'ann�es de donn�es
pluie = pluies_davos(:,7); % stocker les pr�cipitations dans la variable "pluie"

% -- question 1 --
annee = unique(pluies_davos(:,2)); % vecteur des ann�es
for i = 1:length(annee) % pour chaque ann�e...
    ind = find(pluies_davos(:,2)==annee(i)); % calculer les indices de l'ann�e �tudi�e
    pmax(i) = max(pluie(ind)); % calculer la pluie maximale de l'ann�e �tudi�e
end
%
% -- question 2 --
[parmhat,parmci] = gevfit(pmax); % ajuster une loi des valeurs extr�mes par le maximum de vraisemblance
parmhat(1)
% parmhat(1) is the shape parameter, K, parmhat(2) is the scale parameter, SIGMA, and parmhat(3) is the location parameter, MU
% puisque parmhat(1) > 0 les maxima annuels suivent une loi de type Fr�chet
x = 0:50; % quantiles
Fr = gevcdf(x, parmhat(1), parmhat(2), parmhat(3))
% Fr = exp(-1./(1+parmhat(1)*(x-parmhat(3))./parmhat(2)).^(1/parmhat(1))); % probabilit� de non-d�passement (Fr�chet)
plot(1./(1-Fr),x, 'b') % graph des quantiles th�oriques (Fr�chet) en fonction du temps de retour
[f,x] = ecdf(pmax) % fonction de r�partition empirique
hold on
plot(1./(1-f),x,'b.') % graph des quantiles empiqrique en fonction du temps de retour
axis([0 50 0 100]) % fixer les axes du graph
xlabel('p�riode de retour T [ann�es]')
ylabel('pluie [mm/j]')

% -- question 3 -- (voir les 2 premi�res parties de la s�rie)

% *M�thode du renouvellement*
seuil = 45 % choisir un seuil qui a priori d�fini les valeurs extr�mes [mm/j]
Ps = pluie(find(pluie>seuil)); % s�lection des pluies sup�rieures au seuil
Ps = sort(Ps); % ordonner les quantiles (valeurs de pluie) par ordre croissant
Ms = mean(Ps)  % moyenne empirique des pluies sup�rieures au seuil [mm/j]
ns = length(Ps) % nombre de pluies sup�rieures au seuil
I = [1:1:ns];    % vecteur donnant le rang de chacune de ces pluies ordonn�es
T = na/ns.*(ns+1)./(ns+1.-I); % p�riode de retour empirique (mais d�pendante du seuil)
lambda = ns/na;    % calcul de lambda
mu = 1/(Ms-seuil); % calcul de mu
% calcul du quantile th�orique pour des p�riodes de retour de 1 � 30 ans
C = seuil+log(lambda)/mu+1/mu.*log([1:30]); 
plot([1:30],C,'g') % courbe th�orique

% *Loi de Pareto*
i=1;
for seuil = 1:80 % pour chaque valeur de seuil
E(i)=mean(pluie(find(pluie>seuil))-seuil); % calculer E(X-s|X>s)
i=i+1;
end
% ajustement sur un domaine limit� (i.e. pour une tranche de valeurs de seuil)
s0 = 30;   % seuil minimum
smax = 58; % seuil maximum
p2 = polyfit([s0:smax],E(s0:smax),1) % r�gression lin�aire sur le domaine limit�
% param�tres de la loi de Pareto (xi et sigma)
xi = p2(1)/(1+p2(1))        % pente = xi/(1-xi)
sigma0 = p2(2)*(1-xi)+xi*s0 % ordonn�e � l'origine = (sigma0-xi*so)/(1-xi) 
P0 = pluie(find(pluie>s0)); % pluie > s0 (�chantillon)
ns = length(P0);            % nombre de valeurs dans l'�chantillon
T = [0.1:0.1:50]; % vecteur des temps de retour d'inter�t
plot(T,s0+sigma0/xi*((T*ns/na).^xi-1), 'r') % plot de xp = f(T) (quantile th�orique)
hold on
Tempi = na/ns*(1./(1-[1:ns]./(ns+1))); % temps de retour empirique [ann�es]
plot(Tempi,sort(P0),'r.') % plot des quantiles empiriques
legend('Frechet','Max. ann. empirique','Meth. renouvellement','Pareto th�orique','Pareto reg. lin.', 'Location', 'SouthEast')
