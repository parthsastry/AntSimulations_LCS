function [update_taxis] = change_chemotaxis(particle_vel, grid_pos, g, change_const, deltaX, deltaT, X, Y)
%UPDATE_PARTICLE_VEL updates particle velocity according to gradient of the
%pheromone matrix
%   the idea is that v' = v + b*grad(g), where grad(g) is computed at the
%   point, but g is a grid function, v is continuous, so we shall compute
%   gradient at each point on the grid, then update v based on the weighted
%   gradient at 4 nearest grid points (cell within which the particle
%   is located) using the interp2 function

update_taxis = zeros(size(particle_vel));
[gradx, grady] = gradient(g, deltaX); % numerical gradient of g

gradx_pos = interp2(X,Y,gradx,grid_pos(:,1),grid_pos(:,2),'linear');
grady_pos = interp2(X,Y,grady,grid_pos(:,1),grid_pos(:,2),'linear');

update_taxis(:,1) = change_const*deltaT*gradx_pos;
update_taxis(:,2) = -1*change_const*deltaT*grady_pos; % negative because we have reversed our y-axis

end

