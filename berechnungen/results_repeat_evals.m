% Lade alle Ergebnistabellen und gebe eine Übersicht der Ergebnisse für
% jeden Roboter

clear
clc

dimsynthpath = fileparts(which('structgeomsynth_path_init.m'));
importdir = fullfile(dimsynthpath, 'dimsynth', 'results');
filter = 'IFToMMDACH_Vgl_Winkel*_20200206_nachts_Wdh*';
outputdir = fullfile(dimsynthpath, 'dimsynth', 'results', 'IFToMMDACH_Vgl_20200206_nachts');
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
  % Eintragen des Namens der Optimierung (zum späteren Auffinden)
  ResTab_i = addvars(ResTab_i, repmat({d},size(ResTab_i,1),1), 'Before', 1);
  ResTab_i.Properties.VariableNames(1) = {'OptName'};
  
  if i == 1
    ResTab_ges = ResTab_i;
  else
    ResTab_ges = [ResTab_ges; ResTab_i]; %#ok<AGROW>
  end
end

%% Eintragen zusätzlicher Informationen
ResTab_ges = addvars(ResTab_ges, NaN(size(ResTab_ges,1),1));
ResTab_ges.Properties.VariableNames(end) = {'MaxTiltAngle'};
for i = 1:size(ResTab_ges,1)
  OptName = ResTab_ges.OptName{i};
  LfdNr = ResTab_ges.LfdNr(i);
  RobName = ResTab_ges.Name{i};
  resfile = fullfile(importdir, OptName, sprintf('Rob%d_%s_Endergebnis.mat', LfdNr, RobName));
  tmp = load(resfile);
  TiltAngles = NaN(length(tmp.Traj.t),1);
  for jj = 1:length(tmp.Traj.t)
    R_jj = eulxyz2r(tmp.Traj.X(jj,4:6)');
    TiltAngles(jj) = acos(R_jj(1:3,3)'*[0;0;1]);
  end
  ResTab_ges.MaxTiltAngle(i) = max(abs(TiltAngles));
end
%% Speichern der Tabelle
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
% Merke, welche Optimierungen ein gültiges Endergebnis haben
I_feasible = ResTab_ges.Fval_Opt < 1e3;
%% Bild für Materialausnutzung und Konditionszahl
figure(1);clf;hold on;

% I_condlim = contains(ResTab_ges.OptName, 'KondLim1');
hdl_feas = NaN(length(Robots),1);
for i = 1:length(Robots)
  RobName = Robots{i};
  I_Robi = strcmp(ResTab_ges.Name, RobName);
  I = I_Robi;%&I_condlim;
  set(gca, 'ColorOrderIndex', i);
  hdl_feas(i) = plot(ResTab_ges.Kondition_phys(I&I_feasible), 100*ResTab_ges.Materialspannung(I&I_feasible), '^');
  set(gca, 'ColorOrderIndex', i);
  plot(ResTab_ges.Kondition_phys(I&~I_feasible), 100*ResTab_ges.Materialspannung(I&~I_feasible), 'x');
end
% ylim([0,200]);
legend(hdl_feas, Robots);
xlabel('Konditionszahl Jacobi');
ylabel('Materialbeanspruchung in Prozent');
grid on;
saveas(1,     fullfile(outputdir, sprintf('Materialbeanspruchung_vs_Jacobi')));
export_fig(1, fullfile(outputdir, sprintf('Materialbeanspruchung_vs_Jacobi.png')));

%% Bild für Energie und Konditionszahl
figure(2);clf;hold on;

% I_condlim = contains(ResTab_ges.OptName, 'KondLim1');
hdl_feas = NaN(length(Robots),1);
for i = 1:length(Robots)
  RobName = Robots{i};
  I_Robi = strcmp(ResTab_ges.Name, RobName);
  I = I_Robi;%&I_condlim;
  set(gca, 'ColorOrderIndex', i);
  hdl_feas(i) = plot(ResTab_ges.Kondition_phys(I&I_feasible), ResTab_ges.Energie_phys(I&I_feasible), '^');
  set(gca, 'ColorOrderIndex', i);
  plot(ResTab_ges.Kondition_phys(I&~I_feasible), ResTab_ges.Energie_phys(I&~I_feasible), 'x');
end
% ylim([0,200]);
legend(hdl_feas, Robots);
xlabel('Konditionszahl Jacobi');
ylabel('Energie in J');
grid on;
saveas(2,     fullfile(outputdir, sprintf('Energie_vs_Jacobi')));
export_fig(2, fullfile(outputdir, sprintf('Energie_vs_Jacobi.png')));

%% Bild für Eigenschaften über Neigungswinkel
figure(3);clf;
% I_condlim = contains(ResTab_ges.OptName, 'KondLim1');
% [tokens,~] = regexp(ResTab_ges.OptName,'.*Winkel(\d+).*', 'tokens','match');
% Winkel_ges = NaN(length(ResTab_ges.OptName), 1);
% for i = 1:length(tokens)
%   Winkel_ges(i) = str2double(tokens{i}{1});
% end
subplot(2,2,1); hold on;
quota = ResTab_ges.num_succ ./ (ResTab_ges.num_fail + ResTab_ges.num_succ);
for i = 1:length(Robots)
  RobName = Robots{i};
  I_Robi = strcmp(ResTab_ges.Name, RobName);
  I = I_Robi;%&I_condlim;
  plot(180/pi*ResTab_ges.MaxTiltAngle(I), 100*quota(I), 'x');
end
legend(Robots);
xlabel('Neigungswinkel in Grad');
ylabel('Erfolgreiche Partikel (in Prozent)');
grid on;
title('Erfolgsquote vs Schwenkwinkel');

subplot(2,2,2); hold on;
hdl_feas = NaN(length(Robots),1);
for i = 1:length(Robots)
  RobName = Robots{i};
  I_Robi = strcmp(ResTab_ges.Name, RobName);
  I = I_Robi;%&I_condlim;
  set(gca, 'ColorOrderIndex', i);
  hdl_feas(i) = plot(180/pi*ResTab_ges.MaxTiltAngle(I&I_feasible), ResTab_ges.Kondition_phys(I&I_feasible), '^');
  set(gca, 'ColorOrderIndex', i);
  plot(180/pi*ResTab_ges.MaxTiltAngle(I&~I_feasible), ResTab_ges.Kondition_phys(I&~I_feasible), 'x');
end
legend(hdl_feas, Robots);
xlabel('Neigungswinkel in Grad');
ylabel('Konditionszahl Endergebnis');
grid on;
title('Konditionszahl vs Schwenkwinkel');

subplot(2,2,3); hold on;
hdl_feas = NaN(length(Robots),1);
for i = 1:length(Robots)
  RobName = Robots{i};
  I_Robi = strcmp(ResTab_ges.Name, RobName);
  I = I_Robi;%&I_condlim;
  set(gca, 'ColorOrderIndex', i);
  hdl_feas(i) = plot(180/pi*ResTab_ges.MaxTiltAngle(I&I_feasible), ResTab_ges.Energie_phys(I&I_feasible), '^');
  set(gca, 'ColorOrderIndex', i);
  plot(180/pi*ResTab_ges.MaxTiltAngle(I&~I_feasible), ResTab_ges.Energie_phys(I&~I_feasible), 'x');
end
legend(hdl_feas, Robots);
xlabel('Neigungswinkel in Grad');
ylabel('Energie Endergebnis in J');
grid on;
title('Energie vs Schwenkwinkel');

subplot(2,2,4); hold on;
hdl_feas = NaN(length(Robots),1);
for i = 1:length(Robots)
  RobName = Robots{i};
  I_Robi = strcmp(ResTab_ges.Name, RobName);
  I = I_Robi;%&I_condlim;
  set(gca, 'ColorOrderIndex', i);
  hdl_feas(i) = plot(180/pi*ResTab_ges.MaxTiltAngle(I&I_feasible), 100*ResTab_ges.Materialspannung(I&I_feasible), '^');
  set(gca, 'ColorOrderIndex', i);
  plot(180/pi*ResTab_ges.MaxTiltAngle(I&~I_feasible), 100*ResTab_ges.Materialspannung(I&~I_feasible), 'x');
end
legend(hdl_feas, Robots);
xlabel('Neigungswinkel in Grad');
ylabel('Materialbelastung Endergebnis in %');
grid on;
title('Materialbelastung vs Schwenkwinkel');

saveas(3,     fullfile(outputdir, sprintf('Vergleich_Anteil_Erfolgreich')));
export_fig(3, fullfile(outputdir, sprintf('Vergleich_Anteil_Erfolgreich.png')));

%% Bild für Kinematikparameter
figure(4);clf;
for i = 1:length(Robots)
  RobName = Robots{i};
  % Alle Ergebnisse laden
  I_Robi = strcmp(ResTab_ges.Name, RobName);
  pval_robi_norm = [];
  for j = find(I_Robi)'
    OptName_j = ResTab_ges.OptName{j};
    robnr = ResTab_ges.LfdNr(j);
    resfile_j = fullfile(importdir, OptName_j, sprintf('Rob%d_%s_Endergebnis.mat', robnr, RobName));
    tmp = load(resfile_j, 'RobotOptRes', 'Set', 'Traj', 'PSO_Detail_Data');
    pval_robi_norm = [pval_robi_norm;(tmp.RobotOptRes.p_val-tmp.RobotOptRes.p_limits(:,1)')./...
      diff(tmp.RobotOptRes.p_limits')]; %#ok<AGROW>
  end
  subplot(2,2,i);hold on;
  plot(pval_robi_norm');
  title(sprintf('Parameterverlauf für Rob %d (%s)', i, RobName));
  ylabel('Parameterwert (normiert)');
  xlabel('Parameter lfd Nummer');
  fprintf('Roboter %s; Parameter:\n', RobName);
  disp(tmp.RobotOptRes.Structure.varnames);
end