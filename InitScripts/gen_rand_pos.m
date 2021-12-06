function [random_pos] = gen_rand_pos(density, distribution_name, deltaX, varargin)
%GEN_RANDOM_POS Generates random positions for a number of particles
%   The number of particles is dictated by the particle density. If we 
%   specify the generating distribution to be 'gaussian', we
%   sample the positions from a 2D normal distribution, otherwise we
%   uniformly assign particle position. 
%   varargin should be a cell array with varargin{1} = sigma (for gaussian)
%   density should refer to number of particles per unit area

num_particles = round(density);
particle_pos_size = [num_particles, 2];

if strcmp(distribution_name,'gaussian')
    mu = 0.5;
    sigma = varargin{1};
    random_pos = normrnd(mu,sigma,particle_pos_size);
    random_pos = mod(random_pos, 1);
    % ensures any particles generated outside the grid are appropriately
    % placed within
elseif strcmp(distribution_name, 'uniform')
    veclist = 0:deltaX:1;
    [A,B] = meshgrid(veclist,veclist);
    foo = cat(2,A',B');
    random_pos = reshape(foo,[],2);
    % uniformly placed particles on each grid point. ignores the particle
    % density
elseif strcmp(distribution_name, 'init_circ')
    random_angle = 2*pi*rand(particle_pos_size(1),1);
    random_pos = [0.5 + 0.25*sin(random_angle), 0.5 + 0.25*cos(random_angle)];
    random_pos = random_pos + 0.1*rand(particle_pos_size(1),2);
else
    random_pos = rand(num_particles,2);
    % randomly placed particles on the grid
end
end

