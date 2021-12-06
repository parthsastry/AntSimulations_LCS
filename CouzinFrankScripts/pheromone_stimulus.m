function [new_orientation_vec, new_orientation] = pheromone_stimulus(ant_pos,orientation,orientation_vec, ...
    ant_length,collision_stimulus,antenna_length,pheromone_conc,turning_rate_p,deltaT,X,Y)
%PHEROMONE_STIMULUS Checks which antenna perceives higher conc. Turns
%towards that 
%   Takes in previous input of ant_interaction. At the end, ensures all new
%   orientations are 

    new_orientation_vec = orientation_vec;
    new_orientation = orientation;

    head_pos = ant_pos + 0.5*ant_length*orientation_vec; % head positions
    left_antennae_angle = orientation + pi/4;
    right_antennae_angle = orientation - pi/4; % positions of antennae
    turning_angle = turning_rate_p*deltaT; % angle by which to turn
    
    left_antennae_pos = head_pos + antenna_length*[cos(left_antennae_angle),sin(left_antennae_angle)];
    right_antennae_pos = head_pos + antenna_length*[cos(right_antennae_angle),sin(right_antennae_angle)];
    % get positions of left and right antennae for all ants
    
    left_conc = interp2(X,Y,pheromone_conc,left_antennae_pos(:,1),left_antennae_pos(:,2),'linear');
    right_conc = interp2(X,Y,pheromone_conc,right_antennae_pos(:,1),right_antennae_pos(:,2),'linear');
    % get pheromone concentrations at left and right antennae for all ants
    
    for i = 1:size(ant_pos,1)
        if ~collision_stimulus(i)
            if left_conc(i) > right_conc(i)
                new_orientation(i) = wrapToPi(orientation(i) + turning_angle + 0.5*randn(1,1));
                new_orientation_vec(i,:) = [cos(new_orientation(i)), sin(new_orientation(i))]; % turn left (anti-clockwise)
            elseif right_conc(i) > left_conc(i)
                new_orientation(i) = wrapToPi(new_orientation(i) - turning_angle + 0.5*randn(1,1));
                new_orientation_vec(i,:) = [cos(new_orientation(i)), sin(new_orientation(i))]; % turn right
            else
            end
        end       
    end
    
end

