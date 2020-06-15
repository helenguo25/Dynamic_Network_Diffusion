%% Investigate the "green stripe" ~ medium parasitic load at T=300

%% Create Histogram of average degree
close all %For now. Delete Later.
clc

currentParasiteData = load('./msriParasites/Dynamic_Degree_1_2_2_nodeParasites.txt');

startValue = 250;
ToPlot = currentParasiteData(startValue:end,2:end); % t= 150 is where the parasite is introduced
ToPlot = ToPlot';

%% Set up properties of the figures
fontSize = 20;

figure('Position',[100,100,1500,500]);
set(gcf,'defaultlinelinewidth',2,'DefaultAxesFontSize', fontSize,'DefaultAxesFontName', 'Times')
set(gca,'fontsize',fontSize,'fontname','Times','fontweight','bold')

ToPlot_HEATMAP = bar3(ToPlot(:,:));
for m = 1:length(ToPlot_HEATMAP)
    zdata = get(ToPlot_HEATMAP(m),'ZData');
    set(ToPlot_HEATMAP(m),'CData',zdata)
end

view(2)
caxis([0 1])
colorbar
xlabel('Time after parasite introduction')
ylabel('Node')
ylim([1 50])
