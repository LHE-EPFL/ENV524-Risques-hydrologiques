%% Corection TD0- Master Risques Hydro - 2013

% INTRODUCTION A MATLAB

close all

% attention les exercises 10 & 11 contiennent fonctions et devraient
% etre coup�s/coll�s dans des nouveaux fichiers.  

%----------
% Exercise 1&2
%----------

z1=(sqrt(3)+3*i)^5;

z2=(2*sqrt(3)*exp(i*pi/3))^5;

%----------
% Exercice 3
%----------
%creation d'un vecteur de pas 0,1
% la fonction sinus sera calcul�e en ces diff�rentes valeurs

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

% matrice de� 20 lignes et 30 colonnes

M = rand(20,30)
dimension = size(M)
moyenne = mean(M), variance = var(M), maximum = max(M)
l2c3 = M(2,3)
M(1,2) = pi
transposee_de_M = M'

%----------
%Exercice 7
%----------

% simulation d'un lancer de d�

d = rand(1);
D = ceil(6*d);

% simulation de 100 lancer de d�
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

% Ce d� semble correcte. Pour s'en persuader, on peut r�p�ter la boucle en
% faisant plus de lanc�s. Dans la limite ou les lanc�s tend vers l'infini
% on aura une probabilit� parfaite de 1/6 pour toute les valeurs 1 � 6

%----------
%Exercice 8
%----------

% Attention � retirer la premi�re ligne de texte du fichier. 
% charger les donn�es du fichier pluies_davos.txt
A = load('pluies_davos.txt');
pluie = A(:,7);

% cr�er l'histogramme avec 50 barres
nbins = 50;
figure
histogram(pluie, nbins)

% dessiner la fonction de r�partition
figure
ecdf(pluie)

% calculer la moyenne et la variance des pluies
mean(pluie)
var(pluie)

%----------
%Exercice 9
%----------

% la fonction random() g�n�re des nombre selon un distribution sp�cifi�e.
% dans notre cas on veut g�n�rer un vecteur de 3650x1 nombres tir�s d'une
% loi exponentielle. le param�tre principale d'une loi exponentielle est la
% moyenne de la distribution (dans notre cas 10 mm). pour plus de d�tail
% regarder la documentation (taper 'help random' dans le terminal)s

y = random('exponential', 10, 365*10, 1);

figure
histogram(y, 50)

%ou y = exprnd(10, [1,365*10])

% la fonction find() retourne les indices (positions) des valeurs qui
% correspondent � la condition voulue. dans notre cas, nous cherchons les
% jours de pluies de plus de 70 mm, donc la condition s'�crit y>70

c = find(y>70);
d = find(y>50);

% on cherche deux jours de pluies cons�cutifs. pour cela on cherche d'abord
% les jours de plus de 50 mm de pluie (d = find(y>50)) puis on rajoute la
% condition que le jour suivant (d+1) la pluie soit sup�rieure � 50 mm

e = find (y(d+1)>50);

% Le nombre de jours avec des pr�cipitaions de plus de 70 mm correspond �
% la taille du vecteur c car c contient toutes les positions ou y (la pluie
% journali�re) est sup�rieure � 70 mm

length(c)

% Le nombre de 2 jours de suite avec des pr�cipitations sup�rieures �50 mm

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

% 1. Traitement d'une s�rie de donn�es

%-----------
% Question 1 : Pluies � Davos
%-----------

% 1. & 2.

% Importation des donn�es
% Il existe diff�rentes fonctions pour importer des donn�es (textscan offre
% de nombreuses possibilit�s, load marche seulement s'il n'y a pas de 
% caract�res, importdata detecte g�naralement automatiquenent les donn�es 
% et les classe dans une structure)
% Attention : A chaque fois il faut bien conna�tre son fichier de donn�e
% pour utiliser la bonne commande

% Exemple avec importdata
% Davos = importdata('pluies_davos_header.txt');
% pluies = Davos.data(2:end);

% Exemple avec textscan
% Davosfile=fopen('pluies_davos_header.txt');
% Davos = textscan(Davosfile, '%f %f %f %f %f %f %f', 'HeaderLines', 1);
% pluie=Davos{7};

