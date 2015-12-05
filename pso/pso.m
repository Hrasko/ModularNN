function [ gBest,bestFit ] = pso( params,restriction,costFunction,db)

% n-> numero de particulas
n = params(1);
% steps -> numero de passos
steps = params(2);
%d = dimension
d = params(3);
% c1, c2 -> pso parameters
c1 = params(4);
c2 = params(5);
% w -> pso momentum
w = params(6);

% restriction -> matrix with limits
%p -> pause between each interaction

%% Initialization
clc;

%fitness indicates how well is the particule doing.
fitness = ones(n,1);


% randomize positions between -interval and interval
pos = ones(d,n);
for i=1:n
    for j=1:d
        pos(j,i) = rand(1)*(restriction(j,2)-restriction(j,1))+restriction(j,1);
    end
end
localBestPos = pos;

% randomize initial velocity. 
velocity = w*rand(d,n);

% evaluate initial positions
for i= 1: n
   fprintf('Particula: %d, pos: %14.3f %14.3f\n',i,pos(:,i));
   fitness(i) = costFunction(pos(:,i),db);
   
end

% Initialy, local fitness is current fitness
localFitness = fitness;

% Find minimum fitness (gBest) on gIndex
[gBest,gIndex] = min(localFitness) ;

% Get Position of gBest. IT is a vector to simplify the velocity
% calculation in the main loop
gBestPos = pos;
for i= 1: n
    gBestPos(:,i) = pos(:,gIndex);
end

% Walk the particles
for i=1:n
    for j=1:d
        target = pos(j,i) + velocity(j,i);
        if (target >= restriction(j,1) && target <= restriction(j,2))
            pos(j,i) = target;
        end
    end
end

%% Drawing initialization
%xv = [-interval:0.1:interval];
%yv = [-interval:0.1:interval];
%[u,v] = meshgrid(xv,yv);
%s = funcao(u,v);
currentGBest = 10000000000;
%% Main Loop
interactions = 0;
improvementCounter = 0;
while (gBest > 0.001 && interactions < steps && improvementCounter < 5)    
    interactions = interactions + 1;
    % Used to track gBest for drawing purposes only
    %gBestTracker(interactions) = gBest;
    
    % Evaluate new positions
    for i= 1: n
        fprintf('Iteracao: %d, Particula: %d, gBestFit: %14.3f\n',interactions,i,currentGBest);
        fitness(i) = costFunction(pos(:,i),db);   
    end
    
    % Get the best local position 
    for i = 1 : n
        if fitness(i) < localFitness(i)
           localFitness(i)  = fitness(i);  
           localBestPos(:,i) = pos(:,i);
        end   
    end
    
    % Find current minimum fitness (gBest) on gIndex
    [currentGBest,gIndex] = min(localFitness) ;

    % Get Position of gBest if it is better
    if currentGBest < gBest
        gBest = currentGBest;
        for i= 1: n
            gBestPos(:,i) = pos(:,gIndex);
        end
    else
        improvementCounter = improvementCounter +1;
    end
    
    R1 = rand(d,n);
    R2 = rand(d,n);
    
    % Analize velocity
    velocity = w *velocity + c1*(R1.*(localBestPos-pos)) + c2*(R2.*(gBestPos-pos));

    % Walk the particles
    for i=1:n
        for j=1:d
            target = pos(j,i) + velocity(j,i);
            if (target >= restriction(j,1))
                if  (target <= restriction(j,2))
                    pos(j,i) = target;
                else
                    pos(j,i) = restriction(j,2);
                end
            else
                pos(j,i) = restriction(j,1);
            end
        end
    end
    
    %% Drawing
    clc;
    
    dlmwrite('gBestPos.txt',gBestPos(:,1));
    dlmwrite('gBest.txt',gBestPos);
    
end 

bestFit = gBestPos(:,1);