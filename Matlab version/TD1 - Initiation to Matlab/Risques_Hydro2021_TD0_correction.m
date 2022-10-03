%% Corection TD0- Master Risques Hydro - 2013

% INTRODUCTION A MATLAB

close all

% attention les exercises 10 & 11 contiennent fonctions et devraient
% etre coupés/collés dans des nouveaux fichiers.  

%----------
% Exercise 1&2
%----------

z1=(sqrt(3)+3*i)^5;

z2=(2*sqrt(3)*exp(i*pi/3))^5;

%----------
% Exercice 3
%----------
%creation d'un vecteur de pas 0,1
% la fonction sinus sera calculée en ces différentes valeurs

x = 0 : 0.1 : 2*pi;

figure
plot(x, sin(x))

%----------
%Exercice 4
%----------

figure
x = 0 : 0.01 : 3;
plot(x, sin(pi*x),'-r')
hold on
x = 0 : 0.01 : 1;
plot(x, cos(pi*x),'-g')
figure
plot(x, cos(pi*x),'-b')

%----------
%Exercice 5
%----------

% creation d'un vecteur colonne v de longueur 10
% affichage de la longueur de v

v = rand(10,1);            
length(v)             
somme = sum(v)
moyenne = mean(v)
variance = var(v)
minimum = min(v)
maximum = max(v)

%----------
%Exercice 6
%----------

% matrice de  20 lignes et 30 colonnes

M = rand(20,30)
dimension = size(M)
moyenne = mean(M), variance = var(M), maximum = max(M)
l2c3 = M(2,3)
M(1,2) = pi
transposee_de_M = M'

%----------
%Exercice 7
%----------

% simulation d'un lancer de dé

d = rand(1);
D = ceil(6*d);

% simulation de 100 lancer de dé
tic
D=zeros(1,100);
for i = 1:100
    d = rand(1);
    D(i) = ceil(6*d);
end
toc

figure
histogram(D)

moyenne_des_100_jetes = mean(D);
variance_des_100_jetes = var(D);

% Ce dé semble correcte. Pour s'en persuader, on peut répéter la boucle en
% faisant plus de lancés. Dans la limite ou les lancés tend vers l'infini
% on aura une probabilité parfaite de 1/6 pour toute les valeurs 1 à 6

%----------
%Exercice 8
%----------

% Attention à  retirer la première ligne de texte du fichier. 
% charger les données du fichier pluies_davos.txt
A = load('pluies_davos.txt');
pluie = A(:,7);

% créer l'histogramme avec 50 barres
nbins = 50;
figure
histogram(pluie, nbins)

% dessiner la fonction de répartition
figure
ecdf(pluie)

% calculer la moyenne et la variance des pluies
mean(pluie)
var(pluie)

%----------
%Exercice 9
%----------

% la fonction random() génère des nombre selon un distribution spécifiée.
% dans notre cas on veut générer un vecteur de 3650x1 nombres tirés d'une
% loi exponentielle. le paramètre principale d'une loi exponentielle est la
% moyenne de la distribution (dans notre cas 10 mm). pour plus de détail
% regarder la documentation (taper 'help random' dans le terminal)s

y = random('exponential', 10, 365*10, 1);

figure
histogram(y, 50)

%ou y = exprnd(10, [1,365*10])

% la fonction find() retourne les indices (positions) des valeurs qui
% correspondent à la condition voulue. dans notre cas, nous cherchons les
% jours de pluies de plus de 70 mm, donc la condition s'écrit y>70

c = find(y>70);
d = find(y>50);

% on cherche deux jours de pluies consécutifs. pour cela on cherche d'abord
% les jours de plus de 50 mm de pluie (d = find(y>50)) puis on rajoute la
% condition que le jour suivant (d+1) la pluie soit supérieure à 50 mm

e = find (y(d+1)>50);

% Le nombre de jours avec des précipitaions de plus de 70 mm correspond à
% la taille du vecteur c car c contient toutes les positions ou y (la pluie
% journalière) est supérieure à 70 mm

length(c)

% Le nombre de 2 jours de suite avec des précipitations supérieures à 50 mm

length(e)       

%----------
%Exercice 10
%----------
    
%%-------------copier et enregistrer dans un nouveau fichier binom.m
% appel "binom(3,4)" dans fenetre Matlab p. ex.

