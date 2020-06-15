%Compute the Graph Closeness based on closeness for the nodes;
%Note: Should really make a single function where we do this for nodes and
%      edges. 
function graphCloseness = mbiGraphCloseness(CLOSENESS)
    N = length(CLOSENESS);
    graphCloseness = sum(CLOSENESS)/((N-1)*(N-2));
end