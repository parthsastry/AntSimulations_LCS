function [new_ant_pos, new_full_pos] = update_pos(full_pos,ant_pos,orientation,orientation_vec,ant_vel,deltaT)
%UPDATE_POS Move ants according to orientation and velocity
%   x' = x + v*t

new_full_pos = full_pos + ant_vel.*orientation_vec*deltaT;
new_ant_pos = mod(ant_pos + ant_vel.*orientation_vec*deltaT,1);

end

