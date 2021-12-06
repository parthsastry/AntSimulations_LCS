function [collision_stimulus,new_orientation_vec,new_vels,new_orientation] = ant_interaction(ant_pos,ant_vels,...
    orientation,orientation_vec,r_d,r_p,int_angle,deltaT,u_min,u_max,accl,turning_rate_a)
%ANT_INTERACTION simulate inter-ant interactions, give output direction
%   Given ant positions and orientations - 
%   for ant i, if there are ants j within i's interaction zone, then i
%   turns to avoid them. returns 'preferred orientations' for every ant
%   after checking for interaction. 
%
%   May or may not be possible depending on
%   turn rate, the update happens later.

    max_turn = turning_rate_a*deltaT;
    
    new_orientation = orientation;
    new_orientation_vec = orientation_vec;
    new_vels = zeros(size(ant_vels));
    collision_stimulus = false(size(ant_pos,1),1);
    
    distances = pdist2(ant_pos, ant_pos);
    
    for i = 1:size(ant_pos,1)
        not_i = true(size(ant_pos,1),1);
        not_i(i) = false; % useful logical array.
        
        sep_vecs = -ant_pos + ant_pos(i,:);
        sep_vecs = sep_vecs./vecnorm(sep_vecs,2,2);
        sep_angle = atan2(sep_vecs(:,2),sep_vecs(:,1));
        
        rd_interacting_ants = (distances(:,i) < r_d) & not_i;
        rp_interacting_ants = (distances(:,i) < r_p & ...
            abs(sep_angle - new_orientation(i)) < int_angle/2) & not_i;
        
        interacting_ants = rd_interacting_ants | rp_interacting_ants;
        
        if sum(interacting_ants) == 0
            new_vels(i) = min(u_max,ant_vels(i)+accl*deltaT);
%         elseif sum(rp_interacting_ants) == 0
%             new_orientation_vec(i,:) = sum(sep_vecs(interacting_ants,:))./vecnorm(sum(sep_vecs(interacting_ants,:)),2,2);
%             pref_orientation = atan2(new_orientation_vec(i,2),new_orientation_vec(i,1));
%             
%             if abs(pref_orientation - orientation(i)) < max_turn % if possible to turn to pref_orientation, do
%                 new_orientation(i) = pref_orientation;
%             else % else, turn towards pref_orientation as much as you can
%                 new_orientation(i) = wrapToPi(orientation(i) + sign(pref_orientation - orientation(i))*max_turn);
%             end
%             
%             new_vels(i) = min(u_max,ant_vels(i)+accl*deltaT);
%             % new_vels(i) = max(u_min,ant_vels(i)-accl*deltaT);
%             collision_stimulus(i) = true;
        else
            new_orientation_vec(i,:) = sum(sep_vecs(interacting_ants,:))./vecnorm(sum(sep_vecs(interacting_ants,:)),2,2);
            pref_orientation = atan2(new_orientation_vec(i,2),new_orientation_vec(i,1));
            
            if abs(pref_orientation - orientation(i)) < max_turn % if possible to turn to pref_orientation, do
                new_orientation(i) = pref_orientation;
            else % else, turn towards pref_orientation as much as you can
                new_orientation(i) = wrapToPi(orientation(i) + sign(pref_orientation - orientation(i))*max_turn);
            end
            
            % new_vels(i) = max(u_min,ant_vels(i)-accl*deltaT);
            new_vels(i) = ant_vels(i);
            collision_stimulus(i) = true;
        end    
    end
end

