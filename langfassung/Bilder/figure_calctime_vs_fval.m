% Erstelle ein Bild mit Rechenzeit vs Zielfunktionswert

% Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2020-02
% (C) Institut für Mechatronische Systeme, Universität Hannover

clear
clc
close all

outputdir = fileparts(which('figure_calctime_vs_fval.m'));

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
%% Detail-Ergebnisse nachladen
TimeEvalData = [];
for i = 1:size(ResTab_ges,1)
  OptName = ResTab_ges.OptName{i};
  LfdNr = ResTab_ges.LfdNr(i);
  RobName = ResTab_ges.Name{i};
  if ~strcmp(Robots_TL_List{4}{1}, RobName)
    continue
  end
  resfile = fullfile(resdirtotal, OptName, sprintf('Rob%d_%s_Endergebnis.mat', LfdNr, RobName));
  tmp = load(resfile);
  TimeEvalData = [TimeEvalData; [tmp.PSO_Detail_Data.fval(:), tmp.PSO_Detail_Data.comptime(:)]];
end
% Daten in Klassen aufteilen
I_kl = false(size(TimeEvalData,1), 15); % Binär-Inidizes für Klassen
for i = 1:size(I_kl,2)
  I_kl(TimeEvalData(:,1) > 10^(i-1) & TimeEvalData(:,1) <= 10^(i),i) = true;
end
% Klassen neu stapeln (Eingabeformat für boxplot)
BPData = NaN(size(TimeEvalData,1),1);
GVar = NaN(size(TimeEvalData,1),1);
k = 0;
for i = 1:size(I_kl,2)
  l = sum(I_kl(:,i));
  if l == 0 % Leere Klassen sollen als Platzhalter da sein
    BPData(k+1) = NaN;
    GVar(k+1) = i;
    l = 1;
  else
    BPData(k+1:k+l) = TimeEvalData(I_kl(:,i),2);
    GVar(k+1:k+l) = i;
  end
  k = k + l;
end

sum(I_kl(:))
% Bild zeichnen
figure(1);clf;hold on;

grid on;
boxplot(BPData, GVar);
xlim([2.5, 12.5])
xlabel('upper limit of $\mathrm{log}(f)$', 'interpreter', 'latex');
ylabel('time per particle in s');
figure_format_publication(gca);
% set(h, 'Position', [0.15,0.93,0.7,0.05]);
set_size_plot_subplot(1,8,4.5,gca,...
  0.10,0.01,0.01,0.18,0,0); % bl,br,hu,hd,bdx,bdy
export_fig(1, fullfile(outputdir, sprintf('figure_calctime_vs_fval.pdf')));