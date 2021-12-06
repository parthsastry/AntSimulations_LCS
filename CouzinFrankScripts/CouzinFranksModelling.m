% MATLAB script to run sims of isolated ants on a grid using different
% parameters.
%
% We'll be assuming the grid to be a 1m x 1m grid, the number of grid
% points we shall divide it into, is a variable that we can control via the
% deltaX variable

close all
deltaX = 0.025; % separation of grid points
x = 0:deltaX:1; y = 0:deltaX:1;
[X,Y] = meshgrid(x,y); Y = flipud(Y); % making the grid

conc_matrix = zeros(size(X));

density = 300; % particle density in #/m^2. Since grid is 1x1, # of particles will be particle_density
deltaT = 0.02;

ant_length = 0.008;
antenna_length = 0.004;
r_d = 0.002;
r_p = 0.012;
u_max = 0.13;
u_min = 0.02;
accl = 0.5;
turning_rate_p = 25*pi/9;
turning_rate_a = 50*pi/9;% ant parameters taken from paper

int_angle = pi/2;

% align_const = 0.02;
% shoaling_range = 5*deltaX;
% chemotaxis_coeff = 1;
% to be considered for later. (if take shoaling)

[ant_pos,orientation,orientation_vec,ant_vel] = gen_ants(u_min,density,'uniform',deltaX,0.5);

init_pos = ant_pos;
init_vel = ant_vel;

full_pos = ant_pos;

for t = 1:5000
    conc_matrix = update_pheromone_conc(conc_matrix,ant_pos,deltaX,deltaT,X,Y);
    [ant_pos, full_pos] = update_pos(full_pos,ant_pos,orientation,orientation_vec,ant_vel,deltaT);
    
    [collision_stimulus,orientation_vec,ant_vel,orientation] = ant_interaction(ant_pos,ant_vel,...
    orientation,orientation_vec,r_d,r_p,int_angle,deltaT,u_min,u_max,accl,turning_rate_a);
    
    [orientation_vec, orientation] = pheromone_stimulus(ant_pos,orientation,orientation_vec, ...
    ant_length,collision_stimulus,antenna_length,conc_matrix,turning_rate_p,deltaT,X,Y);

    if mod(t,1000) == 0
        [gradient_xx, gradient_xy] = gradient(reshape(full_pos(:,2),[41,41]), x, y);
        [gradient_yx, gradient_yy] = gradient(reshape(full_pos(:,1),[41,41]), x, y);

        eigenvalue_matrix = ones(size(X));

        for k = 1:size(full_pos,1)
            foo = [gradient_xx(k), gradient_xy(k); gradient_yx(k), gradient_yy(k)];
            eigenvalues = eig(foo'*foo);
            eigenvalue_matrix(k) = max(eigenvalues);
        end

        log_eigenvalues = log(eigenvalue_matrix);
        Z = log_eigenvalues/t;
        
        figure()
        surf(X,Y,Z);
        view([0 90]);
        axis tight;
        shading FLAT;
        colorbar
    end 
end
