function simplifiedParasiteModel = simplifiedParasiteModel(numHosts,numSteps,...
    infectionStep,freezeStep,criteria,...
    parasiteReproductionProb,effectivenessOfGroomingProb,...
    spreadProb,coreCriteria,randomSeed1,randomSeed2,outputPrefix, ...
    num_neighbors, num_neighbors_keep)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Last Updated: 09/08/2018 to include adjacency file  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%function simplifiedParasiteModel(numHosts,numSteps,...
%    infectionStep,freezeStep,criteria,...
%    parasiteReproductionProb,effectivenessOfGrooming,...
%    spreadProb,randomSeed1,randomSeed2,outputPrefix)
% Inputs:
%   - numHosts: The number of individuals in the population
%   - numSteps: The total number of steps in the simulation
%   - infectionStep: The iteration to begin the random infection
%   - freezeStep: The iteration to FREEZE the dynamic network. 
%   - criteria: Which centrality measure to select edges based on
%               0 = Random, 1 = Degree, 2 = Closeness, 3 = Betweenness
%   - parasiteReproductionProb: 
%       parasitesNext = parasitesCurrent*parasiteReproductionProb
%   - effectivenessOfGroomingProb:
%       parasitesGroomed = parasitesCurrent*(1-q)^N;
%   - spreadProb
%        parasitesSpreadToGroomee = s; 
%   - coreCriteria:
%        0 = infect the periphery (i.e., the non KEEP of the network).
%        1 = infect the core (i.e., the top KEEP of the network.)
%   - randomSeed1: randomSeed for the network dynamics
%   - randomSeed2: randomSeed for the parasite dynamics
%   - outputPrefix: The prefix for all the output files.
%
% Outputs:
%   Note: All output files will begin with "outputPrefix_"
%   - command.txt: Inputs + RandomSeeds;
%   - node.txt:    All Centrality Measures, Plus Parasite Load;
%   - network.txt: All Centrality Measures, Plus Parasite Burden; 
%   - edge.txt:    Core->Core, Core->Per, Per->Core, Per->Per

% Note: This edge.txt plot will track the amount of parasites that
%       travel on each edge (not sure how I can check this)
%       For now we will leave this part blank.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Goal: Simulate a number of hosts evolving according to the           %
%       degree model. Do the indidence of parasites cause differences  %
%       in the underlying social structure?                            %
%                                                                      %                                                        
% Comments:                                                            %
% (1) Betweenness/Closeness are computed on the undirected graphs      %
%     We added a "copy" of edges as an undirected graph!               %
% (2) We are doing a different version of betweenness/closeness than   %
%     Nina or Matlab (2017). At some point we may want to consider a   %
%     different type of structure.                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%close all;
%clear;
warning('off','all')
addpath('./MIT_Code')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BEGIN PARAMETERS FOR THE MODEL TO MODIFY %
%    Change/Modify Values Here to Test     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Number of Hosts
NUM_HOSTS             = numHosts

%Number of Neighbors (Outgoing Edges)
NUM_NEIGHBORS         = num_neighbors;

%Number of Neighbors to Keep/Drop
NUM_NEIGHBORS_KEEP    = num_neighbors_keep;
NUM_NEIGHBORS_DROP    = NUM_NEIGHBORS-NUM_NEIGHBORS_KEEP;

%Criteria to Maximize:
% 0 == Random;
% 1 == Degree
% 2 == Closeness;
% 3 == Betweenness; 
CRITERIA = criteria;

if(~(CRITERIA==0 || CRITERIA==1 || CRITERIA == 2 || CRITERIA == 3))
    error('Criteria must be set to a valid choice: 0,1,2 or 3');
end

CORECRITERIA = coreCriteria;
if(~(CORECRITERIA==0 || CORECRITERIA==1 || CORECRITERIA==2))
    error('Core Criteria must be set to a valid choice: 0,1 or 2');
end

%Number of iterations (Steps) in the model
NUM_STEPS         = numSteps;

