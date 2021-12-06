function [update_shoaling] = change_shoaling(particle_vel, grid_pos, align_const, shoaling_range, deltaT)
%CHANGE_SHOALING updates particle velocity dependent on neighbouring
%   particle velocity
%   v' = v + avg(v_neighbouring). neighbouring particles within range
%   shoaling_range used for averaging. update weighted by align_const

update_shoaling = zeros(size(particle_vel));
distances = pdist2(grid_pos, grid_pos);

for i = 1:size(particle_vel,1)
    not_i = true(size(particle_vel,1),1);
    not_i(i) = false;
    vels_i = particle_vel(distances(:,i) < shoaling_range & not_i, :);
    if isempty(vels_i)
        vels_i = zeros(1,2);
    end
    vel_i = mean(vels_i,1);
    update_shoaling(i,:) = deltaT*align_const*vel_i;
end

end

