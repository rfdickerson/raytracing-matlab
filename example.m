width = 1024;
height = 1024;

%width = 2048;
%height = 2048;

rng('shuffle')

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

nSamples = 9;

view_origin = repmat(view_origin, numpixels, 1);
view_direction = [reshape(X, numpixels, 1) reshape(Y, numpixels, 1) ones(numpixels,1)]; 

view_direction = single(view_direction);

v = zeros(numpixels, 3, nSamples);

samples = supersample(3);

tic
for i = 1:nSamples
    perturbedDirection = view_direction + 0.01 * samples(i);
    [colors, ~, ~] = raytrace (view_origin, perturbedDirection, spheres, 0);
    v(:, :, i) = colors;
end
toc
   
finalImage = mean(v, 3);

finalImage = reshape(finalImage, width, height, 3);

image(finalImage);
pbaspect([1 1 1]);

%imwrite(image2, 'sphere.png');
