function [superVectors] = supersample()
%SUPERSAMPLE Summary of this function goes here
%   Detailed explanation goes here

rng('shuffle')

size=3;
scale = 1/size;

nPixels = size*size;

x = linspace(0, 1, size); 
y = linspace(0, 1, size);

rx = scale * (-1+2*rand(size));
ry = scale * (-1+2*rand(size));

[X,Y] = meshgrid(x,y);


RX = X + rx;
RY = Y + ry;

scatter(reshape(RX,nPixels,1), reshape(RY,nPixels,1),'filled');

%offsets = [reshape(X, nPixels, 1) reshape(Y, nPixels, 1) ones(nPixels,1)];
  
%superVectors = offsets + vectors;
end

