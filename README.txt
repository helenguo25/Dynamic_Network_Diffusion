Last Modified by: Helen Guo
Date: May 18, 2929

This README file documents the Infection Simulations. It contains two 
sections:

Section 1: How to Run the Infection Model
Section 2: Documentation of the Output Files Produced

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Section 1: How to Run the Infection Model %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

There are two *M files associated with the infection model. 

- simplifiedDriver.m
- simplifiedInfectionModel.m

For simplicity, to run the code you need only change parameters in 
Part 1 and Part 2 of the "simplifiedDriver.m" script. 

If you take a closer look, you will find you can run any number of combinations
of parameters, centrality metrics, etc. 

When this script is run, output will automatically be generated in the directory

Automatically a prefix will be generated for the simulation(s) which will 
be of the form:

Network_Static_InjectionSite_Random_Centrality_Closeness_Run_0001_<outputName>.txt

All simulations with the same 3 major criteria:

- Network: Static or Dynamic
- Injection Site: Periphery, Core, Random
- Centrality: Random, Degree, Closeness, Betweenness

Will be indexed as different runs (i.e., Run_0001, Run_0002) and listed in
an info file:

Network_Static_InjectionSite_Random_Centrality_Closeness__runInfo.txt


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Section 2: Documentation of the Output Files Produced %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Here is a short description of each of the different output files:

- adjacency.txt            %Adjacency Matrix
- command.txt              %Exact Matlab Command Ran
- debug.txt                %Debugging information
- graph.txt                %Graph Centrality Metrics/Infection Load
- nodeBetweenness.txt      %Betweeness Metric for each node
- nodeCloseness.txt        %Closeness Metric for each node
- nodeDegree.txt           %Degree Metric for each node
- nodeInfection.txt        %Infection Level for each node


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Adjacenty Matrix
OutputFile: <filePrefix>.adjacency.txt

Description: We have stored a compressed format of the adjacency matrix
             at each time in the simulation. The first entry of each line
             is the iterate. The neighbors of each host are given as
             comma separated values. (The first 5 belong to host 1, the
             second 5 values are neighbors of host 2, etc.)

Line Format: Time N1,N2,N3,N4,N5 M1,M2,M3,M4,M5 ... 
    
Time           = Iterate of the simulation
N1,N2,N3,N4,N5 = the neighbors of node 1
M1,M2,M3,M4,M5 = the neighbors of node 2
etc..


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
Command that Generated the output associated with these files.
Output File: <filePrefix>command.txt

Description: This is a human readable file that contains all the 
             parameters that defined this simulation as well as the 
             seeds for the random numbers. 
             
             Each file also contains **THE EXACT MATLAB COMMAND** that was
             run so if you ever want to duplicate a simulation you can.
             
             
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Debug File
Output File: <filePrefix>debug.txt

Description: Currently this file should be empty. It was created as a
             file so that - when the code was being debugged - we had 
             a place to sent output we wanted to look at later. 
             
             If at any point there are quantities you want to monitor in
             from the simulation, but do not want to make a new output 
             file; this would be a good place to send such info.
             
             
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Graph Centrality Metrics and Infection Load
Output File: <filePrefix>graph.txt

Description: This file lists (for each time) all the graph level centrality 
             metrics and the total infection burden.
             
Format: Time GRAPH_BETWEENNESS GRAPH_CLOSENESS GRAPH_DEGREE NODE_INFECTION





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Betweenness Metric for Every Node
Output File: <filePrefix>nodeBetweenness.txt

Description: This file lists (for each time) the betweenness metric for
             each node/host.
             
Format: Time B1 B2 B3 ...
    
Time = currentIterate
Bi   = betweenness metric for node i.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Closeness Metric for Every Node
Output File: <filePrefix>nodeCloseness.txt

Description: This file lists (for each time) the closeness metric for
             each node/host.
             
Format: Time C1 C2 C3 ...
    
Time = currentIterate
Ci   = betweenness metric for node i.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Degree Metric for Every Node
Output File: <filePrefix>nodeDegree.txt

Description: This file lists (for each time) the degree metric for
             each node/host.
             
Format: Time D1 D2 D3 ...
    
Time = currentIterate
Di   = betweenness metric for node i.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Infection Load (Level) for Every Node
Output File: <filePrefix>nodeInfection.txt

Description: This file lists (for each time) the infection level for
             each node/host.
             
Format: Time P1 P2 P3 ...
    
Time = currentIterate
Pi   = betweenness metric for node i.

