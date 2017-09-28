function [intersection, distance, normals] = sphere(view_origin, ...
                                                    view_direction, ...
                                                    sphere_center, ...
                                                    sphere_radius)
%SPHERE Summary of this function goes here
%   Detailed explanation goes here

numpixels = size(view_direction, 1);

a = ones(numpixels,1, 'single'); % sum(view_direction.^2, 2);

b = 2 * view_direction * (view_origin - sphere_center)';

c = sum((view_origin - sphere_center).^2,2) - sphere_radius^2;

discriminant = b.^2 - 4 .* a .* c;

hits = discriminant > 0;

distance_a = (-b - sqrt(complex(discriminant)))./(2*a);
distance_b = (-b + sqrt(complex(discriminant)))./(2*a);
distance = min([distance_a distance_b],[],2);
%distance = distanceb;
distance(hits==0) = NaN;

intersection = view_origin + view_direction .* distance;

normals = intersection - sphere_center;
normals = normals ./ sqrt(sum(normals.^2,2));
end
