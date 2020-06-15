clear; close all;
%% visualizeNetworks.m
% This script reads in the connectivity ('..._adjacency.txt') and
% node infection matrix ('..._nodeInfection.txt') files. Change file names for
% adjData and infectionData.
%
% Networks are plotted with node colors to represent infections at each
% time step. The node sizes represent the degree (in-degree + out-degree)
% of each node.
%HZB 9-8-2018

%% Load in adjacency and infection data txt file 
adjData=load('SpreadResults/Network_Dynamic_InjectionSite_Random_Centrality_Betweenness_Run_0001_adjacency.txt');
infectionData=load('SpreadResults/Network_Dynamic_InjectionSite_Random_Centrality_Betweenness_Run_0001_nodeInfection.txt');
activeData=load('SpreadResults/Network_Dynamic_InjectionSite_Random_Centrality_Betweenness_Run_0001_active.txt');
%% Setup
%remove the first column which contains the time
%(since the row encodes the time data anyway)
adjData = adjData(:,2:end);
infectionData = infectionData(:,1:end);
activeData = activeData(:,2:end);

firstTime=1; %where to start showing video
maxTime=length(adjData(:,1)); %number of time steps
N=100; %number of nodes
k=5; %number grooming connections
stepSize=10; %so we don't need to see all of them..

%put adjacency data into cells; edges{i,j} contains the 
%edges for node j at time i
edges=mat2cell(adjData,1*ones(maxTime,1),k*ones(1,N));


h = figure;
filename = 'infectionAnimated2.gif'; %uncomment to save gif with this filename
%% Create and plot network
vid1 = VideoWriter('network.mp4', 'MPEG-4');
open(vid1);
for i=firstTime:stepSize:102
    clear G
    G=digraph;
    G=addnode(G,N);
    
    %add edges to build graph
    for j=1:N
        G=addedge(G,j*ones(1,k),edges{i,j});
    end
    
    degree=indegree(G)+outdegree(G); %calculate total degree of each node
   
    p=plot(G); %make network plot
    p.NodeCData = infectionData(i,:); %color nodes to 
    p.EdgeCData = activeData(i,:);
    p.MarkerSize = degree; %make size of nodes proportional to degree
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); %make figure very big
    title(['\fontsize{20}t=',num2str(i)]);
    myColorMap = jet(256);
    myColorMap(1,:) = .8; %nodes that are uninfected are gray
    colormap(myColorMap);
    colorbar
    caxis([0 max(max(infectionData))])
    drawnow

   
%     % Capture the plot as an image (if want to save)
%       frame = getframe(h); 
%       im = frame2im(frame); 
%       [imind,cm] = rgb2ind(im,256); 
%       % Write to the GIF File 
%       if i == firstTime 
%           imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
%       else 
%           imwrite(imind,cm,filename,'gif','WriteMode','append'); 
%       end 
currFrame = getframe(h);
writeVideo(vid1,currFrame);
end
close(vid1)
    
