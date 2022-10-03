%---------------------------------------------------
% Risques Hydrologiques et Am�nagement du Territoire
% TD4 - Corrig�
%---------------------------------------------------

clear all % effacer toutes les donn�es en m�moire
close all % fermer toutes les fen�tres (p. ex. les figures) ouvertes
clc       % effacer toutes les entr�es de la fen�tre de commande

% 2. Algorithme d'Hasting-Metropolis

% Question 1-2 ------------------------------------------------------------

% g�n�rer N valeurs al�atoirement selon une loi de Poisson de param�tre
% lambda = 2
N = 20; d = poissrnd(2,N,1);
% d repr�sente un jeu de donn�es qu'on sait, par exp�rience, distribu� 
% selon une loi de Poisson, mais dont on ignore le param�re lambda
% l'objectif est de retrouver la valeur du param�tre lambda


% initialisation du theta initial
% theta repr�sente ici le param�tre lambda recherch�
theta0 = 1;

% "posterior" pour le theta initial (posterior non normalis�)
% le posterior est la probabilit� d'avoir theta sachant les observations d

% Pour obtenir le "vrai" posterior, il faut diviser Q0 par une constante 
% qui est inconnue (terme avec l'int�grale dans l'�quation g�n�rale).
% Cependant, cette constante se simplifie lorsque l'on compare les deux
% posteriors (taux d'acceptation r). On peut donc la n�gliger d�j� ici.

Q0 = sum(log(pdf('poiss',d,theta0)))+log(pdf('unif',theta0,1,100));
% le 1er terme est la log-vraisemblance de theta0
% le 2�me terme est le log du prior pris selon une loi uniforme U(0,100)

nPas = 3000; % nombre d'it�rations
for i = 1:nPas
    D0(i) = theta0; % enregistrer le theta au pas i
    
    % g�n�ration d'un theta candidat selon une loi instrumentale q
    thetai = random('norm',theta0,0.01);
    % q est ici une loi normale d'esp�rence theta1 et d'�cart-type 0.01
    % q contr�le la taille des "sauts" qui explorent l'espace de Q(theta)
    
    % "posterior" pour le theta candidat
    Q1 = sum(log(pdf('poiss',d,thetai)))+log(pdf('unif',thetai,1,100));

    r = exp(Q1-Q0); % taux d'acceptation
    % crit�re d'acceptation ou de rejet du theta candidat
    % si r >= 1 on accepte le nouveau theta car on monte sur la courbe Q(theta)
    % (probabilit� plus �lev�e d'avoir thetai que theta0 sachant les observations d)
    % si r<1 on accepte le nouveau theta avec un probabilit� r uniquement
    % (comparaison avec une valeur al�atoire u tir�e d'une distribution uniforme U(0,1))
    u = rand(1,1);
    if r>u
        theta0 = thetai;
        Q0 = Q1;
    end        
end


% Question 3-4 ------------------------------------------------------------
plot(D0, 'b')
title('Algorithme d''Hasting-Metropolis (N = 20 donn�es)')
xlabel('it�rations')
ylabel('theta')

lambda_HMunif = mean(D0(end-1499:end))
lambda_poiss = poissfit(d) % maximum de vraisemblance

% on remarque que les deux valeurs peuvent �tre assez proches et donner une
% bonne approximation du lambda de la loi de Poisson qui a servi � g�n�rer 
% les donn�es (lambda = 2)
% cependant, il n'y a pas assez de donn�es et les r�sutats peuvent varier
% de mani�re significatives d'un tirage � l'autre


% Question 5 -------------------------------------------------------------- 
% on r�p�te l'algorithme pr�c�dent en changeant le prior
theta0 = 1;
Q0 = sum(log(pdf('poiss',d,theta0)))+log(pdf('norm',theta0,2,0.1));
% le 2�me terme est le prior pris selon une loi normale
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
% l'utilisation d'un prior correct (p. ex. ici centr� en 2) acc�l�re donc 
% la convergence quand il y a peu de donn�es


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
title('Algorithme d''Hasting-Metropolis (N = 2000 donn�es)')
xlabel('it�rations')
ylabel('theta')
hold on
plot(D, 'r')
legend('prior U(0,100)','prior N(2,0.1^2)','Location','SouthEast')

lambda_HMunif = mean(D0(end-1499:end))
lambda_poiss = poissfit(d)
lambda_HMnorm = mean(D(end-1499:end))


% on remarque que le choix du prior importe peu quand le nombre de donn�es
% est suffisant
% le choix du prior a alors moins d'importance que la vraisemblance
% la valeur de lambda est bien estim�e par les deux m�thodes


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

% en prenant un prior erron� (p. ex. centr� en 0.5), l'algorithme ne
% converge pas vers la bonne valeur si le nombre de donn�es est insuffisant

% en prenant un prior tr�s �ronn� (p. ex. centr� en 5), des probl�mes de 
% convergence apparaissent