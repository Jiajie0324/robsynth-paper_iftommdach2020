% Bild für Vergleich von Materialbelastung und Konditionszahl der Jacobi

% Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2019-08
% (C) Institut für Mechatronische Systeme, Universität Hannover

clear
clc
close all

outputdir = fileparts(which('figure_condition_vs_tiltangle.m'));

%% Definitionen
colors = [[0 80 155 ]/255; ...%imesblau
          [231 123 41 ]/255;... %imesorange
          [200 211 23 ]/255;... %imesgrün
          [0 0 0]]; % schwarz
        
%% Zusammenfassungen der bisherige Versuche laden
dimsynthpath = fileparts(which('structgeomsynth_path_init.m'));
resdirtotal = fullfile(dimsynthpath, 'dimsynth', 'results');
resdirs = {'IFToMMDACH_Vgl_20200206_nachts'};
for i = 1:length(resdirs)
  tablepath = fullfile(resdirtotal, resdirs{i}, 'all_results.csv');
  ResTab_i = readtable(tablepath, 'HeaderLines', 1);
  ResTab_i_headers = readtable(tablepath, 'ReadVariableNames', true);
  ResTab_i.Properties.VariableNames = ResTab_i_headers.Properties.VariableNames;
  if i == 1
    ResTab_ges = ResTab_i;
  else
    ResTab_ges = [ResTab_ges; ResTab_i]; %#ok<AGROW>
  end
end
% Liste der Namen für die Legende bearbeiten
Robots_TL_List = { ...
  {'P6PRRRRR6G8P3A1',   '6PRRRRR'}, ...
  {'P6PRRRRR6V2G8P3A1', '6PRRS'}, ...
  {'P6RRRRRR10G1P1A1', '6RRRRRR'}, ...
  {'P6RRRRRR10V3G1P1A1', '6RRRS'}};
Robots = unique(ResTab_ges.Name);
Robots_TL = Robots;
for i = 1:length(Robots_TL_List)
  Robots_TL = strrep(Robots_TL, Robots_TL_List{i}{1}, Robots_TL_List{i}{2});
end
% Bild zeichnen
figure(1);clf;hold on;
plotsymbollist = {'^', 'o', 'x', 's'};
shift = [-1.5, -0.5, .5, 1.5];
I_iO = ResTab_ges.Fval_Opt < 1e3;
for i = 1:length(Robots)
  RobName = Robots{i};
  I_Robi = strcmp(ResTab_ges.Name, RobName);
  I = I_Robi & I_iO;
  plot(180/pi*ResTab_ges.MaxTiltAngle(I)+shift(i), ResTab_ges.Kondition_phys(I), ...
    plotsymbollist{i}, 'color', colors(i,:));
end
grid on;
h = legend(Robots_TL, 'orientation', 'horizontal'); 
h.ItemTokenSize(1) = 15; %https://de.mathworks.com/matlabcentral/answers/438845-change-figure-legend-horizontal-spacing#answer_398095
xlabel('Max. Tilt Angle in Traj. in deg');
ylabel('cond(J)');
xlim([35, 95]);
ylim([0, 230]);
figure_format_publication(gca);
set_size_plot_subplot(1,8,4.5,gca,...
  0.13,0.01,0.11,0.18,0,0); % bl,br,hu,hd,bdx,bdy
set(h, 'Position', [0.15,0.93,0.7,0.05]);

export_fig(1, fullfile(outputdir, sprintf('figure_condition_vs_tiltangle.pdf')));