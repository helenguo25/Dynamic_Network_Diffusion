
% Set below to desired file path
% Later, we'll have to cycle through mutiple text files in
% appropriate folder to generate multiple figures.
% Also, we'll have to save the figures to appropriate file names.
ToPlot = load('./BLAH/test_nodeDegree.txt');



%% Set up properties of the figures
fontSize = 20;

fig1 = figure('Position',[100,100,1500,500]);
set(gcf,'defaultlinelinewidth',2,'DefaultAxesFontSize', fontSize,'DefaultAxesFontName', 'Times')
set(gca,'fontsize',fontSize,'fontname','Times','fontweight','bold')

%% Do the actual plotting

% Drop first column of iteration numbers and transpose to align with code
ToPlot = ToPlot(:,2:end);
ToPlot = ToPlot';

ToPlot_HEATMAP = bar3(ToPlot(:,:));
for k = 1:length(ToPlot_HEATMAP)
    zdata = get(ToPlot_HEATMAP(k),'ZData');
    set(ToPlot_HEATMAP(k),'CData',zdata)%,...
             %'FaceColor','interp')
end
view(2)
title('Node Degree Heat Map')
ylabel('Node')
xlabel('Iteration (time)')
ylim([-1 size(ToPlot,1)]+1)
xlim([-1 size(ToPlot,2)]+1)
colorbar

%% Until I figure out weird thing with colors not redering correctly
% figure 
% 
% ToPlot_HEATMAP = bar3(ToPlot(:,:));
% for k = 1:length(ToPlot_HEATMAP)
%     zdata = get(ToPlot_HEATMAP(k),'ZData');
%     set(ToPlot_HEATMAP(k),'CData',zdata)%,...
%              %'FaceColor','interp')
% end
% view([180, 0, 0])
% title('Node Degree Heat Map')
% ylabel('Node')
% xlabel('Iteration (time)')
% ylim([0 size(ToPlot,1)])
% xlim([0 size(ToPlot,2)])