%---------------------------------------------------
% Risques Hydrologiques et Aménagement du Territoire
% TD2 - Corrigé
%---------------------------------------------------

clear all % effacer toutes les données en mémoire
close all % fermer toutes les fenêtres (p. ex. les figures) ouvertes
clc       % effacer toutes les entrées de la fenêtre de commande

% 3. Le Paradoxe de Petersbourg

% paramètre
F_final = [];     % initialisation de la variable qui stock la fortune finale
Fi      = 10000;    % fortune initiale
Mi      = 1;      % mise initiale
nexp    = 10000; % nombre de fois qu'on répète l'expérience (i.e. qu'on va au casino)

% simulation de la stratégie
for j = 1:nexp  % à chaque fois qu'on va au casino...    
    F  = Fi;    % initialisation de la variable "fortune"
    M  = Mi;    % initialisation de la variable "mise" 
    i  = 1;     % initialisation de la variable "nb de jeu"
    
    % tant que la fortune est inférieure à 2x la fortune initiale et
    % que que la fortune est supérieure à la mise
    while (F < 2*Fi) && (F > M) 
        P = rand;    % on joue (tire un nombre aléatoire entre 0 et 1)
        if P > 0.5   % si on gagne...
            F = F+M; % la fortune est augmenté de la mise
            M = Mi;  % et la mise du prochain jeu est égale à la mise initiale
        else         % si on perd...
            F = F-M; % la fortune est diminué de la mise
            M = 2*M; % et la mise du prochain jeu double
        end
        i = i+1;     % incrémente le compteur du nombre de jeu
    end
    F_final(j) = F;  % enregistre la fortune finale
end

hist(F_final)
xlabel('fortune final')
ylabel('nombre de réalisation')

mean(F_final)

% Pour mettre en évidence le paradoxe de Petersbourg, il faudrait répéter
% l'expérience une infinité de fois, ou alors ne pas limiter le nombre de
% jeu par (F < 2*Fi) && (F > M).
% On verrait alors que l'espérence du gain est positive. Cependant, cela 
% présuppose que le joueur a une réserve illimité d'argent qu'il peut
% avancer, ce qui est en soit impossible.