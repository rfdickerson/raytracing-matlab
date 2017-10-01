function [hits, distance, intersection, normals] = sphere_collision(viewOrigin, ...
                                                                    viewDirection, ...
                                                                    sphereCenter, ...
                                                                    sphereRadius)
%SPHERE Summary of this function goes here
%   Detailed explanation goes here

nPixels = size(viewDirection, 1);

sphereCenter = repmat(sphereCenter, nPixels, 1);

%a = ones(nPixels, 1, 'single'); 
a = dot(viewDirection, viewDirection, 2);

b = 2 * dot(viewDirection, (viewOrigin - sphereCenter),2);

c = sum((viewOrigin - sphereCenter).^2,2) - sphereRadius^2;

discriminant = b.^2 - 4 .* a .* c;

hits = discriminant > 0;

distance_a = (-b - sqrt(complex(discriminant)))./(2.*a);
distance_b = (-b + sqrt(complex(discriminant)))./(2.*a);
distance = min([distance_a distance_b],[],2);
distance(hits==0) = NaN;

hits(distance<0) = false;

intersection = viewOrigin + viewDirection .* distance;

normals = normalize(intersection - sphereCenter);
end

