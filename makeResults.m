GROWTH_RATE  = load('../../WAMB2017_Ectoparasites/SuzanneStuff/RESULTS/GROWTH_RATE');
GROOMING_EFF = load('../../WAMB2017_Ectoparasites/SuzanneStuff/RESULTS/GROOMING_EFFICIENCY');

randSeed1 = 32432;
randSeed2 = 234;

numHosts      = 50;
numSteps      = 500;
infectionStep = 250;
freezeStep    = 500;

for i = 1:length(GROWTH_RATE)
    for j = 1:length(GROOMING_EFF)
       PARASITE_GROWTH_RATE = GROWTH_RATE(i);
       ALLOGROOMING_EFFICIENCY = GROOMING_EFF(j);
       
       %Output Prefixes
       randomName = sprintf('../../WAMB2017_Ectoparasites/SuzanneStuff/RESULTS/randomDir/randomDynamic_%i_%i',i,j);
       degName = sprintf('../../WAMB2017_Ectoparasites/SuzanneStuff/RESULTS/degreeDir/degreeDynamic_%i_%i',i,j);
       closenessName = sprintf('../../WAMB2017_Ectoparasites/SuzanneStuff/RESULTS/closenessDir/closenessDynamic_%i_%i',i,j);
       betweennessName = sprintf('../../WAMB2017_Ectoparasites/SuzanneStuff/RESULTS/betweennessDir/betweennessDynamic_%i_%i',i,j);
       
       runParasiteHostModelRevisedWeekend(numHosts,numSteps,infectionStep,freezeStep,0,PARASITE_GROWTH_RATE,ALLOGROOMING_EFFICIENCY,randSeed1,randSeed2,randomName);
       runParasiteHostModelRevisedWeekend(numHosts,numSteps,infectionStep,freezeStep,1,PARASITE_GROWTH_RATE,ALLOGROOMING_EFFICIENCY,randSeed1,randSeed2,degName);
       runParasiteHostModelRevisedWeekend(numHosts,numSteps,infectionStep,freezeStep,2,PARASITE_GROWTH_RATE,ALLOGROOMING_EFFICIENCY,randSeed1,randSeed2,closenessName);
       runParasiteHostModelRevisedWeekend(numHosts,numSteps,infectionStep,freezeStep,3,PARASITE_GROWTH_RATE,ALLOGROOMING_EFFICIENCY,randSeed1,randSeed2,betweennessName);
        
    end
end