%Where Infection Begins in the model;
INFECTION_STEP    = infectionStep;

%The Step at which we will FREEZE the network dynamics
FREEZE_STEP       = freezeStep;

%If set to 1 will initialize with a cycle
DEBUG = 0;

%Seed/Set-up the randomStreams
%We want separate randomStreams for paraistes and nodes to decouple
%completey the dynamics/repeat if needed;
seedNetwork  = RandStream('mt19937ar','Seed',randomSeed1);
seedParasite = RandStream('mt19937ar','Seed',randomSeed2);

%Create Output File for Debuggind
debugFile = sprintf('%s_debug.txt',outputPrefix);
debugOut = fopen(debugFile,'w');

%Create Output Files:
docFile = sprintf('%s_command.txt',outputPrefix);
docOut  = fopen(docFile,'w');

adjFile = sprintf('%s_adjacency.txt',outputPrefix);
adjOut  = fopen(adjFile,'w');

nodeDegreeFile = sprintf('%s_nodeDegree.txt',outputPrefix);
nodeDegreeOut  = fopen(nodeDegreeFile,'w');

nodeClosenessFile = sprintf('%s_nodeCloseness.txt',outputPrefix);
nodeClosenessOut  = fopen(nodeClosenessFile,'w');

nodeBetweennessFile = sprintf('%s_nodeBetweenness.txt',outputPrefix);
nodeBetweennessOut  = fopen(nodeBetweennessFile,'w');

nodeParasiteFile = sprintf('%s_nodeParasites.txt',outputPrefix);
nodeParasiteOut  = fopen(nodeParasiteFile,'w');

graphFile = sprintf('%s_graph.txt',outputPrefix);
graphOut  = fopen(graphFile,'w');

attemptFile = sprintf('%s_attemptedTransfer.txt',outputPrefix);
attemptOut  = fopen(attemptFile,'w');

actualFile = sprintf('%s_actualTransfer.txt',outputPrefix);
actualOut  = fopen(actualFile,'w');

%Print the Command to the OutputFile:
fprintf(docOut,'%s\n',date);
fprintf(docOut, 'function simplifiedParasiteModel(numHosts,numSteps,infectionStep,freezestep,criteria,parasiteReproductionProb,effectivenessOfGroomingProb,spreadProb,coreCriteria,randomSeed1,randomSeed2,outputPrefix)\n');
fprintf(docOut, 'function simplifiedParasiteModel(%i,%i,%i,%i,%i,%.3f,%.3f,%.3f,%i,%i,%i,%s)\n',numHosts,numSteps,infectionStep,freezeStep,criteria,parasiteReproductionProb,effectivenessOfGroomingProb,spreadProb,coreCriteria,randomSeed1,randomSeed2,outputPrefix);
fprintf(docOut, '\n');

fprintf(docOut, 'Graph File: Iterate, Betweenness, Closeness, Degree, Parasite Burden (Alphabetical Order.\n');
fprintf(docOut, 'Node File : One file for each metric; Iterate, Node1(Metric), Node2(Metric). etc.\n');
fclose(docOut);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% END PARAMETERS FOR THE MODEL TO MODIFY %
%    Do not change values below here!    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step -1: Parasite Parameters %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

INITIAL_PARASITE_LOAD         = zeros(NUM_HOSTS,1); %individuals/node
INITIAL_PARASITE_BURDEN       = 0; %population
INITIAL_NUMBER_INFECTED       = 0;

PARASITES_EATEN               = zeros(NUM_HOSTS,1); %dummy holder
PARASITES_SPREAD              = zeros(NUM_HOSTS,1);

MAX_PARASITE_LOAD             = 1.0;
INITIAL_PARASITE_INFECTION    = .3*MAX_PARASITE_LOAD;

%Binomial Distribution Probabilities
p                             = parasiteReproductionProb;
q                             = effectivenessOfGroomingProb; %Fraction: 
s                             = spreadProb;
a                             = 0.2; %This is addFac from Nina's addFac = 0.2;


