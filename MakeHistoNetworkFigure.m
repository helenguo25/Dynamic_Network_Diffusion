%% Script file to draw the "histogram-network" figure for Paper 2
% This script reads in the connectivity ('..._adjacency.txt') and
% parasite load ('..._nodeParasites.txt') files. Change file names for
% adjData and parasiteData.
%
% Networks are plotted with node colors to represent parasite load at each
% time step. This is irrelevant here, but is a vestige
% from the "visualizeNetworks.m" script that this was copied from.
% The node sizes represent the degree (in-degree + out-degree)
% of each node.
% ARAD 8-28-19

% used Betweenness_Run_0001 
% used Closeness_Run_0002
% used Degree_Run_0001
% used Random_Run_0001
adjData=load('../MatlabResults/Network_Dynamic_InjectionSite_Random_Centrality_Random_Run_0001_adjacency.txt');

%% Setup
%remove the first column which contains the time
%(since the row encodes the time data anyway)
adjData = adjData(:,2:end);

firstTime=150; %which time point to plot
N=50; %number of nodes
k=5; %number grooming connections

%put adjacency data into cells; edges{i,j} contains the 
%edges for node j at time i
edges=mat2cell(adjData(firstTime,:),1,k*ones(1,N));

%% Draw network
    G=digraph;
    G=addnode(G,N);
    
    %add edges to build graph
    for j=1:N
        G=addedge(G,j*ones(1,k),edges{j});
    end
    
    degree=indegree(G)+outdegree(G); %calculate total degree of each node
    
    p=plot(G,'EdgeColor','k','layout','force'); %make network plot
    p.NodeCData = degree; %color nodes to 
    p.MarkerSize = 3*degree.^(1/2); %make size of nodes proportional to degree
    p.NodeLabel = [];
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); %make figure very big
    set(gca,'XTick',[],'YTick',[])
    title('Edges selected randomly','fontsize',30,'interpreter','latex');
    myColorMap = jet(256);
    %myColorMap(1,:) = .8; %nodes that are uninfected are gray
    colormap(myColorMap);
    axis('square')
    colorbar
%% Draw histogram of degree
figure
h = histogram(degree,50);
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); %make figure very big
    set(gca,'fontsize',20,'fontname','Times')
title('Edges selected randomly','fontsize',30,'interpreter','latex');
    myColorMap = jet(256);
    xlabel('Degree','fontsize',26,'interpreter','latex')
    ylabel('Number of nodes','fontsize',26,'interpreter','latex')