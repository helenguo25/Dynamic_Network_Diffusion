%% Plots Degree Centrality Measures

% Set below to desired file path
% Later, we'll have to cycle through mutiple text files in
% appropriate folder to generate multiple figures.
% Also, we'll have to save the figures to appropriate file names.
GRAPH_DATA = load('./BLAH/test_graph.txt');


%% Set up properties of the figures
fontSize = 20;

fig1 = figure('Position',[100,100,1500,1000]);
set(gcf,'defaultlinelinewidth',2,'DefaultAxesFontSize', fontSize,'DefaultAxesFontName', 'Times')
set(gca,'fontsize',fontSize,'fontname','Times','fontweight','bold')

fig2 = figure('Position',[100,100,1500,500]);
set(gcf,'defaultlinelinewidth',2,'DefaultAxesFontSize', fontSize,'DefaultAxesFontName', 'Times')
set(gca,'fontsize',fontSize,'fontname','Times','fontweight','bold')

fig3 = figure('Position',[100,100,1500,500]);
set(gcf,'defaultlinelinewidth',2,'DefaultAxesFontSize', fontSize,'DefaultAxesFontName', 'Times')
set(gca,'fontsize',fontSize,'fontname','Times','fontweight','bold')

%% Do the actual plotting

ITERATION = GRAPH_DATA(:,1);
GRAPH_BETWEENNESS_HISTORY= GRAPH_DATA(:,2);
GRAPH_CLOSENESS_HISTORY= GRAPH_DATA(:,3);
GRAPH_DEGREE_HISTORY = GRAPH_DATA(:,4);
PARASITE_BURDEN_HISTORY = GRAPH_DATA(:,5);

% Plot each centrality measure and Parasite load in its own subplot
figure(fig1)
subplot(4,1,1)
colorOrder = get(gca, 'ColorOrder');
plot(GRAPH_DEGREE_HISTORY)
ylabel('Degree')


subplot(4,1,2)
plot(GRAPH_CLOSENESS_HISTORY,'Color',colorOrder(2,:))
ylabel('Closeness')

subplot(4,1,3)
plot(GRAPH_BETWEENNESS_HISTORY,'Color',colorOrder(3,:))
ylabel('Betweenness')

subplot(4,1,4)
plot(PARASITE_BURDEN_HISTORY,'Color',colorOrder(4,:))
ylabel('Parasite Burden')

% Plot All centrality measures on one figure
figure(fig2)
hold all
plot(GRAPH_DEGREE_HISTORY)
plot(GRAPH_CLOSENESS_HISTORY)
plot(GRAPH_BETWEENNESS_HISTORY )
legend('Degree','Closeness','Betweenness')
ylabel('Centrality Measure')
xlabel('Time')

% Plot parasite load
figure(fig3)
plot(PARASITE_BURDEN_HISTORY,'Color',colorOrder(4,:))
ylabel('Parasite Load')
xlabel('Time')
