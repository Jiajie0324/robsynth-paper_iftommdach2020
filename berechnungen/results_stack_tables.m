% Lade alle Ergebnistabellen und gebe eine Übersicht der Ergebnisse für
% jeden Roboter

clear
clc

dimsynthpath = fileparts(which('structgeomsynth_path_init.m'));
importdir = fullfile(dimsynthpath, 'dimsynth', 'results');
filter = 'IFToMMDACH_Vgl_Winkel*_KondLim*_20200124_nachts';
outputdir = fullfile(dimsynthpath, 'dimsynth', 'results', 'IFToMMDACH_Vgl_Winkel_20200124_nachts');
mkdirs(outputdir);
%% Zusammenstellen der Ergebnisse
reslist = dir(fullfile(importdir, filter));
for i = 1:length(reslist)
  d = reslist(i).name;
  tablepath = fullfile(importdir, d, sprintf('%s_results_table.csv', d));
  ResTab_i = readtable(tablepath, 'HeaderLines', 2);
  ResTab_i_headers = readtable(tablepath, 'ReadVariableNames', true);
  ResTab_i.Properties.VariableNames = ResTab_i_headers.Properties.VariableNames;
  ResTab_i = addvars(ResTab_i, repmat({d},6,1), 'Before', 1);
  ResTab_i.Properties.VariableNames(1) = {'OptName'};
  if i == 1
    ResTab_ges = ResTab_i;
  else
    ResTab_ges = [ResTab_ges; ResTab_i]; %#ok<AGROW>
  end
end

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