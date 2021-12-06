function [newConc] = update_pheromone_conc(conc,particle_pos,deltaX,deltaT, X,Y)
%UPDATE_PHEROMONE_CONC update pheromone concentration
%   This is a tricky implementation. Current - Add conc in a small gaussian
%   around current point, then convolve full concentration matrix with a
%   gaussian kernel to simulate 'spread'.
%   To ensure that concentration doesn't increase fully, we scale the
%   gaussian down with an 'evaporation' factor, that makes total pheromone
%   content reduce a tiny bit.

update = zeros(size(conc));
update_sigma = 2*(deltaX^2)/3; % choice made, keeping in mind how far the 
% pheromone should spread (initially)

for i = 1:size(particle_pos, 1)
    dist2 = (X - particle_pos(i,1)).^2 + (Y - particle_pos(i,2)).^2;
    update = update + exp(-dist2/update_sigma);
end

newConc = conc + update;
gaussian_kernel = (1-deltaT)*fspecial('gaussian');
newConc = conv2(newConc,gaussian_kernel,'same');

end

