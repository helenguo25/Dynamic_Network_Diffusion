% Betweenness centrality measure: number of shortest paths running though a vertex 
% Compute for all vertices, using Dijkstra's algorithm, using 'number of shortest paths through a node' definition
% Note: Valid for a general (connected) graph.
% INPUTS: adjacency (distances) matrix (nxn)
% OUTPUTS: betweeness vector for all vertices (nx1)
% Other routines used: dijkstra.m
% GB, December 22, 2009

%Modified from MIT: node_betweenness_faster
function betw = mbiBetweenness(adj)

n = length(adj);
spaths=inf(n,n); %Shortest Paths
adjk = adj;

% calculate number of shortest paths
for k=1:n-1
  
  for i=1:n
    for j=1:n
      
      if adjk(i,j)>0; spaths(i,j)=min([spaths(i,j) adjk(i,j)]); end
    
    end
  end
  
  adjk=adjk*adj;
 
end
%spaths correctly contains the number of shortest paths from i to j.

betw = zeros(1,n);  
for i=1:n
    % Returns:    
    % dist = The vector of all distances form i to all nodes
    % P    = the actual paths starting an i and going to all other nodes
    [dist,P]=dijkstra(adj,i,[])
    
    for j=1:n
      
        if dist(j)<=1; continue; end   % either i=j or i,j are 1 edge apart
        betw(P{j}(2:dist(j))) = betw(P{j}(2:dist(j))) + 1; %spaths(i,j);
        
    end
end

betw=betw/nchoosek(n-1,2); %nchoosek(n,2);   % further normalize by the number of all node pairs