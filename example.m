width = 512;
height = 512;

%width = 2048;
%height = 2048;

view_origin = single([0, -1, -2]);

numpixels = width * height;

x = linspace(-1, 1, width); 
y = linspace(-1, 1, height);

[X,Y] = meshgrid(x,y);

origins = [
    0.5,    0,      2.5;
    0.0,    0,      1;
    1.0,    0,      1.5;
    -1.0,    0,      1.5;
    -0.5,    0,      2.5;
    ];

colors = [
    76, 175, 80;
    233, 30, 99;
    3, 169, 244;
    76, 175, 80;
    3, 169, 244;
];

radii = [
    0.5, 0.5, 0.5, 0.5, 0.5
    ];

spheres = [origins rgb2vec(colors) radii'];

% spheres = random_spheres(10);

spheres = single(spheres);

view_origin = repmat(view_origin, numpixels, 1);
view_direction = [reshape(X, numpixels, 1) reshape(Y, numpixels, 1) ones(numpixels,1)]; 
view_direction = normalize(view_direction);
view_direction = single(view_direction);

%view_direction = supersample(view_direction, 0.001);

% view_direction = gpuArray(view_direction);

tic
[colors, ~, ~] = raytrace(view_origin, view_direction, spheres, 0);
toc

image2 = reshape(colors, width, height, 3);

%gather(image2);

image(image2);
pbaspect([1 1 1]);

%imwrite(image2, 'sphere.png');
