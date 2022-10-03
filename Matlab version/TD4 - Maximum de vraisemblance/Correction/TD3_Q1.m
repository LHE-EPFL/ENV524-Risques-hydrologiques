%---------------------------------------------------
% Risques Hydrologiques et Am�nagement du Territoire
% TD3 - Corrig�
%---------------------------------------------------

clear all % effacer toutes les donn�es en m�moire
close all % fermer toutes les fen�tres (p. ex. les figures) ouvertes
clc       % effacer toutes les entr�es de la fen�tre de commande

% 3. Ajustement de lois de valeurs extr�mes

% charger les donn�es de temp�ratures journali�res
% col. 2 = ann�e,    col. 3 = mois,      col. 4 = jour
% col. 7 = temp. 7h, col. 8 = temp. 13h, col. 9 = temp. 21h
data = load('temperature_davos.txt'); % temp�ratures journali�res

% extraire la temp�rature maximale annuelle pour chaque ann�e
for i = 1:105  % les donn�es vont de 1901 � 2005
    ind     = find(data(:,2)==1900+i);
    pmax(i) = max(data(ind,8)); % pour les temp�ratures � 13h
end

% estimer les param�tres de la loi d'extremum g�n�ralis�e (GEV)
p = gevfit(pmax);
p(1) % afficher le param�tre de forme xi
% si xi < 0, les maxima suivent un loi de Weibull
% si xi = 0, les maxima suivent un loi de Gumbel
% si xi > 0, les maxima suivent un loi de Fr�chet


% fonction de densit� de probabilit� des donn�es de temp�rature (empirique)
dx = 1;                       % largeur des classes
tmn = floor(min(pmax));       % limite min. des classes
tmx = ceil(max(pmax));        % limite max. des classes
nbins = (tmx-tmn)/dx;         % nombre de classe
m_int = tmn+dx/2:dx:tmx-dx/2; % milieux des classes
N = hist(pmax, m_int);        % nombre d'�l�ments dans chacune des classes
P = N/length(pmax);           % probabilit� associ�e � chaque classe
pdf = P/dx;                   % densit� de probabilit�

% fonction de r�partition empirique des donn�es de temp�rature
[f,x] = ecdf(pmax);
% f est la probabilit� de non-d�passement des valeurs de x

% fonction de densit� de probabilit� de la loi d'extremum g�n�ralis�e (GEV)
d_gevpdf = gevpdf(tmn:0.1:tmx, p(1), p(2), p(3));

% fonction de r�partition de la loi d'extremum g�n�ralis�e (GEV)
f_gevcdf = gevcdf(tmn:0.1:tmx, p(1), p(2), p(3));


% graphique
subplot(2,1,1)
bar(m_int, pdf, 1);
hold on 
plot(tmn:0.1:tmx, d_gevpdf, 'r', 'LineWidth', 2)
title('Temp�ratures � Davos (1901-2005) - Maxima Annuels')
ylabel('densit� de probabilit� (pdf)')
legend('empirique','GEV','Location','NorthWest')

subplot(2,1,2)
plot(x,f,'.b','LineWidth', 2)
hold on
plot(tmn:0.1:tmx, f_gevcdf, 'r', 'LineWidth', 2)
xlabel('temp�rature journali�re (mm/j)')
ylabel('fonction de r�partition (cdf)')
legend('empirique','GEV','Location','NorthWest')


% avec des temps de retour...
Tr = 1./(1-f);
Tr_gevcdf = 1./(1-f_gevcdf);

figure
plot(Tr,x,'.b','LineWidth', 2)
hold on
plot(Tr_gevcdf, tmn:0.1:tmx, 'r', 'LineWidth', 2)
title('Temp�ratures � Davos (1901-2005) - Maxima Annuels')
xlabel('temp�rature journali�re (mm/j)')
ylabel('temps de retour (ann�es)')
legend('empirique','GEV','Location','SouthEast')