function [colors, distance, normals] = raytrace(view_origin, view_direction, spheres, depth)

numpixels = size(view_direction,1);

light_origin = [-3, -3, -2];
specularity = 120;
ks = 1.0;
kd = 0.9;
ka = 0.0;
reflectivity = 0.05;
eps = 0.001;

% diffuse_color = [0, 0.3, 0.8];
spec_color = [0.7, 0.7, 0.95];
ambient_color = [1.0, 1.0, 1.0];

num_spheres = size(spheres, 1);

normals_array = zeros(numpixels, 3, num_spheres, 'single');
color_array = ones(numpixels, 3, num_spheres, 'single');
distance_array = zeros(numpixels, num_spheres, 'single');

for i = 1:num_spheres
    
    sphere_center = spheres(i, 1:3);
    sphere_color = spheres(i, 4:6);
    sphere_radius = spheres(i, 7);

    [hits, distance, intersection, normals] = sphere(view_origin, ...
                                               view_direction, ...
                                               sphere_center, ...
                                               sphere_radius);
                                        
    i2 = intersection + eps*normals;
    
    light_direction = light_origin - i2;
    light_direction = normalize(light_direction);
    
    occlusion = false(numpixels, 1);
    % compute the shadow rays 
    for j = 1:num_spheres
        if i==j
            continue
        end
        shadowSphereOrigin = spheres(j, 1:3);
        shadowSphereRadius = spheres(j, 7);
        [hits, ~, ~, ~] = sphere(i2, ...
                                       light_direction, ...
                                       shadowSphereOrigin, ...
                                       shadowSphereRadius);
        occlusion = occlusion | hits;
    end
                                   
    view_direction_2 = normalize(view_origin - intersection);

    r = 2 * dot(light_direction, normals, 2) .* normals - light_direction;
    r = normalize(r);
     
    reflect_color = [0, 0, 0];
    if depth < 1
        [reflect_color, ~, ~]  = raytrace(i2, -r, spheres, depth+1);
    end
    
    specular_intensity = max(0, dot(r, view_direction_2, 2)) .^ specularity;
    diffuse_intensity = max(0, dot(normals, light_direction, 2));

    color = ks * specular_intensity * spec_color ...
          + kd * diffuse_intensity * sphere_color ...
          + reflectivity * reflect_color;
    
    color(occlusion,:) = 0.0;
      
    color_array(:,:,i) = color;
    normals_array(:,:,i) = normals;
    distance_array(:,i) = distance;
     
end

[Y, I] = min(distance_array,[],2);

color_array(sub2ind(size(color_array), 1:length(I), ones(length(I)), I'))

colors = color_array(:,:,distance_index);
%colors = zeros(numpixels, 3, 'single');
%for j = 1:numpixels
%    colors(j,:) = color_array(distance_index(j),j,:);
%end


%colors = color_array(i,:,:);


end