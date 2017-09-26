function [colors, distance, normals] = raytrace(view_direction, spheres)

numpixels = size(view_direction,1);
view_origin = [0, 0, -1];
sphere_center = [0, 0, 1];
sphere_radius = 0.7;
light_origin = [-1, -2, -2];
specularity = 120;
ks = 0.9;
kd = 0.7;

diffuse_color = [0, 0.3, 0.8];
spec_color = [0.7, 0.7, 0.95];

[intersection, distance, normals] = sphere(view_origin, ...
                                           view_direction, ...
                                           sphere_center, ...
                                           sphere_radius);

light_direction = light_origin - intersection;
light_direction = light_direction ./ sqrt(sum(light_direction.^2,2));

view_direction = view_origin - intersection;
view_direction = view_direction ./ sqrt(sum(view_direction.^2,2));

r = 2*dot(light_direction, normals, 2) .* normals - light_direction;
r = r ./ sqrt(sum(r.^2,2));

specular_intensity = max(0, dot(r, view_direction, 2)) .^ specularity ;
diffuse_intensity = max(0, dot(normals, light_direction, 2));

colors = ks * specular_intensity * spec_color + kd * diffuse_intensity * diffuse_color;


end