%Error Check:
if(p<0)
    error('Must have parasiteReproductionProb >= 0');
end

if(q<0 || q>1)
    error('Must have effectivenessOfGroomingProb between [0,1]');
end

if(s<0 || s>1)
    error('Must have spreadProb between [0,1]');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 0: Initial Set-Up %
%%%%%%%%%%%%%%%%%%%%%%%%%%

connected = 0;
numTrials = 1;
MAX_TRIALS = 10;

INITIAL_EDGES            = zeros(NUM_HOSTS,NUM_HOSTS);
INITIAL_UNDIRECTED_EDGES = zeros(NUM_HOSTS,NUM_HOSTS);

while ( connected == 0 && numTrials < MAX_TRIALS)

    %(a)Set up the directed edges;
    %Edges are from node i to node j
    if(DEBUG == 1)
        %Complete Graph
        %INITIAL_EDGES = ones(NUM_HOSTS,NUM_HOSTS);
        %INITIAL_EDGES = INITIAL_EDGES - eye(NUM_HOSTS);
        
        %Cycle:
        for i=1:(NUM_HOSTS-1)
            INITIAL_EDGES(i,i+1) = 1;
            INITIAL_UNDIRECTED_EDGES(i,i+1) = 1;
            INITIAL_UNDIRECTED_EDGES(i+1,i) = 1;
        end
        INITIAL_EDGES(NUM_HOSTS,1) = 1;
        INITIAL_UNDIRECTED_EDGES(NUM_HOSTS,1) = 1;
        INITIAL_UNDIRECTED_EDGES(1,NUM_HOSTS) = 1;
        
        %IMPORTANT TEST CASE: Parallel vertex did not have the same
        %                     betweenness.
        %INITIAL_EDGES(1,2) = 1; INITIAL_EDGES(2,3) = 1;
        %INITIAL_EDGES(3,4) = 1;
        %INITIAL_EDGES(4,5) = 1;
        %INITIAL_EDGES(5,1) = 1;
        %INITIAL_EDGES(1,6) = 1; INITIAL_EDGES(6,3) = 1;      
    else 
        for i = 1:NUM_HOSTS
            NEIGHBORS = randperm(seedNetwork,NUM_HOSTS-1,NUM_NEIGHBORS);
            for j = 1:length(NEIGHBORS)
                if(NEIGHBORS(j)<i)
                    INITIAL_EDGES(i,NEIGHBORS(j)) = 1;
                    INITIAL_UNDIRECTED_EDGES(i,NEIGHBORS(j)) = 1;
                    INITIAL_UNDIRECTED_EDGES(NEIGHBORS(j),i) = 1;
                else
                    INITIAL_EDGES(i,NEIGHBORS(j)+1) = 1;
                    INITIAL_UNDIRECTED_EDGES(i,NEIGHBORS(j)+1) = 1;
                    INITIAL_UNDIRECTED_EDGES(NEIGHBORS(j)+1,i) = 1;
                end
            end
        end
    end
    
    %(b) Check to make sure connected
    connected = mbiIsConnected(INITIAL_UNDIRECTED_EDGES);
    numTrials = numTrials+1;
end

if(numTrials>=MAX_TRIALS)
    error('Failed to Find a Connected Graph');
end

%Step (c): Compute Centrality Metrics

%Compute Node/Graph Degree (in/out)
[INITIAL_DEG, INITIAL_NODE_DEGREE,INITIAL_OUT_DEGREE] = degrees(INITIAL_EDGES);
INITIAL_GRAPH_DEGREE                                  = mbiGraphDegree(INITIAL_NODE_DEGREE);

%Compte Node/Graph Closeness
INITIAL_NODE_CLOSENESS  = mbiCloseness(INITIAL_UNDIRECTED_EDGES);
INITIAL_GRAPH_CLOSENESS = mbiGraphCloseness(INITIAL_NODE_CLOSENESS);

