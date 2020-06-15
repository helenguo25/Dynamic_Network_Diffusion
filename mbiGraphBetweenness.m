%Compute the Graph Betweenness based on closeness for the nodes;
%Note: Should really make a single function where we do this for nodes and
%      edges. 
function graphBetweenness = mbiGraphBetweenness(BETWEENNESS)
    N = length(BETWEENNESS);
    graphBetweenness = sum(BETWEENNESS)/((N-1)*(N-2));
end