% function [B] = binom(n,p)
% 
% B = factorial(n)/(factorial(p)*factorial(n-p));
% 
% end

%----------
%Exercice 11
%----------
    
%%-------------copier et enregistrer dans un nouveau fichier binomNewton.m
% appel "binomNewton(5,sqrt(3),3*i)" dans fenetre Matlab
    
% function [Z] = binomNewton(n,x,y)
% 
% z = zeros(1,n);
% 
% for j = 1 : n+1
%     k = j-1;
%     z(j) = binom(n,k)*x^(n-k)*y^k;
% end
% Z = sum(z);
% 
% end    

%% RAPPEL DE PROBABILITES

% 1. Traitement d'une série de données

%-----------
% Question 1 : Pluies à Davos
%-----------

% 1. & 2.

% Importation des données
% Il existe différentes fonctions pour importer des données (textscan offre
% de nombreuses possibilités, load marche seulement s'il n'y a pas de 
% caractères, importdata detecte génaralement automatiquenent les données 
% et les classe dans une structure)
% Attention : A chaque fois il faut bien connaître son fichier de donnée
% pour utiliser la bonne commande

% Exemple avec importdata
% Davos = importdata('pluies_davos_header.txt');
% pluies = Davos.data(2:end);

% Exemple avec textscan
% Davosfile=fopen('pluies_davos_header.txt');
% Davos = textscan(Davosfile, '%f %f %f %f %f %f %f', 'HeaderLines', 1);
% pluie=Davos{7};

data_davos = load('pluies_davos.txt'); % charger les données de pluie et les stock dans la variable "data"
% (ne pas oublier de supprimer les entêtes dans le fichier .txt)

% 3.

pluie_davos = data_davos(:,7); % séléctionner toutes les lignes et la 7ème colonne de "data" et la stocker dans la variable "pluie_i"

% 4.

% graphique
figure(1) % ouvrir la fenêtre de la figure 1
plot(pluie_davos, '.') % tracer les données ('.' pour dessiner des points, '.b' pour dessiner des points bleus)
title('données de pluie à Davos') % titre de la figure
xlabel('numéro de la mesure') % légende de l'axe des abscisses
ylabel('pluie [mm/j]') % légende de l'axe des ordonnées

% 5.



figure(2)
histogram(pluie_davos,50) % histogramme avec 50 classes
title('histogramme des données de pluie à Davos') % titre de la figure
xlabel('pluie journalière [mm/j]') % légende de l'axe des abscisses

% calcul la fonction de répartition empirique des données de pluie
[F,x] = ecdf(pluie_davos);
% F(x) = P(X<=x)
% le vecteur contient la probabilité de non-dépassement des valeurs de x 
% (qui sont des valeurs de pluie journalière)
figure(3)
plot(x,F)
title('fonction de répartition empirique des données de pluie à Davos') % titre de la figure
xlabel('x (pluie journalière [mm/j])') % légende de l'axe des abscisses
ylabel('P(X<=x) (prob. de non-dépassement)') % légende de l'axe des ordonnées

% 6.

% calcul la fonction de densité des données de pluie
nbins = 100; % nombre de classe
dx = max(pluie_davos)/nbins; % calcul de la largeur des classes
m_int = dx/2:dx:nbins*dx-dx/2; % calcul du milieux des classes
h = histogram(pluie_davos, nbins);
N = h.Values; % compte le nombre d'éléments dans chacune des nbins classes
P = N/length(pluie_davos); % calcul de la probabilité associée à  chaque classe (P = nb d'élément dans une classe / nb total d'élément)
pdf = P/dx; % calcul de la densité de probabilité

figure(4)
plot(m_int, pdf, '.-r');
title('fonction de densité des données de pluie à Davos') % titre de la figure
xlabel('x (pluie journalière [mm/j])') % légende de l'axe des abscisses
ylabel('f(x)') % légende de l'axe des ordonnées
% fonction de densité : P(a<=X<=b) = integrale entre a et b de f(x)dx

% 7.

% calcul de la fréquence et du temps de retour
S = [30 50 80]; % vecteur comprenant les 3 seuils [mm]
P_seuil = zeros(1,length(S));
for i = 1:length(P_seuil) % pour chacun des seuils
    N = sum(pluie_davos >= S(i)); % compte le nombre de mesure > au seuil
    % pluie >= seuil(i) retourne un vecteur de la même taille que pluie,
    % contenant un 1 si la condition est respecté et un 0 sinon
    P_seuil(i) = N/length(pluie_davos); % calcul de la probabilité (= fréquence) qu'une pluie soit > au seuil (P = nb d'élément / nb total d'élément)
