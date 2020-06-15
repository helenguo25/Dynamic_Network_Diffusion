% Compute the total degree, in-degree and out-degree of a graph based on
% the adjacency matrix; should produce weighted degrees, if the input matrix is weighted
% INPUTS: adjacency matrix
% OUTPUTS: degree, indegree and outdegree sequences
% GB, Last Updated: October 2, 2009

function [deg,indeg,outdeg]=computeDegrees(adj)

indeg = sum(adj);
outdeg = sum(adj');

deg = indeg + outdeg; % total degree

end