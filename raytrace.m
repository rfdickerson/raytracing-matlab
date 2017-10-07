function [colors, distance, normals] = raytrace(view_origin, ...
                                                view_direction, ...
                                                spheres, ...
                                                depth)

numpixels = size(view_direction,1);

light_origin = [10, -10, -5];
specularity = 60;
ks = 0.6;
kd = 0.9;
ka = 0.00;
reflectivity = 0.1;
eps = 0.01;

% diffuse_color = [0, 0.3, 0.8];
spec_color = [0.7, 0.7, 0.95];
ambient_color = [1.0, 1.0, 1.0];

num_spheres = size(spheres, 1);

normals_array = zeros(numpixels, 3, num_spheres, 'single');
color_array = ones(numpixels, 3, num_spheres, 'single');
distance_array = zeros(numpixels, num_spheres, 'single');
occlusions = false(numpixels, num_spheres);

for i = 1:num_spheres
    
    sphere_center = spheres(i, 1:3);
    sphere_color = spheres(i, 4:6);
    sphere_radius = spheres(i, 7);

    [~, distance, intersection, normals] = sphere_collision(view_origin, ...
                                                            view_direction, ...
                                                            sphere_center, ...
                                                            sphere_radius);
                                        
    intersection = intersection + eps*normals;
    
    light_direction = light_origin - intersection;
    light_direction = normalize(light_direction);
    
    occlusion = false(numpixels, 1);
    
    % compute the shadow rays 
    for j = 1:num_spheres
        if i==j
            continue
        end
        shadowSphereOrigin = spheres(j, 1:3);
        shadowSphereRadius = spheres(j, 7);
        [shadowHits, ~, ~, ~] = sphere_collision(intersection, ...
                                                 light_direction, ...
                                                 shadowSphereOrigin, ...
                                                 shadowSphereRadius);
        occlusion = occlusion | shadowHits;
    end
    
    occlusions(:,i) = occlusion;
                                   
    view_direction_2 = normalize(view_origin - intersection);

    r = 2 * dot(light_direction, normals, 2) .* normals - light_direction;
    r = normalize(r);
     
    reflect_color = [0, 0, 0];
    if depth < 1
        [reflect_color, ~, ~]  = raytrace(intersection, r, spheres, depth+1);
    end
    
    specular_intensity = max(0, dot(r, view_direction_2, 2)) .^ specularity;
    diffuse_intensity = max(0, dot(normals, light_direction, 2));

    color = ks * specular_intensity * spec_color ...
          + kd * diffuse_intensity * sphere_color ...
          + reflectivity * reflect_color ...
          + ka * ambient_color;
   
    color_array(:,:,i) = color;
    normals_array(:,:,i) = normals;
    distance_array(:,i) = distance;
     
end

[~, I] = min(distance_array,[],2);

red = color_array(sub2ind(size(color_array), 1:length(I), ones(length(I),1)', I'));
green = color_array(sub2ind(size(color_array), 1:length(I), 2*ones(length(I),1)', I'));
blue = color_array(sub2ind(size(color_array), 1:length(I), 3*ones(length(I),1)', I'));

occlusions = occlusions(sub2ind(size(occlusions), 1:length(I), I'));
%occlusions = occlusions(I);
%occlusions = occlusions(:,3);

colors = [red' green' blue'];
colors(occlusions,:) = 0.0;


end