end
P_seuil;
T_jours = 1./P_seuil; % le temps de retour est donné par l'inverse de la probablité (en jours puisque les pluies sont en mm/j)
T_annee = T_jours/365; % temps de retour en année

% 8.

% moyenne annuelle
% 1ère valeur 02/09/1986
% dernière valeur 01/09/2006
annee_davos = data_davos(:,2); % les années sont stockées dans la 2eme colonne du vecteur data
debut = min(annee_davos); % 1986 c'est le premiere annee complet, mais on commence du 1985 pour le cycle
fin = max(annee_davos)-1; % 2005 c'est le derniere annee complet
pluie_moyenne = zeros(1,fin-debut);
for i = 1:fin-debut % pour chaque année
    annee_i = debut + i; % calculer l'année étudié
    pluie_moyenne(i)=mean(pluie_davos(annee_davos == annee_i)); % faire la moyenne des pluies de l'année étudiée
end
% Les années 1986 et 2006 ne sont pas entières, elles ne sont donc pas
% prises en compte. Les moyennes des pluies sont calculées pour la période
% 1987-2005.

figure(5)
bar(debut+1:fin, pluie_moyenne) ; % graphique en barre des moyennes annuelles
title('données de pluie à Davos') % titre de la figure
xlabel('année') % légende de l'axe des abscisses
ylabel('pluie moyenne [mm/j]') % légende de l'axe des ordonnées

%%
%-----------
% Question 2
%-----------

data_chamo = load('neige_chamonix.txt'); % charger les données
neige_chamo = data_chamo(:,4); % la 4ème colonne contient les chutes de neige
annee_chamo = data_chamo(:,1);
% les données ne sont faites que pour jan, fev, mar, avr, oct, nov, dec
% début des données: 1959
% fin des données: 2002 (manque oct, nov et dec pour 2002 )
neige_chamo = neige_chamo(annee_chamo<2002); % ne garder que les données entre 1959 et 2001 (données entières)
annee_chamo = annee_chamo(annee_chamo<2002); % ne garder que les données entre 1959 et 2001 (données entières)
nbannee_chamo = length(unique(annee_chamo)); % calcul le nombre d'année
debut = min(annee_chamo);
neige_yr = zeros(1,nbannee_chamo);
for i = 1:nbannee_chamo % pour chaque année (de 1959 à  2001)
    annee_i = debut + i;
    neige_yr(i) = sum(neige_chamo(annee_chamo == annee_i)); % faire la somme des chutes de neige
end

figure(6)
bar(debut+(1:nbannee_chamo), neige_yr);
title('données de neige à  Chamonix') % titre de la figure
xlabel('année') % légende de l'axe des abscisses
ylabel('chutes de neige annuelles [cm/an]') % légende de l'axe des ordonnées

