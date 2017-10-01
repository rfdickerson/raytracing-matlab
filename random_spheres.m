function [spheres] = random_spheres(nSpheres)
%RANDOM_SPHERES Summary of this function goes here
%   Detailed explanation goes here
    green = [76, 175, 80];
    red = [233, 30, 99];
    blue = [3, 169, 244];
    
    colors = rgb2vec([green; red; blue]);
    
    radii = 0.2*ones(nSpheres,1);
    
    rng('shuffle')
    
    iColor = randi(3, nSpheres, 1)
    
    colors = colors(iColor, :);
    
    x = 7*(-0.5+rand(nSpheres,1));
    y = zeros(nSpheres,1);
    z = 2*(rand(nSpheres,1));
    
    origins = [x y z];
    
    disp(origins);
    
    spheres = [origins colors radii];
    
end

