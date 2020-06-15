Last Modified by: Suzanne S. Sindi
Date: Sept 8, 2018

This README file documents the Parasite Simulations. It contains two 
sections:

Section 1: How to Run the Parasite Model
Section 2: Documentation of the Output Files Produced

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Section 1: How to Run the Parasite Model %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

There are two *M files associated with the parasite model. 

- simplifiedDriver.m
- simplifiedParasiteModel.m

There are several dependencies these codes have and all of them are
(together with these files) in our shared dropbox:

WAMB2017_Ectoparasites/Papers/SimulationPaper2/MatlabCode

For simplicity, to run the code you need only change parameters in 
Part 1 and Part 2 of the "simplifiedDriver.m" script. 

If you take a closer look, you will find you can run any number of combinations
of parameters, centrality metrics, etc. 

When this script is run, output will automatically be generated in 

WAMB2017_Ectoparasites/Papers/SimulationPaper2/MatlabResults

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

This info file will allow you to map the Run number to value for:

%cat Network_Static_InjectionSite_Random_Centrality_Closeness__runInfo.txt
0001 	 1.010000 	 0.004000 	 1.000000 

0001     = Run Number
1.010000 = Parasite Reproduction Rate
0.004000 = Grooming Efficiency
1.000000 = Spread (should keep this at 1).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Section 2: Documentation of the Output Files Produced %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Here is a short description of each of the different output files:

- adjacency.txt            %Adjacency Matrix
- actualTransfer.txt       %Actual Parasite Transfer
- attemptedTransfer.txt    %Attempted Parasite Transfer
- command.txt              %Exact Matlab Command Ran
- debug.txt                %Debugging information
- graph.txt                %Graph Centrality Metrics/Parasite Load
- nodeBetweenness.txt      %Betweeness Metric for each node
- nodeCloseness.txt        %Closeness Metric for each node
- nodeDegree.txt           %Degree Metric for each node
- nodeParasites.txt        %Parasite Level for each node


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
Actual Transfers of Parasites to Hosts
Output File: <filePrefix>.actualTransfer.txt

Description: Hosts might gain parasites from their neighbors. But the
             transfer of parasites is only possible if the host is not
             fully saturated with parasites. This file records which 
             hosts *did* receive parasites from neighbors and how much.

Format: Time N1 N2 N3 ...
    
Ni > 0 if host i did receive Ni parasites from neighbors.
             
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Attempted Transfers
Output File: <filePrefix>attemptedTransfer.txt

Description: This file is the counterpart to the previous file (actual
             transfers). This file lists the total amount of parasites
             that were *ATTEMPTED* to be transfered to each host at each
             time. Note that hosts have a maximum saturation level of
             parasites. This is why attempted and actual values may differ.
             
Format: Time N1 N2 N3 ...
    
Ni > 0 if there was an attempt to transver Ni parasites to host i. 

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
Graph Centrality Metrics and Parasite Load
Output File: <filePrefix>graph.txt

Description: This file lists (for each time) all the graph level centrality 
             metrics and the total parasite burden (sum of the parasite
             load over all loads in the network).
             
Format: Time GRAPH_BETWEENNESS GRAPH_CLOSENESS GRAPH_DEGREE PARASITE_BURDEN

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
Parasite Load (Level) for Every Node
Output File: <filePrefix>nodeParasites.txt

Description: This file lists (for each time) the parasite level for
             each node/host.
             
Format: Time P1 P2 P3 ...
    
Time = currentIterate
Pi   = betweenness metric for node i.

