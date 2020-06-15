%%function connected = isConnected(adj)
%Goal:   Return 1 if the graph is connected and 0 if the graph is not.
%Inputs: Adjacency graph
function connected = mbiIsConnected(adj)

    checkForInfty = 0;
    for i = 1:length(adj)
        checkForInfty = checkForInfty + isinf(sum( simple_dijkstra(adj,i)));
    end
    
    if(checkForInfty>0)
        connected = 0;
    else
        connected = 1;
    end
end