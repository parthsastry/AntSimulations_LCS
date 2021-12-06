function [gnew] = update_pheromone_conc(g, lambda, particle_pos, deltaX, deltaT, X, Y)
%UPDATE_PHEROMONE_CONC updates pheromone concentration matrix g
%   updates the pheromone concentration g at each grid point given by 
%   matrices X and Y, according to the particle position and the update
%   constants lambda and update_sigma, and the time scale deltaT

% the update constant update_sigma dictates the 'spread' of the pheromone
% patch around each particle. The smaller the value, the less the pheromone
% will spread around each particle.

% lamda dictates 'how much' pheromone is deposited around the particle pos.
% The deposition is in the form of a gaussian around the particle position
% with height 'lambda' and spread 'update_sigma'

update_mat = zeros(size(g)); % update matrix, which determines the update
% to be made according to the particle positions
update_sigma = 4*(deltaX^2)/3; % choice made, keeping in mind how far the 
% pheromone should spread

for i = 1:size(particle_pos, 1)
    dist2 = (X - particle_pos(i,1)).^2 + (Y - particle_pos(i,2)).^2;
    update_mat = update_mat + exp(-dist2/update_sigma);
end
    
% update_mat now contains the weight to be added at each grid point
% according to particle position

gnew = g*(1 - deltaT) + lambda*update_mat*deltaT;
% updates g matrix according to our differential equation
% g decays - > g*(1-deltaT) and there is some update happening.

end