%Compute Node/Graph Betweenness
INITIAL_NODE_BETWEENNESS  = node_betweenness_faster(INITIAL_UNDIRECTED_EDGES);
INITIAL_GRAPH_BETWEENNESS = mbiGraphBetweenness(INITIAL_NODE_BETWEENNESS);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 1: Run the Host Model Iterations with All Metrics %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Store the Initial Computations on the Graph 
CURR_NODE_DEGREE          = INITIAL_NODE_DEGREE;
CURR_GRAPH_DEGREE         = INITIAL_GRAPH_DEGREE; 

CURR_NODE_CLOSENESS       = INITIAL_NODE_CLOSENESS;
CURR_GRAPH_CLOSENESS      = INITIAL_GRAPH_CLOSENESS;

CURR_NODE_BETWEENNESS     = INITIAL_NODE_BETWEENNESS;
CURR_GRAPH_BETWEENNESS    = INITIAL_GRAPH_BETWEENNESS;

CURRENT_EDGES             = INITIAL_EDGES;
CURRENT_UNDIRECTED_EDGES  = INITIAL_UNDIRECTED_EDGES;

%Store the Initial Computations on the Graph 
CURRENT_PARASITE_LOAD     = INITIAL_PARASITE_LOAD;
NEXT_PARASITE_LOAD        = INITIAL_PARASITE_LOAD;
PAST_PARASITE_LOAD        = INITIAL_PARASITE_LOAD;
CURRENT_PARASITE_BURDEN   = INITIAL_PARASITE_BURDEN;
CURRENT_NUMBER_INFECTED   = INITIAL_NUMBER_INFECTED;
probOfInfectionPerGroomee = INITIAL_PARASITE_LOAD;
GAINED_BY_GROOMING        = zeros(size(INITIAL_PARASITE_LOAD));
ACTUAL_GAINED_BY_GROOMING = zeros(size(INITIAL_PARASITE_LOAD));

%Helpers:
ONE_VEC = ones(size(CURRENT_PARASITE_LOAD));
GROOMING_REDUCTION = ONE_VEC;

