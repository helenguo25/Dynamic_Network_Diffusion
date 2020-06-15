clear; close all;
%% TestNetworks.m
% This script reads in the connectivity ('..._adjacency.txt') and
% parasite load ('..._nodeParasites.txt') files. Change file names for
% adjData and parasiteData.
%
% Networks are plotted with node colors to represent parasite load at each
% time step. The node sizes represent the degree (in-degree + out-degree)
% of each node.
%HZB 9-8-2018

%% Load in adjacency and parasite load data txt file 
adjData=load('../MatlabResults/Network_Dynamic_InjectionSite_Random_Centrality_Degree_Run_0003_adjacency.txt');
parasiteData=load('../MatlabResults/Network_Dynamic_InjectionSite_Random_Centrality_Degree_Run_0003_nodeParasites.txt');

%% Setup
%remove the first column which contains the time
%(since the row encodes the time data anyway)
adjData = adjData(:,2:end);
parasiteData = parasiteData(:,2:end);

firstTime=1; %where to start showing video
maxTime=length(adjData(:,1)); %number of time steps
N=100; %number of nodes
k=5; %number grooming connections
stepSize=50; %so we don't need to see all of them..

%put adjacency data into cells; edges{i,j} contains the 
%edges for node j at time i
edges=mat2cell(adjData,1*ones(maxTime,1),k*ones(1,N));

h = figure;
filename = 'parasitesAnimated2.gif'; %uncomment to save gif with this filename
%% Create and plot network

for i=firstTime:stepSize:285
    clear G
    G=digraph;
    G=addnode(G,N);
    
    %add edges to build graph
    for j=1:N
        G=addedge(G,j*ones(1,k),edges{i,j});
    end
    
    degree=indegree(G)+outdegree(G); %calculate total degree of each node
    
    p=plot(G,'EdgeColor','k'); %make network plot
    p.NodeCData = degree; %color nodes to 
    p.MarkerSize = degree; %make size of nodes proportional to degree
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); %make figure very big
    title(['\fontsize{20}t=',num2str(i)]);
    myColorMap = jet(256);
    myColorMap(1,:) = .8; %nodes that are uninfected are gray
    colormap(myColorMap);
    colorbar
    caxis([0 max(max(parasiteData))])
    drawnow
    
    % Capture the plot as an image (if want to save)
      frame = getframe(h); 
      im = frame2im(frame); 
      [imind,cm] = rgb2ind(im,256); 
      % Write to the GIF File 
      if i == firstTime 
          imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
      else 
          imwrite(imind,cm,filename,'gif','WriteMode','append'); 
      end 
    
end