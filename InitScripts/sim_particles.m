% MATLAB script to run sims of the particles on a grid using different
% parameters.
% we'll be assuming the grid to be a 1m x 1m grid, the number of grid
% points we shall divide it into, is a variable that we can control via the
% deltaX variable

close all
deltaX = 0.005; % separation of grid points
x = 0:deltaX:1; y = 0:deltaX:1;
[X,Y] = meshgrid(x,y); Y = flipud(Y); % making the grid

g = zeros(size(X));

particle_density = 200; % particle density in #/m^2. Since grid is 1x1, # of particles will be particle_density
deltaT = 0.01; % magnitude of time step (we take deltaX and deltaT accordingly to match average velocity measured IRL)

change_const = 0.1; % how much does the velocity change as a proportion to the gradient of the pheromone concentration
lambda = 0.4; % how much pheromone is deposited (arbitrary right now, 
% trying to keep reasonable values of ant acceleration)
% NEED TO TUNE THESE.

align_const = 0.02;
shoaling_range = 5*deltaX;

chemotaxis_coeff = 1;

initial_random_pos = gen_rand_pos(particle_density, 'init_circ', deltaX);
initial_random_vel = gen_rand_vel(initial_random_pos, deltaX, deltaT);

true_pos = initial_random_pos; grid_pos = true_pos;
particle_vel = initial_random_vel;

for t = 1:5000
    [true_pos, grid_pos] = update_particle_pos(true_pos, grid_pos, particle_vel, deltaT);
    g = update_pheromone_conc(g, lambda, grid_pos, deltaX, deltaT, X, Y);
    [gradx, grady] = gradient(g,deltaX);
    % update_taxis = change_chemotaxis(particle_vel, grid_pos, g, b, deltaX, deltaT, X, Y);
    % update_shoaling = change_shoaling(particle_vel, grid_pos, align_const, shoaling_range, deltaT);
    % for now, only considering chemotaxis
    % particle_vel = particle_vel + update_taxis; % + 0.8*update_shoaling;
    disp(sum(particle_vel));
    particle_vel = update_vel(particle_vel, grid_pos, g, change_const, deltaX, deltaT, X, Y, ...
        align_const, shoaling_range, chemotaxis_coeff);
    myfig = scatter(grid_pos(:,1),grid_pos(:,2),[],'red','filled');
    drawnow;
    pause(0.01);
end