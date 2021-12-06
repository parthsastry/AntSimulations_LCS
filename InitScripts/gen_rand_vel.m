function [random_vel] = gen_rand_vel(random_pos, deltaX, deltaT)
%GEN_RAND_VEL Takes inputs - positions of particles, array dimension
%   positions of particles used to determine how many particle velocities
%   need to be generated.

particle_pos_size = size(random_pos);
random_angle = 2*pi*rand(particle_pos_size(1),1);

random_vel = (deltaX/deltaT)*[sin(random_angle), cos(random_angle)];
% normalizing by grid and time scale ensures that initial velocity only
% enough to cross 1 grid point in 5 time steps

end

