%Compute the Graph Degree based on all the in-degrees for the nodes;
%Note: Should really make a single function where we do this for nodes and
%      edges. 
function graphDegree = mbiGraphDegree(IN_DEGREES)

    avg = mean(IN_DEGREES);
    maxD = max(IN_DEGREES);
    N   = length(IN_DEGREES);
    %graphDegree = sum(avg*ones(size(IN_DEGREES)) - IN_DEGREES)/((N-1)*(N-2));
    graphDegree = sum(maxD*ones(size(IN_DEGREES)) - IN_DEGREES)/((N-1)*(N-2));

end