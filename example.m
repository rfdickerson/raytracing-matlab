width = 128;
height = 128;


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
    0.5,    0,      0.5;
    0, 2000, 0
    ];

colors = [
    140, 146, 172;
    140, 146, 172;
    140, 146, 172;
    140, 146, 172;
    140, 146, 172;
    140, 146, 172;
    140, 146, 172;
];

radii = [
    0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1999.5
    ];

spheres = [origins rgb2vec(colors) radii'];

% spheres = random_spheres(10);
 
spheres = single(spheres);

nSamples = 1;

view_origin = repmat(view_origin, numpixels, 1);
view_direction = [reshape(X, numpixels, 1) reshape(Y, numpixels, 1) ones(numpixels,1)]; 

view_direction = single(view_direction);

randDirections = [rand(numpixels, 2) zeros(numpixels, 1)];

view_direction = view_direction + (1/width * randDirections);
view_direction = normalize(view_direction);

% v = zeros(numpixels, 3, nSamples); 
% 
% samples = supersample(nSamples);
% 
% tic
% for i = 1:nSamples
%     perturbedDirection = view_direction + 2/width * (-0.5 + samples(i));
%     perturbedDirection = normalize(perturbedDirection);
%     [colors, ~, ~] = raytrace (view_origin, perturbedDirection, spheres, 0);
%     v(:, :, i) = colors;
% end
%toc

%finalImage = mean(v, 3);

tic
[colors, distance, normals] = raytrace(view_origin, view_direction, spheres, 0);
toc

distanceImage = reshape(distance, width, height, 1);
normalsImage = reshape(normals, width, height, 3);
finalImage = reshape(colors, width, height, 3);

finalImage = imgaussfilt(finalImage, 1);

image(finalImage);
pbaspect([1 1 1]);

imwrite(finalImage, 'sphere.png');
