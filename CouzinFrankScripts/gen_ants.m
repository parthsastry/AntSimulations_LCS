function [ant_pos,orientation,orientation_vec,ant_vel] = gen_ants(u_min,density,distribution_name,deltaX,varargin)
%GEN_ANTS Generates random positions and orientations for N ants
%   The number of particles is dictated by the particle density (area = 1m2). 
%
%   If we specify the generating distribution to be 'gaussian', we
%   sample the positions from a 2D normal distribution.
%   In the case of 'uniform' it's uniformly distributed on each grid point
%   (doesn't take into account particle density)
%
%   varargin should be a cell array with varargin{1} = sigma (for gaussian)

num_particles = round(density);
particle_pos_size = [num_particles, 2];

if strcmp(distribution_name,'gaussian')
    mu = 0.5;
    sigma = varargin{1};
    random_pos = normrnd(mu,sigma,particle_pos_size);
    ant_pos = mod(random_pos, 1);
    % ensures any particles generated outside the grid are appropriately
    % placed within
elseif strcmp(distribution_name, 'uniform')
    veclist = 0:deltaX:1;
    [A,B] = meshgrid(veclist,veclist);
    foo = cat(2,A',B');
    ant_pos = reshape(foo,[],2);
    num_particles = size(ant_pos,1);
    % uniformly placed particles on each grid point. ignores the particle
    % density
elseif strcmp(distribution_name, 'init_circ')
    random_angle = -pi + 2*pi*rand(particle_pos_size(1),1);
    circ_pos = [0.5 + 0.25*sin(random_angle), 0.5 + 0.25*cos(random_angle)];
    ant_pos = circ_pos + 0.1*rand(particle_pos_size(1),2);
else
    ant_pos = rand(num_particles,2);
    % randomly placed particles on the grid
end

orientation = 2*pi*rand(num_particles,1);
orientation_vec = [cos(orientation), sin(orientation)];

if strcmp(distribution_name, 'init_circ')
    orientation = wrapToPi(random_angle + pi/2);
    orientation_vec = [cos(orientation), sin(orientation)];
end

ant_vel = u_min*ones(num_particles,1);

end

