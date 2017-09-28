width = 512;
height = 512;

view_origin = [0, -1, -2];

numpixels = width * height;

x = linspace(-1, 1, width); 
y = linspace(-1, 1, height);

[X,Y] = meshgrid(x,y);

origins = [
    0.0,    0,      1;
    1.0,    0,      1.5;
    -1.0,    0,      1.5;
    -1.0,    0,      3.0;
    ];

colors = [
    233, 30, 99;
    3, 169, 244;
    76, 175, 80;
    3, 169, 244;
];

radii = [
    0.5, 0.5, 0.5, 0.5
    ];

% store sphere information as origin, color, radius
% spheres = [
%         0.0,    0,      1,   0.78, 0.9531, 0.3906, 0.5;
%         1.0,    0,      1.5,  0.332, 0.3828, 0.4375, 0.5;
%        -1.0,    0,      1.5, 0.1094, 0.8008, 0.7656, 0.5;  
% ];

spheres = [origins rgb2vec(colors) radii'];

spheres = single(spheres);

view_origin = repmat(view_origin, numpixels, 1);
view_direction = [reshape(X, numpixels, 1) reshape(Y, numpixels, 1) ones(numpixels,1)]; 
view_direction = normalize(view_direction);
view_direction = single(view_direction);

tic
[colors, distance, normals] = raytrace(view_origin, view_direction, spheres, 0);
toc

image2 = reshape(colors, width, height, 3);

image(image2);
pbaspect([1 1 1]);

imwrite(image2, 'sphere.png');