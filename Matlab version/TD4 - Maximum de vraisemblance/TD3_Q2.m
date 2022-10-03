%---------------------------------------------------
% Risques Hydrologiques et Aménagement du Territoire
% TD4 - Corrigé
%---------------------------------------------------

clear all % effacer toutes les données en mémoire
close all % fermer toutes les fenêtres (p. ex. les figures) ouvertes
clc       % effacer toutes les entrées de la fenêtre de commande

% 2. Algorithme d'Hasting-Metropolis

% Question 1-2 ------------------------------------------------------------

% générer N valeurs aléatoirement selon une loi de Poisson de paramètre
% lambda = 2
N = 20; d = poissrnd(2,N,1);
% d représente un jeu de données qu'on sait, par expérience, distribué 
% selon une loi de Poisson, mais dont on ignore le paramère lambda
% l'objectif est de retrouver la valeur du paramètre lambda


% initialisation du theta initial
% theta représente ici le paramètre lambda recherché
theta0 = 1;

% "posterior" pour le theta initial (posterior non normalisé)
% le posterior est la probabilité d'avoir theta sachant les observations d

% Pour obtenir le "vrai" posterior, il faut diviser Q0 par une constante 
% qui est inconnue (terme avec l'intégrale dans l'équation générale).
% Cependant, cette constante se simplifie lorsque l'on compare les deux
% posteriors (taux d'acceptation r). On peut donc la négliger déjà ici.

Q0 = sum(log(pdf('poiss',d,theta0)))+log(pdf('unif',theta0,1,100));
% le 1er terme est la log-vraisemblance de theta0
% le 2ème terme est le log du prior pris selon une loi uniforme U(0,100)

nPas = 3000; % nombre d'itérations
for i = 1:nPas
    D0(i) = theta0; % enregistrer le theta au pas i
    
    % génération d'un theta candidat selon une loi instrumentale q
    thetai = random('norm',theta0,0.01);
    % q est ici une loi normale d'espérence theta1 et d'écart-type 0.01
    % q contrôle la taille des "sauts" qui explorent l'espace de Q(theta)
    
    % "posterior" pour le theta candidat
    Q1 = sum(log(pdf('poiss',d,thetai)))+log(pdf('unif',thetai,1,100));

    r = exp(Q1-Q0); % taux d'acceptation
    % critère d'acceptation ou de rejet du theta candidat
    % si r >= 1 on accepte le nouveau theta car on monte sur la courbe Q(theta)
    % (probabilité plus élevée d'avoir thetai que theta0 sachant les observations d)
    % si r<1 on accepte le nouveau theta avec un probabilité r uniquement
    % (comparaison avec une valeur aléatoire u tirée d'une distribution uniforme U(0,1))
    u = rand(1,1);
    if r>u
        theta0 = thetai;
        Q0 = Q1;
    end        
end


% Question 3-4 ------------------------------------------------------------
plot(D0, 'b')
title('Algorithme d''Hasting-Metropolis (N = 20 données)')
xlabel('itérations')
ylabel('theta')

lambda_HMunif = mean(D0(end-1499:end))
lambda_poiss = poissfit(d) % maximum de vraisemblance

% on remarque que les deux valeurs peuvent être assez proches et donner une
% bonne approximation du lambda de la loi de Poisson qui a servi à générer 
% les données (lambda = 2)
% cependant, il n'y a pas assez de données et les résutats peuvent varier
% de manière significatives d'un tirage à l'autre


% Question 5 -------------------------------------------------------------- 
% on répète l'algorithme précédent en changeant le prior
theta0 = 1;
Q0 = sum(log(pdf('poiss',d,theta0)))+log(pdf('norm',theta0,2,0.1));
% le 2ème terme est le prior pris selon une loi normale
nPas = 3000;
for i = 1:nPas
    D(i) = theta0;
    thetai = random('norm',theta0,0.01);
    Q1 = sum(log(pdf('poiss',d,thetai)))+log(pdf('norm',thetai,2,0.1));
    r = exp(Q1-Q0);
    u = rand(1,1);
    if r>u
        theta0 = thetai;
        Q0 = Q1;
    end        
end

hold on
plot(D, 'r')
plot([0 3000],[lambda_poiss lambda_poiss],'--k')
plot([0 3000],[2 2],'k')

legend('prior U(0,100)','prior N(2,0.1^2)','max. vrais. (poissfit)','lambda','Location','SouthEast')

lambda_HMnorm = mean(D(end-1499:end))

% on remarque que le prior pris selon la loi normale converge plus vite
% l'utilisation d'un prior correct (p. ex. ici centré en 2) accélère donc 
% la convergence quand il y a peu de données


% Question 6 -------------------------------------------------------------- 
% prior selon loi uniforme
N = 2000; d = poissrnd(2,N,1);
theta0 = 1;
Q0 = sum(log(pdf('poiss',d,theta0)))+log(pdf('unif',theta0,1,100));
nPas = 3000;
for i = 1:nPas
    D0(i) = theta0;
    thetai = random('norm',theta0,0.01);
    Q1 = sum(log(pdf('poiss',d,thetai)))+log(pdf('unif',thetai,1,100));
    r = exp(Q1-Q0);
    u = rand(1,1);
    if r>u
        theta0 = thetai;
        Q0 = Q1;
    end        
end

% prior selon loi normale
theta0 = 1;
Q0 = sum(log(pdf('poiss',d,theta0)))+log(pdf('norm',theta0,2,0.1));
nPas = 3000;
for i = 1:nPas
    D(i) = theta0;
    thetai = random('norm',theta0,0.01);
    Q1 = sum(log(pdf('poiss',d,thetai)))+log(pdf('norm',theta0,2,0.1));
    r = exp(Q1-Q0);
    u = rand(1,1);
    if r>u
        theta0 = thetai;
        Q0 = Q1;
    end        
end

figure
plot(D0, 'b')
title('Algorithme d''Hasting-Metropolis (N = 2000 données)')
xlabel('itérations')
ylabel('theta')
hold on
plot(D, 'r')
legend('prior U(0,100)','prior N(2,0.1^2)','Location','SouthEast')

lambda_HMunif = mean(D0(end-1499:end))
lambda_poiss = poissfit(d)
lambda_HMnorm = mean(D(end-1499:end))


% on remarque que le choix du prior importe peu quand le nombre de données
% est suffisant
% le choix du prior a alors moins d'importance que la vraisemblance
% la valeur de lambda est bien estimée par les deux méthodes


% Question 7 --------------------------------------------------------------
% prior selon loi normale
N = 2000; d = poissrnd(2,N,1);
theta0 = 1;
Q0 = sum(log(pdf('poiss',d,theta0)))+log(pdf('norm',theta0,5,0.1));
nPas = 3000;
for i = 1:nPas
    D(i) = theta0;
    thetai = random('norm',theta0,0.01);
    Q1 = sum(log(pdf('poiss',d,thetai)))+log(pdf('norm',theta0,5,0.1));
    r = exp(Q1-Q0);
    u = rand(1,1);
    if r>u
        theta0 = thetai;
        Q0 = Q1;
    end        
end

hold on 
plot(D, 'm')
plot([0 3000],[lambda_poiss lambda_poiss],'--k')
legend('prior U(0,100)','prior N(2,0.1^2)','prior N(5,0.1^2)','max. vrais. (poissfit)','Location','SouthEast')
axis([0 3000 0.5 2.5])

% en prenant un prior erroné (p. ex. centré en 0.5), l'algorithme ne
% converge pas vers la bonne valeur si le nombre de données est insuffisant

% en prenant un prior très éronné (p. ex. centré en 5), des problèmes de 
% convergence apparaissent