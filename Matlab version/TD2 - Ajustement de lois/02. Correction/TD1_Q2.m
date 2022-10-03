%---------------------------------------------------
% Risques Hydrologiques et Am�nagement du Territoire
% TD2 - Corrig�
%---------------------------------------------------

clear all % effacer toutes les donn�es en m�moire
close all % fermer toutes les fen�tres (p. ex. les figures) ouvertes
clc       % effacer toutes les entr�es de la fen�tre de commande

% 3. Le Paradoxe de Petersbourg

% param�tre
F_final = [];     % initialisation de la variable qui stock la fortune finale
Fi      = 10000;    % fortune initiale
Mi      = 1;      % mise initiale
nexp    = 10000; % nombre de fois qu'on r�p�te l'exp�rience (i.e. qu'on va au casino)

% simulation de la strat�gie
for j = 1:nexp  % � chaque fois qu'on va au casino...    
    F  = Fi;    % initialisation de la variable "fortune"
    M  = Mi;    % initialisation de la variable "mise" 
    i  = 1;     % initialisation de la variable "nb de jeu"
    
    % tant que la fortune est inf�rieure � 2x la fortune initiale et
    % que que la fortune est sup�rieure � la mise
    while (F < 2*Fi) && (F > M) 
        P = rand;    % on joue (tire un nombre al�atoire entre 0 et 1)
        if P > 0.5   % si on gagne...
            F = F+M; % la fortune est augment� de la mise
            M = Mi;  % et la mise du prochain jeu est �gale � la mise initiale
        else         % si on perd...
            F = F-M; % la fortune est diminu� de la mise
            M = 2*M; % et la mise du prochain jeu double
        end
        i = i+1;     % incr�mente le compteur du nombre de jeu
    end
    F_final(j) = F;  % enregistre la fortune finale
end

hist(F_final)
xlabel('fortune final')
ylabel('nombre de r�alisation')

mean(F_final)

% Pour mettre en �vidence le paradoxe de Petersbourg, il faudrait r�p�ter
% l'exp�rience une infinit� de fois, ou alors ne pas limiter le nombre de
% jeu par (F < 2*Fi) && (F > M).
% On verrait alors que l'esp�rence du gain est positive. Cependant, cela 
% pr�suppose que le joueur a une r�serve illimit� d'argent qu'il peut
% avancer, ce qui est en soit impossible.