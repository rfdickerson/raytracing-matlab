function [colors, distance, normals] = raytrace(view_direction)

numpixels = size(view_direction,1);
view_origin = [0, 0, -1];
s_center = [0, 0, 1];
s_radius = 0.7;
light_origin = [-1, -2, -2];
specularity = 120;
ks = 0.9;
kd = 0.7;

diffuse_color = [0, 0.3, 0.8];
spec_color = [0.7, 0.7, 0.95];


a = ones(numpixels,1); % sum(view_direction.^2, 2);

b = 2 * view_direction * (view_origin - s_center)';

c = sum((view_origin - s_center).^2,2) - s_radius^2;

discriminant = b.^2 - 4 .* a .* c;

hits = discriminant > 0;

distancea = (-b - sqrt(complex(discriminant)))./(2*a);
distanceb = (-b + sqrt(complex(discriminant)))./(2*a);
distance = real(min(distancea, distanceb));
distance(hits==0) = NaN;


intersection = view_origin + view_direction .* distance;

normals = intersection - s_center;
normals = normals ./ sqrt(sum(normals.^2,2));

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