%%

addpath('./MIT_Code')

data0 = load('/Users/suzannesindi/Dropbox/PROJECTS/MBI_WORKSHOP/WAMB2017_Ectoparasites/data/default/iterate0_adjMatrix');
data50 = load('/Users/suzannesindi/Dropbox/PROJECTS/MBI_WORKSHOP/WAMB2017_Ectoparasites/data/default/iterate50_adjMatrix');
data100 = load('/Users/suzannesindi/Dropbox/PROJECTS/MBI_WORKSHOP/WAMB2017_Ectoparasites/data/default/iterate100_adjMatrix');

undirected_data0  = data0;
undirected_data50 = data50; 
undirected_data100 = data100;

for i = 1:50
    for j = 1:50
        if(data0(i,j) == 1)
            undirected_data0(j,i) = 1;
            undirected_data0(i,j) = 1;
        end
        
        if(data50(i,j) == 1)
            undirected_data50(j,i) = 1;
            undirected_data50(i,j) = 1;
        end
        
        if(data100(i,j) == 1)
            undirected_data100(j,i) = 1;
            undirected_data100(i,j) = 1;
        end
        
    end
end

%%
%PROCESS data0

%Compute Node/Graph Degree (in/out)
[INITIAL_DEG, INITIAL_NODE_DEGREE,INITIAL_OUT_DEGREE] = computeDegrees(data0)
INITIAL_GRAPH_DEGREE                                  = mbiGraphDegree(INITIAL_NODE_DEGREE)

%Compte Node/Graph Closeness
INITIAL_NODE_CLOSENESS  = mbiCloseness(undirected_data0)
INITIAL_GRAPH_CLOSENESS = mbiGraphCloseness(INITIAL_NODE_CLOSENESS)

%Compute Node/Graph Betweenness
INITIAL_NODE_BETWEENNESS  = node_betweenness_faster(undirected_data0)
INITIAL_GRAPH_BETWEENNESS = mbiGraphBetweenness(INITIAL_NODE_BETWEENNESS)

%%
%PROCESS data50

%Compute Node/Graph Degree (in/out)
[INITIAL_DEG, INITIAL_NODE_DEGREE,INITIAL_OUT_DEGREE] = computeDegrees(data50);
INITIAL_GRAPH_DEGREE                                  = mbiGraphDegree(INITIAL_NODE_DEGREE)

%Compte Node/Graph Closeness
INITIAL_NODE_CLOSENESS  = mbiCloseness(undirected_data50);
INITIAL_GRAPH_CLOSENESS = mbiGraphCloseness(INITIAL_NODE_CLOSENESS)

%Compute Node/Graph Betweenness
INITIAL_NODE_BETWEENNESS  = node_betweenness_faster(undirected_data50);
INITIAL_GRAPH_BETWEENNESS = mbiGraphBetweenness(INITIAL_NODE_BETWEENNESS)

%%
%PROCESS data100

%Compute Node/Graph Degree (in/out)
[INITIAL_DEG, INITIAL_NODE_DEGREE,INITIAL_OUT_DEGREE] = computeDegrees(data100);
INITIAL_GRAPH_DEGREE                                  = mbiGraphDegree(INITIAL_NODE_DEGREE)

%Compte Node/Graph Closeness
INITIAL_NODE_CLOSENESS  = mbiCloseness(undirected_data100);
INITIAL_GRAPH_CLOSENESS = mbiGraphCloseness(INITIAL_NODE_CLOSENESS)

%Compute Node/Graph Betweenness
INITIAL_NODE_BETWEENNESS  = node_betweenness_faster(undirected_data100);
INITIAL_GRAPH_BETWEENNESS = mbiGraphBetweenness(INITIAL_NODE_BETWEENNESS)