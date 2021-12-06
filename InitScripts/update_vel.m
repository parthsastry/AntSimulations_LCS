function [particle_vel_new] = update_vel(particle_vel, grid_pos, g, ...
    change_const, deltaX, deltaT, X, Y, align_const, shoaling_range, chemotaxis_coeff)
%UPDATE_VEL updates particle velocity proportional to the ratio specified
%   between chemotaxis and shoaling
%   uses functions update_chemotaxis and update_shoaling to update particle
%   velocity. uses chemotaxis_coeff as a ratio(between 0 and 1) between the
%   influence of chemotaxis and the influence of shoaling.

update_taxis = change_chemotaxis(particle_vel, grid_pos, g, change_const, deltaX, deltaT, X, Y);
update_shoaling = change_shoaling(particle_vel, grid_pos, align_const, shoaling_range, deltaT);

particle_vel_new = particle_vel + chemotaxis_coeff*(update_taxis) + (1 - chemotaxis_coeff)*update_shoaling;
% have a velocity max? deltaX/deltaT maximum possiblie velocity at some
% time instant

mag_vel = sqrt(particle_vel_new(:,1).^2 + particle_vel_new(:,2).^2);
vel_gt_max = mag_vel > deltaX/deltaT;
particle_vel_new(vel_gt_max,:) = deltaX/deltaT*(particle_vel_new(vel_gt_max,:)./mag_vel(vel_gt_max));

x_edge = ((1 - grid_pos(:,1) < deltaX & particle_vel_new(:,1) > 0) | (grid_pos(:,1) < deltaX & particle_vel_new(:,1) < 0));
particle_vel_new(x_edge,1) = -1*particle_vel_new(x_edge,1);

y_edge = ((1 - grid_pos(:,2) < deltaX & particle_vel_new(:,2) > 0) | (grid_pos(:,2) < deltaX & particle_vel_new(:,2) < 0));
particle_vel_new(y_edge,2) = -1*particle_vel_new(y_edge,2);

end

