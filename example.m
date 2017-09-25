width = 1024;
height = 1024;

numpixels = width * height;

x = linspace(-1, 1, width);
y = linspace(-1, 1, height);

[X,Y] = meshgrid(x,y);

view_direction = [reshape(X, numpixels, 1) reshape(Y, numpixels, 1) ones(numpixels,1)]; 
view_direction = normalize(view_direction);

[colors, distance, normals] = raytrace(view_direction);

image2 = reshape(colors, width, height, 3);

image(image2); 

imwrite(image2, 'sphere.png');