data_davos = load('pluies_davos.txt'); % charger les donn�es de pluie et les stock dans la variable "data"
% (ne pas oublier de supprimer les ent�tes dans le fichier .txt)

% 3.

pluie_davos = data_davos(:,7); % s�l�ctionner toutes les lignes et la 7�me colonne de "data" et la stocker dans la variable "pluie_i"

% 4.

% graphique
figure(1) % ouvrir la fen�tre de la figure 1
plot(pluie_davos, '.') % tracer les donn�es ('.' pour dessiner des points, '.b' pour dessiner des points bleus)
title('donn�es de pluie � Davos') % titre de la figure
xlabel('num�ro de la mesure') % l�gende de l'axe des abscisses
ylabel('pluie [mm/j]') % l�gende de l'axe des ordonn�es

% 5.



figure(2)
histogram(pluie_davos,50) % histogramme avec 50 classes
title('histogramme des donn�es de pluie � Davos') % titre de la figure
xlabel('pluie journali�re [mm/j]') % l�gende de l'axe des abscisses

% calcul la fonction de r�partition empirique des donn�es de pluie
[F,x] = ecdf(pluie_davos);
% F(x) = P(X<=x)
% le vecteur contient la probabilit� de non-d�passement des valeurs de x 
% (qui sont des valeurs de pluie journali�re)
figure(3)
plot(x,F)
title('fonction de r�partition empirique des donn�es de pluie � Davos') % titre de la figure
xlabel('x (pluie journali�re [mm/j])') % l�gende de l'axe des abscisses
ylabel('P(X<=x) (prob. de non-d�passement)') % l�gende de l'axe des ordonn�es

% 6.

% calcul la fonction de densit� des donn�es de pluie
nbins = 100; % nombre de classe
dx = max(pluie_davos)/nbins; % calcul de la largeur des classes
m_int = dx/2:dx:nbins*dx-dx/2; % calcul du milieux des classes
h = histogram(pluie_davos, nbins);
N = h.Values; % compte le nombre d'�l�ments dans chacune des nbins classes
P = N/length(pluie_davos); % calcul de la probabilit� associ�e � chaque classe (P = nb d'�l�ment dans une classe / nb total d'�l�ment)
pdf = P/dx; % calcul de la densit� de probabilit�

figure(4)
plot(m_int, pdf, '.-r');
title('fonction de densit� des donn�es de pluie � Davos') % titre de la figure
xlabel('x (pluie journali�re [mm/j])') % l�gende de l'axe des abscisses
ylabel('f(x)') % l�gende de l'axe des ordonn�es
% fonction de densit� : P(a<=X<=b) = integrale entre a et b de f(x)dx

% 7.

% calcul de la fr�quence et du temps de retour
S = [30 50 80]; % vecteur comprenant les 3 seuils [mm]
P_seuil = zeros(1,length(S));
for i = 1:length(P_seuil) % pour chacun des seuils
    N = sum(pluie_davos >= S(i)); % compte le nombre de mesure > au seuil
    % pluie >= seuil(i) retourne un vecteur de la m�me taille que pluie,
    % contenant un 1 si la condition est respect� et un 0 sinon
    P_seuil(i) = N/length(pluie_davos); % calcul de la probabilit� (= fr�quence) qu'une pluie soit > au seuil (P = nb d'�l�ment / nb total d'�l�ment)
end
P_seuil;
T_jours = 1./P_seuil; % le temps de retour est donn� par l'inverse de la probablit� (en jours puisque les pluies sont en mm/j)
T_annee = T_jours/365; % temps de retour en ann�e

% 8.

% moyenne annuelle
% 1�re valeur 02/09/1986
% derni�re valeur 01/09/2006
annee_davos = data_davos(:,2); % les ann�es sont stock�es dans la 2eme colonne du vecteur data
debut = min(annee_davos); % 1986 c'est le premiere annee complet, mais on commence du 1985 pour le cycle
fin = max(annee_davos)-1; % 2005 c'est le derniere annee complet
pluie_moyenne = zeros(1,fin-debut);
for i = 1:fin-debut % pour chaque ann�e
    annee_i = debut + i; % calculer l'ann�e �tudi�
    pluie_moyenne(i)=mean(pluie_davos(annee_davos == annee_i)); % faire la moyenne des pluies de l'ann�e �tudi�e