% Les mesures de neige ne sont faites que pendant l'hiver de octobre à  avril.
% Il faut donc faire l'hypothèse que le reste de l'année les chutes de
% neige valent 0 pour calculer le temps de retour.
N = sum(neige_chamo>30); % compter le nombre de valeurs superieures à  30 cm/j
Fr = N/nbannee_chamo/365; % calcule la fréquence en jours-1
% (le nb total d'évènement est ici 365*nb année, et non length(neige) )
T = 1/Fr/365; % calcul du temps de retour en année

[F, x] = ecdf(neige_chamo); % calcule la fonction de répartition empirique des données
Fr = 1 - F; % calcul de la fréquence en jours d'hiver-1
% (F est la probabilité de non-dépassement, 1-F est donc la probabilité de dépassement, qui est la fréquence)
T = 1./Fr; % calcule le temps de retour en jours d'hivers
T = T/212; % convertit le temps de retour en hivers, ce qui est la même chose que des années puisque il ne neige pas l'été
% il ya a 212 jours d'hivers par an (oct-avr)
figure(7)
plot(x, T, '*-c')
title('données de neige à  Chamonix') % titre de la figure
xlabel('neige [cm/j]') % légende de l'axe des abscisses
ylabel('temps de retour [an]') % légende de l'axe des ordonnées

%%
%-----------

% Question 3
%-----------

data_davos = load('pluies_davos.txt');
pluie_davos = data_davos(:,7);                   
S = 1; % seuil [mm]
N = cumsum(pluie_davos>S); % compte le nombre d'évènements dépassant le seuil parmi les i premières valeurs
figure(8)
plot(N)
title('données de pluie à  Davos') % titre de la figure
xlabel('numéro i de la mesure') % légende de l'axe des abscisses
ylabel(strcat(['nombre cumulé de mesure journalière dépassant ', num2str(S), 'mm'])) % légende de l'axe des ordonnées
hold on
plot([0,length(pluie_davos)],[0,sum(pluie_davos>S)],'r'); % droite de comparaison

% pour les sommes annuelles
annee_davos = data_davos(:,2);
debut = min(annee_davos); % 1986 c'est le premiere annee complet, mais on commence du 1985 pour le cycle
fin = max(annee_davos)-1; % 2005 c'est le derniere annee complet
pluie_sum = zeros(1,fin-debut);
for i = 1:fin-debut % pour chaque année
    annee_i = debut + i; % calculer l'année étudié
    pluie_sum(i)=sum(pluie_davos(annee_davos == annee_i)); % faire la somme des pluies de l'année étudiée
end

% Mesure visuelle de la stationarité des évènement 
% On peut mesurer la stationnarité du cumul des pluies annuel mais aussi la
% stationarité d'avoir des évènements journaliers depassant un certain seuil.
% Par exemple le fait d'avoir des jours oà¹ il neige plus de 30 cm
% est-il stationnaire sur 50 ans de données?

% pour le cumul sur une année depassant 900 mm
S = 900;
figure(9)
plot(cumsum(pluie_sum>S));
title('Vérification du charactère stationnaire') % titre de la figure
xlabel('temps') % légende de l'axe des abscisses
ylabel(strcat(['nombre cumulé de mesure anuelles dépassant ', num2str(S), 'mm'])) % légende de l'axe des ordonnées
hold on
plot([0,length(pluie_sum)],[0,sum(pluie_sum>S)],'r') ;

% pour les mesures journalières
Seuil = 50;
Nev = cumsum(pluie_davos>Seuil);
Nj = 1:length(pluie_davos);

figure(10)
plot(Nj./(365.25),Nev)
title('Vérification du charactère stationnaire Davos') % titre de la figure
xlabel('temps') % légende de l'axe des abscisses
ylabel(strcat(['nombre cumulé de mesure journalière dépassant ', num2str(Seuil), 'mm'])) % légende de l'axe des ordonnées
hold on
plot([0,length(pluie_davos)/365.25],[0,Nev(end)],'r') ;

% pour les données à  Chamonix
% clear all % effacer toutes les données en mémoire
data_chamo = load('neige_chamonix.txt'); % charger les données
neige_chamo = data_chamo(:,4); % la 4ème colonne contient les chutes de neige
annee_chamo = data_chamo(:,1);

% pour les mesures journalières
Seuil = 30;
Nev = cumsum(neige_chamo>Seuil);
Nj=1:length(neige_chamo);

figure(11)
plot(Nj./(221.25),Nev)
title('Vérification du charactère stationnaire Chamonix') % titre de la figure
xlabel('temps') % légende de l'axe des abscisses
ylabel(strcat(['nombre cumulé de mesure journalière dépassant ', num2str(Seuil), 'mm'])) % légende de l'axe des ordonnées
hold on
plot([0,length(neige_chamo)/221.25],[0,Nev(end)],'r') ;

% Cette démarche est purement qualitative et la conclusion qualitative 
% dépend aussi de ce que l'on veut tirer comme information des données. 

% Si on s'intéresse aux évènement extrêmes journaliers (qui peuvent par exemple 
% induire des crues extrêmes)
% alors on va mettre un seuil haut et s'interresser à  la stationnarité de
% ce type d'évènement. Le problème est que ce type d'évènement est rare et
% on peut encore moins conclure même qualitativement sur la stationnarité
% des données.
% On sait par ailleurs que le climat n'est pas stationnaire... D'oà¹ une
% remise en question récente des méthodes d'estimation des périodes de
% retour basé sur les prédiction des modèles climatiques couplé aux données
% antérieurs.

