%% Parasite Load Over time
figure
PARASITE_LOAD_HEATMAP = bar3(PARASITE_LOAD_HISTORY(:,INFECTION_STEP:end));
for k = 1:length(PARASITE_LOAD_HEATMAP)
    zdata = get(PARASITE_LOAD_HEATMAP(k),'ZData');
    set(PARASITE_LOAD_HEATMAP(k),'CData',zdata)
end
view(2)
title('Parasite Load Heat Map')
ylabel('Node')
xlabel('Iteration (time)')
ylim([0 NUM_HOSTS])