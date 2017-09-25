function [ nv ] = normalize( v )
%NORMALIZE Summary of this function goes here
%   Detailed explanation goes here
nv = v ./ sqrt(sum(v.^2,2));

end

