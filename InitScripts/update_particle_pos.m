function [true_pos_new, grid_pos_new] = update_particle_pos(true_pos, grid_pos, particle_vel, deltaT)
%UPDATE_PARTICLE_POS updates particle position according to particle
%velocity
%   true_pos = true_pos+deltaT*velocity.
%   pos_on_grid = pos_on_grid + deltaT*velocity (and then you edit the 
%   position according to boundary conditions, for our grid)
%   currently - periodic boundary conditions.

true_pos_new = true_pos + deltaT * particle_vel;
% grid_pos_new = mod(grid_pos + deltaT * particle_vel, 1);
grid_pos_new = grid_pos + deltaT * particle_vel;

neg_overflow = grid_pos_new <= 0;
grid_pos_new(neg_overflow) = -1*grid_pos_new(neg_overflow);

pos_overflow = grid_pos_new >= 1;
grid_pos_new(pos_overflow) = 2 - grid_pos_new(pos_overflow);

end

