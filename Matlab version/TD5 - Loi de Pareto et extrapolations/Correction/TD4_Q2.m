%---------------------------------------------------
% Risques Hydrologiques et Am�nagement du Territoire
% TD5 - Corrig�
%---------------------------------------------------

clear all % effacer toutes les donn�es en m�moire
close all % fermer toutes les fen�tres (p. ex. les figures) ouvertes
clc       % effacer toutes les entr�es de la fen�tre de commande

% 2. Loi de Pareto

% pr�paration des donn�es
load pluies_davos.txt % charger les donn�es
% supprimer les ann�es incompl�tes
ind = find(pluies_davos(:,2)==1986); pluies_davos(ind,:) = [];
ind = find(pluies_davos(:,2)==2006); pluies_davos(ind,:) = [];
na = length(unique(pluies_davos(:,2))); % nombre d'ann�es de donn�es
pluie = pluies_davos(:,7); % stocker les pr�cipitations dans la variable "pluie"


% -- question 1 --
% calcul de la moyenne (i.e. de l'esp�rence E) de X-s sachant que X>s 
% (E(X-s|X>s)) pour diff�rentes valeurs de seuil, X �tant la variable
% al�atoire donnant les pluies journali�res
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
% [1,29] faiblement croissante, [30,58] fortement croissante et [59, 80] d�croissante
% xi et sigma0 pourront �tre estim�s pour le domaine [30,58], pour un
% seuil plus petit les valeurs ne sont pas extr�mes et la loi de Pareto
% n'est pas adapt�e et pour un seuil plus grand il n'y a plus
% assez de valeurs dans l'�chantillon


% -- question 2 --
% ajustement des param�tres de la loi de Pareto par une r�gression lin�aire
% sur la fonction E(X-s|X>s)

% r�gression lin�aire sur le domaine entier (i.e. pour toutes les valeurs de seuil)
p1 = polyfit([1:80],E,1) % r�gression lin�aire
plot([1:80],polyval(p1,[1:80]),'b-') % tracer la courbe de tendance
% remarque : une r�gression lin�aire sur le domaine en entier ne semble pas adapt�e

% ajustement sur un domaine limit� (i.e. pour une tranche de valeurs de seuil)
s0 = 30;   % seuil minimum
smax = 58; % seuil maximum
plot([s0:smax],E(s0:smax),'r*')
p2 = polyfit([s0:smax],E(s0:smax),1) % r�gression lin�aire sur le domaine limit�
plot([s0:smax],polyval(p2,[s0:smax]),'r-') % tracer la courbe de tendance

% param�tres de la loi de Pareto (xi et sigma)
xi = p2(1)/(1+p2(1))        % pente = xi/(1-xi)
sigma0 = p2(2)*(1-xi)+xi*s0 % ordonn�e � l'origine = (sigma0-xi*so)/(1-xi) 


% -- question 3 --
P0 = pluie(find(pluie>s0)); % pluie > s0 (�chantillon)
ns = length(P0);            % nombre de valeurs dans l'�chantillon

figure(2)
T = [0.1:0.1:50]; % vecteur des temps de retour d'inter�t
semilogx(T,s0+sigma0/xi*((T*ns/na).^xi-1)) % plot de xp = f(T) (quantile th�orique)
hold on

Tempi = na/ns*(1./(1-[1:ns]./(ns+1))); % temps de retour empirique [ann�es]
% P = rang/(ns+1) -> T = (ns+1)/(rang) pour les valeurs class�es par ordre
% d�croissant -> T = (ns+1)/(1-rang) pour les valeurs class�es par ordre
% croissant, le facteur na/ns permet de convertir T en ann�es
semilogx(Tempi,sort(P0),'k.') % plot des quantiles empiriques
xlabel('T [ann�es]')
ylabel('quantiles (pluie journali�re en mm/j)')
legend('quantiles th�oriques (Pareto)','quantiles empiriques', 'Location', 'SouthEast')

% -- question 4 -- 
% ajustement des param�tres de la loi de Pareto avec la m�thode du maximum de vraisemblance

par = gpfit(P0-s0) % calcul des param�tres de la loi de Pareto avec gpfit
% attention les valeurs � ajuster selon cette loi sont les pluies P0 qui
% sont sup�rieures au seuil moins la valeur du seuil s0

% -- question 5 --
semilogx(T,s0+par(2)/par(1)*((T*ns/na).^par(1)-1),'r-')
legend('quantiles th�oriques (Pareto)','quantiles empiriques', 'quantiles th�oriques (Pareto) max. vrai.','Location', 'SouthEast')
% la m�thode par r�gression lin�aire de E(X-s|X>s) donne une loi de Pareto
% comparable � une loi de type Fr�chet (xi>0) tandis que la m�thode du
% maximum de vraismeblance a un comportement de type Gumbel (xi = 0)

% -- question 6 --
% valeurs extrapol�es
C100_par_reg = s0+sigma0/xi*((100*ns/na).^xi-1) % 114.4 mm/j
C100_par_vraiss = s0+par(2)/par(1)*((100*ns/na).^par(1)-1) % 96.7 mm/j

% -------------------------------------------------------------------------
% comparaison des lois de Pareto pour diff�rents seuils
figure(3)
hold on
semilogx(T,s0+par(2)/par(1)*((T*ns/na).^par(1)-1),'r-')

P0 = pluie(find(pluie>40)); % pluie > s0 (�chantillon)
ns = length(P0);            % nombre de valeurs dans l'�chanti
par = gpfit(P0-40); % calcul des param�tres de la loi de Pareto avec gpfit
semilogx(T,40+par(2)/par(1)*((T*ns/na).^par(1)-1),'m-')

P0 = pluie(find(pluie>50)); % pluie > s0 (�chantillon)
ns = length(P0);            % nombre de valeurs dans l'�chanti
par = gpfit(P0-50); % calcul des param�tres de la loi de Pareto avec gpfit
semilogx(T,50+par(2)/par(1)*((T*ns/na).^par(1)-1),'b-')

P0 = pluie(find(pluie>60)); % pluie > s0 (�chantillon)
ns = length(P0);            % nombre de valeurs dans l'�chanti
par = gpfit(P0-60); % calcul des param�tres de la loi de Pareto avec gpfit
semilogx(T,60+par(2)/par(1)*((T*ns/na).^par(1)-1),'k-')

axis([0 50 0 110])
xlabel('T [ann�es]')
ylabel('quantiles (pluie journali�re en mm/j)')
legend('s0 = 30 mm/j','s0 = 40 mm/j', 's0 = 50 mm/j','s0 = 60 mm/j','Location', 'SouthEast')