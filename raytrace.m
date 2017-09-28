function [colors, distance, normals] = raytrace(view_origin, view_direction, spheres)

numpixels = size(view_direction,1);
view_origin = [0, 0, -1];

light_origin = [-1, -2, -2];
specularity = 120;
ks = 1.0;
kd = 0.9;
ka = 0.0;

% diffuse_color = [0, 0.3, 0.8];
spec_color = [0.7, 0.7, 0.95];
ambient_color = [1.0, 1.0, 1.0];

num_spheres = size(spheres, 1);

normals_array = zeros(num_spheres, numpixels, 3, 'single');
color_array = ones(num_spheres, numpixels, 3, 'single');
distance_array = zeros(num_spheres, numpixels, 'single');

for i = 1:num_spheres
    
    sphere_center = spheres(i, 1:3);
    sphere_color = spheres(i, 4:6);
    sphere_radius = spheres(i, 7);

    [intersection, distance, normals] = sphere(view_origin, ...
                                               view_direction, ...
                                               sphere_center, ...
                                               sphere_radius);
                                        
    light_direction = light_origin - intersection;
    light_direction = normalize(light_direction);

    view_direction_2 = normalize(view_origin - intersection);

    r = 2 * dot(light_direction, normals, 2) .* normals - light_direction;
    r = normalize(r);

    specular_intensity = max(0, dot(r, view_direction_2, 2)) .^ specularity;
    diffuse_intensity = max(0, dot(normals, light_direction, 2));

    color = ks * specular_intensity * spec_color ...
          + kd * diffuse_intensity * sphere_color ...
          + ka * ambient_color;
     
    color_array(i,:,:) = color;
    normals_array(i,:,:) = normals;
    distance_array(i,:) = distance;
    
    %image(reshape(color, 1024, 1024, 3));
    %pause
     
end

[distance, distance_index] = min(distance_array(:,:));

colors = zeros(numpixels, 3, 'single');
for j = 1:numpixels
    colors(j,:) = color_array(distance_index(j),j,:);
end

%colors = color_array(i,:,:);


end