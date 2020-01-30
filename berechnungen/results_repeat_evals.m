% Lade alle Ergebnistabellen und gebe eine Übersicht der Ergebnisse für
% jeden Roboter

clear
clc

dimsynthpath = fileparts(which('structgeomsynth_path_init.m'));
importdir = fullfile(dimsynthpath, 'dimsynth', 'results');
filter = 'IFToMMDACH_Vgl_Winkel*_KondLim*_20200129_*';
outputdir = fullfile(dimsynthpath, 'dimsynth', 'results', 'IFToMMDACH_Vgl_Winkel_20200129');
mkdirs(outputdir);
%% Zusammenstellen der Ergebnisse
reslist = dir(fullfile(importdir, filter));
for i = 1:length(reslist)
  d = reslist(i).name;
  tablepath = fullfile(importdir, d, sprintf('%s_results_table.csv', d));
  if ~exist(tablepath, 'file')
    continue; % Wahrscheinlich Optimierung noch nicht abgeschlossen
  end
  ResTab_i = readtable(tablepath, 'HeaderLines', 2);
  ResTab_i_headers = readtable(tablepath, 'ReadVariableNames', true);
  ResTab_i.Properties.VariableNames = ResTab_i_headers.Properties.VariableNames;
  ResTab_i = addvars(ResTab_i, repmat({d},size(ResTab_i,1),1), 'Before', 1);
  ResTab_i.Properties.VariableNames(1) = {'OptName'};
  if i == 1
    ResTab_ges = ResTab_i;
  else
    ResTab_ges = [ResTab_ges; ResTab_i]; %#ok<AGROW>
  end
end
ResTableFile = fullfile(outputdir, 'all_results.csv');
writetable(ResTab_ges, ResTableFile, 'Delimiter', ';');
%% Auswertung verschiedener Testläufe
Robots = unique(ResTab_ges.Name);
for i = 1:length(Robots)
  RobName = Robots{i};
  I_Robi = strcmp(ResTab_ges.Name, RobName);
  ResTab_Robi = ResTab_ges(I_Robi,:);
  RobTableFile = fullfile(outputdir, sprintf('%s_results_table.csv', RobName));
  writetable(ResTab_Robi, RobTableFile, 'Delimiter', ';');
end
fprintf('Ergebnistabellen nach %s geschrieben\n', RobTableFile);

%% Bild für Materialausnutzung und Konditionszahl
figure(1);clf;hold on;
I_condlim = contains(ResTab_ges.OptName, 'KondLim1');
for i = 1:length(Robots)
  RobName = Robots{i};
  I_Robi = strcmp(ResTab_ges.Name, RobName);
  I = I_Robi&I_condlim;
  plot(ResTab_ges.Kondition_phys(I), 100*ResTab_ges.Materialspannung(I), 'x');
end
% ylim([0,200]);
legend(Robots);
xlabel('Konditionszahl Jacobi');
ylabel('Materialbeanspruchung in Prozent');
grid on;
saveas(1,     fullfile(outputdir, sprintf('Materialbeanspruchung_vs_Jacobi')));
export_fig(1, fullfile(outputdir, sprintf('Materialbeanspruchung_vs_Jacobi.png')));
%% Bild für Anzahl erfolgreicher Parametersätze
figure(2);clf;hold on;
I_condlim = contains(ResTab_ges.OptName, 'KondLim1');
[tokens,~] = regexp(ResTab_ges.OptName,'.*Winkel(\d+).*', 'tokens','match');
Winkel_ges = NaN(length(ResTab_ges.OptName), 1);
for i = 1:length(tokens)
  Winkel_ges(i) = str2double(tokens{i}{1});
end
quota = ResTab_ges.num_succ ./ (ResTab_ges.num_fail + ResTab_ges.num_succ);
for i = 1:length(Robots)
  RobName = Robots{i};
  I_Robi = strcmp(ResTab_ges.Name, RobName);
  I = I_Robi&I_condlim;
  plot(Winkel_ges(I), 100*quota(I), 'x');
end
legend(Robots);
xlabel('Neigungswinkel');
ylabel('Erfolgreiche Partikel (in Prozent)');
grid on;
saveas(2,     fullfile(outputdir, sprintf('Vergleich_Anteil_Erfolgreich')));
export_fig(2, fullfile(outputdir, sprintf('Vergleich_Anteil_Erfolgreich.png')));