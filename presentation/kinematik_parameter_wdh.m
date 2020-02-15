% Bild für Wiederholbarkeit der Kinematikparameter
% Zeichne Linienverlauf der Parameter für wiederholte Durchführung der
% Optimierung

% Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2020-02
% (C) Institut für Mechatronische Systeme, Universität Hannover

clear
clc

outputdir = fileparts(which('kinematik_parameter_wdh.m'));
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
Robots = unique(ResTab_ges.Name);
RobName = 'P6RRRRRR10V3G1P1A1';
I_Robi = strcmp(ResTab_ges.Name, RobName);
I_Angle = contains(ResTab_ges.OptName, 'Winkel45');
I_valid = ResTab_ges.Fval_Opt < 1e3;
I = I_Robi & I_Angle & I_valid;
%% Bild für Kinematikparameter
figure(1);clf;hold on;
pval_robi_norm = [];

for j = find(I)'
  OptName_j = ResTab_ges.OptName{j};
  robnr = ResTab_ges.LfdNr(j);
  resfile_j = fullfile(resdirtotal, OptName_j, sprintf('Rob%d_%s_Endergebnis.mat', robnr, RobName));
  tmp = load(resfile_j, 'RobotOptRes', 'Set', 'Traj', 'PSO_Detail_Data');
  pval_robi_norm = [pval_robi_norm;(tmp.RobotOptRes.p_val-tmp.RobotOptRes.p_limits(:,1)')./...
    diff(tmp.RobotOptRes.p_limits')]; %#ok<AGROW>
end
plot(pval_robi_norm', 'LineWidth', 2);
% title(sprintf('Parameterverlauf %s', RobName));
ylabel('Parameterwert (normiert)');
xlabel('Parameter lfd Nummer');
grid on
figure_format_publication(gca);
set_font_fontsize(1,'Times',16)
set_size_plot_subplot(1,16,10,gca,...
  0.13,0.05,0.05,0.16,0,0); % bl,br,hu,hd,bdx,bdy
export_fig(1, fullfile(outputdir, sprintf('figure_parameter_wdh.pdf')));
cd(outputdir);
export_fig(['figure_parameter_wdh', '_r864.png'], '-r864')



fprintf('Roboter %s; Parameter:\n', RobName);
disp(tmp.RobotOptRes.Structure.varnames);
