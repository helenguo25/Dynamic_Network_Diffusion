%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1: Parameters which a for loop will cycle through %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% I only recommend changing NUM_TRIALS: the total number of simulations to run


NUM_TRIALS            =1;        %# of trials per parameter combination
activeedgeProb        = 0.1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2: Parameters for Network Dynamics and Infection Initiation %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

runPrefix   = 'Run';   


numHosts      = 100;     %# hosts/nodes in graph
numSteps      = 300;     %# of total steps in simulation
infectionStep = 1;     %step the infection will be introduced
num_neighbors = 5;
num_neighbors_keep = 3;

coreCriteria  = 2;       %Where do you want the infection introduced?
                         % 0 = Periphery Node
                         % 1 = Core Node
                         % 2 = Random Node

freezeStep   = 300;      %When to "freeze" dynamic network:
                         % - Dynamic Network: freezeStep > numSteps
                         % - Static Network:  freezeStep = infectionStep
                 
criteria     = 1;        %Centrality criteria:
                         % 0 = Random
                         % 1 = Degree
                         % 2 = Closeness
                         % 3 = Betweenness

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 3: Calling the Matlab Code %
%  Do not recommend changing!     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Determine the Network Type
if freezeStep >= numSteps
    networkType = 'Dynamic';
else
    networkType = 'Static';
end

% Network Centrality Choice
switch criteria
    case 0
        simulationType = 'Random';
    case 1
        simulationType = 'Degree';
    case 2
        simulationType = 'Closeness';
    case 3
        simulationType = 'Betweenness';
end    

%Injection Location Choice
switch coreCriteria
    case 0
        injectionLocation = 'Periphery';
    case 1
        injectionLocation = 'Core';
    case 2
        injectionLocation = 'Random';
    end
    
% Open file that contains the parameter values for each run
filePrefix = ['SpreadResults/Network_',networkType,'_InjectionSite_',injectionLocation,'_Centrality_',simulationType];
trialInfo = [filePrefix,'__runInfo.txt'];
FID = fopen(trialInfo,'a+');
Matrix_Infected_File = sprintf('%s_MatrixInfected.txt',filePrefix);
Matrix_Infected = fopen(Matrix_Infected_File,'w');

           MATRIX_NUMBER_INFECTED = [];
            for n = 1:NUM_TRIALS
               
                RS1 = randi(2^32);
                RS2 = randi(2^32);
                
                outputPrefix = sprintf('%s_%s_%04d',filePrefix,runPrefix,n);
                MATRIX_NUMBER_INFECTED(n,:) = simplifiedSpreadingModel2(numHosts,numSteps,...
                infectionStep,freezeStep,criteria,...
                coreCriteria,RS1,RS2,outputPrefix, ...
                 num_neighbors, num_neighbors_keep, activeedgeProb);
               
            end
            TimeToFifty=zeros(1,NUM_TRIALS);
            for i = 1:NUM_TRIALS
                I=find(MATRIX_NUMBER_INFECTED(i,:)==50);
                if isempty(I)
                    TimeToFifty(i)=-1;
                else  
                    TimeToFifty(i)=I(1);
                end
            end
fprintf(Matrix_Infected, ' %i', MATRIX_NUMBER_INFECTED');
       
fclose(FID);
fclose(Matrix_Infected);


