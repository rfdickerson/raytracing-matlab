width = 1024;
height = 1024;

numpixels = width * height;

x = linspace(-1, 1, width); 
y = linspace(-1, 1, height);

[X,Y] = meshgrid(x,y);

% store sphere information as origin, color, radius
spheres = [
        0.0,    0,      1, 1, 0, 0, 0.5;
        1.0,    0,      1.5, 0, 1, 0, 0.5;
       -1.0,    0,      1, 0, 0, 1, 0.5;  
    
];

spheres = single(spheres);

view_origin = [0, 0, -1];
view_direction = [reshape(X, numpixels, 1) reshape(Y, numpixels, 1) ones(numpixels,1)]; 
view_direction = normalize(view_direction);
view_direction = single(view_direction);

tic
[colors, distance, normals] = raytrace(view_origin, view_direction, spheres);
toc

image2 = reshape(colors, width, height, 3);

image(image2);
pbaspect([1 1 1]);

imwrite(image2, 'sphere.png');