end
% Les ann�es 1986 et 2006 ne sont pas enti�res, elles ne sont donc pas
% prises en compte. Les moyennes des pluies sont calcul�es pour la p�riode
% 1987-2005.

figure(5)
bar(debut+1:fin, pluie_moyenne) ; % graphique en barre des moyennes annuelles
title('donn�es de pluie � Davos') % titre de la figure
xlabel('ann�e') % l�gende de l'axe des abscisses
ylabel('pluie moyenne [mm/j]') % l�gende de l'axe des ordonn�es

%%
%-----------
% Question 2
%-----------

data_chamo = load('neige_chamonix.txt'); % charger les donn�es
neige_chamo = data_chamo(:,4); % la 4�me colonne contient les chutes de neige
annee_chamo = data_chamo(:,1);
% les donn�es ne sont faites que pour jan, fev, mar, avr, oct, nov, dec
% d�but des donn�es: 1959
% fin des donn�es: 2002 (manque oct, nov et dec pour 2002 )
neige_chamo = neige_chamo(annee_chamo<2002); % ne garder que les donn�es entre 1959 et 2001 (donn�es enti�res)
annee_chamo = annee_chamo(annee_chamo<2002); % ne garder que les donn�es entre 1959 et 2001 (donn�es enti�res)
nbannee_chamo = length(unique(annee_chamo)); % calcul le nombre d'ann�e
debut = min(annee_chamo);
neige_yr = zeros(1,nbannee_chamo);
for i = 1:nbannee_chamo % pour chaque ann�e (de 1959 � 2001)
    annee_i = debut + i;
    neige_yr(i) = sum(neige_chamo(annee_chamo == annee_i)); % faire la somme des chutes de neige
end

figure(6)
bar(debut+(1:nbannee_chamo), neige_yr);
title('donn�es de neige � Chamonix') % titre de la figure
xlabel('ann�e') % l�gende de l'axe des abscisses
ylabel('chutes de neige annuelles [cm/an]') % l�gende de l'axe des ordonn�es

