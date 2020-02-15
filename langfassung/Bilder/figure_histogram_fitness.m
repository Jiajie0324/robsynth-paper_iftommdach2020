% Bild für Vergleich von Materialbelastung und Konditionszahl der Jacobi
% Vorher wurde die Optimierung mit cds_example_3T3R_PKM_wiederholbarkeit.m
% gestartet und ein Optimierungsverlauf daraus ausgewählt

% Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2020-02
% (C) Institut für Mechatronische Systeme, Universität Hannover

clear
clc

outputdir = fileparts(which('figure_histogram_fitness.m'));

dimsynthpath = fileparts(which('structgeomsynth_path_init.m'));
resdirtotal = fullfile(dimsynthpath, 'dimsynth', 'results');
histogramfigure = fullfile(resdirtotal, 'IFToMMDACH_Vgl_Winkel45_20200203_nachts_Wdh5', ...
  'Rob1_P6RRRRRR10V3G1P1A1_Histogramm.fig');

uiopen(histogramfigure, 1);
figh = gcf();
axh_ges = get(figh, 'Children');
delete(axh_ges([2 4 5 6]))

ah = axh_ges(1);
% Senkrechten Strich entfernen
lh = get(ah, 'children');
I_line = strcmp(get(lh,'type'), {'line'});
delete(lh(I_line));

figure_format_publication(ah);
set_size_plot_subplot(figh,8,4.5,ah,...
  0.15,0.03,0.02,0.18,0,0); % bl,br,hu,hd,bdx,bdy
ylabel('Frequency of occurence');
xlabel('log(fitness)');
title('');
ylim([0,1850]); % Damit oben keine Beschriftung ist
export_fig(figh, fullfile(outputdir, sprintf('figure_histogram_fitness.pdf')));