%Begin the Iterations/Sampling;
%There are TWO phases to the iterations: 
%       Phase 1: Grooming; Phase 2: Network Resample
for iterate = 1:NUM_STEPS
    if mod(iterate,10) == 0
       iterate
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Phase 0: Store a Copy of the Current Configuration %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    NEXT_PARASITE_LOAD    = CURRENT_PARASITE_LOAD;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Phase 1: Parasites/Grooming %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (iterate>= INFECTION_STEP)
       infection_step = iterate;
       
       if(iterate == INFECTION_STEP)
           
           %RANDOM
           if(CRITERIA == 0)
               I         = randperm(seedParasite,NUM_HOSTS);
           %DEGREE
           elseif(CRITERIA == 1)
               [S,I]     = sort(CURR_NODE_DEGREE,'descend');
           %CLOSENESS
           elseif(CRITERIA == 2)
               [S,I]     = sort(CURR_NODE_CLOSENESS,'descend');
           %BETWEENNESS
           elseif(CRITERIA == 3)
               [S,I]     = sort(CURR_NODE_BETWEENNESS,'descend');
           end
           
           %(0) Periphery: Pick infection in the periphery
           if(CORECRITERIA == 0)
               patient0  = I(randi(seedParasite,[NUM_NEIGHBORS_KEEP+1,NUM_HOSTS]));
           %(1) Core: Pick infection in the core
           elseif(CORECRITERIA == 1)                 
               patient0  = I(randi(seedParasite,NUM_NEIGHBORS_KEEP));
           %(2) Random: Pick a Random host.
           elseif(CORECRITERIA == 2)
               patient0  = randi(seedParasite,NUM_HOSTS);
           end
           NEXT_PARASITE_LOAD(patient0) = INITIAL_PARASITE_INFECTION;
       else
           %Each individual updates their parasite load based on 
           % (1) reproduction on self.
           % (2) reductions of load by grooming + assignment of new
           %     infections to groomers
           
           %(1) Parasites on All Hosts Reproduce
           PAST_PARASITE_LOAD = CURRENT_PARASITE_LOAD;
           
           CURRENT_PARASITE_LOAD = CURRENT_PARASITE_LOAD*p; 
           CURRENT_PARASITE_LOAD = min(MAX_PARASITE_LOAD,CURRENT_PARASITE_LOAD);

           %(2) Grooming and Passing Parasites
           GAINED_BY_GROOMING = 0*GAINED_BY_GROOMING;
           GROOMING_REDUCTION = ONE_VEC;
           for i = 1:NUM_HOSTS
               %(A) Host Grooms Neighbors and May Acquire Parasites
               % Consider host i grooming host j.
               % - The probability that parasites transfer from node j to node i
               %   is: s * CURRENT_PARASITE_LOAD(j)/MAX_PARASITE_LOAD;
               %   This will happen for all of the nodes independently
               % - We need to consider the undirected connections 
               % - If node i gets parasites, it will begin with 10% of the average
               %   of all its neighbors.
               %DEBUG: CURRENT_EDGES(i,:);
               %DEBUG: PAST_PARASITE_LOAD';
               
               %DIRECTED TRANSMISSION
               %probOfInfectionPerGroomee = CURRENT_EDGES(i,:).*(s*PAST_PARASITE_LOAD'/MAX_PARASITE_LOAD);  %Everyone i grooms;
               %avgParasiteLoad = sum(CURRENT_EDGES(i,:).*PAST_PARASITE_LOAD')/sum(CURRENT_EDGES(i,:));
              
               %UNDIRECTED TRANSMISSION        
               %CURRENT_EDGES(i,:) + CURRENT_EDGES(:,i) = {0,1,2}
               %Val = 0 --> Return = 0
               %Val = 1 --> Return = s
               %Val = 2 --> Return = s + a;
               %We will do this through a quadratic value
               probOfInfectionPerGroomee = polyval([(a-s)/2,(3*s-a)/2,0],CURRENT_EDGES(i,:)+CURRENT_EDGES(:,i)').*(PAST_PARASITE_LOAD'/MAX_PARASITE_LOAD);
               avgParasiteLoad = sum(CURRENT_UNDIRECTED_EDGES(i,:).*PAST_PARASITE_LOAD')/sum(CURRENT_UNDIRECTED_EDGES(i,:));
               
               %Maryann: This captures the effect that the parasites that transmit
               %reflects the *babies* that were transmitted. 
               % Current Parasite Load = Adults + Babies *STAY ON HOST*
               % Transmitted Parasites = **Extra Babies** (only # of
               % adults)
               
               %Heather: Parasites can be transmitted either 
               %         Groomee to groomer or groomer to groomee.
               
               AMOUNT_OF_PARASITES_GAINED = 0;
               
               numSuccess = 0;
               for j = 1:NUM_HOSTS
                   if(CURRENT_EDGES(i,j)>0)
                       if(rand(seedParasite) < probOfInfectionPerGroomee(j))
                           numSuccess = numSuccess + 1;
                       end
                   end
               end
               if( numSuccess > 0 )
                   AMOUNT_OF_PARASITES_GAINED = .10*avgParasiteLoad;
                   GAINED_BY_GROOMING(i) = AMOUNT_OF_PARASITES_GAINED;
               end
                              
               %(B) Host is Groomed by Neighbors and Loses Parasites 
               numberOfGroomers = sum(CURRENT_EDGES(:,i)); %Everyone who grooms i;
               groomingReduction = (1-q)^numberOfGroomers;
               
               GROOMING_REDUCTION(i) = groomingReduction;
               
               %Final:
               NEXT_PARASITE_LOAD(i) = min(MAX_PARASITE_LOAD,CURRENT_PARASITE_LOAD(i)*groomingReduction + AMOUNT_OF_PARASITES_GAINED);
               
               m1 =  min(MAX_PARASITE_LOAD,CURRENT_PARASITE_LOAD(i)*groomingReduction);
               m2 =  NEXT_PARASITE_LOAD(i);
               
               %Attempting to look at if parasites were **ACTUALLY**
               %transfered to host i.
               ACTUAL_GAINED_BY_GROOMING(i) = m2 - m1;
               
           end
       end
       
                  
%         ORIGINAL_PARASITE_LOAD       =  CURRENT_PARASITE_LOAD;
%         AFTER_GROWTH_PARASITE_LOAD   =  ORIGINAL_PARASITE_LOAD*p;
%         AFTER_GROOMING_PARASITE_LOAD =  AFTER_GROWTH_PARASITE_LOAD.*GROOMING_REDUCTION;
%         FINAL_PARASITE_LOAD          =  AFTER_GROOMING_PARASITE_LOAD + GAINED_BY_GROOMING;
%         THRESHOLD_PARASITE_LOAD      =  min(MAX_PARASITE_LOAD,FINAL_PARASITE_LOAD);
%         
%         NEXT_PARASITE_LOAD_TEMP = THRESHOLD_PARASITE_LOAD;
%         
%         iterate
%         sum(abs(NEXT_PARASITE_LOAD_TEMP - NEXT_PARASITE_LOAD))
%         
%         fprintf(debugOut, '%i Original',iterate);
%         for h = 1:NUM_HOSTS
%             fprintf(debugOut,' %.10f',ORIGINAL_PARASITE_LOAD(h));
%         end
%         fprintf(debugOut,'\n');
%         
%         fprintf(debugOut, '%i AfterGrowth',iterate);
%         for h = 1:NUM_HOSTS
%             fprintf(debugOut,' %.10f',AFTER_GROWTH_PARASITE_LOAD(h));
%         end
%         fprintf(debugOut,'\n');
%         
%         fprintf(debugOut,'%i GroomingReduction',iterate);
%         for h = 1:NUM_HOSTS
%             fprintf(debugOut,' %.10f',GROOMING_REDUCTION(h));
%         end
%         fprintf(debugOut,'\n');
%         
%         fprintf(debugOut, '%i AfterBeingGroomed',iterate);
%         for h = 1:NUM_HOSTS
%             fprintf(debugOut,' %.10f',AFTER_GROOMING_PARASITE_LOAD(h));
%         end
%         fprintf(debugOut,'\n');
%         
%         fprintf(debugOut, '%i GainedByGrooming',iterate);
%         for h = 1:NUM_HOSTS
%             fprintf(debugOut,' %.10f',GAINED_BY_GROOMING(h));
%         end
%         fprintf(debugOut,'\n');
%         
%         fprintf(debugOut, '%i FinalParasiteLoad',iterate);
%         for h = 1:NUM_HOSTS
%             fprintf(debugOut,' %.10f',FINAL_PARASITE_LOAD(h));
%         end
%         fprintf(debugOut,'\n');
%         
%         fprintf(debugOut, '%i ThresholdParasiteLoad',iterate);
%         for h = 1:NUM_HOSTS
%             fprintf(debugOut,' %.10f',THRESHOLD_PARASITE_LOAD(h));
%         end
%         fprintf(debugOut,'\n');
                     
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Phase 2: Network Resampling %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    nextConnected = 0;
    numTrials = 1;
    MAX_TRIALS = 10;

    while ( nextConnected == 0 && numTrials < MAX_TRIALS)
        NEXT_EDGES            = CURRENT_EDGES;
        NEXT_UNDIRECTED_EDGES = CURRENT_UNDIRECTED_EDGES;
        
        if(iterate>=FREEZE_STEP)
            %Do nothing we have frozen the network resampling.
            freeze_iterate = iterate;
            freeze_iterate;
        else
        
            for i = 1:NUM_HOSTS
                %RANDOM
                if(CRITERIA == 0)
                    [S,I] = sort(CURRENT_EDGES(i,:).*rand(seedNetwork,1,NUM_HOSTS),'descend');
                %DEGREE
                elseif(CRITERIA == 1)
                    [S,I] = sort(CURRENT_EDGES(i,:).*CURR_NODE_DEGREE,'descend');
                %CLOSENESS
                elseif(CRITERIA == 2)
                    eps = .1;
                    [S,I] = sort(CURRENT_EDGES(i,:).*(CURR_NODE_CLOSENESS+eps*ones(size(CURR_NODE_CLOSENESS)) )','descend');
                    %[S,I] = sort(CURRENT_EDGES(i,:).*(CURR_NODE_CLOSENESS)','descend');

                %BETWEENNESS
                elseif(CRITERIA == 3)
                    eps = .1;
                    [S,I] = sort(CURRENT_EDGES(i,:).*(CURR_NODE_BETWEENNESS+eps*ones(size(CURR_NODE_BETWEENNESS)) ),'descend');
                    %[S,I] = sort(CURRENT_EDGES(i,:).*(CURR_NODE_BETWEENNESS),'descend');

                else
                    CRITERIA
                    exit('Should not be here. Invalid criteria value.'); 
                end
                                
                %SortNodes by Degree: 3 Categories
                %NUM_NEIGHBORS_KEEP = 3;
                %NUM_NEIGHBORS = 5;
                keepNodes   = I(1:NUM_NEIGHBORS_KEEP);
                deleteNodes = I(NUM_NEIGHBORS_KEEP+1:NUM_NEIGHBORS);
                sampleNodes = I(NUM_NEIGHBORS+1:NUM_HOSTS);
                
                %Delete the host itself so we do not get self edges.
                sampleNodes(sampleNodes==i)=[];
               
                %Determine New Neighbors:
                newIndex     = randperm(seedNetwork,length(sampleNodes),NUM_NEIGHBORS_DROP);
                newNeighbors = zeros(1,NUM_NEIGHBORS_DROP);
                for j = 1:NUM_NEIGHBORS_DROP
                    newNeighbors(j) = sampleNodes(newIndex(j));
                end

                %Drop Previous Neighbors and Add New Neighbors
                for j = 1:NUM_NEIGHBORS_DROP
                    if( NEXT_EDGES(i,deleteNodes(j)) == 1)
                        NEXT_EDGES(i,deleteNodes(j)) = 0;
                        NEXT_UNDIRECTED_EDGES(i,deleteNodes(j))  = 0;
                        NEXT_UNDIRECTED_EDGES(deleteNodes(j),i) = 0; 
                    else
                        deleteNodes(j)
                        exit('Error: Trying to Delete an Edge that is not there!');
                    end

                    if( NEXT_EDGES(i,newNeighbors(j)) == 0)
                        NEXT_EDGES(i,newNeighbors(j)) = 1;
                        NEXT_UNDIRECTED_EDGES(i,newNeighbors(j)) = 1;
                        NEXT_UNDIRECTED_EDGES(newNeighbors(j),i) = 1;
                    else
                        exit('Error: Trying to Add an Edge that already exists!');
                    end
                end        
            end
        end
        
        nextConnected = mbiIsConnected(NEXT_UNDIRECTED_EDGES);
%         if(nextConnected==0)
%             error('We disconnected the graph');
%         end
        numTrials = numTrials+1;

    end
    
    if(numTrials>3)
        numTrials
    end
    
    if(numTrials > MAX_TRIALS)
        exit('Error in Graph Iteration! Could not create connected graph w/in the maximum number of iterations!'); 
    end
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Phase 3: Store Configuration and Recompute and Store Metrics %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    CURRENT_EDGES            = NEXT_EDGES;
    CURRENT_UNDIRECTED_EDGES = NEXT_UNDIRECTED_EDGES;
    CURRENT_PARASITE_LOAD    = NEXT_PARASITE_LOAD;
   
    %Compute Node/Graph Degree (in/out)
    %CURRENT_EDGES -> Directed Graphs
    [DEG, CURR_NODE_DEGREE,OUT_DEGREE] = degrees(CURRENT_EDGES);
    CURR_GRAPH_DEGREE                  = mbiGraphDegree(CURR_NODE_DEGREE);

    %for p=1:NUM_HOSTS
    %    if(CURRENT_EDGES(p,p) == 1)
    %        CURRENT_EDGES(p,p)
    %        iterate
    %    end
    %end
    
    if(max(CURR_NODE_DEGREE)>=50)
        CURR_NODE_DEGREE
        
        CURRENT_EDGES
        
    end
    %for p=1:length(OUT_DEGREE)
    %   if(OUT_DEGREE(p)!=5)
    %       OUT_DEGREE(p)
    %   end
    %end
    
    %Compte Node/Graph Closeness
    CURR_NODE_CLOSENESS  = mbiCloseness(CURRENT_UNDIRECTED_EDGES);
    CURR_GRAPH_CLOSENESS = mbiGraphCloseness(CURR_NODE_CLOSENESS);

    %Compute Node/Graph Betweenness
    %Commenting out Betweenness because it was causing problems!
    CURR_NODE_BETWEENNESS  = node_betweenness_faster(CURRENT_UNDIRECTED_EDGES);
    CURR_GRAPH_BETWEENNESS = mbiGraphBetweenness(CURR_NODE_BETWEENNESS);
    
    CURRENT_PARASITE_BURDEN = sum(CURRENT_PARASITE_LOAD);
    CURRENT_NUMBER_INFECTED = sum(nnz(CURRENT_PARASITE_LOAD));
    
    %%%%%%%%%%%%%%%%
    % Print Output %
    %%%%%%%%%%%%%%%%

    %Print Graph Information:
    fprintf(graphOut,'%i',iterate);
    fprintf(graphOut,' %.10f %.10f %.10f %.10f',CURR_GRAPH_BETWEENNESS,CURR_GRAPH_CLOSENESS,CURR_GRAPH_DEGREE,CURRENT_PARASITE_BURDEN);
    fprintf(graphOut,'\n');
    
    %Print Edge Information:
    fprintf(attemptOut,'%i',iterate);
    fprintf(actualOut,'%i',iterate);
    
    %Print Node Information:
    fprintf(nodeDegreeOut, '%i',iterate);
    fprintf(nodeClosenessOut, '%i',iterate);
    fprintf(nodeBetweennessOut,'%i',iterate);
    fprintf(nodeParasiteOut, '%i',iterate);
    fprintf(adjOut, '%i', iterate);
    for i = 1:NUM_HOSTS
        fprintf(nodeDegreeOut, ' %i',CURR_NODE_DEGREE(i));
        fprintf(nodeClosenessOut, ' %.10f',CURR_NODE_CLOSENESS(i));
        fprintf(nodeBetweennessOut, ' %.10f',CURR_NODE_BETWEENNESS(i));
        fprintf(nodeParasiteOut,' %.10f',CURRENT_PARASITE_LOAD(i));
        fprintf(attemptOut,' %.10f',GAINED_BY_GROOMING(i));
        fprintf(actualOut,' %.10f',ACTUAL_GAINED_BY_GROOMING(i));
        fprintf(adjOut,' %s',vec2str(find(CURRENT_EDGES(i,:)),[],[],0));
    end
    fprintf(nodeDegreeOut,'\n');
    fprintf(nodeClosenessOut, '\n');
    fprintf(nodeBetweennessOut, '\n'); 
    fprintf(nodeParasiteOut,'\n');
    fprintf(attemptOut,'\n');
    fprintf(actualOut,'\n');
    fprintf(adjOut,'\n');
end

%%%%%%%%%%%%%%%%%%%%%%
% Close Output Files %
%%%%%%%%%%%%%%%%%%%%%%

fclose(nodeDegreeOut);
fclose(nodeClosenessOut);
fclose(nodeBetweennessOut);
fclose(nodeParasiteOut);
fclose(graphOut);
fclose(attemptOut);
fclose(actualOut);
fclose(adjOut);


end