% Les mesures de neige ne sont faites que pendant l'hiver de octobre � avril.
% Il faut donc faire l'hypoth�se que le reste de l'ann�e les chutes de
% neige valent 0 pour calculer le temps de retour.
N = sum(neige_chamo>30); % compter le nombre de valeurs superieures � 30 cm/j
Fr = N/nbannee_chamo/365; % calcule la fr�quence en jours-1
% (le nb total d'�v�nement est ici 365*nb ann�e, et non length(neige) )
T = 1/Fr/365; % calcul du temps de retour en ann�e

[F, x] = ecdf(neige_chamo); % calcule la fonction de r�partition empirique des donn�es
Fr = 1 - F; % calcul de la fr�quence en jours d'hiver-1
% (F est la probabilit� de non-d�passement, 1-F est donc la probabilit� de d�passement, qui est la fr�quence)
T = 1./Fr; % calcule le temps de retour en jours d'hivers
T = T/212; % convertit le temps de retour en hivers, ce qui est la m�me chose que des ann�es puisque il ne neige pas l'�t�
% il ya a 212 jours d'hivers par an (oct-avr)
figure(7)
plot(x, T, '*-c')
title('donn�es de neige � Chamonix') % titre de la figure
xlabel('neige [cm/j]') % l�gende de l'axe des abscisses
ylabel('temps de retour [an]') % l�gende de l'axe des ordonn�es

%%
%-----------

% Question 3
%-----------

data_davos = load('pluies_davos.txt');
pluie_davos = data_davos(:,7);                   
S = 1; % seuil [mm]
N = cumsum(pluie_davos>S); % compte le nombre d'�v�nements d�passant le seuil parmi les i premi�res valeurs
figure(8)
plot(N)
title('donn�es de pluie � Davos') % titre de la figure
xlabel('num�ro i de la mesure') % l�gende de l'axe des abscisses
ylabel(strcat(['nombre cumul� de mesure journali�re d�passant ', num2str(S), 'mm'])) % l�gende de l'axe des ordonn�es
hold on
plot([0,length(pluie_davos)],[0,sum(pluie_davos>S)],'r'); % droite de comparaison

% pour les sommes annuelles
annee_davos = data_davos(:,2);
debut = min(annee_davos); % 1986 c'est le premiere annee complet, mais on commence du 1985 pour le cycle
fin = max(annee_davos)-1; % 2005 c'est le derniere annee complet
pluie_sum = zeros(1,fin-debut);
for i = 1:fin-debut % pour chaque ann�e
    annee_i = debut + i; % calculer l'ann�e �tudi�
    pluie_sum(i)=sum(pluie_davos(annee_davos == annee_i)); % faire la somme des pluies de l'ann�e �tudi�e
end

% Mesure visuelle de la stationarit� des �v�nement 
% On peut mesurer la stationnarit� du cumul des pluies annuel mais aussi la
% stationarit� d'avoir des �v�nements journaliers depassant un certain seuil.
% Par exemple le fait d'avoir des jours o� il neige plus de 30 cm
% est-il stationnaire sur 50 ans de donn�es?

% pour le cumul sur une ann�e depassant 900 mm
S = 900;
figure(9)
plot(cumsum(pluie_sum>S));
title('V�rification du charact�re stationnaire') % titre de la figure
xlabel('temps') % l�gende de l'axe des abscisses
ylabel(strcat(['nombre cumul� de mesure anuelles d�passant ', num2str(S), 'mm'])) % l�gende de l'axe des ordonn�es
hold on
plot([0,length(pluie_sum)],[0,sum(pluie_sum>S)],'r') ;

% pour les mesures journali�res
Seuil = 50;
Nev = cumsum(pluie_davos>Seuil);
Nj = 1:length(pluie_davos);

figure(10)
plot(Nj./(365.25),Nev)
title('V�rification du charact�re stationnaire Davos') % titre de la figure
xlabel('temps') % l�gende de l'axe des abscisses
ylabel(strcat(['nombre cumul� de mesure journali�re d�passant ', num2str(Seuil), 'mm'])) % l�gende de l'axe des ordonn�es
hold on
plot([0,length(pluie_davos)/365.25],[0,Nev(end)],'r') ;

% pour les donn�es � Chamonix
% clear all % effacer toutes les donn�es en m�moire
data_chamo = load('neige_chamonix.txt'); % charger les donn�es
neige_chamo = data_chamo(:,4); % la 4�me colonne contient les chutes de neige
annee_chamo = data_chamo(:,1);

% pour les mesures journali�res
Seuil = 30;
Nev = cumsum(neige_chamo>Seuil);
Nj=1:length(neige_chamo);

figure(11)
plot(Nj./(221.25),Nev)
title('V�rification du charact�re stationnaire Chamonix') % titre de la figure
xlabel('temps') % l�gende de l'axe des abscisses
ylabel(strcat(['nombre cumul� de mesure journali�re d�passant ', num2str(Seuil), 'mm'])) % l�gende de l'axe des ordonn�es
hold on
plot([0,length(neige_chamo)/221.25],[0,Nev(end)],'r') ;

% Cette d�marche est purement qualitative et la conclusion qualitative 
% d�pend aussi de ce que l'on veut tirer comme information des donn�es. 

% Si on s'int�resse aux �v�nement extr�mes journaliers (qui peuvent par exemple 
% induire des crues extr�mes)
% alors on va mettre un seuil haut et s'interresser � la stationnarit� de
% ce type d'�v�nement. Le probl�me est que ce type d'�v�nement est rare et
% on peut encore moins conclure m�me qualitativement sur la stationnarit�
% des donn�es.
% On sait par ailleurs que le climat n'est pas stationnaire... D'o� une
% remise en question r�cente des m�thodes d'estimation des p�riodes de
% retour bas� sur les pr�diction des mod�les climatiques coupl� aux donn�es
% ant�rieurs.

