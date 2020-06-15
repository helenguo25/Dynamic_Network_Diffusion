%% Plot parasite load for one run
% This is just a sanity check
parasiteDataD=load('../MatlabResults/Network_Dynamic_InjectionSite_Random_Centrality_Degree_Run_0001_nodeParasites.txt');
parasitesD = parasiteDataD(:,2:end); % delete first column containing time step
TotalDegreeParasite = sum(parasitesD,2); %sum over all nodes

parasiteDataB=load('../MatlabResults/Network_Dynamic_InjectionSite_Random_Centrality_Betweenness_Run_0001_nodeParasites.txt');
parasitesB = parasiteDataB(:,2:end); 
TotalBetweenParasite = sum(parasitesB,2); 

parasiteDataC=load('../MatlabResults/Network_Dynamic_InjectionSite_Random_Centrality_Closeness_Run_0002_nodeParasites.txt');
parasitesC = parasiteDataC(:,2:end); 
TotalClosenessParasite = sum(parasitesC,2); 

parasiteDataR=load('../MatlabResults/Network_Dynamic_InjectionSite_Random_Centrality_Random_Run_0001_nodeParasites.txt');
parasitesR = parasiteDataR(:,2:end); 
TotalRandomParasite = sum(parasitesR,2); 

times = 1:1:length(TotalRandomParasite);
plot(times,TotalBetweenParasite,times,TotalClosenessParasite,...
    times,TotalDegreeParasite,times,TotalRandomParasite)
legend('Betweenness','Closeness','Degree','Random')
