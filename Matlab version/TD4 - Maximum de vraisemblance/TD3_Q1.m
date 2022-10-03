%---------------------------------------------------
% Risques Hydrologiques et Aménagement du Territoire
% TD3 - Corrigé
%---------------------------------------------------

clear all % effacer toutes les données en mémoire
close all % fermer toutes les fenêtres (p. ex. les figures) ouvertes
clc       % effacer toutes les entrées de la fenêtre de commande

% 3. Ajustement de lois de valeurs extrêmes

% charger les données de températures journalières
% col. 2 = année,    col. 3 = mois,      col. 4 = jour
% col. 7 = temp. 7h, col. 8 = temp. 13h, col. 9 = temp. 21h
data = load('temperature_davos.txt'); % températures journalières

% extraire la température maximale annuelle pour chaque année
for i = 1:105  % les données vont de 1901 à 2005
    ind     = find(data(:,2)==1900+i);
    pmax(i) = max(data(ind,8)); % pour les températures à 13h
end

% estimer les paramètres de la loi d'extremum généralisée (GEV)
p = gevfit(pmax);
p(1) % afficher le paramètre de forme xi
% si xi < 0, les maxima suivent un loi de Weibull
% si xi = 0, les maxima suivent un loi de Gumbel
% si xi > 0, les maxima suivent un loi de Fréchet


% fonction de densité de probabilité des données de température (empirique)
dx = 1;                       % largeur des classes
tmn = floor(min(pmax));       % limite min. des classes
tmx = ceil(max(pmax));        % limite max. des classes
nbins = (tmx-tmn)/dx;         % nombre de classe
m_int = tmn+dx/2:dx:tmx-dx/2; % milieux des classes
N = hist(pmax, m_int);        % nombre d'éléments dans chacune des classes
P = N/length(pmax);           % probabilité associée à chaque classe
pdf = P/dx;                   % densité de probabilité

% fonction de répartition empirique des données de température
[f,x] = ecdf(pmax);
% f est la probabilité de non-dépassement des valeurs de x

% fonction de densité de probabilité de la loi d'extremum généralisée (GEV)
d_gevpdf = gevpdf(tmn:0.1:tmx, p(1), p(2), p(3));

% fonction de répartition de la loi d'extremum généralisée (GEV)
f_gevcdf = gevcdf(tmn:0.1:tmx, p(1), p(2), p(3));


% graphique
subplot(2,1,1)
bar(m_int, pdf, 1);
hold on 
plot(tmn:0.1:tmx, d_gevpdf, 'r', 'LineWidth', 2)
title('Températures à Davos (1901-2005) - Maxima Annuels')
ylabel('densité de probabilité (pdf)')
legend('empirique','GEV','Location','NorthWest')

subplot(2,1,2)
plot(x,f,'.b','LineWidth', 2)
hold on
plot(tmn:0.1:tmx, f_gevcdf, 'r', 'LineWidth', 2)
xlabel('température journalière (mm/j)')
ylabel('fonction de répartition (cdf)')
legend('empirique','GEV','Location','NorthWest')


% avec des temps de retour...
Tr = 1./(1-f);
Tr_gevcdf = 1./(1-f_gevcdf);

figure
plot(Tr,x,'.b','LineWidth', 2)
hold on
plot(Tr_gevcdf, tmn:0.1:tmx, 'r', 'LineWidth', 2)
title('Températures à Davos (1901-2005) - Maxima Annuels')
xlabel('température journalière (mm/j)')
ylabel('temps de retour (années)')
legend('empirique','GEV','Location','SouthEast')