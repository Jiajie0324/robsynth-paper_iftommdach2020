% Einstellungen für komb. Struktur- und Maßsynthese für 3T3R PKM
% Auswertung Bezüglich Schwenkwinkeln und Konditionszahl

% Moritz Schappler, moritz.schappler@imes.uni-hannover.de, 2020-01
% (C) Institut für Mechatronische Systeme, Universität Hannover

clc
clear

% Aufgaben-FG
DoF = [1 1 1 1 1 1];
Traj_no = 2;

Set = cds_settings_defaults(struct('DoF', DoF));
Set.task.Ts = 1e-2;
Set.task.Tv = 1e-1;
Set.task.profile = 1;

Set.optimization.objective = 'energy';
Set.optimization.NumIndividuals = 100;
Set.optimization.MaxIter = 30;
Set.general.plot_details_in_fitness = 1e3*0;
Set.general.plot_robot_in_fitness = 1e3*0;
Set.optimization.base_size = true;
Set.optimization.base_size_limits = [1 2];
Set.optimization.platform_size = true;
Set.optimization.platform_size_limits = [0.3 1];
Set.optimization.base_morphology = true;
Set.optimization.platform_morphology = true;
Set.optimization.movebase = false;
Set.optimization.constraint_link_yieldstrength = 1.0; % Beachte Materialbeanspruchung
Set.general.max_retry_bestfitness_reconstruction = 1;
Set.general.verbosity = 3;
Set.general.matfile_verbosity = 0;
Set.structures.use_serial = false;
Set.optimization.ee_rotation = false;
Set.general.parcomp_struct = true;
Set.general.nosummary = false;

% Auswahl für Paper
Set.structures.whitelist = { ...
  'P6PRRRRR6G8P3A1', 'P6PRRRRR6V2G8P3A1', ...
  'P6RRRRRR10G1P1A1', 'P6RRRRRR10V3G1P1A1'};
% Verschiedene Schwenkwinkel durchgehen
for maxangle = [45 60 75 90 30 10]
  % Prüfung mit Begrenzung der Konditionszahl und ohne
  for cond_limit = 1%[1, 0]
    % Einstellungen anpassen
    if cond_limit == 1
      Set.optimization.constraint_obj(4) = 1e3;
    else
      Set.optimization.constraint_obj(4) = 1e12; % Setze auf hohen Wert, damit Kondition trotzdem berechnet wird.
    end
    Set.optimization.optname = sprintf('IFToMMDACH_Vgl_Winkel%d_20200205_nachts', maxangle);
    Set.task.maxangle = maxangle*pi/180; 
    Traj = cds_gen_traj(DoF, Traj_no, Set.task);
    cds_start
  end
end