function [superVectors] = supersample(size)
%SUPERSAMPLE Summary of this function goes here
%   Detailed explanation goes here

%rng('shuffle')

scale = 1/size;

nPixels = size*size;

x = linspace(scale, 1-scale, size); 
y = linspace(scale, 1-scale, size);

rx = scale * (-1+2*rand(size));
ry = scale * (-1+2*rand(size));

[X,Y] = meshgrid(x,y);


RX = X + rx;
RY = Y + ry;

% scatter(reshape(RX,nPixels,1), reshape(RY,nPixels,1),'filled');

superVectors = [reshape(RX, nPixels, 1) reshape(RY, nPixels, 1) zeros(nPixels,1)];
  
end

