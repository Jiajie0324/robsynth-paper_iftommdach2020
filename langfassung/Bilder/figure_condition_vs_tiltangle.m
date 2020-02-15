% Bild für Vergleich von Materialbelastung und Konditionszahl der Jacobi
% Vorher wurde die Optimierung mit cds_example_3T3R_PKM_wiederholbarkeit.m
% gestartet
% Erzeugt Fig. 10 im Paper

% Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2020-02
% (C) Institut für Mechatronische Systeme, Universität Hannover

clear
clc
close all

% Benutzereingabe: Bei true werden die Daten für das Paper aus dem
% Data-Ordner genommen. Bei false werden die Daten aus dem Ergebnis-Ordner
% der Maßsynthese genommen.
origdaten = true;

%% Definitionen
outputdir = fileparts(which('figure_condition_vs_tiltangle.m'));
colors = [[0 80 155 ]/255; ...%imesblau
          [231 123 41 ]/255;... %imesorange
          [200 211 23 ]/255;... %imesgrün
          [0 0 0]]; % schwarz
        
%% Zusammenfassungen der bisherige Versuche laden
if ~origdaten
  dimsynthpath = fileparts(which('structgeomsynth_path_init.m'));
  resdirtotal = fullfile(dimsynthpath, 'dimsynth', 'results');
else
  resdirtotal = fullfile(outputdir, '..', 'Data');
end
resdirs = {'IFToMMDACH_Vgl_20200206_nachts', 'IFToMMDACH_Vgl_20200212_nachts', 'IFToMMDACH_Vgl_20200211'};
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
writetable(ResTab_ges, fullfile(outputdir, 'figure_condition_vs_tiltangle_data.csv'), 'Delimiter', ';');
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
%% Kurzauswertung machen
TiltAngles = 180/pi*unique(ResTab_ges.MaxTiltAngle);
I_valid = ResTab_ges.Fval_Opt < 1e3;
sum_total = 0;
for j = 1:length(Robots)
  I_robj = strcmp(ResTab_ges.Name, Robots{j});
  for i = 1:length(TiltAngles)
    I_TAi = abs(TiltAngles(i) - 180/pi*ResTab_ges.MaxTiltAngle) < 1e-3;
    sum_total = sum_total + sum(I_TAi&I_robj);
    I_TAi = abs(ResTab_ges.MaxTiltAngle*180/pi - TiltAngles(i)) < 1e-6;
    fprintf('Rob %s, Winkel %1.0f: %d/%d Erfolgreich\n', Robots{j}, TiltAngles(i), sum(I_valid&I_robj&I_TAi), sum(I_robj&I_TAi));
  end
end
fprintf('%d Einträge mit Filter gezählt. %d Einträge insgesamt\n', sum_total, size(ResTab_ges,1));
if sum_total ~= size(ResTab_ges,1)
  warning('Es gibt Simulationsergebnisse mit nicht zuordnungsfähigen Schwenkwinkeln');
end
%% Bild zeichnen
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
xlh = xlabel('Maximum Tilt Angle in Trajectory in deg');
ylabel('cond(J)');
xlim([-5, 89]);
ylim([8, 230]);

% Grid und Achseneinteilung so verändern, dass es Abschnittsweise für jeden
% Winkelschritt eine Sammlung von Werten gibt
TAintermediate = TiltAngles(1:end-1)+diff(TiltAngles)/2;
set(gca, 'xtick', TAintermediate, 'xticklabel', {})
[X_off, X_slope] = get_relative_position_in_axes(gca, 'x');
[Y_off, Y_slope] = get_relative_position_in_axes(gca, 'y'); % Funktioniert nicht bei Log Scale
set(xlh, 'position', [X_off+X_slope*(0), 5,1]);
for i = 1:length(TiltAngles)-1
  text(TiltAngles(i)-3, 6.5, sprintf('%1.0f',TiltAngles(i)), 'FontSize', 8);
end

set(gca, 'YScale', 'log'); % Zur Übersichtlichkeit -> Mehr Werte in kleinem Bereich
set(gca, 'ytick', [10, 100])

figure_format_publication(gca);
set_size_plot_subplot(1,8,4.5,gca,...
  0.13,0.01,0.11,0.18,0,0); % bl,br,hu,hd,bdx,bdy
set(h, 'Position', [0.17,0.93,0.7,0.05]);

export_fig(1, fullfile(outputdir, sprintf('figure_condition_vs_tiltangle.pdf')));